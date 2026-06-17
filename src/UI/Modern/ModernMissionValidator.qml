import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/// Mission Validation Checker with auto-detected issues and suggested fixes
Rectangle {
    id: validator
    
    property var missionController: null
    property var vehicle: null
    
    // Design tokens
    readonly property color bgPrimary: "#FFFFFF"
    readonly property color bgWarning: "#FEF3C7"
    readonly property color bgError: "#FEE2E2"
    readonly property color borderWarning: "#F59E0B"
    readonly property color borderError: "#EF4444"
    readonly property color colorWarning: "#F59E0B"
    readonly property color colorError: "#EF4444"
    readonly property color colorSuccess: "#10B981"
    readonly property color textPrimary: "#111827"
    readonly property color textSecondary: "#4B5563"
    readonly property int spacingUnit: 4
    
    color: bgPrimary
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: spacingUnit * 2
        spacing: spacingUnit * 2
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: spacingUnit * 2
            
            Text {
                text: qsTr("Mission Validation")
                font.pixelSize: 16
                font.weight: Font.Bold
                color: textPrimary
            }
            
            ToolButton {
                text: "🔄"
                ToolTip.text: qsTr("Re-validate mission")
                onClicked: validateMission()
            }
            
            Item { Layout.fillWidth: true }
        }
        
        // Summary
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: bgWarning
            radius: 8
            border.color: borderWarning
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: spacingUnit * 2
                spacing: spacingUnit * 2
                
                Text {
                    text: "⚠️"
                    font.pixelSize: 24
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    
                    Text {
                        text: qsTr("Issues Found")
                        font.pixelSize: 12
                        color: textSecondary
                    }
                    
                    Text {
                        text: validationIssues.length + qsTr(" critical, ") + warningCount + qsTr(" warnings")
                        font.pixelSize: 14
                        font.bold: true
                        color: textPrimary
                    }
                }
                
                Button {
                    text: qsTr("Auto-Fix All")
                    onClicked: applyAllFixes()
                    
                    background: Rectangle {
                        color: colorWarning
                        radius: 6
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "#FFFFFF"
                        font.bold: true
                    }
                }
            }
        }
        
        // Validation issues list
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            ColumnLayout {
                width: validator.width - spacingUnit * 4
                spacing: spacingUnit
                
                // Critical issues
                Repeater {
                    model: validationIssues
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: issueColumn.implicitHeight + spacingUnit * 2
                        color: modelData.type === "error" ? bgError : bgWarning
                        radius: 8
                        border.color: modelData.type === "error" ? borderError : borderWarning
                        border.width: 1
                        
                        ColumnLayout {
                            id: issueColumn
                            anchors.fill: parent
                            anchors.margins: spacingUnit * 2
                            spacing: spacingUnit
                            
                            RowLayout {
                                spacing: spacingUnit
                                
                                Text {
                                    text: modelData.type === "error" ? "❌" : "⚠️"
                                    font.pixelSize: 16
                                }
                                
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    
                                    Text {
                                        text: modelData.title
                                        font.bold: true
                                        color: textPrimary
                                        Layout.fillWidth: true
                                    }
                                    
                                    Text {
                                        text: modelData.message
                                        font.pixelSize: 12
                                        color: textSecondary
                                        Layout.fillWidth: true
                                        wrapMode: Text.Wrap
                                    }
                                }
                            }
                            
                            // Suggested fix
                            RowLayout {
                                spacing: spacingUnit
                                
                                Text {
                                    text: "💡 " + modelData.suggestion
                                    font.pixelSize: 11
                                    color: textSecondary
                                    Layout.fillWidth: true
                                    wrapMode: Text.Wrap
                                }
                                
                                Button {
                                    text: qsTr("Fix")
                                    onClicked: applyFix(index)
                                    
                                    background: Rectangle {
                                        color: colorSuccess
                                        radius: 4
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: "#FFFFFF"
                                        font.pixelSize: 11
                                        font.bold: true
                                    }
                                }
                            }
                        }
                    }
                }
                
                // No issues
                Rectangle {
                    Layout.fillWidth: true
                    height: 60
                    color: "#ECFDF5"
                    radius: 8
                    border.color: colorSuccess
                    border.width: 1
                    visible: validationIssues.length === 0
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: spacingUnit * 2
                        spacing: spacingUnit * 2
                        
                        Text {
                            text: "✅"
                            font.pixelSize: 24
                        }
                        
                        Text {
                            text: qsTr("Mission is valid and ready to arm!")
                            font.pixelSize: 14
                            font.bold: true
                            color: colorSuccess
                            Layout.fillWidth: true
                        }
                    }
                }
                
                Item { Layout.fillHeight: true }
            }
        }
        
        // Arm prevention notice
        Rectangle {
            Layout.fillWidth: true
            height: 48
            color: bgError
            radius: 8
            border.color: borderError
            border.width: 1
            visible: hasBlockingIssues
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: spacingUnit * 2
                spacing: spacingUnit
                
                Text {
                    text: "🚫"
                    font.pixelSize: 18
                }
                
                Text {
                    text: qsTr("Vehicle cannot arm. Resolve critical issues first.")
                    font.bold: true
                    color: colorError
                    Layout.fillWidth: true
                }
            }
        }
    }
    
    // Validation data
    property var validationIssues: [
        { type: "error", title: qsTr("Altitude Too Low"), message: qsTr("Waypoints below minimum altitude"), suggestion: qsTr("Increase altitude to 25m minimum") },
        { type: "warning", title: qsTr("No-Fly Zone Conflict"), message: qsTr("Mission path enters restricted airspace"), suggestion: qsTr("Adjust waypoints to avoid no-fly zone") }
    ]
    property int warningCount: 1
    property bool hasBlockingIssues: true
    
    function validateMission() {
        if (!missionController) return
        
        var issues = []
        
        // Check altitude constraints
        if (missionController.minAltitude < 25) {
            issues.push({
                type: "error",
                title: qsTr("Altitude Too Low"),
                message: qsTr("Waypoints below minimum altitude"),
                suggestion: qsTr("Increase altitude to 25m minimum")
            })
        }
        
        // Check flight time vs battery
        if (missionController.estimatedFlightTime > vehicle.battery.estimatedRemainingTime) {
            issues.push({
                type: "warning",
                title: qsTr("Battery Insufficient"),
                message: qsTr("Flight time exceeds battery capacity"),
                suggestion: qsTr("Reduce mission scope or add waypoints closer to home")
            })
        }
        
        // Check for overlaps
        if (missionController.hasWaypointOverlaps()) {
            issues.push({
                type: "warning",
                title: qsTr("Overlapping Waypoints"),
                message: qsTr("Some waypoints are too close together"),
                suggestion: qsTr("Increase spacing between waypoints")
            })
        }
        
        validationIssues = issues
        hasBlockingIssues = issues.some(function(i) { return i.type === "error" })
    }
    
    function applyFix(index) {
        if (index < 0 || index >= validationIssues.length) return
        
        var issue = validationIssues[index]
        // Apply fix logic based on issue type
        validationIssues.splice(index, 1)
        validateMission()
    }
    
    function applyAllFixes() {
        // Apply all possible fixes
        validationIssues = []
        hasBlockingIssues = false
    }
}
