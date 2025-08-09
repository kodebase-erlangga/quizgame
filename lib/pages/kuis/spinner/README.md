# SpinSoal Refactored Structure

The SpinSoal component has been refactored into multiple files for better maintainability and easier feature additions.

## File Structure

```
lib/pages/kuis/spinner/
├── spin_soal.dart                          # Main export file (for backward compatibility)
├── spin_soal_refactored.dart              # Refactored main widget
├── models/
│   └── spin_soal_model.dart               # Data model for SpinSoal
├── controllers/
│   └── spin_soal_controller.dart          # Business logic controller
├── services/
│   └── question_service.dart              # Question loading and selection service
├── widgets/
│   ├── spin_wheel_widget.dart             # Fortune wheel component
│   └── spin_info_widgets.dart             # Info display widgets
├── utils/
│   └── dialog_utils.dart                  # Dialog utilities
└── README.md                              # This documentation
```

## Components

### 1. SpinSoalModel (`models/spin_soal_model.dart`)

- Contains all the data and parameters for the SpinSoal widget
- Provides utility methods for getting titles and player info
- Immutable data structure

### 2. SpinSoalController (`controllers/spin_soal_controller.dart`)

- Handles all business logic for spinning and question selection
- Manages state transitions and callbacks
- Controls navigation flow between screens

### 3. QuestionService (`services/question_service.dart`)

- Handles loading questions from JSON files
- Provides utilities for random question selection
- Centralized question management

### 4. SpinWheelWidget (`widgets/spin_wheel_widget.dart`)

- Encapsulates the fortune wheel component
- Handles both single question and multi-question displays
- Customizable colors and animations

### 5. SpinInfoWidgets (`widgets/spin_info_widgets.dart`)

- Contains all UI components for displaying information
- Reusable widgets for player info, question count, instructions, etc.
- Consistent styling across components

### 6. DialogUtils (`utils/dialog_utils.dart`)

- Centralized dialog management
- Exit confirmation and completion dialogs
- Reusable across different parts of the app

## Benefits of This Structure

1. **Separation of Concerns**: Each file has a single responsibility
2. **Maintainability**: Easier to find and modify specific functionality
3. **Testability**: Components can be tested in isolation
4. **Reusability**: Widgets and services can be reused in other parts of the app
5. **Backward Compatibility**: Original import statements still work

## Usage

The refactored structure maintains full backward compatibility. Existing code will continue to work without changes:

```dart
import 'package:quizgame/pages/kuis/spinner/spin_soal.dart';

// Use SpinSoal widget as before
SpinSoal(
  mode: 'single',
  availableQuestions: [1, 2, 3, 4, 5],
  // ... other parameters
)
```

## Adding New Features

To add new features:

1. **New UI Components**: Add to `widgets/` directory
2. **New Business Logic**: Extend `SpinSoalController` or create new controllers
3. **New Data Models**: Add to `models/` directory
4. **New Services**: Add to `services/` directory
5. **New Utilities**: Add to `utils/` directory

## Migration Guide

If you want to use the new structure directly:

```dart
// Old import
import 'package:quizgame/pages/kuis/spinner/spin_soal.dart';

// New import (optional)
import 'package:quizgame/pages/kuis/spinner/spin_soal_refactored.dart';
```

The functionality remains identical, but the new structure provides better organization and maintainability.
