const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp(functions.config().firebase);

let db = admin.firestore();

let recRef = db.collection('plan');

let today = new Date();

exports.updateRecruiting = functions.region('asia-northeast1')
    .pubsub.schedule('0 0 * * *').timeZone('Asia/Tokyo').onRun((_) => {
        recRef.where('date', '<', today).get()
        .then(snapshot => {
          if (snapshot.empty) {
            console.log('No matching documents.');
            return;
          }
          snapshot.forEach(doc => {
            doc.ref.update({"recruiting": false});
          });
        })
        .catch(err => {
          console.log('Error getting documents', err);
        });
    });


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
