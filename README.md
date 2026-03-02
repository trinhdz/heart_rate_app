# app_heart_rate

Heart Disease Prediction Application Using Heart Rate Data

## Overview

This project demonstrates the deployment of a Machine Learning model into a Flutter mobile application using real-time heart rate data collected from embedded hardware.

The model was trained on Google Colab using Python, converted to TensorFlow Lite (.tflite) format, and integrated into the Flutter application for on-device inference.

The application performs prediction locally on the device without requiring cloud processing.

## Disclaimer

This application is developed for educational purposes only.  
It is not intended for medical diagnosis or professional healthcare use.

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

## Features

### User Authentication
Login and registration flow with form validation.

### Personal Information Management
Input and update user health-related information.

### Real-time Heart Rate Measurement
Receive heart rate data from the MAX30102 sensor via ESP32.

### On-device Heart Disease Risk Prediction
Machine Learning model deployed using TensorFlow Lite for mobile inference.

### Measurement History Tracking
Store and review previous heart rate readings and prediction results.

### Notification Display
Display prediction alerts and system notifications within the application.

## Hardware Components

- ESP32 microcontroller  
- MAX30102 heart rate sensor  
- Android mobile device  

## Software & Tools

- Flutter (Dart)  
- TensorFlow Lite  
- Python (Google Colab for model training)  
- Arduino IDE (for ESP32 programming)  

## System Architecture

MAX30102 Sensor  
→ ESP32  
→ Flutter Application  
→ TensorFlow Lite Model  
→ Prediction Result  
→ History Storage  

## Installation

```bash
git clone https://github.com/trinhdz/heart_rate_app.git
cd heart_rate_app
flutter pub get
flutter run
```

Make sure the `.tflite` model file is properly declared in `pubspec.yaml`.

## Model Training

The Machine Learning model was trained using Python on Google Colab.

Training notebook:  
[View Training Notebook on Google Colab](https://colab.research.google.com/drive/1z69FfImCqJ1gz5GdUgZNxgZk_GTvk6KL?usp=sharing)

After training, the model was converted to TensorFlow Lite (.tflite) format and integrated into the Flutter application for on-device inference.

## Future Improvements

- Improve model accuracy with larger datasets  
- Enhance UI/UX design  
- Add cloud synchronization  
- Implement advanced state management