# E-Commerce App

A Flutter e-commerce application built using Clean Architecture principles.

## Architecture

The project is organized into different layers to separate responsibilities and make the code easier to maintain.

### Presentation Layer

The presentation layer is responsible for the user interface and user interactions.

### Domain Layer

The domain layer contains the core business logic of the application.

It includes:

- Entities
- Use Cases
- Repository interfaces

The `Product` entity represents an e-commerce product.

The use cases handle operations such as:

- View all products
- View a product
- Create a product
- Update a product
- Delete a product

### Data Layer

The data layer is responsible for handling data.

It includes:

- Data sources
- Repository implementations
- Models

The `ProductModel` converts data between JSON and Dart objects using `fromJson()` and `toJson()`.

## Data Flow

The application follows this general flow:

User
↓
Presentation Layer
↓
Use Case
↓
Repository
↓
Data Source
↓
API or Local Storage

When receiving data:

API or Local Storage
↓
JSON
↓
ProductModel
↓
Product Entity
↓
Use Case
↓
Presentation Layer
↓
User

## Project Structure

```text
lib/
├── core/
│   ├── error/
│   └── usecase/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── data/
│   ├── datasources/
│   └── repositories/
│
├── features/
│   └── ecommerce/
│       └── data/
│           └── models/
│               └── product_model.dart
│
└── main.dart

test/
└── features/
    └── ecommerce/
        └── data/
            └── models/
                └── product_model_test.dart