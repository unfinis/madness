# MouseRegion Structure Fix

## ✅ **Critical Issues Fixed (Lines 1113, 1119)**

### **Root Problem:**
The MouseRegion widget parameters were incorrectly indented, causing the compiler to interpret them as separate statements instead of widget properties, leading to unmatched parentheses errors.

### **Issues Fixed:**

#### **1. Line 1119 - MouseRegion Declaration**
```dart
// BEFORE (incorrect):
      child: MouseRegion(
        cursor: _getCursorForTool(widget.selectedTool),
      onHover: (event) {    // ❌ Wrong indentation
      child: GestureDetector(  // ❌ Wrong indentation

// AFTER (correct):
      child: MouseRegion(
        cursor: _getCursorForTool(widget.selectedTool),
        onHover: (event) {    // ✅ Correct indentation
        child: GestureDetector(  // ✅ Correct indentation
```

#### **2. Line 1121 - onHover Method Content**
```dart
// BEFORE (incorrect):
        onHover: (event) {
        final canvasPoint = _screenToCanvasCoords(event.localPosition);  // ❌ Wrong indentation
        // All content had wrong indentation

// AFTER (correct):
        onHover: (event) {
          final canvasPoint = _screenToCanvasCoords(event.localPosition);  // ✅ Correct indentation
          // All content properly indented
```

#### **3. Complete MouseRegion Structure**
```dart
// NOW CORRECTLY STRUCTURED:
child: MouseRegion(
  cursor: _getCursorForTool(widget.selectedTool),
  onHover: (event) {
    final canvasPoint = _screenToCanvasCoords(event.localPosition);

    // Crop tool hover handling
    if (widget.selectedTool == EditorTool.crop) {
      // ... properly indented content
    }
    // Select/move tool hover handling
    else if ((widget.selectedTool == EditorTool.select || widget.selectedTool == EditorTool.move) && _selectedLayerId != null) {
      // ... properly indented content
    } else if (_hoverHandle != null) {
      // ... properly indented content
    }
  },
  child: GestureDetector(
    // ... GestureDetector content
  )
)
```

### **Specific Changes Applied:**

1. **Fixed `onHover` indentation** (line 1121) - moved from column 6 to column 8
2. **Fixed `child: GestureDetector` indentation** (line 1161) - moved from column 6 to column 8
3. **Fixed all content within `onHover` method** - consistently indented with 2 more spaces
4. **Fixed method closing brace structure** - proper alignment and placement

### **Result:**
- ✅ MouseRegion properly declared with correct widget parameter structure
- ✅ All properties (`cursor`, `onHover`, `child`) properly aligned within MouseRegion
- ✅ All parentheses and braces matched correctly
- ✅ Widget hierarchy maintained: Focus > MouseRegion > GestureDetector > Container

## 🎯 **Expected Outcome:**

These fixes should resolve the compilation errors:
- `lib/widgets/screenshot_editor/editor_canvas.dart(1119,25): error G297C951C: Can't find ')' to match '('.`
- `lib/widgets/screenshot_editor/editor_canvas.dart(1113,17): error G297C951C: Can't find ')' to match '('.`

The MouseRegion widget is now properly structured and should compile successfully.