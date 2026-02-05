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
