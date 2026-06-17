import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/// Left sidebar with collapsible navigation
Rectangle {
    id: sidebar
    
    property var vehicle: null
    property var missionController: null
    property bool isCollapsed: false
    
    // Design tokens
    readonly property color bgSecondary: "#F9FAFB"
    readonly property color bgTertiary: "#F3F4F6"
    readonly property color textPrimary: "#111827"
    readonly property color textSecondary: "#4B5563"
    readonly property color borderColor: "#D1D5DB"
    readonly property color colorCyan: "#00BCD4"
    readonly property int spacingUnit: 4
    readonly property int minTouchTarget: 44
    
    color: bgSecondary
    border.color: borderColor
    border.width: 1
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit * 2
        spacing: spacingUnit * 2
        
        // Navigation items
        ModernNavItem {
            Layout.fillWidth: true
            icon: "📋"
            label: qsTr("Plan")
            isActive: true
            isCollapsed: sidebar.isCollapsed
            onClicked: selectSection("plan")
        }
        
        ModernNavItem {
            Layout.fillWidth: true
            icon: "🚁"
            label: qsTr("Fly")
            isCollapsed: sidebar.isCollapsed
            onClicked: selectSection("fly")
        }
        
        ModernNavItem {
            Layout.fillWidth: true
            icon: "🚗"
            label: qsTr("Vehicles")
            isCollapsed: sidebar.isCollapsed
            onClicked: selectSection("vehicles")
        }
        
        ModernNavItem {
            Layout.fillWidth: true
            icon: "📚"
            label: qsTr("Library")
            isCollapsed: sidebar.isCollapsed
            onClicked: selectSection("library")
        }
        
        ModernNavItem {
            Layout.fillWidth: true
            icon: "📊"
            label: qsTr("Analyze")
            isCollapsed: sidebar.isCollapsed
            onClicked: selectSection("analyze")
        }
        
        Rectangle { Layout.fillHeight: true; color: "transparent" }
        
        ModernNavItem {
            Layout.fillWidth: true
            icon: "⚙️"
            label: qsTr("Settings")
            isCollapsed: sidebar.isCollapsed
            onClicked: selectSection("settings")
        }
        
        // Collapse toggle
        ToolButton {
            Layout.alignment: Qt.AlignHCenter
            text: sidebar.isCollapsed ? "→" : "←"
            ToolTip.text: qsTr("Toggle sidebar")
            ToolTip.visible: hovered
            onClicked: sidebar.isCollapsed = !sidebar.isCollapsed
        }
    }
    
    signal selectSection(string sectionName)
}

/// Navigation item component
Rectangle {
    id: navItem
    
    property string icon: ""
    property string label: ""
    property bool isActive: false
    property bool isCollapsed: false
    
    readonly property color colorCyan: "#00BCD4"
    readonly property color bgHover: "#F3F4F6"
    readonly property int spacingUnit: 4
    readonly property int minTouchTarget: 44
    
    signal clicked()
    
    color: isActive ? "#E0F2FE" : "transparent"
    radius: 6
    height: minTouchTarget
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit
        spacing: spacingUnit * 2
        
        Text {
            text: navItem.icon
            font.pixelSize: 20
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.preferredWidth: 24
        }
        
        Text {
            text: navItem.label
            font.pixelSize: 14
            color: navItem.isActive ? "#0097A7" : "#374151"
            Layout.fillWidth: !navItem.isCollapsed
            visible: !navItem.isCollapsed
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: navItem.clicked()
        onEntered: navItem.color = navItem.isActive ? navItem.color : navItem.bgHover
        onExited: navItem.color = navItem.isActive ? "#E0F2FE" : "transparent"
    }
}
