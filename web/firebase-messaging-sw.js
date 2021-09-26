importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDjmOylk4C7u7byFMIPp7n3hUpgU4fC3IU",
  authDomain: "quickpay-a7fe7.firebaseapp.com",
  databaseURL: "https://quickpay-a7fe7.firebaseio.com",
  projectId: "quickpay-a7fe7",
  storageBucket: "quickpay-a7fe7.appspot.com",
  messagingSenderId: "230997755329",
  appId: "1:230997755329:web:58b3abba6400f189cedb40",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});