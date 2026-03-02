# appfoods

Heart Disease Prediction Application Using Heart Rate Data

## Getting Started

This project is a student-level AI application that predicts heart disease risk using heart rate data measured by the MAX30102 sensor.

The machine learning model was trained on Google Colab and converted to TensorFlow Lite (.tflite) format. The model is integrated into a Flutter mobile app for on-device prediction.

## Demo

### Home Screen
![Home](assets/demo/home.png)

### Login Screen
![Login](assets/demo/login.png)

### Register Screen
![Register](assets/demo/register.png)

### Personal Info Screen
![Personal Info](assets/demo/personal_info.png)

### Heart Rate Measurement
![Heart Rate](assets/demo/heart_rate.png)

### Prediction Result
![Prediction](assets/demo/predict.png)

### Notification / History
![Notification](assets/demo/notification.png)


##  Features

### User Authentication
Login and registration flow with basic form validation.

### Personal Information Management
Allow users to input and update personal health-related information.

### Real-time Heart Rate Measurement
Receive heart rate data from the MAX30102 sensor via ESP32.

### On-device Heart Disease Risk Prediction
Machine Learning model trained on Google Colab and deployed using TensorFlow Lite for on-device inference.

### Measurement History Tracking
Store and review previous heart rate readings and prediction results.

### Notification Display
Display prediction alerts and system notifications inside the application.

---

## Hardware Components

- ESP32 microcontroller  
- MAX30102 heart rate sensor  
- Mobile device (Android)

---

## 🛠 Software & Tools

- Flutter (Dart)
- TensorFlow Lite
- Python (Google Colab for model training)
- Arduino IDE (for ESP32 programming)

---

## System Architecture

MAX30102 Sensor  
→ ESP32  
→ Flutter Application  
→ TensorFlow Lite Model  
→ Prediction Result  
→ History Storage

---

## Installation

```bash
git clone <your-repo-url>
cd <project-folder>
flutter pub get
flutter run
```

Make sure the `.tflite` model file is properly declared in `pubspec.yaml`.