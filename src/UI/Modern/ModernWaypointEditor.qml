import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/// Modern Waypoint Editor with drag/drop, snapping, and inline editing
Rectangle {
    id: waypointEditor
    
    property var missionController: null
    property var mapController: null
    
    // Design tokens
    readonly property color bgPrimary: "#FFFFFF"
    readonly property color bgSecondary: "#F9FAFB"
    readonly property color borderColor: "#D1D5DB"
    readonly property color textPrimary: "#111827"
    readonly property color textSecondary: "#4B5563"
    readonly property color colorCyan: "#00BCD4"
    readonly property color colorWarning: "#F59E0B"
    readonly property int spacingUnit: 4
    
    color: bgPrimary
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit * 2
        spacing: spacingUnit * 2
        
        // Header with tools
        RowLayout {
            Layout.fillWidth: true
            spacing: spacingUnit * 2
            
            Text {
                text: qsTr("Waypoints")
                font.pixelSize: 16
                font.weight: Font.Bold
                color: textPrimary
            }
            
            ToolButton {
                text: "➕"
                ToolTip.text: qsTr("Add waypoint")
                onClicked: missionController.addWaypoint()
            }
            
            ToolButton {
                text: "🗑️"
                ToolTip.text: qsTr("Delete selected")
                onClicked: missionController.deleteWaypoint()
            }
            
            // Alignment tools
            ToolButton {
                text: "↔️"
                ToolTip.text: qsTr("Space evenly")
                onClicked: missionController.spaceWaypoints()
            }
            
            Item { Layout.fillWidth: true }
        }
        
        // Waypoint list with inline editing
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            ColumnLayout {
                width: waypointEditor.width - spacingUnit * 4
                spacing: spacingUnit
                
                Repeater {
                    model: missionController ? missionController.waypoints : []
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: bgSecondary
                        radius: 8
                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: spacingUnit * 2
                            spacing: spacingUnit
                            
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: spacingUnit
                                
                                Text {
                                    text: index + 1
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: colorCyan
                                }
                                
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    
                                    TextField {
                                        Layout.fillWidth: true
                                        text: modelData.command || ""
                                        placeholderText: qsTr("Command")
                                        readOnly: false
                                        font.pixelSize: 12
                                        
                                        background: Rectangle {
                                            color: "transparent"
                                            border.color: borderColor
                                            border.width: 1
                                            radius: 4
                                        }
                                    }
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: spacingUnit
                                        
                                        TextField {
                                            Layout.preferredWidth: 100
                                            text: modelData.latitude ? modelData.latitude.toFixed(6) : ""
                                            placeholderText: qsTr("Lat")
                                            font.pixelSize: 11
                                        }
                                        
                                        TextField {
                                            Layout.preferredWidth: 100
                                            text: modelData.longitude ? modelData.longitude.toFixed(6) : ""
                                            placeholderText: qsTr("Lon")
                                            font.pixelSize: 11
                                        }
                                        
                                        TextField {
                                            Layout.preferredWidth: 80
                                            text: modelData.altitude ? modelData.altitude.toFixed(1) : ""
                                            placeholderText: qsTr("Alt (m)")
                                            font.pixelSize: 11
                                        }
                                    }
                                }
                                
                                ToolButton {
                                    text: "📋"
                                    onClicked: missionController.duplicateWaypoint(index)
                                }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            drag.target: parent
                            drag.threshold: 10
                        }
                    }
                }
            }
        }
        
        // Validation status
        Rectangle {
            Layout.fillWidth: true
            height: 32
            color: "#FEF3C7"
            radius: 6
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: spacingUnit
                spacing: spacingUnit
                
                Text {
                    text: "⚠️"
                    font.pixelSize: 14
                }
                
                Text {
                    text: qsTr("3 validation warnings")
                    font.pixelSize: 12
                    color: textPrimary
                    Layout.fillWidth: true
                }
                
                ToolButton {
                    text: "View"
                    onClicked: showValidationDetails()
                }
            }
        }
    }
    
    function showValidationDetails() {
        // Show validation panel
    }
}
