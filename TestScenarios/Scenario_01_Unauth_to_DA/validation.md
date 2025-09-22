# ✅ **Validation Guide - Scenario 1: Unauthenticated to Domain Admin**

This document provides systematic validation steps to ensure the methodology system is working correctly.

## **Pre-Test Setup Validation**

### **1. Application State Check**
- [ ] **Fresh Project**: Create new project "CorpNet Inc. Pentest"
- [ ] **Clean Dashboard**: Attack chain should show no progress
- [ ] **Empty Context**: No assets, credentials, or findings present
- [ ] **Navigation**: Can access "Testing → Attack Chain" successfully

### **2. Ingestion Dialog Check**
- [ ] **Dialog Opens**: "+" button opens ingestion dialog
- [ ] **Outcome Types**: All types available in dropdown
- [ ] **Parser Selection**: Parser dropdown populated with options
- [ ] **Form Validation**: Required fields enforce completion

---

## **Phase-by-Phase Validation**

### **Phase 1: Network Discovery**

**After Step 1.1 (Network Monitoring)**:
- [ ] **Recommendation Generated**: System suggests "LLMNR Poisoning"
- [ ] **Dashboard Update**: "Reconnaissance" phase shows activity
- [ ] **Context Building**: Engagement context includes broadcast protocols

**After Step 1.2 (ARP Scan)**:
- [ ] **Asset Count**: Dashboard shows 23 discovered hosts
- [ ] **Parser Success**: ARP-scan parser extracts correct host list
- [ ] **Recommendations**: Port scanning suggested for targets

**After Step 1.3 (Domain Controller)**:
- [ ] **Critical Asset**: DC identified and highlighted
- [ ] **Domain Context**: CORP.LOCAL domain recorded
- [ ] **High Priority**: SMB enumeration recommended with high priority

**After Step 1.4 (Service Discovery)**:
- [ ] **Multiple Assets**: File server, SQL server, web server all tracked
- [ ] **Service Classification**: Each asset properly categorized by type
- [ ] **Attack Surface**: Dashboard shows expanded target environment

### **Phase 2: Initial Access**

**After Step 2.1 (LLMNR Poisoning)**:
- [ ] **Hash Captured**: Responder parser extracts hash correctly
- [ ] **Critical Alert**: Hash capture triggers immediate alert
- [ ] **Next Step**: Hash cracking methodology recommended

**After Step 2.2 (Credential Found)**:
- [ ] **CRITICAL ALERT**: "Valid Domain Credentials" alert fires
- [ ] **Context Update**: Credentials added to engagement context
- [ ] **High Priority**: Credential testing becomes top recommendation
- [ ] **Phase Progress**: Dashboard moves to "Lateral Movement" phase

### **Phase 3: Lateral Movement**

**After Step 3.1 (Admin Access)**:
- [ ] **CRITICAL ALERT**: "Administrative Access Achieved!" fires
- [ ] **Visual Update**: Host 192.168.1.55 shows admin access indicator
- [ ] **Recommendations**: Payload deployment and enumeration suggested

**After Step 3.2 (Multiple Access)**:
- [ ] **Access Tracking**: Multiple admin access points recorded
- [ ] **Service-Specific**: SQL and web server access properly categorized
- [ ] **Context Building**: All access points tracked in engagement state

**After Step 3.3 (Share Discovery)**:
- [ ] **Data Source**: Backup share identified as valuable target
- [ ] **Next Steps**: Share content analysis recommended

### **Phase 4: Privilege Escalation**

**After Step 4.1 (Service Account)**:
- [ ] **Privileged Alert**: Service account compromise detected
- [ ] **Context Update**: svc_backup credentials added to context
- [ ] **Recommendations**: Elevated privilege testing suggested

**After Step 4.2 (Service Admin Rights)**:
- [ ] **Escalation Confirmed**: Admin rights via service account tracked
- [ ] **Multiple Vectors**: System recognizes multiple admin pathways

**After Step 4.3 (SQL Sysadmin)**:
- [ ] **HIGH ALERT**: "SQL Server Sysadmin Access!" fires
- [ ] **Command Execution**: xp_cmdshell capability detected
- [ ] **Critical Recommendations**: SQL-based attack methods suggested

### **Phase 5: Domain Compromise**

**After Step 5.1 (Domain Admin Creds)**:
- [ ] **CRITICAL ALERT**: "DOMAIN ADMINISTRATOR CREDENTIALS!" fires
- [ ] **Highest Priority**: DC testing becomes immediate recommendation
- [ ] **Context Significance**: System recognizes criticality

**After Step 5.2 (DC Compromise)**:
- [ ] **MISSION COMPLETE**: "DOMAIN CONTROLLER COMPROMISED!" alert
- [ ] **Chain Complete**: Attack chain visualization shows 100% completion
- [ ] **Final Status**: All phases marked as completed

---

## **System-Wide Validation**

### **Dashboard Metrics Accuracy**
- [ ] **Asset Count**: Matches manually counted assets (20+)
- [ ] **Credential Count**: Shows exactly 3 credentials found
- [ ] **Admin Access**: Shows 4+ hosts with admin access
- [ ] **Phase Progress**: All 5 phases show completion

### **Attack Chain Visualization**
- [ ] **Progressive Updates**: Each phase updates in real-time
- [ ] **Visual Indicators**: Completed phases clearly marked
- [ ] **Current Status**: Shows final state as "Domain Compromise"

### **Recent Activity Timeline**
- [ ] **Chronological Order**: Events listed in correct time sequence
- [ ] **Event Details**: Each activity shows relevant details
- [ ] **Critical Highlights**: Important findings visually emphasized

### **Recommendation Quality**
- [ ] **Context Awareness**: Recommendations become more targeted over time
- [ ] **Priority Ordering**: Critical findings generate highest priority recommendations
- [ ] **Logical Flow**: Each recommendation logically follows from previous outcomes

### **Critical Finding Detection**
- [ ] **Timing**: Critical alerts fire immediately upon ingestion
- [ ] **Accuracy**: Only truly critical findings trigger critical alerts
- [ ] **Completeness**: All major findings (DA creds, DC access) detected

---

## **Error Conditions to Check**

### **Data Integrity**
- [ ] **No Duplicates**: Assets, credentials, findings not duplicated
- [ ] **Consistent State**: Dashboard metrics match detail screens
- [ ] **Context Persistence**: Engagement context survives app navigation

### **Performance**
- [ ] **Responsive UI**: Dashboard updates happen quickly
- [ ] **Memory Usage**: No obvious memory leaks during testing
- [ ] **Parser Performance**: Raw output parsing completes quickly

### **Edge Cases**
- [ ] **Invalid Data**: System handles malformed parser input gracefully
- [ ] **Empty Outcomes**: System handles outcomes with no useful data
- [ ] **Large Datasets**: Performance remains acceptable with many assets

---

## **Troubleshooting Common Issues**

### **Recommendations Not Appearing**
1. Check that methodology YAML files are loading correctly
2. Verify trigger conditions are being evaluated properly
3. Ensure engagement context is being updated
4. Confirm methodology chain manager is functioning

### **Critical Alerts Not Firing**
1. Verify domain controller IP detection logic
2. Check administrative access parsing
3. Confirm critical finding conditions match input data
4. Ensure alert system is properly connected

### **Parser Issues**
1. Test parser with sample data in isolation
2. Verify raw output format matches expected patterns
3. Check that parser output contains expected fields
4. Ensure asset extraction is working correctly

### **Dashboard Not Updating**
1. Confirm Riverpod providers are notifying listeners
2. Check that engagement context changes trigger UI updates
3. Verify dashboard is subscribed to correct data streams
4. Test with manual data to isolate issue

---

## **Success Criteria**

The test is successful if:

✅ **All phases complete** with appropriate recommendations
✅ **Critical alerts fire** for DA credentials and DC access
✅ **Dashboard accurately reflects** the full engagement state
✅ **Attack chain visualization** shows clear progression
✅ **No errors or crashes** occur during the full scenario
✅ **Performance remains responsive** throughout testing
✅ **Data integrity maintained** across all screens and functions

**Expected Duration**: 15-30 minutes for full scenario validation
**Pass Criteria**: 95%+ of validation points successful