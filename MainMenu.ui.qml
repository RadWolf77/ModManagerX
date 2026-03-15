

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    width: 163
    height: 216
    color: "#353535"

    property alias importArea: importArea
    property alias resyncArea: resyncArea
    property alias forceUpdateArea: forceUpdateArea
    property alias reinstallModpackArea: reinstallModpackArea
    property alias uninstallModpackArea: uninstallModpackArea
    property alias exitArea: exitArea

    // The menu items here are organized into the categories of their function.
    // Import file is import and very common, so it is at top.
    // Resync and Force Update both relate to MMX itself
    // Open pack dir, etc relate to the modpacks themselves
    // Exit at bottom because we are civilized.
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: importButton
            height: 20
            Layout.fillWidth: true
            Layout.preferredHeight: 25
            color: importArea.containsMouse ? "#00aaff" : "transparent"

            Text {
                text: Language.get("MENU_IMPORT")
                horizontalAlignment: Text.AlignHCenter
                textFormat: Text.RichText
                font.pointSize: 14
                color: "white"
                font.family: "F77 Minecraft"
                anchors.centerIn: parent
                fontSizeMode: Text.Fit
                elide: Text.ElideRight
            }
            MouseArea {
                id: importArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        Column {
            Layout.fillWidth: true
            Layout.leftMargin: 10 // Optional: adds padding so it doesn't touch the edges
            Layout.rightMargin: 10
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            // Top line (dark)
            Rectangle {
                width: parent.width
                height: 2
                color: "#5d5d5d"
            }
            // Bottom line (highlight - slightly lighter than the background)
            Rectangle {
                width: parent.width
                height: 2
                color: "#838383"
            }
        }

        Rectangle {
            id: resyncButton
            Layout.fillWidth: true
            Layout.preferredHeight: 25
            color: resyncArea.containsMouse ? "#404040" : "transparent"

            Text {
                text: Language.get("MENU_RESYNC")
                horizontalAlignment: Text.AlignHCenter
                textFormat: Text.RichText
                font.pointSize: 14
                color: "white"
                font.family: "F77 Minecraft"
                anchors.centerIn: parent
                fontSizeMode: Text.Fit
                elide: Text.ElideRight
            }
            MouseArea {
                id: resyncArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        // Button 1: File Explorer
        Rectangle {
            id: forceUpdateButton
            Layout.fillWidth: true
            Layout.preferredHeight: 25
            color: forceUpdateArea.containsMouse ? "#404040" : "transparent"

            Text {
                text: Language.get("MENU_FORCE")
                horizontalAlignment: Text.AlignHCenter
                textFormat: Text.RichText
                font.pointSize: 14
                color: "white"
                font.family: "F77 Minecraft"
                anchors.centerIn: parent
                fontSizeMode: Text.Fit
                elide: Text.ElideRight
            }
            MouseArea {
                id: forceUpdateArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        Column {
            Layout.fillWidth: true
            Layout.leftMargin: 10 // Optional: adds padding so it doesn't touch the edges
            Layout.rightMargin: 10
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            // Top line (dark)
            Rectangle {
                width: parent.width
                height: 2
                color: "#5d5d5d"
            }
            // Bottom line (highlight - slightly lighter than the background)
            Rectangle {
                width: parent.width
                height: 2
                color: "#838383"
            }
        }

        Rectangle {
            id: explorerButton
            Layout.fillWidth: true
            Layout.preferredHeight: 25
            color: explorerArea.containsMouse ? "#404040" : "transparent"

            Text {
                text: Language.get("MENU_OPENDIR")
                horizontalAlignment: Text.AlignHCenter
                textFormat: Text.RichText
                font.pointSize: 14
                color: "white"
                font.family: "F77 Minecraft"
                anchors.centerIn: parent
                fontSizeMode: Text.Fit
                elide: Text.ElideRight
            }
            MouseArea {
                id: explorerArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        Rectangle {
            id: reinstallModpackButton
            Layout.fillWidth: true
            Layout.preferredHeight: 25
            color: reinstallModpackArea.containsMouse ? "#404040" : "transparent"

            Text {
                text: Language.get("MENU_REINSTALL")
                font.pointSize: 14
                color: "white"
                font.family: "F77 Minecraft"
                anchors.centerIn: parent
                fontSizeMode: Text.Fit
                elide: Text.ElideRight
            }
            MouseArea {
                id: reinstallModpackArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        Rectangle {
            id: uninstallModpackButton
            Layout.fillWidth: true
            Layout.preferredHeight: 25
            color: uninstallModpackArea.containsMouse ? "#e81123" : "transparent"

            Text {
                text: Language.get("MENU_UNINSTALL")
                font.pointSize: 14
                color: "white"
                font.family: "F77 Minecraft"
                anchors.centerIn: parent
                fontSizeMode: Text.Fit
                elide: Text.ElideRight
            }
            MouseArea {
                id: uninstallModpackArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        Column {
            Layout.fillWidth: true
            Layout.leftMargin: 10 // Optional: adds padding so it doesn't touch the edges
            Layout.rightMargin: 10
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            // Top line (dark)
            Rectangle {
                width: parent.width
                height: 2
                color: "#5d5d5d"
            }
            // Bottom line (highlight - slightly lighter than the background)
            Rectangle {
                width: parent.width
                height: 2
                color: "#838383"
            }
        }

        Rectangle {
            id: exitButton
            color: exitArea.containsMouse ? "#e81123" : "transparent"
            Text {
                color: "#ffffff"
                text: Language.get("MENU_EXIT")
                font.pointSize: 14
                font.family: "F77 Minecraft"
                anchors.centerIn: parent
                fontSizeMode: Text.Fit
                elide: Text.ElideRight
            }

            MouseArea {
                id: exitArea
                anchors.fill: parent
                hoverEnabled: true
            }
            Layout.preferredHeight: 25
            Layout.fillWidth: true
        }
    }
}
