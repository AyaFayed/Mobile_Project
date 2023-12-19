// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: "AIzaSyBKF_GdAx4V5KxyZhPKfIqX9lBXUS_yNnA",
    authDomain: "gucians-99ca4.firebaseapp.com",
    projectId: "gucians-99ca4",
    storageBucket: "gucians-99ca4.appspot.com",
    messagingSenderId: "157330251998",
    appId: "1:157330251998:web:c45879b168a78f64eea24f",
    measurementId: "G-Y361T46S88"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);


