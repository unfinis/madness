# 🧪 **Test Scenarios for Methodology System**

This folder contains realistic penetration testing scenarios designed to test the methodology orchestration system.

## **Available Scenarios**

1. **[Scenario 1: Unauthenticated to Domain Admin](./Scenario_01_Unauth_to_DA/)**
   - **Target**: CorpNet Inc. (CORP.LOCAL)
   - **Objective**: Achieve Domain Administrator access from external network
   - **Techniques**: LLMNR Poisoning → Hash Cracking → Lateral Movement → Privilege Escalation
   - **Duration**: ~45 minutes of testing simulation

## **How to Use Test Scenarios**

1. **Launch the Madness application**
2. **Create a new project** (use scenario company name)
3. **Navigate to "Attack Chain"** in the Testing section
4. **Follow the step-by-step guide** in each scenario folder
5. **Input the provided data** using the ingestion dialog
6. **Observe system recommendations** and attack chain progression

## **Scenario Structure**

Each scenario contains:
- **`GUIDE.md`** - Step-by-step testing instructions
- **`data/`** - Raw tool outputs and sample data
- **`expected_results.md`** - What the system should recommend
- **`validation.md`** - How to verify the scenario worked correctly

## **Testing Tips**

- 🕐 **Go slowly** - Input data gradually to see progression
- 👀 **Watch recommendations** - System should suggest logical next steps
- 🚨 **Check alerts** - Critical findings should trigger immediate notifications
- 📊 **Monitor dashboard** - Attack chain visualization should update in real-time
- 📝 **Take notes** - Document any unexpected behavior for debugging

## **Adding New Scenarios**

To add a new test scenario:
1. Create a new folder: `Scenario_XX_Description/`
2. Include the required files (guide, data, expected results)
3. Update this README with scenario details
4. Test thoroughly before committing

---

**Happy Testing!** 🎯
These scenarios will help validate that the methodology system correctly guides testers through complex attack chains.