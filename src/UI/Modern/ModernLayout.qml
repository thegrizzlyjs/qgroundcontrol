import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QGroundControl.Palette
import QGroundControl.ScreenTools
import QGroundControl.Controls

/// Modern main layout with central map, left sidebar, right panel, and status bar
Rectangle {
    id: root
    
    property var vehicle: null
    property var missionController: null
    property var mapController: null
    
    // Design tokens from design-tokens.json
    readonly property color colorPrimary: "#00BCD4"
    readonly property color colorCyan: "#00BCD4"
    readonly property color colorEmerald: "#10B981"
    readonly property color colorSuccess: "#10B981"
    readonly property color colorWarning: "#F59E0B"
    readonly property color colorError: "#EF4444"
    
    readonly property color bgPrimary: "#FFFFFF"
    readonly property color bgSecondary: "#F9FAFB"
    readonly property color textPrimary: "#111827"
    readonly property color textSecondary: "#4B5563"
    readonly property color borderColor: "#D1D5DB"
    
    readonly property int spacingUnit: 4
    readonly property int minTouchTarget: 44
    
    color: bgPrimary
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Top toolbar / header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            color: bgSecondary
            border.color: borderColor
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: spacingUnit * 2
                spacing: spacingUnit * 3
                
                Text {
                    text: qsTr("QGroundControl Modern")
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                // Theme toggle
                ToolButton {
                    text: "🌙"
                    onClicked: {
                        // Toggle dark mode
                    }
                    ToolTip.text: qsTr("Toggle dark mode")
                    ToolTip.visible: hovered
                }
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            
            // Left sidebar
            ModernLeftSidebar {
                Layout.preferredWidth: sidebarWidth
                Layout.fillHeight: true
                vehicle: root.vehicle
                missionController: root.missionController
            }
            
            // Central map area (80% of width)
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#E0E0E0" // Placeholder for map
                border.color: borderColor
                border.width: 1
                
                Text {
                    anchors.centerIn: parent
                    text: qsTr("Map Area (OSM/Satellite/Terrain)")
                    font.pixelSize: 14
                    color: textSecondary
                }
            }
            
            // Right slide-over panel
            ModernRightPanel {
                Layout.preferredWidth: 350
                Layout.fillHeight: true
                visible: showRightPanel
                vehicle: root.vehicle
                missionController: root.missionController
            }
        }
        
        // Status bar at bottom
        ModernStatusBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            vehicle: root.vehicle
        }
    }
    
    // FAB (Floating Action Button)
    ModernFAB {
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: spacingUnit * 4
        }
        vehicle: root.vehicle
        missionController: root.missionController
    }
    
    // Properties
    property bool showRightPanel: true
    property int sidebarWidth: 280
}
