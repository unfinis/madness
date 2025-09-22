# 🏗️ **Screen Architecture & Navigation Flow**

## **Unified Methodology System Architecture**

### 🎯 **Core Concept**
The system should have a clear separation between:
- **Planning** (what could be done)
- **Execution** (what is being done)
- **Discovery** (what has been found)

---

## 📱 **Screen Purposes & When to Use**

### **1. 💾 Assets Screen**
**Purpose**: Asset inventory and property management
**When to use**:
- View all discovered assets
- Check asset properties and their evolution
- Add new network segments or assets
- See what has been discovered

**Key Features**:
- Asset cards with dynamic properties
- Property evolution tracking
- Network segment addition
- Quick stats overview

---

### **2. 🎯 Attack Graph Screen** (Recommended Primary Screen)
**Purpose**: Dynamic attack planning and execution
**When to use**:
- View current attack paths
- See recommended next steps
- Execute methodologies
- Track attack progression

**Key Features**:
- Visual graph/tree of attack paths
- Executable nodes highlighted
- Parallel path visualization
- Property-driven recommendations

**This should be your main operational screen!**

---

### **3. 📚 Methodology Library** (Renamed from Methodology Screen)
**Purpose**: Reference library of all available methodologies
**When to use**:
- Browse all methodology templates
- Search for specific techniques
- View detailed methodology information
- Manual methodology execution (edge cases)

**Key Features**:
- Full methodology catalog
- Search and filter
- Detailed methodology cards (6 tabs)
- Manual execution for non-standard paths

---

### **4. 📊 Dashboard** (Home Screen)
**Purpose**: High-level overview and metrics
**When to use**:
- Project overview
- Progress tracking
- Quick stats
- Navigation hub

**Key Features**:
- Attack phase progress
- Asset statistics
- Recent activities
- Quick actions

---

## 🔄 **Recommended Workflow**

```
1. Start: Dashboard
   ↓
2. Add Asset: Assets Screen → Add Network Segment
   ↓
3. View Attack Path: Attack Graph Screen (PRIMARY WORK HERE)
   ↓
4. Execute Nodes: Click executable nodes in graph
   ↓
5. Update Properties: Automatic from methodology completion
   ↓
6. New Paths Open: Graph updates with new opportunities
   ↓
7. Reference: Methodology Library for manual techniques
```

---

## 🎮 **User Journey Example**

### **Step 1: Project Setup** (Dashboard)
- Create new project
- View project statistics
- Navigate to Assets

### **Step 2: Asset Addition** (Assets Screen)
- Add network segment with NAC barrier
- Asset appears with initial properties
- Navigate to Attack Graph

### **Step 3: Attack Planning** (Attack Graph Screen)
- See network discovery node as executable
- Click node to view methodology details
- Execute methodology

### **Step 4: Execution** (Attack Graph Screen)
- Methodology completes
- Properties updated (subnet discovered)
- New nodes appear (host discovery, service enum)
- Multiple paths now available

### **Step 5: Parallel Execution** (Attack Graph Screen)
- Run Responder attack (if domain found)
- Run mitm6 (if IPv6 enabled)
- Both can run in parallel
- Graph shows parallel execution

### **Step 6: Reference** (Methodology Library)
- Need specific technique not in graph?
- Search methodology library
- Execute manually if needed

---

## 🚫 **What to Remove/Merge**

### **Remove Redundancy**:
1. **Attack Chain Screen** → Merge into **Attack Graph Screen**
2. **Methodology Dashboard** → Split between:
   - Attack Graph (execution view)
   - Methodology Library (reference view)

### **Clear Separation**:
- **Attack Graph**: For execution and progression
- **Methodology Library**: For reference and manual execution
- **Assets**: For asset management
- **Dashboard**: For overview

---

## 💡 **Key Principles**

1. **Single Source of Truth**: Each screen has a clear, unique purpose
2. **Progressive Disclosure**: Start simple (dashboard) → detailed (attack graph)
3. **Context-Aware**: Show only relevant actions based on current state
4. **Visual First**: Graph view for attack paths, not lists
5. **Property-Driven**: Let asset properties drive available actions

---

## 🎨 **Visual Hierarchy**

```
Dashboard (Overview)
    ├── Assets Screen (What we have)
    │   └── Asset Properties
    │
    ├── Attack Graph Screen (What we're doing) ← PRIMARY
    │   ├── Executable Nodes
    │   ├── Completed Nodes
    │   └── Blocked Nodes
    │
    └── Methodology Library (What we could do)
        └── All Methodologies
```

---

## 🔧 **Implementation Priority**

1. **High Priority**: Create unified Attack Graph Screen
2. **Medium Priority**: Rename/refactor Methodology Screen → Library
3. **Low Priority**: Clean up redundant screens
4. **Future**: Interactive graph visualization

This architecture provides clear separation of concerns and eliminates confusion about which screen to use when!