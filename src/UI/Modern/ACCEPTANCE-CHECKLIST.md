# QGroundControl Modern UI - Acceptance Checklist

## Pre-Release Validation

### Functional Requirements
- [ ] **Layout Structure** - All main components visible and positioned correctly
  - [ ] Central map area occupies ~80% of width
  - [ ] Left sidebar collapses and expands smoothly
  - [ ] Right panel slides in/out on property selection
  - [ ] Status bar displays at bottom persistently

- [ ] **Navigation** - All sidebar sections accessible
  - [ ] Plan section loads mission planner
  - [ ] Fly section loads flight view
  - [ ] Vehicles section shows multi-vehicle list
  - [ ] Library section shows saved items
  - [ ] Analyze section shows telemetry/logs
  - [ ] Settings section opens preferences

- [ ] **Map Integration** - Map displays and functions correctly
  - [ ] Base layers switchable (OSM/Satellite/Terrain)
  - [ ] Overlay layers toggle on/off
  - [ ] Layer opacity sliders work
  - [ ] Waypoints render on map
  - [ ] Vehicle position updates in real-time

- [ ] **Waypoint Editor** - Mission planning tools work
  - [ ] Add waypoint button creates new waypoint
  - [ ] Delete button removes selected waypoint
  - [ ] Drag/drop reorders waypoints
  - [ ] Inline coordinate editing updates position
  - [ ] Altitude field validates min/max constraints
  - [ ] Snapping to grid/terrain works
  - [ ] Space tool evenly distributes waypoints
  - [ ] Duplicate tool creates waypoint copy

- [ ] **Vehicle Telemetry** - Real-time data displays
  - [ ] GPS position updates in right panel
  - [ ] Battery voltage/capacity displays
  - [ ] Flight mode shows current mode
  - [ ] Armed/disarmed state reflects vehicle
  - [ ] Latitude/longitude coordinates display
  - [ ] Altitude AGL/MSL displayed correctly
  - [ ] Status bar updates every 100ms

- [ ] **FAB Actions** - Floating button menu works
  - [ ] Create Mission action opens mission editor
  - [ ] Arm Vehicle action arms drone (with confirmation)
  - [ ] Start Mission action begins flight
  - [ ] Menu expands/collapses
  - [ ] Clicking outside collapses menu

- [ ] **Mission Validation** - Auto-checks prevent errors
  - [ ] Altitude validation detects low altitudes
  - [ ] No-fly zone checker prevents restricted airspace
  - [ ] Battery sufficient check calculates flight time
  - [ ] Waypoint overlap detection finds duplicates
  - [ ] Suggested fixes display for each issue
  - [ ] "Fix All" button applies all suggestions
  - [ ] Critical issues block arming
  - [ ] Auto-fix corrects detected issues

- [ ] **Status Bar** - Multi-vehicle monitoring
  - [ ] GPS status shows Fix type (3D/2D/No Fix)
  - [ ] Battery capacity as percentage
  - [ ] Flight mode name displayed
  - [ ] MAVLink latency in milliseconds
  - [ ] Vehicle count shown
  - [ ] All indicators update in real-time

### Performance
- [ ] **Load Time** - UI loads quickly
  - [ ] Initial load completes in <1000ms
  - [ ] Map renders in <500ms
  - [ ] Components lazy-load without blocking
  - [ ] No visible stutter on startup

- [ ] **Memory** - Efficient resource usage
  - [ ] Memory usage stable during 10min flight
  - [ ] No memory leaks during component switching
  - [ ] Sidebar collapse frees hidden components
  - [ ] Multiple vehicles don't cause memory spike

- [ ] **Animations** - Smooth motion
  - [ ] Sidebar collapse animation smooth (300ms)
  - [ ] Panel slide-in smooth
  - [ ] Waypoint drag animation responsive
  - [ ] Theme transition smooth
  - [ ] Respects reduce-motion preference

### Accessibility
- [ ] **Visual Accessibility**
  - [ ] Text contrast ≥4.5:1 (WCAG AA) on all text
  - [ ] Focus indicators visible (2px blue ring)
  - [ ] High-contrast theme available and working
  - [ ] Dark mode available and functional
  - [ ] Icons have text labels

- [ ] **Touch Accessibility**
  - [ ] All buttons ≥44×44px (48px preferred)
  - [ ] Tap targets have minimum 8px spacing
  - [ ] Long-press menus work on touch
  - [ ] Scroll areas responsive on touch

- [ ] **Keyboard Accessibility**
  - [ ] Tab key navigates through all sections
  - [ ] Enter/Space activates buttons
  - [ ] Arrow keys navigate lists
  - [ ] Escape closes dialogs/menus
  - [ ] F1 opens help
  - [ ] Shortcuts displayed in tooltips

- [ ] **Screen Readers**
  - [ ] All buttons have descriptive text
  - [ ] Form inputs have labels
  - [ ] Status messages announced
  - [ ] Errors communicated clearly

### Compatibility
- [ ] **Vehicle Support**
  - [ ] PX4 multirotor vehicle works
  - [ ] ArduPilot quadcopter works
  - [ ] Fixed-wing configuration works
  - [ ] Multi-vehicle scenario works
  - [ ] No vehicle selected handles gracefully

- [ ] **Screen Sizes**
  - [ ] Works on 1024×768 (tablet)
  - [ ] Works on 1920×1080 (desktop)
  - [ ] Responsive on ultra-wide (3840×2160)
  - [ ] Sidebar collapses on small screens
  - [ ] Map zoom appropriate for screen size

- [ ] **Themes**
  - [ ] Light theme displays correctly
  - [ ] Dark theme displays correctly
  - [ ] High-contrast theme passes WCAG AAA
  - [ ] Theme toggle button visible
  - [ ] Theme persists after restart

### Integration
- [ ] **MAVLink Integration**
  - [ ] Vehicle telemetry updates in real-time
  - [ ] Mission items send correctly to vehicle
  - [ ] Waypoint commands send in correct order
  - [ ] Arming commands execute properly
  - [ ] No MAVLink message corruption

- [ ] **Fact System Integration**
  - [ ] Vehicle parameters accessible via Fact System
  - [ ] Parameter changes reflect in UI
  - [ ] Battery fact properly connected
  - [ ] Flight mode fact properly connected
  - [ ] GPS fact properly connected

- [ ] **Mission Manager Integration**
  - [ ] Mission load displays in waypoint editor
  - [ ] Mission save persists waypoints
  - [ ] Mission upload sends to vehicle
  - [ ] Mission download from vehicle works
  - [ ] Mission clear clears all waypoints

- [ ] **Settings Integration**
  - [ ] Advanced Mode toggle visible
  - [ ] Setup pages hide in normal mode
  - [ ] Setup pages show in advanced mode
  - [ ] Settings persist after app restart
  - [ ] Theme setting persists

### Security
- [ ] **Double-Step Confirmations**
  - [ ] Arming requires confirmation
  - [ ] Disarming requires confirmation
  - [ ] Mission start requires confirmation
  - [ ] Confirmation timeout after 5 seconds
  - [ ] Cancel button dismisses confirmation

- [ ] **Data Validation**
  - [ ] Waypoint coordinates validated
  - [ ] Altitude values within limits
  - [ ] Mission item commands validated
  - [ ] User input sanitized
  - [ ] No SQL injection possible

- [ ] **MAVLink Security**
  - [ ] System ID/Component ID validated
  - [ ] Sequence numbers tracked
  - [ ] Message signing respected
  - [ ] Denial-of-service mitigated

### Documentation
- [ ] **Help & Support**
  - [ ] README provides clear integration steps
  - [ ] Design tokens documented
  - [ ] Component mapping provided
  - [ ] MAVLink mapping provided
  - [ ] Troubleshooting section included

- [ ] **Code Quality**
  - [ ] All QML files formatted (qmllint pass)
  - [ ] No compiler warnings
  - [ ] No runtime warnings
  - [ ] Comments explain complex logic
  - [ ] TODOs documented with context

### Regression Testing
- [ ] **Existing Features Still Work**
  - [ ] Classic UI still available (fallback)
  - [ ] Setup pages accessible (advanced mode)
  - [ ] Telemetry logging works
  - [ ] Flight replay works
  - [ ] Parameter editor works
  - [ ] Vehicle console works
  - [ ] RC calibration works
  - [ ] Attitude tuning works

- [ ] **No Broken Dependencies**
  - [ ] QGroundControl builds successfully
  - [ ] All unit tests pass
  - [ ] All integration tests pass
  - [ ] CI pipeline passes

## Acceptance Criteria - MUST HAVE

✅ **All "MUST" items checked before merge:**
- [ ] UI load time ≤ 1000ms measured
- [ ] "Create Mission → Simulate → Start" end-to-end flow works
- [ ] WCAG AA contrast tests 100% pass
- [ ] All touch targets ≥44px verified
- [ ] Dark/light themes work correctly
- [ ] Mission validation prevents arm on critical issues
- [ ] Vehicle telemetry updates in real-time from MAVLink
- [ ] No regressions in existing features
- [ ] Build passes without warnings
- [ ] All tests pass (QML + integration)

## Sign-Off

**Developer:** _______________________________ Date: _________
**QA Reviewer:** _____________________________ Date: _________
**Integration Lead:** ________________________ Date: _________

## Notes

