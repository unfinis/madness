# 🎯 **Scenario 1: Unauthenticated Network to Domain Admin**

## **📋 Scenario Overview**

**Target Environment**: CorpNet Inc.
**Network**: 192.168.1.0/24
**Domain**: CORP.LOCAL
**Objective**: Achieve Domain Administrator access from external network position
**Estimated Time**: 45 minutes of simulation

## **🎬 Background Story**

You've been hired to conduct an external penetration test of CorpNet Inc. You've gained access to their internal network (perhaps through WiFi or physical access) and now have an IP address on their internal subnet. Your goal is to achieve Domain Administrator privileges and demonstrate the impact of a compromise.

---

## **🚀 Step-by-Step Testing Guide**

### **Prerequisites**
1. Launch Madness application
2. Create new project: "CorpNet Inc. Pentest"
3. Navigate to **Testing → Attack Chain**

---

## **Phase 1: Network Discovery** 🔍

### **Step 1.1: Initial Network Reconnaissance**
**Simulated Activity**: Passive network monitoring with tcpdump

**📝 Action**: Click the **"+" button** in Attack Chain dashboard

**Input Data**:
- **Outcome Type**: `Custom Outcome`
- **Details**: `Detected LLMNR and NBT-NS broadcasts on network. Observed SMB traffic to multiple hosts.`

**✅ Expected Result**: System recommends LLMNR poisoning attack

---

### **Step 1.2: ARP Network Scan**
**Simulated Activity**: arp-scan -l to discover live hosts

**📝 Action**: Click **"+" button** again

**Input Data**:
- **Outcome Type**: `Custom Outcome`
- **Details**: `ARP scan discovered 23 live hosts on 192.168.1.0/24`
- **Parser Type**: `ARP-Scan`
- **Raw Output**: Copy from `data/arp_scan_output.txt`

**✅ Expected Result**: System determines medium network density, recommends port scanning

---

### **Step 1.3: Port Scanning - Domain Controller**
**Simulated Activity**: nmap -sV 192.168.1.20

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Service Identified`
- **Host**: `192.168.1.20`
- **Service**: `Domain Controller`
- **Ports**: `53,88,389,445,3389`

**✅ Expected Result**: Domain controller identified, system recommends SMB enumeration

---

### **Step 1.4: Additional Service Discovery**
**Simulated Activity**: Scanning other interesting hosts

**📝 Actions**: Repeat for each host (3 separate ingestions)

**Host 1** - File Server:
- **Outcome Type**: `Service Identified`
- **Host**: `192.168.1.10`
- **Service**: `SMB File Server`
- **Ports**: `445,3389`

**Host 2** - SQL Server:
- **Outcome Type**: `Service Identified`
- **Host**: `192.168.1.15`
- **Service**: `SQL Server`
- **Ports**: `1433,445`

**Host 3** - Web Server:
- **Outcome Type**: `Service Identified`
- **Host**: `192.168.1.25`
- **Service**: `Web Server`
- **Ports**: `80,443,445`

**✅ Expected Result**: Rich target environment identified, multiple attack vectors available

---

## **Phase 2: Initial Access** 🎯

### **Step 2.1: LLMNR Poisoning Attack**
**Simulated Activity**: Running Responder for 45 minutes

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Hash Captured`
- **Username**: `CORP\jsmith`
- **Hash**: Copy from `data/responder_hash.txt`
- **Parser Type**: `Responder`
- **Raw Output**: Copy from `data/responder_output.txt`

**✅ Expected Result**: Hash captured, system recommends hash cracking

---

### **Step 2.2: Hash Cracking Success**
**Simulated Activity**: hashcat -m 5600 hashes.txt rockyou.txt

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Credential Found`
- **Domain**: `CORP`
- **Username**: `jsmith`
- **Password**: `Summer2024!`

**✅ Expected Result**: **CRITICAL** - Valid domain credentials obtained! System recommends credential testing

---

## **Phase 3: Lateral Movement** ⚡

### **Step 3.1: Credential Testing - Admin Access**
**Simulated Activity**: crackmapexec smb 192.168.1.0/24 -u jsmith -p 'Summer2024!'

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Admin Access Achieved`
- **Host**: `192.168.1.55`
- **User**: `CORP\jsmith`

**✅ Expected Result**: Admin access achieved! System recommends payload deployment or further enumeration

---

### **Step 3.2: Additional Access Points**
**Simulated Activity**: Testing credentials across environment

**📝 Actions**: Two separate ingestions

**Web Server Access**:
- **Outcome Type**: `Admin Access Achieved`
- **Host**: `192.168.1.25`
- **User**: `CORP\jsmith`

**SQL Server Access** (read-only):
- **Outcome Type**: `Custom Outcome`
- **Details**: `CORP\jsmith has db_reader access on SQL Server 192.168.1.15`

**✅ Expected Result**: Multiple access points established, attack surface expanded

---

### **Step 3.3: Share Enumeration**
**Simulated Activity**: smbclient -L //192.168.1.10 -U jsmith

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Custom Outcome`
- **Details**: `Found readable share \\192.168.1.10\Backup containing old credential files and scripts`

**✅ Expected Result**: Valuable data source identified, system recommends share exploration

---

## **Phase 4: Privilege Escalation** 🔺

### **Step 4.1: Service Account Discovery**
**Simulated Activity**: Found credentials in backup share

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Credential Found`
- **Domain**: `CORP`
- **Username**: `svc_backup`
- **Password**: `BackupSvc2024!`

**✅ Expected Result**: Service account discovered, system recommends testing elevated access

---

### **Step 4.2: Service Account Privileges**
**Simulated Activity**: Testing svc_backup credentials

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Admin Access Achieved`
- **Host**: `192.168.1.10`
- **User**: `CORP\svc_backup`

**✅ Expected Result**: Service account has admin rights, privilege escalation successful

---

### **Step 4.3: SQL Server Sysadmin Access**
**Simulated Activity**: Testing service account on SQL server

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Custom Outcome`
- **Details**: `CORP\svc_backup has sysadmin privileges on SQL Server 192.168.1.15. xp_cmdshell enabled.`

**✅ Expected Result**: **HIGH** - SQL sysadmin access! System recommends SQL-based attacks

---

## **Phase 5: Domain Compromise** 👑

### **Step 5.1: Domain Admin Credential Discovery**
**Simulated Activity**: SQL server credential extraction via xp_cmdshell

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Credential Found`
- **Domain**: `CORP`
- **Username**: `Administrator`
- **Password**: `Corp2024Admin!`

**✅ Expected Result**: **CRITICAL ALERT** - Domain Administrator credentials found!

---

### **Step 5.2: Domain Controller Compromise**
**Simulated Activity**: Testing domain admin credentials on DC

**📝 Action**: Click **"+" button**

**Input Data**:
- **Outcome Type**: `Admin Access Achieved`
- **Host**: `192.168.1.20`
- **User**: `CORP\Administrator`

**✅ Expected Result**: **CRITICAL ALERT** - Domain Controller Administrative Access! 🚨

---

## **🎉 Mission Accomplished!**

**Final Attack Chain Status**: All phases should show as completed
- ✅ **Reconnaissance** → Network discovery complete
- ✅ **Initial Access** → Valid domain credentials
- ✅ **Lateral Movement** → Multiple admin access points
- ✅ **Privilege Escalation** → Service account compromise
- ✅ **Domain Compromise** → Domain Controller access

**Final Statistics**:
- **Assets Discovered**: 20+ hosts, services, shares
- **Credentials Found**: 3 (jsmith, svc_backup, Administrator)
- **Admin Access**: 4 hosts including Domain Controller
- **Critical Findings**: 2 major alerts

---

## **🔍 Validation Checklist**

After completing the scenario, verify:

- [ ] Attack chain visualization shows all phases complete
- [ ] Dashboard shows correct asset/credential counts
- [ ] Critical finding alerts appeared for DA credentials and DC access
- [ ] Recent activity shows complete timeline
- [ ] Recommendations were contextually appropriate at each step
- [ ] No duplicate or missing data in various screens

## **🐛 Troubleshooting**

**If recommendations aren't appearing**:
1. Check that outcomes are being ingested properly
2. Verify engagement context is updating
3. Ensure triggers are evaluating correctly

**If critical alerts don't fire**:
1. Verify domain controller IP matches alert conditions
2. Check that administrative access is properly detected
3. Review critical finding detection logic

---

**🎯 This scenario demonstrates the full power of the methodology orchestration system - from initial foothold to complete domain compromise!**