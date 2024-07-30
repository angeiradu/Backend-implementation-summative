# Be Fit App

## Welcome to Be Fit App!

Be Fit App is designed to help users manage their fitness journey. This guide will walk you through the features and functionalities of the app.

### Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [Technology Stack](#technology-stack)
4. [Development Process](#development-process)
5. [Demo video](#demo-video)
6. [Team Members](#team-members)

## Introduction

Be Fit App provides a comprehensive platform for users to track their workouts, monitor their progress, and manage their fitness goals. The app features a user-friendly interface and a variety of tools to support users on their fitness journey.

## Getting Started
Upon launching the Be Fit App, you will be greeted with the home screen. To begin, click on the "Get Started" button.

## Features

- **User Onboarding**:
  - **Sign Up**: Create an account by entering your name, email, and password. Accept the terms and conditions.
  - **Personal Information**: Choose your fitness level and enter your birth date, weight, height, and gender.

- **Dashboard**:
  - **Add a New Workout**: Enter a title and image URL for your workout. The data is saved to Firestore.
  - **Update a Workout**: Edit the title and image URL of an existing workout.
  - **Delete a Workout**: Remove a workout from Firestore.
  - **All Workouts**: View workouts added by other users. Note that you cannot edit or delete these workouts.
  - **BMI Calculator**: Input your weight and height to calculate and display your Body Mass Index (BMI).

- **Account Management**:
  - **Sign In**: Use your Google account or email to sign in.
  - **Password Reset**: Reset your password via Firebase Authentication if forgotten.

- **Authentication**:
  - Displays email addresses, authentication providers, creation date, last sign-in date, and unique user identifiers (UIDs).
 
- **Tables**:
  - We have four tables in firestore database includes; Users, Items, support, tips, fitness levels, and Workout.
## Technology Stack

- **Flutter**: Utilized for building the frontend, providing a responsive UI for both Android and iOS platforms.
- **Firebase Firestore**: Used for database management, storing user data, workout information, and ensuring data synchronization. Note: The app does not use Firestore's real-time synchronization features.

## Development Process

1. **UI Design**:
   - Initial UI designs were created using Figma, focusing on user experience and visual appeal.

2. **Frontend Development**:
   - Implemented the UI designs in Flutter, ensuring the app's responsiveness and functionality across different devices.

3. **Backend Development**:
   - Set up Firebase Firestore for data storage and retrieval, implementing user authentication and data management functionalities.
  [
## Demo Video
  [Link to the video](https://youtu.be/7BXNipuH-NE)

## Team Members

- Ange Marie Iradukunda
- Foibe Uwizeyimana
- Joselyne Marie Nyampinga

We hope you enjoy using the Be Fit App to enhance your fitness journey! If you have any questions or feedback, feel free to reach out.

