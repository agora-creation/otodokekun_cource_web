const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);

let db = admin.firestore();

let today = new Date();

exports.deleteShopPlan = functions.region('asia-northeast1').pubsub.schedule('0 0 * * *').timeZone('Asia/Tokyo').onRun((_) => {
    let shopRef = db.collection('shop');
    shopRef.get().then((shopSnapshot) => {
        shopSnapshot.forEach((shopDoc) => {
            shopRef.doc(shopDoc.id).collection('plan').where('deliveryAt', '<', today).get().then((planSnapshot) => {
                if(planSnapshot.empty) {
                    console.log('No matching documents.');
                    return;
                }
                planSnapshot.forEach((planDoc) => {
                    planDoc.ref.delete();
                });
            }).catch((e) => {
                console.log('Error getting documents', e);
            });
        });
    });
});

exports.updateShopPlan = functions.region('asia-northeast1').pubsub.schedule('0 0 * * 1').timeZone('Asia/Tokyo').onRun((_) => {
    let shopRef = db.collection('shop');
    let userRef = db.collection('user');
    userRef.where('fixed' == true).get().then((userSnapshot) => {
        userSnapshot.forEach((userDoc) => {
            shopRef.doc(userDoc.data()['shopId']).collection('plan').get().then((planSnapshot) => {
                console.log('data:');
            });
        });
    });
});


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
