# moneybase-stocks-mvvm

iOS take-home project for the Moneybase interview process.

## Features

- Stocks list screen with symbol, name, price, and percentage change
- Stock detail screen with expanded company profile data
- Search by symbol or company name
- Auto-refresh every 8 seconds
- Pull-to-refresh support
- MVVM architecture with Swift Concurrency
- Dependency Injection through a composition root

## Architecture

The project follows a simple layered MVVM setup:

- `Domain`: entities, repository contracts, and use cases
- `Data`: mock repository implementation and seed data
- `Presentation`: SwiftUI views and view models
- `App`: dependency container and wiring

### SOLID applied

- Single Responsibility: views render UI, view models manage state, repositories fetch data
- Open/Closed: repository protocol allows swapping mock with real API without changing view models
- Liskov Substitution: any repository implementation can be injected through the protocol
- Interface Segregation: focused contracts for each use case
- Dependency Inversion: view models depend on abstractions, not concrete data sources

## Dependency Injection

The app uses a lightweight DI pattern via `AppDIContainer`.

- Build dependencies once at app launch
- Inject view models into views
- Inject use cases into view models
- Inject repository into use cases

## Running the app

1. Open `moneybase-stocks-mvvm.xcodeproj` in Xcode.
2. Select the `moneybase-stocks-mvvm` scheme.
3. Run on an iOS simulator.

## Current data source

The app currently uses mock in-memory data for both list and detail screens.
A network-backed repository can be introduced later and injected through `AppDIContainer`.
