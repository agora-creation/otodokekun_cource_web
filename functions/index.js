const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);

let db = admin.firestore();

exports.deleteShopPlan = functions.region('asia-northeast1').pubsub.schedule('0 0 * * *').timeZone('Asia/Tokyo').onRun((_) => {
    let today = new Date();
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
    let today = new Date();
    let today_7 = new Date();
    today_7.setDate(today_7.getDate() + 7);
    let shopRef = db.collection('shop');
    let userRef = db.collection('user');
    userRef.where('fixed', '==', true).get().then((userSnapshot) => {
        userSnapshot.forEach((userDoc) => {
            shopRef.doc(userDoc.data()['shopId']).collection('plan').where('deliveryAt', '>=', today).where('deliveryAt', '<=', today_7).get().then((planSnapshot) => {
                planSnapshot.forEach((planDoc) => {
                    let cart = [];
                    cart.push({
                        'id': planDoc.data()['id'],
                        'name': planDoc.data()['name'],
                        'image': planDoc.data()['image'],
                        'unit': planDoc.data()['unit'],
                        'price': planDoc.data()['price'],
                        'quantity': 1,
                        'totalPrice': planDoc.data()['price'],
                    });
                    let orderId = shopRef.doc(userDoc.data()['shopId']).collection('order').doc().id;
                    shopRef.doc(userDoc.data()['shopId']).collection('order').add({
                        id: orderId,
                        shopId: userDoc.data()['shopId'],
                        userId: userDoc.id,
                        name: userDoc.data()['name'],
                        zip: userDoc.data()['zip'],
                        address: userDoc.data()['address'],
                        tel: userDoc.data()['tel'],
                        cart: cart,
                        deliveryAt: planDoc.data()['deliveryAt'],
                        remarks: '',
                        totalPrice: planDoc.data()['price'],
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
