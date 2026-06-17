import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/// Right-side slide-over panel for properties and parameters
Rectangle {
    id: rightPanel
    
    property var vehicle: null
    property var missionController: null
    
    // Design tokens
    readonly property color bgPrimary: "#FFFFFF"
    readonly property color bgSecondary: "#F9FAFB"
    readonly property color borderColor: "#D1D5DB"
    readonly property color textPrimary: "#111827"
    readonly property color textSecondary: "#4B5563"
    readonly property int spacingUnit: 4
    
    color: bgPrimary
    border.color: borderColor
    border.width: 1
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit * 2
        spacing: spacingUnit * 2
        
        // Header with close button
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: qsTr("Properties")
                font.pixelSize: 16
                font.weight: Font.Bold
                color: textPrimary
            }
            
            Item { Layout.fillWidth: true }
            
            ToolButton {
                text: "✕"
                onClicked: rightPanel.visible = false
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }
        
        // Scrollable content
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            ColumnLayout {
                width: rightPanel.width - spacingUnit * 4
                spacing: spacingUnit * 2
                
                // Property groups
                PropertyGroup {
                    title: qsTr("Position")
                    properties: [
                        { label: "Latitude", value: vehicle ? vehicle.latitude.toFixed(6) : "N/A" },
                        { label: "Longitude", value: vehicle ? vehicle.longitude.toFixed(6) : "N/A" },
                        { label: "Altitude", value: vehicle ? vehicle.altitudeAMSL.toFixed(1) + " m" : "N/A" }
                    ]
                }
                
                PropertyGroup {
                    title: qsTr("Battery")
                    properties: [
                        { label: "Voltage", value: vehicle ? vehicle.battery.voltage.toFixed(1) + " V" : "N/A" },
                        { label: "Capacity", value: vehicle ? vehicle.battery.capacity.toFixed(1) + "%" : "N/A" },
                        { label: "Current", value: vehicle ? vehicle.battery.current.toFixed(1) + " A" : "N/A" }
                    ]
                }
                
                PropertyGroup {
                    title: qsTr("Flight Mode")
                    properties: [
                        { label: "Mode", value: vehicle ? vehicle.flightMode : "N/A" },
                        { label: "Armed", value: vehicle ? (vehicle.armed ? "Yes" : "No") : "N/A" }
                    ]
                }
                
                Item { Layout.fillHeight: true }
            }
        }
    }
}

/// Property group display
Rectangle {
    id: propGroup
    
    property string title: ""
    property var properties: [] // Array of {label, value}
    
    readonly property color bgSecondary: "#F9FAFB"
    readonly property color textPrimary: "#111827"
    readonly property color textSecondary: "#4B5563"
    readonly property int spacingUnit: 4
    
    color: bgSecondary
    radius: 8
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit * 2
        spacing: spacingUnit
        
        Text {
            text: propGroup.title
            font.pixelSize: 14
            font.weight: Font.Bold
            color: textPrimary
            Layout.fillWidth: true
        }
        
        Repeater {
            model: propGroup.properties
            
            RowLayout {
                Layout.fillWidth: true
                spacing: spacingUnit
                
                Text {
                    text: modelData.label + ":"
                    font.pixelSize: 12
                    color: textSecondary
                    Layout.preferredWidth: 100
                }
                
                Text {
                    text: modelData.value
                    font.pixelSize: 12
                    font.family: "monospace"
                    color: textPrimary
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
        }
    }
}
