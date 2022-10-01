# Location Sharing App
This is a mobile application to share your realtime location with GPS tracking and stay connected with your friends, families and co-workers.

It is built using Flutter with Firebase and Firestore to handle the authentication of users and data management.


## Using the APK
- The pre-built .apk file for the app can be downloaded [here](https://drive.google.com/file/d/11gRFkX5z8_vxo-lSKzv3d1zy6IYXc863/view?usp=sharing).
- Open the file in your android device. If prompted, open using `Google Drive` and then `Package Installer`.
- Give necessary permissions to start the installation and start using the application.


## Requirements
- [Flutter](https://flutter.dev/docs/get-started/install)

If you face an error of *missing dependencies*, try running `flutter pub get`.


## Features
  - Live Location Sharing between members of a group using Location Markers on Google Maps.

    <img width="192" height="400" alt="Screenshot 2021-07-26 235949" src="https://user-images.githubusercontent.com/62967830/127062784-02cc9551-1f45-4826-9987-e38dd3f20a16.png">
  - Form multiple groups with your friends or family easily and share your location with each other.

    <img width="192" height="400" alt="Screenshot_20210726-234417" src="https://user-images.githubusercontent.com/62967830/127062963-eeb74747-5530-43b9-a2fb-e1d8696a188e.png">
  - Users can login either by creating an account or sign-in using their Google accounts as well.

    <img width="192" height="400" alt="Screenshot_20210726-234050" src="https://user-images.githubusercontent.com/62967830/127063108-cdb63c0d-c826-4e3e-9713-fa213cc430ab.png">
  - Users have an option to edit their name and profile picture after creating an account.

    <img width="192" height="400" alt="Screenshot_20210726-234539" src="https://user-images.githubusercontent.com/62967830/127063209-bc53a1b3-2c06-4a67-a732-a19a785564c1.png">


## How the Location Sharing Works?
- The device gets its continous location updates from GPS using the Google Maps API.
- Location data for the user is updated in their respective firestore documents, and subsequently in the group documents.
- Other devices sharing goups with the first user read that firebase firestore document and show the marker in the stored location.



