# TahlilAI - Modern iOS Health App

A modern iOS application built with Swift and UIKit, following MVVM architecture and protocol-oriented programming principles. The app allows users to scan, analyze, and track laboratory test results using AI technology.

## 🚀 Features

### Authentication
- **Modern Login/Register Screens**: Beautiful, animated authentication flow
- **User Profile Management**: Complete user profile with health metrics
- **Secure Data Storage**: User data stored locally with UserDefaults

### Main Features
1. **📷 Photo Scan/Capture**: Upload lab results via camera or gallery
2. **✏️ Manual Entry**: Manually enter lab test data
3. **📊 Analytics/Charts**: View test history with graphical analysis
4. **⚙️ Settings**: User profile, theme selection, and premium features

### Premium System
- **Credit System**: Purchase credits for AI analysis
- **Premium Features**: Advanced analytics and unlimited credits
- **In-App Purchases**: Mock implementation for premium upgrades

## 🏗️ Architecture

### MVVM + Protocol-Oriented Programming
- **Models**: Data structures with protocol definitions
- **Views**: UI components with SnapKit layout
- **ViewModels**: Business logic with protocol interfaces
- **Services**: Data management with protocol abstractions

### Project Structure
```
TahlilAI/
├── Models/
│   ├── User.swift
│   └── LabTest.swift
├── Views/
│   ├── Auth/
│   │   ├── LoginViewController.swift
│   │   └── RegisterViewController.swift
│   └── Main/
│       ├── MainTabBarController.swift
│       ├── ScanViewController.swift
│       ├── ManualEntryViewController.swift
│       ├── AnalyticsViewController.swift
│       └── SettingsViewController.swift
├── ViewModels/
│   ├── BaseViewModel.swift
│   └── AuthViewModel.swift
├── Services/
│   ├── UserService.swift
│   └── LabTestService.swift
└── Utils/
    └── Extensions.swift
```

## 🎨 Design

### Modern UI/UX
- **Clean Design**: Minimalist, modern interface
- **Color Palette**: Professional blue theme with accent colors
- **Typography**: System fonts with proper hierarchy
- **Animations**: Smooth transitions and loading states
- **Responsive Layout**: SnapKit for adaptive constraints

### Visual Elements
- **Emojis**: Intuitive iconography throughout the app
- **Shadows & Rounded Corners**: Modern card-based design
- **Color Coding**: Status indicators for test results
- **Loading States**: Visual feedback for user actions

## 🔧 Technical Implementation

### Dependencies
- **SnapKit**: Programmatic Auto Layout
- **UIKit**: Native iOS UI framework
- **Foundation**: Core data structures and utilities

### Key Technologies
- **Swift 5**: Modern Swift programming
- **MVVM Architecture**: Clean separation of concerns
- **Protocol-Oriented Programming**: Flexible, testable code
- **UserDefaults**: Local data persistence
- **UIImagePickerController**: Camera and photo library access

### Data Management
- **Mock Data**: Comprehensive test data for development
- **Local Storage**: UserDefaults for user data and test results
- **Data Validation**: Input validation and error handling
- **State Management**: Reactive UI updates

## 📱 Screens

### Authentication
- **Login Screen**: Email/password authentication
- **Register Screen**: User registration with validation
- **Navigation**: Seamless flow between auth screens

### Main App
- **Tab Bar Navigation**: 4 main sections
- **Scan Screen**: Camera/gallery upload with AI analysis
- **Manual Entry**: Form-based test data entry
- **Analytics**: Charts, filters, and test history
- **Settings**: Profile, theme, credits, and premium

## 🎯 Features in Detail

### Scan & Analysis
- Camera and photo library integration
- Mock AI analysis with realistic delays
- Credit system for analysis
- Test result visualization
- Save and manage results

### Manual Entry
- Category-based test selection
- Comprehensive form validation
- Real-time data entry
- Test result preview
- Notes and metadata

### Analytics & Charts
- Historical test data
- Category and date filtering
- Statistical overview
- Chart visualization (placeholder)
- Data export capabilities

### Settings & Profile
- Complete user profile management
- Theme selection (Light/Dark/System)
- Credit purchase system
- Premium subscription options
- Account management

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 15.0+
- Swift 5.0+

### Installation
1. Clone the repository
2. Open `TahlilAI.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the project

### Mock Data
The app includes comprehensive mock data:
- **User Profiles**: Sample user accounts
- **Test Results**: Various lab test categories
- **Historical Data**: 30 days of test history
- **Abnormal Results**: Realistic test variations

## 🔮 Future Enhancements

### Planned Features
- **Real AI Integration**: Actual machine learning analysis
- **Cloud Sync**: Remote data storage and sync
- **Advanced Charts**: Real charting library integration
- **Push Notifications**: Test result alerts
- **Export Features**: PDF reports and data export
- **Health Kit Integration**: Apple Health data sync

### Technical Improvements
- **Core Data**: Advanced data persistence
- **Network Layer**: API integration
- **Unit Tests**: Comprehensive test coverage
- **UI Tests**: Automated UI testing
- **Performance Optimization**: Memory and performance improvements

## 📄 License

This project is created for educational and demonstration purposes.

## 👨‍💻 Author

**Muhammed Yılmaz**
- Modern iOS development
- MVVM architecture
- Protocol-oriented programming
- UI/UX design

---

*Built with ❤️ using Swift and UIKit* 