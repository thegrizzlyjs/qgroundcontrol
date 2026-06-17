import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/// Floating Action Button with primary actions
Rectangle {
    id: fab
    
    property var vehicle: null
    property var missionController: null
    
    // Design tokens
    readonly property color colorCyan: "#00BCD4"
    readonly property color colorEmerald: "#10B981"
    readonly property color colorError: "#EF4444"
    readonly property color textPrimary: "#111827"
    readonly property color white: "#FFFFFF"
    readonly property int spacingUnit: 4
    readonly property int minTouchTarget: 48
    
    width: minTouchTarget
    height: minTouchTarget
    radius: minTouchTarget / 2
    color: colorCyan
    
    signal createMissionClicked()
    signal armClicked()
    signal startClicked()
    signal cancelClicked()
    
    // Main button
    Control {
        anchors.centerIn: parent
        width: minTouchTarget
        height: minTouchTarget
        
        background: Rectangle {
            color: colorCyan
            radius: parent.width / 2
        }
        
        contentItem: Text {
            anchors.centerIn: parent
            text: fab.expanded ? "✕" : "+"
            font.pixelSize: 28
            color: white
            font.bold: true
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: fab.expanded = !fab.expanded
        }
    }
    
    // Expanded menu
    Rectangle {
        id: menuContainer
        anchors {
            right: parent.right
            bottom: parent.top
            margins: spacingUnit * 2
        }
        width: 180
        height: menuColumn.implicitHeight + spacingUnit * 2
        radius: 12
        color: white
        border.color: "#D1D5DB"
        border.width: 1
        
        visible: fab.expanded
        
        ColumnLayout {
            id: menuColumn
            anchors.fill: parent
            anchors.margins: spacingUnit * 2
            spacing: spacingUnit
            
            FabMenuItem {
                Layout.fillWidth: true
                icon: "➕"
                label: qsTr("Create Mission")
                onClicked: {
                    fab.createMissionClicked()
                    fab.expanded = false
                }
            }
            
            FabMenuItem {
                Layout.fillWidth: true
                icon: "🚀"
                label: qsTr("Arm Vehicle")
                backgroundColor: colorEmerald
                onClicked: {
                    fab.armClicked()
                    fab.expanded = false
                }
            }
            
            FabMenuItem {
                Layout.fillWidth: true
                icon: "▶️"
                label: qsTr("Start Mission")
                backgroundColor: colorCyan
                onClicked: {
                    fab.startClicked()
                    fab.expanded = false
                }
            }
        }
    }
    
    // Dim overlay when expanded
    MouseArea {
        anchors.fill: parent
        visible: fab.expanded
        enabled: fab.expanded
        onClicked: fab.expanded = false
    }
    
    property bool expanded: false
}

/// FAB menu item
Rectangle {
    id: menuItem
    
    property string icon: ""
    property string label: ""
    property color backgroundColor: "#00BCD4"
    
    signal clicked()
    
    readonly property int spacingUnit: 4
    readonly property color white: "#FFFFFF"
    readonly property color textPrimary: "#111827"
    
    color: "transparent"
    radius: 8
    height: 40
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit
        spacing: spacingUnit
        
        Rectangle {
            width: 28
            height: 28
            radius: 4
            color: menuItem.backgroundColor
            
            Text {
                anchors.centerIn: parent
                text: menuItem.icon
                font.pixelSize: 14
            }
        }
        
        Text {
            text: menuItem.label
            font.pixelSize: 12
            color: textPrimary
            Layout.fillWidth: true
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: menuItem.clicked()
        onEntered: menuItem.color = "#F3F4F6"
        onExited: menuItem.color = "transparent"
    }
}
