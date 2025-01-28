# Quiz Creator

A Flutter application for creating and taking quizzes with multiple question types. Store quizzes locally and test your knowledge!

## Features

- 📝 Create quizzes with multiple question types:
  - Multiple Choice Questions (MCQ)
  - Fill-in-the-blank (Complete)
- 💾 Local storage using SQLite
- 🎨 Dark theme UI with smooth animations
- 📊 Interactive quiz progress tracking
- 🔍 Answer review mode with results analysis
- 📋 JSON formatting assistance for question creation
- 📱 Responsive design for mobile devices

## Installation

1. **Prerequisites**
   - Flutter SDK (version 3.0.0 or higher)
   - Dart (version 2.17.0 or higher)

2. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/quiz-creator.git
   cd quiz-creator
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Creating a Quiz
1. Tap the "+" button on the home screen
2. Enter a quiz title
3. Add questions using JSON format:
   ```json
   [
     {
       "question": "What is the capital of France?",
       "options": ["Paris", "London", "Berlin", "Madrid"],
       "answer": "Paris",
       "type": "MSQ"
     },
     {
       "question": "The Eiffel Tower is located in ______.",
       "options": [],
       "answer": "Paris",
       "type": "complete"
     }
   ]
   ```
4. Use the copy/paste buttons for formatting help
5. Save your quiz

### Taking a Quiz
1. Select a quiz from the home screen
2. Answer questions:
   - Multiple Choice: Tap correct answer
   - Complete: Type your answer
3. View final results and review incorrect answers

### Managing Quizzes
- Long-press quiz cards to delete
- Swipe to refresh quiz list

## Technologies Used

- **Flutter** - UI framework
- **Dart** - Programming language
- **SQLite** - Local database (using `sqflite`)
- **Google Fonts** - Typography
- **Material Design** - UI components

## Acknowledgements

- Developed by Ali Abdelmoaty
- Built with ❤️ using Flutter

