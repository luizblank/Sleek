# Sleek

### Your stylish wishlist.

Sleek is a personal, AI-powered inventory and style companion. Designed for thrifters, fashion enthusiasts, and organized shoppers, Sleek helps you track items you want to buy and seamlessly transitions them into a curated digital wardrobe once purchased.

---

## Features

- **AI-Powered Item Entry**: Add items via Camera or Gallery. Sleek utilizes Apple's Vision Framework to automatically remove backgrounds, creating clean, high-quality stickers of your items.
- **Intelligent Classification**: The app automatically suggests names for your items based on visual recognition, reducing manual data entry.
- **Seamless Integration**: Add items directly from your browser or other apps using the dedicated Sleek Share Extension.
- **Wardrobe Transition**: Track your journey from "want" to "own." Drag and drop items from your wishlist to your Wardrobe when they are acquired.
- **Infinite Customization**: Personalize the app's interface by choosing from multiple logos, fonts, background images, and color schemes.
- **Organized and Searchable**: Categorize items, mark favorites, and use advanced filtering to manage your collection efficiently.

---

## Technical Stack

Sleek is built with modern Apple technologies to ensure a fast and native experience:

- **SwiftUI**: For a responsive and fluid user interface.
- **SwiftData**: Robust data persistence for all items and user preferences.
- **Vision Framework**: Used for background removal (VNGenerateForegroundInstanceMaskRequest) and automatic item classification (VNClassifyImageRequest).
- **Core Image**: High-performance image processing and rendering for sticker creation.
- **App Groups**: Facilitates secure data sharing between the main application and the Share Extension.

---

## Personalization

The Settings menu provides extensive control over the app's aesthetic:

- **Logos**: Multiple styles including horizontal, blank, overlapped, and text-only variants.
- **Typography**: A curated selection of professional fonts such as Antonio, Pacifico, Nabla, and Orbitron.
- **Theming**: Granular control over Background, Text, and Stroke colors.
- **Custom Backgrounds**: Support for using personal images as the application backdrop.

---

## Getting Started

### Prerequisites
- macOS with Xcode 15.0 or later.
- iOS 17.0 or later (required for SwiftData and Vision features).

### Installation
1. Clone the repository.
2. Open `Thrift.xcodeproj` in Xcode.
3. Configure the App Groups capability for your development team in both the main target and the Share Extension.
4. Build and run on a compatible device or simulator.

---

## License

This project is licensed under the MIT License.

---

**Developed by Luiz Antonio**
