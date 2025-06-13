# SwiftUI Pokédex - Clean Architecture

This project is a high-performance Pokédex application built with SwiftUI, designed to serve as a strong reference for modern iOS development using **Clean Architecture** and **MVVM**.

The app fetches and displays the first 151 Pokémon from [PokeAPI], focusing on scalability, testability, and performance.

## Key Features & Technical Highlights

-   **Clean Architecture:** The codebase is strictly separated into Core, Data, Domain, and Presentation layers. This enforces the Dependency Rule, ensuring a decoupled, scalable, and highly testable system.
    
-   **MVVM Design Pattern:** The Presentation layer uses MVVM to separate UI (SwiftUI Views) from presentation logic (ViewModels), resulting in cleaner, more maintainable view code.
    
-   **Performance Optimized:**
    
    -   **Infinite Scrolling:** Pokémon are loaded in batches using a LazyVGrid, minimizing initial payload and memory usage.
        
    -   **Concurrent Data Fetching:** Utilizes Swift's async/await with withThrowingTaskGroup to fetch Pokémon details in parallel, drastically reducing wait times.
        
    -   **Multi-Layer Caching:** Implements an in-memory cache (NSCache) for both API responses and downloaded images, ensuring near-instantaneous loads on subsequent visits and reducing network usage.
        
-   **Protocol-Oriented Networking:** The network layer is fully abstract, defined by an Endpoint protocol. This makes the NetworkService generic, reusable, and easy to mock for testing.
    
-   **Scalable Navigation:** A centralized Router class manages navigation using SwiftUI's NavigationStack, providing a single source of truth for the application's flow.
    
-   **DTO & Mapper Pattern:** The Data layer uses Data Transfer Objects (DTOs) to mirror the API's structure and Mappers to transform DTOs into clean Domain entities. This isolates the app from API-specific implementation details.
    

## Architecture Overview

The project adheres to the Clean Architecture dependency rule, ensuring dependencies only flow inwards.

```
Presentation (MVVM) -> Domain (Use Cases) -> Data (Repositories) -> Core (Network)
```
![GitHub - mind0w/HelloCleanArchitectureWithSwiftUI: CleanArchitecture for  SwiftUI with Combine, Concurrency](https://user-images.githubusercontent.com/25020477/155071101-28765b74-9c9a-4ccb-ae19-f342288937c0.png)

1.  **Core Layer:** Contains a generic, protocol-based NetworkService and a reusable CacheManager. It has no knowledge of Pokémon or any other business logic.
    
2.  **Data Layer:** Implements the PokemonRepository protocol. It's responsible for fetching data from the PokeAPI, handling DTO-to-Domain model mapping, and interacting with the network layer.
    
3.  **Domain Layer:** The core of the application. It defines the Pokemon entity, the PokemonRepository contract (protocol), and business logic via UseCases. It is completely independent of UI and data sources.
    
4.  **Presentation Layer:** The UI, built with SwiftUI. Views are lightweight and state-driven, observing a ViewModel that orchestrates data flow by calling UseCases.
    

## Getting Started

### Prerequisites

-   Xcode 14.0+
    
-   Swift 5.7+
    
-   iOS 16.0+
    

### Installation

1.  Clone the repository:
    
    ```
    git clone https://github.com/your-username/pokedex-swiftui-app.git
    ```
    
    content_copydownload
    
    Use code  [with caution](https://support.google.com/legal/answer/13505487).Bash
    
2.  Open the project in Xcode.
    
3.  Build and run (Cmd + R).
