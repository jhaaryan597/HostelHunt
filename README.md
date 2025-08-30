# 🏠 HostelHunt

![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![Made With](https://img.shields.io/badge/Made%20With-SwiftUI-blue?logo=swift)
![iOS](https://img.shields.io/badge/iOS-16%2B-lightgrey?logo=apple)
![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase)
![Database](https://img.shields.io/badge/Database-Postgres-336791?logo=postgresql)

**A modern, sleek, and user-friendly iOS application for discovering and booking hostels.**  
Built with **SwiftUI** and powered by **Supabase**, HostelHunt makes it simple for travelers to explore, wishlist, and reserve accommodations worldwide.  

---

## 📖 Project Overview

HostelHunt is designed to deliver a **frictionless hostel booking experience**.  
Users can search for hostels, manage their profiles, and earn rewards — all wrapped in a clean and futuristic UI.  

✨ The **rewards program** makes travel not just affordable, but also more rewarding.

---

## 🛠 Core Technologies

- **Framework:** [SwiftUI](https://developer.apple.com/xcode/swiftui/) (modern declarative UI)  
- **Backend:** [Supabase](https://supabase.com/)  
  - 📂 Database → Hostel listings, reservations, wishlists  
  - 🔑 Authentication → Supabase Auth (email/password, OAuth)  
  - 🔔 Real-time → Reservation & availability updates  
- **Database:** PostgreSQL (via Supabase)  

---

## 📸 Screenshots

**Actual app looks even better in action!** 😍  

<p align="center">
  <img src="HostelHunt/Assets.xcassets/ss1.imageset/ss1.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss2.imageset/ss2.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss3.imageset/ss3.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss4.imageset/ss4.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss5.imageset/ss5.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss6.imageset/ss6.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss7.imageset/ss7.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss8.imageset/ss8.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss9.imageset/ss9.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss10.imageset/ss10.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss11.imageset/ss11.png" width="250"/>
  <img src="HostelHunt/Assets.xcassets/ss12.imageset/ss12.png" width="250"/>
</p>


---

## ✨ Features

- 🔍 **Explore hostels** with filters (location, price, amenities)  
- ❤️ **Wishlist system** for saving favorite hostels  
- 📅 **Reservations** with secure booking flow  
- 👤 **User profiles** with booking history & favorites  
- 🎁 **Rewards program** for loyal users  
- 🎨 **Modern SwiftUI UI** with smooth transitions  

---

## 🔄 Application Flow

- **Splash Screen** → App initializes & checks authentication  
- **Login / Signup** → Supabase Auth  
- **Explore Screen** → Hostel listings with filters  
- **Details Screen** → Hostel info + booking option  
- **Wishlist Screen** → Saved hostels  
- **Profile Screen** → User details, bookings, rewards  

---

## 📂 Project Structure

- HostelHunt/
  ┣ Models/         # Data models (Hostel, User, Booking)  
  ┣ Services/       # Supabase API integration  
  ┣ Views/          # SwiftUI screens  
  ┣ Components/     # Reusable UI components  
  ┣ Assets/         # App assets (images, icons)  

---

## 📦 Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/HostelHunt.git
   cd HostelHunt
