import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/// Modern Layer Manager for map layers (satellite, OSM, terrain, etc.)
Rectangle {
    id: layerManager
    
    property var mapController: null
    
    // Design tokens
    readonly property color bgPrimary: "#FFFFFF"
    readonly property color bgSecondary: "#F9FAFB"
    readonly property color borderColor: "#D1D5DB"
    readonly property color textPrimary: "#111827"
    readonly property color textSecondary: "#4B5563"
    readonly property color colorCyan: "#00BCD4"
    readonly property int spacingUnit: 4
    
    color: bgPrimary
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit * 2
        spacing: spacingUnit * 2
        
        // Header
        Text {
            text: qsTr("Map Layers")
            font.pixelSize: 16
            font.weight: Font.Bold
            color: textPrimary
            Layout.fillWidth: true
        }
        
        // Base layer selection
        ColumnLayout {
            Layout.fillWidth: true
            spacing: spacingUnit
            
            Text {
                text: qsTr("Base Layer")
                font.pixelSize: 12
                font.bold: true
                color: textSecondary
            }
            
            ComboBox {
                Layout.fillWidth: true
                model: ["OpenStreetMap", "Satellite", "Terrain", "Hybrid"]
                currentIndex: 0
                onCurrentIndexChanged: {
                    if (mapController) {
                        mapController.setBaseLayer(currentText)
                    }
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }
        
        // Overlay layers with toggles
        Text {
            text: qsTr("Overlays")
            font.pixelSize: 12
            font.bold: true
            color: textSecondary
            Layout.fillWidth: true
        }
        
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            ColumnLayout {
                width: layerManager.width - spacingUnit * 4
                spacing: spacingUnit
                
                // Weather overlay
                LayerToggleItem {
                    Layout.fillWidth: true
                    label: qsTr("Weather")
                    icon: "🌤️"
                    enabled: true
                    opacity: 0.7
                    onToggled: mapController.setLayerVisible("weather", checked)
                    onOpacityChanged: mapController.setLayerOpacity("weather", opacity)
                }
                
                // No-fly zones
                LayerToggleItem {
                    Layout.fillWidth: true
                    label: qsTr("No-Fly Zones")
                    icon: "⛔"
                    enabled: true
                    opacity: 0.6
                    onToggled: mapController.setLayerVisible("nofly", checked)
                    onOpacityChanged: mapController.setLayerOpacity("nofly", opacity)
                }
                
                // Terrain
                LayerToggleItem {
                    Layout.fillWidth: true
                    label: qsTr("Terrain Elevation")
                    icon: "🏔️"
                    enabled: true
                    opacity: 0.5
                    onToggled: mapController.setLayerVisible("terrain", checked)
                    onOpacityChanged: mapController.setLayerOpacity("terrain", opacity)
                }
                
                // Mission area
                LayerToggleItem {
                    Layout.fillWidth: true
                    label: qsTr("Mission Area")
                    icon: "📍"
                    enabled: true
                    opacity: 0.8
                    onToggled: mapController.setLayerVisible("mission", checked)
                    onOpacityChanged: mapController.setLayerOpacity("mission", opacity)
                }
                
                // Vehicle positions
                LayerToggleItem {
                    Layout.fillWidth: true
                    label: qsTr("Vehicle Positions")
                    icon: "🚁"
                    enabled: true
                    opacity: 1.0
                    onToggled: mapController.setLayerVisible("vehicles", checked)
                    onOpacityChanged: mapController.setLayerOpacity("vehicles", opacity)
                }
                
                Item { Layout.fillHeight: true }
            }
        }
        
        // Legend
        Rectangle {
            Layout.fillWidth: true
            color: bgSecondary
            radius: 8
            height: contentColumn.implicitHeight + spacingUnit * 2
            
            ColumnLayout {
                id: contentColumn
                anchors.fill: parent
                anchors.margins: spacingUnit * 2
                spacing: spacingUnit
                
                Text {
                    text: qsTr("Legend")
                    font.pixelSize: 11
                    font.bold: true
                    color: textSecondary
                }
                
                RowLayout {
                    spacing: spacingUnit
                    
                    Rectangle { width: 16; height: 16; color: colorCyan; radius: 2 }
                    Text { text: qsTr("Waypoints"); font.pixelSize: 11; color: textPrimary }
                }
                
                RowLayout {
                    spacing: spacingUnit
                    
                    Rectangle { width: 16; height: 2; color: "#10B981" }
                    Text { text: qsTr("Flight path"); font.pixelSize: 11; color: textPrimary }
                }
            }
        }
    }
}

/// Toggle item for layer visibility and opacity
Rectangle {
    id: layerItem
    
    property string label: ""
    property string icon: ""
    property bool enabled: true
    property real opacity: 0.7
    property bool checked: enabled
    
    signal toggled(bool checked)
    signal opacityChanged(real opacity)
    
    readonly property color bgHover: "#F3F4F6"
    readonly property int spacingUnit: 4
    
    color: "transparent"
    radius: 8
    height: 80
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit
        spacing: spacingUnit
        
        RowLayout {
            Layout.fillWidth: true
            spacing: spacingUnit
            
            CheckBox {
                checked: layerItem.checked
                onCheckedChanged: layerItem.toggled(checked)
            }
            
            Text {
                text: layerItem.icon
                font.pixelSize: 16
            }
            
            Text {
                text: layerItem.label
                font.pixelSize: 12
                Layout.fillWidth: true
            }
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: spacingUnit
            
            Text {
                text: qsTr("Opacity: ") + (layerItem.opacity * 100).toFixed(0) + "%"
                font.pixelSize: 10
                color: "#4B5563"
            }
            
            Slider {
                Layout.fillWidth: true
                from: 0
                to: 1
                value: layerItem.opacity
                onValueChanged: layerItem.opacityChanged(value)
                
                background: Rectangle {
                    height: 4
                    color: "#E5E7EB"
                    radius: 2
                    
                    Rectangle {
                        height: parent.height
                        width: parent.width * parent.parent.value
                        color: "#00BCD4"
                        radius: 2
                    }
                }
                
                handle: Rectangle {
                    x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                    y: parent.topPadding + parent.availableHeight / 2 - height / 2
                    width: 16
                    height: 16
                    radius: 8
                    color: "#00BCD4"
                    border.color: "#FFFFFF"
                    border.width: 2
                }
            }
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: layerItem.color = layerItem.bgHover
        onExited: layerItem.color = "transparent"
    }
}
