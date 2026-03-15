

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VectorImage

Item {
    id: mainScreen
    width: 680
    height: 480
    property alias updateButton: updateButton

    property alias modListView: modList

    property alias packIcon: packIcon

    property alias noticeText: noticeText

    RowLayout {
        width: 200
        height: 480
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.topMargin: 0
        spacing: 0

        // 1. LEFT SIDEBAR (Scrollable List)
        Rectangle {
            id: rectangle1
            Layout.fillHeight: true
            Layout.preferredWidth: 200
            color: "#ffffff"

            ListView {
                id: modList
                y: 0
                width: 192
                height: 480
                anchors.left: parent.left
                anchors.leftMargin: 0
                boundsMovement: Flickable.FollowBoundsBehavior
                flickableDirection: Flickable.VerticalFlick
                layer.enabled: false
                boundsBehavior: Flickable.StopAtBounds
                model: backend.modItems // Connected to C++
                clip: true // Prevents drawing outside the box

                ScrollIndicator.vertical: ScrollIndicator {}
            }
        }
    }

    Image {
        id: grayMMX
        x: 223
        y: 76
        width: 437
        height: 328
        opacity: 0.1
        source: "images/GrayMMX.png"
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: areaTitle
        x: 200
        width: 480
        height: 51
        text: backend.getSelectedModPack ? backend.getSelectedModPack.name : ""
        anchors.top: parent.top
        anchors.topMargin: 0
        font.pixelSize: 40
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Rectangle {
        id: rectangle
        x: 191
        y: 0
        width: 11
        height: 480
        color: "#fafafa"
    }

    ScriptAction {
        id: scriptAction
    }

    Button {
        id: updateButton
        x: 348
        y: 421
        width: 188
        height: 35
        text: backend.getSelectedModPack ? backend.getSelectedModPack.getButtonText(
                                               ) : ""
        enabled: backend.getSelectedModPack ? backend.getSelectedModPack.canUpdate : ""
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        baselineOffset: 29
        wheelEnabled: false
        checkable: false
        highlighted: false
        flat: false
        font.bold: false
        font.family: "F77 Minecraft"
        display: AbstractButton.TextOnly
        font.pointSize: 20

        contentItem: Text {
            text: updateButton.text
            font: updateButton.font
            color: "#000000" // Forces black text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter // Fixes the downward shift
        }
    }

    Text {
        id: packversionstatic
        x: 223
        width: 217
        height: 26
        visible: backend.getSelectedModPack ? true : false
        text: Language.get("MAIN_CURRENTVERSION")
        anchors.top: parent.top
        anchors.topMargin: 76
        font.pixelSize: 24
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: versionText
        x: 443
        width: 217
        height: 26
        text: backend.getSelectedModPack ? backend.getSelectedModPack.version : ""
        anchors.top: parent.top
        anchors.topMargin: 76
        font.pixelSize: 24
        horizontalAlignment: Text.AlignRight
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: descText
        x: 223
        width: 217
        height: 206
        text: backend.getSelectedModPack ? backend.getSelectedModPack.description : ""
        anchors.top: parent.top
        anchors.topMargin: 146
        font.pixelSize: 20
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Image {
        id: packIcon
        x: 446
        y: 133
        width: 219
        height: 219
        fillMode: Image.PreserveAspectFit
        source: backend.getCurrentIconPath
    }

    Text {
        id: latestversionstatic
        x: 223
        width: 217
        height: 26
        text: Language.get("MAIN_LATESTVERSION")
        visible: backend.getSelectedModPack ? true : false
        anchors.top: parent.top
        anchors.topMargin: 102
        font.pixelSize: 24
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: latestText
        x: 446
        width: 217
        height: 26
        text: backend.getSelectedModPack ? backend.getSelectedModPack.latestVersion : ""
        anchors.top: parent.top
        anchors.topMargin: 102
        font.pixelSize: 24
        horizontalAlignment: Text.AlignRight
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: noticeText
        x: 223
        y: 377
        width: 437
        height: 33
        text: backend.getSelectedModPack ? backend.getSelectedModPack.getNoticeText(
                                               ) : ""
        font.pixelSize: 10
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }
}



