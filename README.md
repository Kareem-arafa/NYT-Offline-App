
# 1- Advanced Networking and Data Handling

Build a mobile network layer for an application, focusing on error handling, exception management, and request interception/synchronization. Use a modern programming language/framework (e.g., Swift for iOS, Kotlin for Android, or Dart) and provide documentation/unit tests.

Bonus points for caching, reactive programming, and authentication/token management. Submit code repository with setup instructions for evaluation.



## Features

- Data Layer
- Presentation layer
- Nertwork layer


## Documentation
#### Network service Class
Network service class A class for managing network requests using Dio.

- Constructor for initializing the [NetworkService].

- [baseUrlBuilder] is a function that provides the base URL for the network requests.
- [createRefreshAccessTokenOptions] is used for creating and refreshing access tokens.
- [enableLogging] determines whether to enable logging of network requests and responses.
- [connectTimeout], [sendTimeout], and [receiveTimeout] define the timeouts for various stages of the network requests.

- Adds a custom interceptor to the network service.

- Adds a header interceptor to the network service.

#### Interceptor
- Access Token Interceptor.
- Header Interceptor.
- Logging Interceptor.

#### Network Model
- Network requests.
- Network responses


