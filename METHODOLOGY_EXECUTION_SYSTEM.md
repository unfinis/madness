# Methodology Execution System

## Overview

The methodology execution system is now complete and fully functional. Here's how it works:

## Complete Flow: Asset Discovery → Trigger Evaluation → Methodology Execution

### 1. Asset Discovery & Management
- **Location**: `lib/screens/assets_screen_classic.dart`
- Users create and manage assets (hosts, networks, services, credentials, etc.)
- Assets have rich property systems with typed values

### 2. Automatic Trigger Evaluation
- **Service**: `lib/services/comprehensive_trigger_evaluator.dart`
- **Integration**: `lib/services/asset_trigger_integration_service.dart`
- When assets are created/updated, triggers are automatically evaluated
- Creates `RunInstance` objects for successful matches
- Uses deduplication to prevent repeated executions

### 3. Methodology Execution Orchestrator (NEW)
- **Service**: `lib/services/methodology_execution_orchestrator.dart`
- **Provider**: `lib/providers/methodology_execution_provider.dart`
- Monitors for pending `RunInstance` objects
- Automatically executes methodologies when triggers fire
- Supports concurrent execution limits and auto/manual modes

### 4. Interactive Execution Dashboard (ENHANCED)
- **Location**: `lib/screens/run_dashboard_simple.dart` → Execution tab
- Real-time monitoring of the orchestrator
- Manual control over auto-execution
- View pending run instances
- Execute methodologies manually
- Configure concurrency limits

## Key Features

### Automatic Execution
✅ **YES! The system now fires methodology items automatically**

When you:
1. Add a new host asset: `10.1.1.50`
2. With property: `open_ports: [22, 80, 443]`

The system will:
1. Evaluate all methodology triggers against this asset
2. Find matching methodologies (e.g., "SSH Enumeration", "Web Service Scanning")
3. Create `RunInstance` objects in `pending` status
4. The orchestrator automatically picks them up and executes them
5. Commands run in the background with real-time status updates

### Manual Control
- Start/stop the orchestrator
- Enable/disable auto-execution
- Set max concurrent executions (1-10)
- Manually execute specific run instances
- View execution statistics and history

### Real-time Monitoring
- Live dashboard showing orchestrator status
- Pending run instances list
- Execution statistics (success rate, active executions, etc.)
- Error reporting and event streaming

## Technical Architecture

### Core Services
1. **ComprehensiveTriggerEvaluator**: Evaluates assets against methodology triggers
2. **AssetTriggerIntegrationService**: Handles asset change events and batches evaluations
3. **MethodologyExecutionOrchestrator**: Bridges trigger evaluation to actual execution
4. **MethodologyEngine**: Executes individual methodology steps and commands

### Data Flow
```
Asset Created/Updated
       ↓
Trigger Evaluation (automatic)
       ↓
RunInstance Created (if triggers match)
       ↓
Orchestrator Picks Up (every 10 seconds)
       ↓
Methodology Execution (via MethodologyEngine)
       ↓
Results & Findings Generation
```

### Database Storage
- All `RunInstance` objects stored in Drift database
- Full execution history and status tracking
- Deduplication prevents repeated executions
- Evidence and findings linked to run instances

## Usage Instructions

### To Enable Auto-Execution:
1. Go to Run Dashboard → Execution tab
2. Click "Start" to start the orchestrator
3. Ensure "Enable Auto" is activated
4. Set desired concurrency limit (default: 3)

### To Manually Execute:
1. View pending run instances in the dashboard
2. Click the play button next to any instance
3. Monitor execution progress in real-time

### To Monitor Activity:
1. Overview tab: Real-time stats and system status
2. Activity tab: Recent trigger evaluations
3. Metrics tab: Detailed analytics
4. Execution tab: Orchestrator control and run instances

## Integration Points

### Asset Provider Integration
- Automatic trigger evaluation when assets change
- Real-time updates to run instances
- Property-based trigger matching

### Methodology Library Integration
- Uses YAML-based methodology templates
- Converts templates to executable formats
- Supports complex trigger conditions (DSL)

### Visual Findings Integration
- Results flow into findings visualization system
- Executive summary reports
- Risk matrix and timeline views

## Files Created/Modified

### New Files:
- `lib/services/methodology_execution_orchestrator.dart` - Core orchestration logic
- `lib/providers/methodology_execution_provider.dart` - State management

### Enhanced Files:
- `lib/screens/run_dashboard_simple.dart` - Added Execution tab with controls
- Multiple trigger evaluation and integration services

## Answer to Your Question

**"Okay will this now fire methodology items?"**

**YES! Absolutely.** The system now:

1. ✅ **Automatically evaluates triggers** when you add/modify assets
2. ✅ **Creates run instances** for matching methodologies
3. ✅ **Automatically executes** the methodologies in the background
4. ✅ **Provides real-time monitoring** and manual control
5. ✅ **Generates findings** and results from executions

The complete workflow is now functional from asset discovery all the way through to methodology execution and results generation. You have full control over when and how methodologies execute, with both automatic and manual modes available.