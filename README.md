# 🍽️ Flutter Restaurant & Café Finder App

A **Flutter mobile application** that helps users **discover restaurants and cafés**, **search for products**, and **view distances & directions** to selected locations.  
The app demonstrates **API integration, state management with RxDart**, **local storage**, and **real-time geolocation features**.

---

## ✨ About the Project

This app allows users to **sign up, log in, and explore nearby restaurants and cafés**.  
Users can **search for specific products**, view which restaurants offer them, and **switch between list and map views** to visualize locations with distances and directions.  
It also supports **profile image uploads** to a **Spring Boot backend**, with **local database caching** for better performance.

---

## 🌟 Features

### 🔐 User Authentication
- **Signup Screen**
  - Name (**mandatory**)
  - Gender (**optional**, via radio buttons)
  - Email (**must match `xxxx@stud.fci-cu.edu.eg`**)
  - Level (**optional**, select 1–4)
  - Password (**min 8 characters**) & Confirm Password (**must match**)
  - ✅ **Validation:** Sign-up fails if required fields are invalid.
  
- **Login Screen**
  - Secure login with email and password.

---

### 🍴 Restaurant & Café Management
- Browse all restaurants & cafés dynamically via **Overpass API**
- Display **names, latitude, and longitude**
- View **products offered** per restaurant or café

---

### 🔍 Product Search & Discovery
- **Search for a product** from a dropdown list
- View all restaurants/cafés that serve it
- **Toggle between List View & Map View**
- **Interactive Map View**
  - Pins on restaurants serving the searched product
  - Tap pins to view **distance and directions**

---

### 📍 Distance & Directions
- **Geolocator** integration to:
  - Fetch **current user location**
  - Calculate **distance in meters** to the selected restaurant/café
  - Display **route and directions** on the map

---

### 🖼️ Profile Management with Image Upload
- Upload profile pictures from **camera or gallery**
- Images are **uploaded to a Spring Boot server**
- Local DB stores only the **image URL** for fast retrieval

---

## 🛠️ Tech Stack

**Frontend:**
- Flutter (Dart)
- RxDart (or any Stream-based state management)
- Flutter Map / Google Maps
- Image Picker & Multipart HTTP

**Backend:**
- Spring Boot (for image upload & retrieval)

**Database:**
- SQLite via **sqflite** (for local storage)

**APIs & Packages:**
- **http** for API calls
- **Overpass API** for restaurant & café data
- **Geolocator** for user location & distance
- **Map Math / Google Maps** for route visualization

---

## 📱 Screens Overview

- **Signup & Login Screens** – Secure access with validation  
- **Home / Restaurants List** – Browse all nearby restaurants & cafés  
- **Product Search Screen** – Find restaurants by product offered  
- **Map View** – Visualize restaurants and distances  
- **Profile Screen** – Upload & view profile picture  

