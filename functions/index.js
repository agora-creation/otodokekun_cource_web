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

exports.deleteShopInvoice = functions.region('asia-northeast1').pubsub.schedule('0 0 * * *').timeZone('Asia/Tokyo').onRun((_) => {
    let three_month = new Date();
    three_month.setMonth(three_month.getMonth() + 3);

    let shopRef = db.collection('shop');
    shopRef.get().then((shopSnapshot) => {
        shopSnapshot.forEach((shopDoc) => {
            shopRef.doc(shopDoc.id).collection('invoice').where('closedAt', '<', three_month).get().then((invoiceSnapshot) => {
                if(invoiceSnapshot.empty) {
                    console.log('No matching documents.');
                    return;
                }
                invoiceSnapshot.forEach((invoiceDoc) => {
                    invoiceDoc.ref.delete();
                });
            }).catch((e) => {
                console.log('Error getting documents', e);
            });
        });
    });
});

exports.updateUser = functions.region('asia-northeast1').pubsub.schedule('0 0 * * *').timeZone('Asia/Tokyo').onRun((_) => {
    let today = new Date();

    let shopRef = db.collection('shop');
    shopRef.get().then((shopSnapshot) => {
        shopSnapshot.forEach((shopDoc) => {
            shopRef.doc(shopDoc.id).collection('invoice').where('closedAt', '==', today).get().then((planSnapshot) => {
                let userRef = db.collection('user');
                userRef.where('shopId', '==', shopDoc.id).get().then((userSnapshot) => {
                    userSnapshot.forEach((userDoc) => {
                        //userのlocationsを取得
                        //locations内のtargetがtrueのみ取得
                        //userのshopIdを変更
                        //userのlocationsを変更(リセット)
                        //userのfixedを変更(リセット)
                        //orderを削除(today以降)
                        //PUSH通知？

                    });
                });


            }).catch((e) => {
                console.log('Error getting documents', e);
            });
        });
    });
});

//exports.updateShopPlan = functions.region('asia-northeast1').pubsub.schedule('0 0 * * *').timeZone('Asia/Tokyo').onRun((_) => {
//    let shopRef = db.collection('shop');
//    let userRef = db.collection('user');
//    userRef.where('fixed', '==', true).get().then((userSnapshot) => {
//        userSnapshot.forEach((userDoc) => {
//            shopRef.doc(userDoc.data()['shopId']).get().then((shopDoc) => {
//                let deliveryAt = new Date();
//                deliveryAt.setDate(deliveryAt.getDate() + shopDoc.data()['cancelLimit']);
//                shopRef.doc(userDoc.data()['shopId']).collection('plan').where('deliveryAt', '==', deliveryAt).get().then((planSnapshot) => {
//                    planSnapshot.forEach((planDoc) => {
//                        let cart = [];
//                        cart.push({
//                            'id': planDoc.data()['id'],
//                            'name': planDoc.data()['name'],
//                            'image': planDoc.data()['image'],
//                            'unit': planDoc.data()['unit'],
//                            'price': planDoc.data()['price'],
//                            'quantity': 1,
//                            'totalPrice': planDoc.data()['price'],
//                        });
//                        let orderId = shopRef.doc(userDoc.data()['shopId']).collection('order').doc().id;
//                        shopRef.doc(userDoc.data()['shopId']).collection('order').add({
//                            id: orderId,
//                            shopId: userDoc.data()['shopId'],
//                            userId: userDoc.id,
//                            name: userDoc.data()['name'],
//                            zip: userDoc.data()['zip'],
//                            address: userDoc.data()['address'],
//                            tel: userDoc.data()['tel'],
//                            cart: cart,
//                            deliveryAt: planDoc.data()['deliveryAt'],
//                            remarks: '',
//                            totalPrice: planDoc.data()['price'],
//                            staff: userDoc.data()['staff'],
//                            shipping: false,
//                            createdAt: planDoc.data()['deliveryAt'],
//                        });
//                    });
//                });
//            });
//        });
//    });
//});


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
