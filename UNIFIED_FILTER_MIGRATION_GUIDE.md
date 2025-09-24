# Unified Filter System Migration Guide

## Overview

The new unified filter system provides a consistent, mobile-first experience across all screens. This guide shows how to migrate existing screens to use the new components.

## Core Components

### 1. `UnifiedFilterBar`
Main component that adapts to screen size and provides search + filter functionality.

### 2. `StandardSearchField`
Consistent search input with proper responsive sizing and styling.

### 3. `StandardFilterChip`
Professional filter chips with consistent styling and touch targets.

### 4. `FilterBottomSheet`
Mobile-optimized bottom sheet for advanced filter options.

### 5. `FilterBreakpoints`
Unified responsive breakpoints and sizing utilities.

## Basic Usage

```dart
import '../widgets/unified_filter/unified_filter.dart';

// In your screen's build method:
UnifiedFilterBar(
  searchController: _searchController,
  searchHint: 'Search items...',
  primaryFilters: [
    PrimaryFilter(
      label: 'Status: ${_getStatusLabel()}',
      isSelected: hasActiveStatusFilters,
      onPressed: () => _toggleStatusFilter(),
      icon: Icons.info,
    ),
  ],
  advancedFilters: [
    FilterSection(
      title: 'Categories',
      children: [
        Wrap(
          spacing: 8,
          children: categories.map((cat) =>
            StandardFilterChip(
              label: cat.name,
              isSelected: isSelected(cat),
              onPressed: () => toggle(cat),
            )
          ).toList(),
        ),
      ],
    ),
  ],
  onSearchChanged: (value) => updateSearch(value),
  resultCount: filteredItems.length,
)
```

## Migration Steps

### Step 1: Import New Components
```dart
import '../widgets/unified_filter/unified_filter.dart';
import '../constants/filter_breakpoints.dart';
```

### Step 2: Replace Old Filter Widget
Remove the old `*FiltersWidget` and replace with `UnifiedFilterBar`.

### Step 3: Configure Primary Filters
Choose 2-3 most important filters for mobile display:

```dart
List<PrimaryFilter> _buildPrimaryFilters() {
  return [
    // Most important filter first
    PrimaryFilter(
      label: 'Status: ${_getStatusLabel()}',
      isSelected: hasStatusFilters,
      onPressed: _showStatusOptions,
      icon: Icons.info,
    ),
    // Second most important
    PrimaryFilter(
      label: 'Type: ${_getTypeLabel()}',
      isSelected: hasTypeFilters,
      onPressed: _showTypeOptions,
      icon: Icons.category,
      badge: selectedTypes.length > 1 ? '${selectedTypes.length}' : null,
    ),
  ];
}
```

### Step 4: Configure Advanced Filters
Organize remaining filters into logical sections:

```dart
List<FilterSection> _buildAdvancedFilters() {
  return [
    FilterSection(
      title: 'Status Options',
      icon: Icons.info,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Status.values.map((status) =>
            StandardFilterChip(
              label: status.displayName,
              isSelected: selectedStatuses.contains(status),
              onPressed: () => toggleStatus(status),
              icon: status.icon,
            )
          ).toList(),
        ),
      ],
    ),
    FilterSection(
      title: 'Advanced Options',
      icon: Icons.tune,
      initiallyExpanded: false,
      children: [
        // Less common filters here
      ],
    ),
  ];
}
```

## Responsive Behavior

### Mobile (< 600px)
- Search bar full width
- 2 primary filters shown
- "More Filters" button opens bottom sheet
- Minimum 44px touch targets

### Tablet (600px - 1024px)
- Search bar 60% width
- Primary filters wrap below search
- Filter toggle button beside search

### Desktop (> 1024px)
- Search bar 40% width
- All filters inline
- Result count displayed
- Hover states active

## Best Practices

### Filter Priority
1. **Primary filters**: Most commonly used (Status, Type)
2. **Secondary filters**: Moderately used (Category, Date)
3. **Advanced filters**: Rarely used (Specific options)

### Labels
- Use clear, descriptive labels
- Show current selection: "Status: Valid" or "Type: Multiple (3)"
- Add badges for multiple selections

### Touch Targets
- Minimum 44px height on mobile
- Adequate spacing between interactive elements
- Clear focus indicators

### Performance
- Use provider state management
- Debounce search input (300ms)
- Lazy load filter options if needed

## Example Screens

### Simple Screen (few filters)
```dart
primaryFilters: [
  PrimaryFilter(
    label: _getMainFilterLabel(),
    isSelected: hasMainFilter,
    onPressed: _toggleMainFilter,
  ),
],
// No advanced filters needed
```

### Complex Screen (many filters)
```dart
primaryFilters: [
  // 2-3 most important
],
advancedFilters: [
  FilterSection(title: 'Category A', children: [...]),
  FilterSection(title: 'Category B', children: [...]),
  FilterSection(title: 'Advanced', initiallyExpanded: false, children: [...]),
],
```

## Testing Checklist

- [ ] Mobile: Filters accessible via bottom sheet
- [ ] Tablet: Filters wrap properly
- [ ] Desktop: All filters visible inline
- [ ] Touch targets minimum 44px on mobile
- [ ] Search clears properly
- [ ] Filter states persist correctly
- [ ] Result count updates live
- [ ] Accessibility: Screen reader friendly
- [ ] Performance: No lag on filter changes

## Migration Priority

1. **High Impact**: Credentials, Tasks, Contacts
2. **Medium**: Expenses, Scope, Documents
3. **Complex**: Findings, Questionnaire (may need custom implementation)

This system provides a consistent, professional, mobile-first experience while maintaining the powerful filtering capabilities users expect.