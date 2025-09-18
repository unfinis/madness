# Final Syntax Fixes for EditorCanvas

## ✅ **Critical Structural Issues Fixed**

### **Root Problem:**
The GestureDetector structure within the build method was completely broken due to incorrect indentation and missing/extra braces, causing the compiler to interpret method calls as class-level declarations.

### **Fixes Applied:**

#### **1. GestureDetector Structure (Lines 1161-1590)**
```dart
// BEFORE (completely broken structure):
child: GestureDetector(
  onTap: () { ... }    // Missing closing brace
  },                   // Extra brace
    onDoubleTap: () { ... }
  },                   // Incorrect brace placement
    onDoubleTapDown: (details) {
    // Wrong indentation throughout

// AFTER (correct structure):
child: GestureDetector(
  onTap: () { ... },
  onTapDown: (details) { ... },
  onDoubleTap: () { ... },
  onDoubleTapDown: (details) { ... },
  onScaleStart: (details) { ... },
  onScaleUpdate: (details) { ... },
  onScaleEnd: (details) { ... },
  child: Container(...)
)
```

#### **2. Method Indentation Fixed**
- **onTap**: Fixed missing closing brace and indentation
- **onTapDown**: Fixed indentation throughout method body
- **onDoubleTap**: Fixed brace placement
- **onDoubleTapDown**: Fixed all content indentation
- **onScaleStart**: Fixed indentation
- **onScaleEnd**: Fixed indentation and brace structure

#### **3. Container/Widget Hierarchy Fixed**
```dart
// BEFORE (wrong indentation):
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: ClipRect(
          child: Center(
            child: Transform(
              child: CustomPaint(
                painter: CanvasPainter(
                _backgroundImage,  // Wrong indentation
                widget.layers,

// AFTER (correct indentation):
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: ClipRect(
            child: Center(
              child: Transform(
                child: CustomPaint(
                  painter: CanvasPainter(
                    _backgroundImage,  // Correct indentation
                    widget.layers,
```

#### **4. Widget Closing Structure Fixed**
```dart
// BEFORE (misaligned):
          ),
      ), // Container
    ), // MouseRegion
    ); // Focus

// AFTER (properly aligned):
        ), // Container
      ), // MouseRegion
    ); // Focus
```

### **Summary of Key Changes:**

1. **Fixed 6 major method indentation issues** in GestureDetector
2. **Corrected widget hierarchy indentation** for Container > ClipRect > Center > Transform > CustomPaint
3. **Fixed CanvasPainter parameter alignment**
4. **Ensured proper closing brace structure**
5. **Maintained consistent 2-space indentation throughout**

### **Result:**
- ✅ All parentheses and braces properly matched
- ✅ Correct widget nesting structure
- ✅ Proper method definitions within class
- ✅ Clean, readable code formatting
- ✅ Build method properly closed before class methods

## 🎯 **Current Status:**

The EditorCanvas file should now compile successfully. The structure is:

```
class _EditorCanvasState extends ConsumerState<EditorCanvas> {
  // ... state variables

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: MouseRegion(
        child: GestureDetector(
          // ... all gesture methods properly formatted
          child: Container(
            // ... properly nested widget hierarchy
          )
        )
      )
    );
  }

  // ... class methods properly outside build method
}
```

The image replacement system with crop functionality should now compile and run without errors!