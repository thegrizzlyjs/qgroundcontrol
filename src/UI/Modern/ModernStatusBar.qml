import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/// Status bar at the bottom showing multi-vehicle state
Rectangle {
    id: statusBar
    
    property var vehicle: null
    
    // Design tokens
    readonly property color bgSecondary: "#F9FAFB"
    readonly property color borderColor: "#D1D5DB"
    readonly property color textPrimary: "#111827"
    readonly property color textSecondary: "#4B5563"
    readonly property int spacingUnit: 4
    
    color: bgSecondary
    border.color: borderColor
    border.width: 1
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit * 2
        spacing: spacingUnit * 3
        
        // GPS status
        RowLayout {
            spacing: spacingUnit
            
            Text {
                text: "📍"
                font.pixelSize: 14
            }
            
            ColumnLayout {
                spacing: 0
                
                Text {
                    text: qsTr("GPS")
                    font.pixelSize: 11
                    color: textSecondary
                }
                
                Text {
                    text: vehicle ? (vehicle.gps.fixType ? "3D Fix" : "No Fix") : "N/A"
                    font.pixelSize: 12
                    color: textPrimary
                    font.bold: true
                }
            }
        }
        
        Rectangle {
            width: 1
            height: parent.height * 0.6
            color: borderColor
        }
        
        // Battery status
        RowLayout {
            spacing: spacingUnit
            
            Text {
                text: "🔋"
                font.pixelSize: 14
            }
            
            ColumnLayout {
                spacing: 0
                
                Text {
                    text: qsTr("Battery")
                    font.pixelSize: 11
                    color: textSecondary
                }
                
                Text {
                    text: vehicle ? vehicle.battery.capacity.toFixed(0) + "%" : "N/A"
                    font.pixelSize: 12
                    color: textPrimary
                    font.bold: true
                }
            }
        }
        
        Rectangle {
            width: 1
            height: parent.height * 0.6
            color: borderColor
        }
        
        // Flight mode
        RowLayout {
            spacing: spacingUnit
            
            Text {
                text: "✈️"
                font.pixelSize: 14
            }
            
            ColumnLayout {
                spacing: 0
                
                Text {
                    text: qsTr("Mode")
                    font.pixelSize: 11
                    color: textSecondary
                }
                
                Text {
                    text: vehicle ? vehicle.flightMode : "N/A"
                    font.pixelSize: 12
                    color: textPrimary
                    font.bold: true
                }
            }
        }
        
        Rectangle {
            width: 1
            height: parent.height * 0.6
            color: borderColor
        }
        
        // Link status / Latency
        RowLayout {
            spacing: spacingUnit
            
            Text {
                text: "📡"
                font.pixelSize: 14
            }
            
            ColumnLayout {
                spacing: 0
                
                Text {
                    text: qsTr("Latency")
                    font.pixelSize: 11
                    color: textSecondary
                }
                
                Text {
                    text: vehicle ? vehicle.mavlinkSilenceMs + " ms" : "N/A"
                    font.pixelSize: 12
                    color: textPrimary
                    font.bold: true
                }
            }
        }
        
        Item { Layout.fillWidth: true }
        
        // Vehicle count
        Text {
            text: qsTr("1 Vehicle")
            font.pixelSize: 12
            color: textSecondary
        }
    }
}
