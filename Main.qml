import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// import Qt.labs.platform as Platform
import QtQuick.Dialogs as Dialogs
import modmanagerx
import "."

ApplicationWindow {
    id: window
    width: 680
    height: 480
    visible: true
    color: "#ffffff"
    maximumHeight: 480
    maximumWidth: 680
    minimumHeight: 480
    minimumWidth: 680
    title: "Mod Manager X"
    flags: Qt.Window | Qt.FramelessWindowHint

/*
    Platform.SystemTrayIcon {
        id: trayIcon
        visible: true
        icon.source: "qrc:/qt/qml/modmanagerx/images/Mod Manager X.ico"
        tooltip: "ModManagerX"

        menu: Platform.Menu {
            Platform.MenuItem {
                text: Language.get("BAR_OPEN")
                onTriggered: window.show()
            }
            Platform.MenuItem {
                text: Language.get("BAR_CLOSE")
                onTriggered: Qt.quit() // Actually kills the process
            }
        }
        onActivated: (reason) => {
                         if (reason === Platform.SystemTrayIcon.Trigger) window.show()
                     }
    }
*/
    property point clickPos: "0,0"

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        onPressed: (mouse) => {
                       clickPos = Qt.point(mouse.x, mouse.y)
                   }

        onPositionChanged: (mouse) => {

                               window.x += mouse.x - clickPos.x
                               window.y += mouse.y - clickPos.y
                           }
    }

    Dialogs.FileDialog {
        id: importPathDialog
        title: Language.get("FILE_PACKSELECT")
        currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)

        // Only show .mmx files
        nameFilters: ["ModManagerX files (*.mmx)"]

        onAccepted: {
            // 1. FileDialog returns a URL (file:///C:/...),
            // we need to convert it to a local path string for C++
            let path = selectedFile.toString();

            // Remove the "file:///" prefix so C++ can use it directly
            // (Qt's QUrl::toLocalFile is better, but this works in JS)
            path = path.replace(/^(file:\/{3})/,"");

            // 2. Send it to the same C++ function your double-click uses!
            backend.stageImportFile(path);
        }
    }

    Dialog {
        id: importDialog
        anchors.centerIn: parent
        modal: true

        property string filePath: ""

        // Define the same properties here to act as a bridge
        property alias name: uiContent.name
        property alias location: uiContent.location
        property alias path: uiContent.path

        contentItem: ImportDialog { // This is your .ui.qml file
            id: uiContent

            doImportArea.onClicked: {
                backend.importPackFile(importDialog.filePath);
                importDialog.accept();
            }

            nevermindArea.onClicked: {
                importDialog.reject();
            }
        }
    }

    Popup {
        id: mainMenu
        x: 0 // Positioned relative to the window
        y: 0 // Exactly below the 32px ToolBar
        width: 163
        height: 216
        padding: 0

        background: Rectangle {
            color: "#353535"
        }
        
        // This is your .ui.qml file
        contentItem: MainMenu {
            id: menuContent
            anchors.fill: parent

            // Handle the logic here (scripts are allowed in Main.qml)

            importArea.onClicked: {
                importPathDialog.open();
            }

            resyncArea.onClicked: {
                backend.resyncModPacks();
            }

            exitArea.onClicked: {
                Qt.quit();
            }
        }

        // Optional: Close menu if user clicks outside
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    }
    
    header: ToolBar {
        background: Rectangle { color: "#2d2d2d" } // Match your sidebar color


        RowLayout {
            anchors.fill: parent
            spacing: 0

            // 1. THE MENUS (Left Aligned)
            Item {
                Layout.preferredWidth: 40
                Layout.fillHeight: true

                Image {
                    id: appIcon
                    source: "qrc:/qt/qml/modmanagerx/images/Mod Manager X.ico"
                    width: 18; height: 22
                    anchors.centerIn: parent
                }

                TapHandler {
                    onTapped: mainMenu.opened ? mainMenu.close() : mainMenu.open()
                }
                
                // Hover effect for the icon button
                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: parent.hovered ? 0.1 : 0
                    z: -1
                }
            }

            // Spacer to push buttons to the right
            Item { Layout.fillWidth: true }

            // 2. THE APP ICON


            // 3. MINIMIZE BUTTON
            Rectangle {
                id: minBtn
                Layout.preferredWidth: 46
                Layout.preferredHeight: 30
                Layout.fillHeight: true
                color: minArea.containsMouse ? "#404040" : "transparent"
                
                Text {
                    text: "—"
                    color: "white"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                }
                MouseArea {
                    id: minArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: window.showMinimized()
                }
            }

            // 4. CLOSE BUTTON
            Rectangle {
                id: closeBtn
                Layout.preferredWidth: 46
                Layout.preferredHeight: 30
                Layout.fillHeight: true
                color: closeArea.containsMouse ? "#e81123" : "transparent"
                
                Text {
                    text: "✕"
                    color: "white"
                    font.pixelSize: 14
                    anchors.centerIn: parent
                }
                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: window.hide()
                }
            }
        }
    }

    // Load your design component
    MainScreen {
        id: mainScreen
        anchors.fill: parent

        

        modListView.model: backend.modpackItems
        modListView.delegate: Rectangle {
            width: ListView.view.width
            height: 40 // Give it a fixed height or implicitHeight
            
            color: {
                switch(modelData.status) {
                case ModPack.UpdateAvailable: return "#f1c40f" // Yellow
                case ModPack.Error:           return "#e74c3c" // Red
                case ModPack.UpToDate:        return "#2ecc71" // Green
                default:                      return "#2d2d2d" // Your menu gray
                }
            }

            Text {
                text: modelData ? modelData.name : "..."
                font.family: "F77 Minecraft"
                font.pointSize: 18
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                
                color: {
                    switch(modelData.status) {
                    case ModPack.UpdateAvailable: return "#000000"
                    case ModPack.Error:           return "#ffffff"
                    case ModPack.UpToDate:        return "#ffffff"
                    default:                      return "#000000"
                    }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: backend.selectModPack(index)
            }
        }
        
    }

    Connections {
        target: mainScreen.updateButton

        function onClicked() {
            backend.updateButtonClicked()
        }

    }

    Connections {
        target: backend

        function onShowImportDialogRequested(name, location, path, filePath) {
            // Bring the window to the front in case it was minimized

            // Populate and open your dialog
            importDialog.name = name
            importDialog.location = location
            importDialog.path = path
            importDialog.filePath = filePath
            importDialog.open()
        }
    }

}
