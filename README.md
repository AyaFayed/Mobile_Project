# GUCians

## Overview
Welcome to the GUC Campus App repository! This project aims to provide a comprehensive application for the students and staff of the German University in Cairo (GUC). The application facilitates various functionalities catering to the needs of the university community. The app offers features ranging from academic assistance to campus-related services, promoting engagement and convenience.

## Project Description
The GUC Campus App serves as a versatile tool for students and staff, encompassing functionalities designed to enhance campus life. Key features include:

- **Sign Up**: Users can register using their GUC email addresses and create unique usernames. Email verification is mandatory for account activation.
- **Confessions**: Allows users to post confessions anonymously or openly, with the option for others to comment.
- **Academic Related Questions**: Users can post queries regarding courses, textbooks, professors, and provide ratings. Image uploads are supported.
- **Lost and Found**: Enables users to post about lost or found items, including images for better identification.
- **Offices and Outlets**: Users can search for professors, TAs, offices, and other campus outlets. The app provides location details and navigation assistance.
- **Important Phone Numbers**: Lists essential contact numbers such as clinic and ambulance services, with one-click calling functionality.
- **News, Events, and Clubs**: Allows users to stay updated on campus news, events, and clubs. Content approval is managed by an admin, with user-requested content addition.

## Implementation Overview
The project encompasses various components and database models to ensure smooth functionality and user experience. Here's a brief overview:

### Database Models
1. **User**: Stores user information including name, email, handle (username), profile picture URL, user type, ratings, notification preferences, and office location.
2. **Post**: Represents different types of posts within the app such as news, confessions, academic questions, etc. Includes post content, author details, comments, tags, voters, and creation timestamp.
3. **NotificationModel**: Manages notifications sent to users, including title, body, creation time, related post ID, and notification type.
4. **Comment**: Stores user comments on posts, containing content, author details, and creation time.
5. **EmergencyNum**: Contains emergency contact details like name and number.
6. **Location**: Stores information about campus locations including name, directions, and map URL.

### Components
1. **Authentication**: Implemented using Firebase Authentication, allowing users to log in/sign up using GUC email addresses. Email verification is handled via a third-party SMTP service.
2. **Settings**: Users can customize notification preferences and manage their profile settings.
3. **Notifications**: Push notifications are sent for various events including mentions, comments, and new posts.
4. **Posting**: Users can view, create, edit, and delete posts, comments, and reactions. Content moderation and bad speech detection are implemented.
5. **Professor Profile**: Enables users to view and rate professors, along with accessing their contact information.
6. **Emergency Numbers**: Lists and allows users to call emergency contacts directly from the app.
7. **Locations**: Provides information and directions to various campus outlets.

## Setup Instructions
To run the GUC Campus App locally or deploy it, follow these steps:

1. Clone this repository to your local machine.
2. Ensure you have the necessary dependencies installed, including Flutter and Firebase.
3. Set up Firebase project and configure it with the app. Update Firebase configurations in the app accordingly.
4. Run the app on your preferred emulator or device using Flutter CLI or IDE.
