const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);

let db = admin.firestore();

let today = new Date();
let today_7 = today.setDate(today.getDate() + 7);

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
    userRef.where('fixed', '==', true).get().then((userSnapshot) => {
        userSnapshot.forEach((userDoc) => {
            shopRef.doc(userDoc.data()['shopId']).collection('plan').where('deliveryAt', '>=', today).where('deliveryAt', '<=', today_7).get().then((planSnapshot) => {
                planSnapshot.forEach((planDoc) => {
                    shopRef.doc(userDoc.data()['shopId']).collection('order').add({
                        shopId: userDoc.data()['shopId'],
                        userId: userDoc.id,
                        name: userDoc.data()['name'],
                        zip: userDoc.data()['zip'],
                        address: userDoc.data()['address'],
                        tel: userDoc.data()['tel'],
                        cart: [],
                        deliveryAt: planDoc.data()['deliveryAt'],
                        remarks: '',
                        totalPrice: 0,
                        staff: userDoc.data()['staff'],
                        shipping: false,
                        createdAt: planDoc.data()['deliveryAt'],
                    });
                });
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
