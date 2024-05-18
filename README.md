# Mentor Match

## Authors

- **Kusuma Reddyvari**
  - Chico State Username: kreddyvari
  - GitLab Username: kusumareddy28

- **Zeba Samiya**
  - Chico State Username: zsamiya
  - GitLab Username: ZebaSamiya

## Project Information

- **Project Name:** Mentor Match
- **Course:** Spring 2024

---

## Project Description

MentorConnect is a versatile and inclusive Flutter application designed to connect mentees with mentors across various categories, including education, mental health, law, career guidance, and personal development. Our app recognizes that mentorship extends beyond traditional educational contexts and aims to provide mentorship support for individuals seeking guidance and expertise in diverse areas of life.




## Key Features

- **Multi-Category Mentorship:** Offers a wide range of mentorship categories to cater to the diverse needs and interests of mentees, including academic support, mental health guidance, legal advice, career counseling, and personal growth coaching.

- **Customized Mentor Matching:** Uses sophisticated algorithms to match mentees with mentors based on their preferred category, expertise, availability, and compatibility.
Secure and Confidential Communication: Provides secure messaging channels, encrypted video calls, and anonymous discussion forums to ensure a safe and supportive environment for mentorship interactions.

- **Comprehensive Mentor Profiles:** Features detailed mentor profiles highlighting qualifications, experiences, areas of expertise, and mentoring styles. Mentees can review profiles, read reviews, and make informed decisions.

- **Resource Library and Tools:** Offers a rich repository of educational resources, self-help articles, legal documents, career resources, and mental health tools curated by mentors and industry experts.



## Advantages

- **Wide Reach:** Connects mentees with mentors from various fields, providing comprehensive support beyond traditional educational contexts.

- **Personalized Mentorship:** Tailors mentor-mentee matches based on specific needs and preferences, enhancing the effectiveness of the mentorship.

- **Privacy and Security:** Ensures secure and confidential communication, fostering trust and openness in mentor-mentee relationships.

- **Informed Decisions:** Allows mentees to make informed choices by providing detailed mentor profiles and reviews.

- **Accessible Resources:** Empowers mentees with access to valuable resources and tools to support their personal and professional development.

## Stakeholders Benefited

- **Students and Educators:** Gain access to academic support and career guidance.

- **Mental Health Professionals and Clients:** Benefit from secure and supportive mental health mentorship.

- **Legal Advisors and Clients:** Connect for legal advice and mentorship.

- **Career Counselors and Job Seekers:** Engage in career development and job search support.

- **Personal Development Coaches and Individuals:** Enhance personal growth and development.


## Addressing Program Requirements

- **Internet Connectivity:** Facilitates mentor-mentee matching, communication, and access to online resources by leveraging internet connectivity.

- **Location Services or Camera:** Recommends local mentors and community resources based on geographical preferences and utilizes the device camera for secure authentication and multimedia content sharing.


## File Descriptions

### `app-release.apk`

- **Purpose:** The compiled release version of the Mentor Match app for Android devices.

### `lib/firebase_options.dart`

- **Purpose:** Configuration file for initializing Firebase with platform-specific options.
- **Key Components:** Firebase configuration settings specific to the current platform (iOS, Android, etc.).

### `lib/main.dart`

- **Purpose:** Initializes the Firebase app and runs the main application. Sets up the root widget and handles authentication state to direct users.
- **Key Components:** Initializes Firebase, runs `MyApp` widget, and `AuthenticationWrapper` widget.

### `lib/pages/chat_screen.dart`

- **Purpose:** Defines the `ChatScreen` widget for handling user chat functionalities.
- **Key Components:** UI components for sending and receiving messages, integration with a backend service.

### `lib/pages/connectiondetail_screen.dart`

- **Purpose:** Displays details about a specific connection (mentor or mentee).
- **Key Components:** UI elements to show user details and actions to manage the connection.

### `lib/pages/conversation_screen.dart`

- **Purpose:** Manages the conversation view between users.
- **Key Components:** Chat interface, message list, and input field.

### `lib/pages/database_service.dart`

- **Purpose:** Provides methods to interact with the backend database.
- **Key Components:** Functions for CRUD (Create, Read, Update, Delete) operations.

### `lib/pages/detail_screen.dart`

- **Purpose:** Displays detailed information about a specific item or user.
- **Key Components:** UI elements to show detailed data and related actions.

### `lib/pages/home_screen.dart`

- **Purpose:** Main landing page after successful login or registration.
- **Key Components:** Navigation to various sections of the app, summary of user activities.

### `lib/pages/knowledgebase_entry.dart`

- **Purpose:** Represents an entry in the knowledge base.
- **Key Components:** UI for displaying and interacting with knowledge base entries.

### `lib/pages/knowledgebase_screen.dart`

- **Purpose:** Displays a list of knowledge base entries for users to browse.
- **Key Components:** List view of entries, search functionality.

### `lib/pages/login.dart`

- **Purpose:** Defines the `LoginPage` widget where users can sign in using their email and password.
- **Key Components:** Email and password input fields, Firebase Authentication for sign-in, navigation to the home screen upon successful login.

### `lib/pages/network_screen.dart`

- **Purpose:** Displays the user's network, including mentors and mentees.
- **Key Components:** List view of connections, options to add or remove connections.

### `lib/pages/picture_screen.dart`

- **Purpose:** Allows users to pick an image from their gallery, upload it to Firebase Storage, and save the image details to Firestore.
- **Key Components:** Image picker, Firebase Storage integration, Firestore integration, UI components for displaying the selected image and uploading status.

### `lib/pages/profile_page.dart`

- **Purpose:** Displays and allows editing of the user's profile information.
- **Key Components:** UI elements for profile details, editing functionality.

### `lib/pages/signup.dart`

- **Purpose:** Defines the `SignUpPage` widget for user registration.
- **Key Components:** Input fields for full name, email, password, date of birth, profession, and profile picture URL, gender and role selection using radio buttons, Firebase Authentication for registration, Firestore integration for storing user details, navigation to the login page upon successful registration.

### `lib/pages/user_profile.dart`

- **Purpose:** Displays the profile of another user.
- **Key Components:** UI elements to show the user's details, options to connect or message.

For more details on the individual components and their functionalities, refer to the comments within each file.



## References

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- ChatGPT by OpenAI