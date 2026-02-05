# Shule Direct App

A Flutter project for Shule Direct assignment.

## Requirements

- **Flutter SDK**: `3.24.3` or higher.
- **Dart SDK**: Compatible with Flutter 3.24.3.

## Known Issues

### WebSocket / Chat Testing Limitation
The application implements WebSocket connection for chat features. However, in the current test environment, the **Conversations API returns an empty list**, which prevents entering a chat room to test the WebSocket connection fully.

**API Details:**
- **Endpoint**: `https://dev-api.supersourcing.com/shuledirect-service/chat/conversations/`
- **Method**: `GET`
- **Current Response**:
  ```json
  {
    "count": 0,
    "next": null,
    "previous": null,
    "results": []
  }
  ```

Because `results` is empty, no valid `conversation_id` is available to initiate the WebSocket connection (which requires a valid ID). The app handles this by displaying a "No Groups Found" message.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
