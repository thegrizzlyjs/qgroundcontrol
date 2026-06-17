# QGroundControl Modern UI - Migration Guide

## Incremental Migration Strategy

This guide describes how to gradually migrate from Classic UI to Modern UI using feature flags.

## Phase 1: Feature Flag Infrastructure

### Add Feature Flag to Settings

```cpp
// src/Settings/AppSettings.h
class AppSettings : public SettingsGroup {
    Q_OBJECT
    
public:
    Q_PROPERTY(Fact* useModernUI READ useModernUI CONSTANT)
    
    Fact* useModernUI(void) const { return &_useModernUIFact; }
    
private:
    Fact _useModernUIFact { 
        _settingsGroup,
        "UseModernUI",
        false,  // Default: disabled
        "Enable modern UI refactor"
    };
};
```

### Add QML Feature Flag

```qml
// main.qml
import QGroundControl.AppSettings

Item {
    // Access feature flag
    readonly property bool useModernUI: qgcApp.appSettings.useModernUI.value
    
    Loader {
        sourceComponent: useModernUI ? modernUIComponent : classicUIComponent
    }
    
    Component { id: modernUIComponent; ModernLayout { } }
    Component { id: classicUIComponent; FlightView { } }
}
```

## Phase 2: Gradual Component Replacement

### Week 1-2: Status Bar & Navigation
```qml
if (useModernUI) {
    ModernStatusBar { }
    ModernLeftSidebar { }
} else {
    ClassicToolBar { }
    ClassicSidebar { }
}
```

**Success Criteria:**
- [ ] Status bar displays GPS, battery, mode
- [ ] Sidebar navigation works
- [ ] No telemetry lag
- [ ] Touch targets ≥44px

### Week 3-4: Map & Waypoint Editor
```qml
if (useModernUI) {
    ModernWaypointEditor { }
    ModernLayerManager { }
} else {
    ClassicWaypointEditor { }
    ClassicLayerPanel { }
}
```

**Success Criteria:**
- [ ] Waypoints render on map
- [ ] Drag/drop works
- [ ] Layer opacity controls work
- [ ] Map updates in real-time

### Week 5-6: Mission Validation & FAB
```qml
if (useModernUI) {
    ModernMissionValidator { }
    ModernFAB { }
} else {
    // No classic equivalent - new feature
}
```

**Success Criteria:**
- [ ] Validation detects issues
- [ ] Arming blocked on critical issues
- [ ] FAB actions work correctly

### Week 7-8: Multi-Vehicle Support
```qml
if (useModernUI) {
    ModernMultiVehicleManager { }
} else {
    ClassicVehicleSelector { }
}
```

**Success Criteria:**
- [ ] Multiple vehicles display
- [ ] Vehicle switching works
- [ ] Right-panel shows selected vehicle

### Week 9-10: Telemetry & HUD (Optional)
```qml
if (useModernUI) {
    ModernHUDPanel { }
} else {
    ClassicHUD { }
}
```

## Phase 3: Rollback Plans

### Scenario 1: Entire Feature Flag Disabled
If critical issues detected, disable completely:

```cpp
// AppSettings.cpp
_useModernUIFact = false;  // Falls back to classic
```

**Time to recover:** <5 minutes
**User impact:** Temporary return to classic UI while fix applied

### Scenario 2: Individual Component Rollback
For specific component issues:

```qml
ModernWaypointEditor {
    enabled: useModernUI && _waypointEditorWorking
    onError: _waypointEditorWorking = false  // Fallback
}
```

### Scenario 3: Hot Patch
For critical bugs, deploy patch without full rebuild:

```qml
// Use Loader to reload component
waypointEditor.source = ""  // Unload
waypointEditor.source = "qrc:/Modern/ModernWaypointEditor.qml"  // Reload
```

## Phase 4: User Communication

### Announcement Timeline
```
Week 1:     "New Modern UI available (beta) - opt-in via Settings"
Week 2-3:   "Modern UI in closed beta - early testers needed"
Week 4-6:   "Modern UI expanded features - feedback invited"
Week 7-8:   "Modern UI approaching stable - known issues resolved"
Week 9-10:  "Modern UI enabled by default - classic available via Settings"
```

### User Messaging
```qml
Rectangle {
    text: qsTr("Modern UI is currently in beta. Please report issues.")
    visible: useModernUI && !qgcApp.appSettings.dismissModernUIBeta.value
    
    Button {
        text: "Dismiss"
        onClicked: qgcApp.appSettings.dismissModernUIBeta.value = true
    }
}
```

## Migration Checklist - Component by Component

### Status Bar & Navigation
- [ ] Enable feature flag in Settings
- [ ] Verify telemetry updates (1-5 Hz)
- [ ] Check touch target sizes
- [ ] Test on tablet/desktop
- [ ] Gather user feedback (1 week)
- [ ] Fix reported issues
- [ ] Move to next component

### Waypoint Editor
- [ ] Verify coordinates accurate
- [ ] Test drag/drop
- [ ] Validate inline editing
- [ ] Check snapping behavior
- [ ] Test on various screen sizes
- [ ] Verify MAVLink upload
- [ ] Gather user feedback (1 week)

### Mission Validator
- [ ] Test altitude checks
- [ ] Verify no-fly zone detection
- [ ] Check battery calculation
- [ ] Test fix suggestions
- [ ] Verify arming block
- [ ] Gather user feedback (1 week)

### FAB Actions
- [ ] Test all three actions
- [ ] Verify confirmations
- [ ] Check error handling
- [ ] Test on touch devices
- [ ] Verify mission upload works
- [ ] Gather user feedback (1 week)

## Common Issues & Solutions

| Issue | Root Cause | Solution |
|-------|-----------|----------|
| Telemetry not updating | Vehicle not connected to right component | Verify `vehicle:` binding in QML |
| Waypoints not saving | MAVLink upload fails | Check vehicle is armed, GPS fix |
| FAB button unresponsive | Touch target too small | Verify dimensions in design-tokens.json |
| Performance sluggish | Too many components loaded | Enable lazy-loading in sidebar |
| Theme doesn't persist | Setting not saved | Verify AppSettings write permission |
| MAVLink corruption | Message queue overflow | Reduce update frequency from 10Hz to 5Hz |

## Performance Benchmarks

### Target Metrics
```
Load Time:          <1000ms (initial)
Telemetry Update:   <100ms (100Hz max)
Memory (idle):      <50MB additional
Memory (flying):    <80MB additional
Frame Rate (UI):    >30fps
Animation Duration: ≤300ms
```

### Measurement Commands
```bash
# UI load time
time qgc --load-time-measurement

# Memory usage
top -p $(pgrep qgc)

# Frame rate
qgc --fps-counter

# MAVLink latency
qgc --mavlink-latency
```

## Automatic Rollback Triggers

If any of these occur, automatically disable Modern UI:

```cpp
if (ui_load_time > 2000ms ||
    memory_increase > 200MB ||
    frame_rate < 30fps ||
    mavlink_errors > 10 ||
    crash_count > 5) {
    
    qgcApp.appSettings.useModernUI.value = false;
    qgcApp.showNotification("Modern UI disabled due to performance issues");
}
```

## Success Criteria - Go Live

Before enabling Modern UI by default:

- ✅ All acceptance tests pass
- ✅ Performance within spec (load <1s)
- ✅ No regression in existing features
- ✅ User feedback positive (>80% satisfaction)
- ✅ Critical issues resolved (0 P1 bugs open)
- ✅ Documentation complete
- ✅ Team training complete
- ✅ Support team ready

## Post-Launch Support

### Week 1-2: Active Monitoring
- Daily performance metrics review
- User bug reports prioritized
- Hotfixes deployed as needed
- Gather usage statistics

### Week 3-4: Stability Phase
- Known issues documented
- Workarounds provided
- Performance optimized
- UI polish improvements

### Week 5-8: Classic UI Deprecation
- Classic UI moved to "Advanced"
- Plan to remove in next version
- User migration guide provided
- Support team trained

## Contact & Support

**Issues?** Report via:
- Issue tracker: https://github.com/qgroundcontrol/qgroundcontrol/issues
- Forum: https://discuss.qgroundcontrol.io
- Email: support@qgroundcontrol.io

**Documentation:**
- Design System: `design-tokens.json`
- Component Mapping: `component-mapping.csv`
- MAVLink Mapping: `mavlink-message-mapping.json`
- README: `UI-REFACTOR-README.md`
