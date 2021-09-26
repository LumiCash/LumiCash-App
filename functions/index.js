const functions = require("firebase-functions");

const admin = require("firebase-admin");

admin.initializeApp(functions.config().functions);

const db = admin.firestore();

var tokens = [];

exports.newProduct = functions.firestore
    .document('products/{productId}')
    .onCreate(async (snap, context) => {

      const product = snap.data();

      const tokensRef = db.collection('tokens').doc('tokenList');

      const snapshot = await tokensRef.get();

      if (snapshot.empty) {
       console.log('No matching documents.');
       return;
      }  
      
      tokens = snapshot.data().tokens;
      

      if (tokens.length === 0)
      {
          console.log("No Tokens available");
      }
      else 
      {
        //console.log(tokens);

        try 
        {
          const message = {
            notification: {
              title: product.title,
              body: product.description,
            },
            data: {
              messageId: product.productId,
              description: product.price
            },
            android: {
              priority: "high",
              notification: {
                imageUrl: product.imageUrl
              }
            },
            apns: {
              payload: {
                aps: {
                  'mutable-content': 1,
                  contentAvailable: true,
                }
              },
              fcm_options: {
                image: product.imageUrl
              },
              headers: {
                "apns-push-type": "background",
                "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
                "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
              },
            },
            webpush: {
              headers: {
                image: product.imageUrl
              }
            },
            //topic: topicName,
            tokens: tokens,
          };
  
          admin.messaging().sendMulticast(message)
          .then((response) => {
            if (response.failureCount > 0) {
              const failedTokens = [];
              response.responses.forEach((resp, idx) => {
                if (!resp.success) {
                  failedTokens.push(registrationTokens[idx]);
                }
              });
              console.log('List of tokens that caused failures: ' + failedTokens);
            }
          });
        }
        catch (error) {
          console.error(error);
        }
        
        // await admin.messaging().sendMulticast({
        //   tokens: tokens,
        //   notification: {
        //     title: product.title,
        //     body: product.description,
        //     sound: 'default'
        //   },
        //   data : {
        //     "fcm_options": {
        //       "imageUrl": product.imageUrl,
        //      },
        //   },
        //   // Set Android priority to "high"
        //   android: {
        //     priority: "high",
        //   },
        //   // Add APNS (Apple) config
        //   apns: {
        //     payload: {
        //       aps: {
        //         contentAvailable: true,
        //       },
        //     },
        //     headers: {
        //       "apns-push-type": "background",
        //       "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
        //       "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
        //     },
        //   },
        // });

        // tokens.forEach(token => {
        //   admin.messaging().send({
        //     token: token,
        //     data: {
        //       hello: "world",

        //     },
        //     // Set Android priority to "high"
        //     android: {
        //       priority: "high",
        //     },
        //     // Add APNS (Apple) config
        //     apns: {
        //       payload: {
        //         aps: {
        //           contentAvailable: true,
        //         },
        //       },
        //       headers: {
        //         "apns-push-type": "background",
        //         "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
        //         "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
        //       },
        //     },
        //   });
        // });
        
      }


    });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
