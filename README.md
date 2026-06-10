**Note**: The complete assignment solution is available in the feature branch. Please switch to the feature branch to review the implementation and source code.

# Flutter User Directory App

A Flutter application developed as part of the Elyx Digital Flutter Developer Assignment.

## Features

* User Listing
* User Details
* Search Functionality
* Infinite Pagination
* Pull To Refresh
* Offline Cache
* Dependency Injection
* Error Handling
* Responsive UI

---

## Architecture

Feature First Architecture with Clean Separation.

Layers:

Presentation

* UI
* Bloc

Data

* Repository
* Remote Data Source
* Local Data Source

Core

* Network
* Error Handling

Injection

* Dependency Injection

---

## State Management

flutter_bloc

---

## Dependency Injection

get_it

---

## Networking

http

---

## Local Storage

hive

---

## Project Structure

lib/

core/
features/
injection/

---

## Setup

1. Clone repository

2. Install dependencies

flutter pub get

3. Generate Hive adapters

flutter pub run build_runner build

4. Run application

flutter run

---

## Packages Used

flutter_bloc
bloc_concurrency
stream_transform
http
get_it
hive
hive_flutter
connectivity_plus
equatable

---

## Future Improvements

* Unit Tests
* Widget Tests
* Shimmer Loading
* Offline First Sync
* Pagination Optimization
