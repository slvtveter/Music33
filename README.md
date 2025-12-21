# 🎵 Music33 - iOS Music Player

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2016.0%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**Music33** is a native iOS music player application built with **SwiftUI**. It focuses on a clean, dark-themed UI and smooth user experience for playing local audio files. This project demonstrates modern iOS development practices including MVVM architecture and complex state management.

<p align="center">
  <img src="https://github.com/user-attachments/assets/cdbc6dab-82f4-444e-a4a2-61e845d8e9b6" alt="App Screenshot" width="300" />
</p>

## ✨ Features

* **Local Audio Playback:** Supports playback of MP3/WAV files stored locally.
* **Smart Player Controls:** Play, Pause, Next Track, Previous Track logic.
* **Interactive Slider:** Real-time scrubbing and time tracking (current time / duration).
* **Modern UI:** Glassmorphism effects, dynamic shadows, and responsive layout using SwiftUI.
* **Metadata Parsing:** Automatically extracts Artist name and Artwork from audio files.

## 🛠 Tech Stack

* **Language:** Swift
* **User Interface:** SwiftUI
* **Audio Framework:** AVFoundation (`AVAudioPlayer`)
* **Architecture:** MVVM (Model-View-ViewModel)

## 🏗 Architecture (MVVM)

The app is built using the **MVVM** pattern to ensure separation of concerns and testability:

* **Model:** Defines the `Track` data structure.
* **View:** `ContentView` (List) and `FullPlayerView` (Player UI). Reactive views that update based on the ViewModel's state.
* **ViewModel:** `PlayerViewModel`. Handles all business logic:
    * Audio session management.
    * Time formatting and seeking logic.
    * State publication (`@Published`) to update the UI instantly.

## 🚀 How to Run

1.  Clone the repository:
    ```bash
    git clone <<repolinklink>>
    ```
2.  Open `Music33.xcodeproj` in **Xcode**.
3.  Ensure you have audio files added to the project bundle (or allow access to the device library).
4.  Build and run on the Simulator or a physical iPhone.

## 🔮 Future Improvements (Roadmap)

* [ ] Fetching music from a remote API (Networking).
* [ ] Background audio playback support.
* [ ] Search functionality.
