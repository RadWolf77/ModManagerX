

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    implicitWidth: 300
    implicitHeight: 220
    width: 300
    height: 220
    radius: 0
    border.color: "#00aaff"
    border.width: 3

    property string name: ""
    property string location: ""
    property string path: ""

    property alias doImportArea: doImportArea
    property alias nevermindArea: nevermindArea

    Text {
        id: title
        x: 8
        y: 5
        width: 284
        height: 17
        text: Language.get("DIALOG_TITLE")
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: nameStatic
        x: 8
        y: 38
        text: Language.get("DIALOG_NAMELABEL")
        font.pixelSize: 12
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: locationStatic
        x: 8
        y: 85
        text: Language.get("DIALOG_LOCATIONLABEL")
        font.pixelSize: 12
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: pathStatic
        x: 8
        y: 139
        text: Language.get("DIALOG_PATHLABEL")
        font.pixelSize: 12
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: name
        x: 91
        y: 38
        width: 201
        height: 40
        text: root.name
        font.pixelSize: 12
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.Wrap
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: location
        x: 91
        y: 85
        width: 201
        height: 40
        text: root.location
        font.pixelSize: 12
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.Wrap
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Text {
        id: path
        x: 91
        y: 139
        width: 201
        height: 40
        text: root.path
        font.pixelSize: 12
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.Wrap
        font.family: "F77 Minecraft"
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
    }

    Rectangle {
        id: doImport
        x: 225
        y: 180
        width: 67
        height: 29
        color: doImportArea.containsMouse ? "#00aaff" : "#00aa00"

        Text {
            width: 67
            height: 17
            text: Language.get("DIALOG_ACCEPT")
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 1
            minimumPixelSize: 8
            textFormat: Text.RichText
            font.pointSize: 12
            color: "white"
            font.family: "F77 Minecraft"
            anchors.centerIn: parent
            fontSizeMode: Text.Fit
            elide: Text.ElideRight
        }
        MouseArea {
            id: doImportArea
            anchors.fill: parent
            hoverEnabled: true
        }
    }

    Rectangle {
        id: nevermind
        x: 11
        y: 180
        width: 67
        height: 29
        color: nevermindArea.containsMouse ? "#00aaff" : "red"

        Text {
            text: Language.get("DIALOG_CANCEL")
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: 8
            textFormat: Text.RichText
            font.pointSize: 12
            color: "white"
            font.family: "F77 Minecraft"
            anchors.centerIn: parent
            fontSizeMode: Text.Fit
            elide: Text.ElideRight
        }
        MouseArea {
            id: nevermindArea
            anchors.fill: parent
            hoverEnabled: true
        }
    }
}
