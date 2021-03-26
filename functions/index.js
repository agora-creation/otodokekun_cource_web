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
    three_month.setMonth(three_month.getMonth() - 3);

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
    let userRef = db.collection('user');
    shopRef.get().then((shopSnapshot) => {
        shopSnapshot.forEach((shopDoc) => {
            shopRef.doc(shopDoc.id).collection('invoice').get().then((invoiceSnapshot) => {
                invoiceSnapshot.forEach((invoiceDoc) => {
                    let closedAt = invoiceDoc.data()['closedAt'];
                    closedAt.setDate(closedAt.getDate() + 1);
                    if(closedAt == today){
                        userRef.where('shopId', '==', shopDoc.id).get().then((userSnapshot) => {
                            userSnapshot.forEach((userDoc) => {
                                let locations = userDoc.data()['locations'];
                                let shopIdNew = '';
                                let locationsNew = [];
                                Object.keys(locations).forEach(key => {
                                    if(locations['target'] == true){
                                        shopIdNew = locations['id'];
                                    }
                                    locationsNew.push({
                                        'id': locations['id'],
                                        'name': locations['name'],
                                        'target': false,
                                    });
                                });
                                if(shopIdNew != ''){
                                    userDoc.ref.update({
                                        'shopId': shopIdNew,
                                        'locations': locationsNew,
                                        'staff': '',
                                        'fixed': false,
                                    });
                                    shopRef.doc(shopDoc.id).collection('order').where('deliveryAt', '>', today).get().then((orderSnapshot) => {
                                        if(orderSnapshot.empty) {
                                            console.log('No matching documents.');
                                            return;
                                        }
                                        orderSnapshot.forEach((orderDoc) => {
                                            orderDoc.ref.delete();
                                        });
                                    }).catch((e) => {
                                        console.log('Error getting documents', e);
                                    });
                                }
                            });
                        });
                    }
                });
            }).catch((e) => {
                userRef.where('shopId', '==', shopDoc.id).get().then((userSnapshot) => {
                    userSnapshot.forEach((userDoc) => {
                        let locations = userDoc.data()['locations'];
                        let shopIdNew = '';
                        let locationsNew = [];
                        Object.keys(locations).forEach(key => {
                            if(locations['target'] == true){
                                shopIdNew = locations['id'];
                            }
                            locationsNew.push({
                                'id': locations['id'],
                                'name': locations['name'],
                                'target': false,
                            });
                        });
                        if(shopIdNew != ''){
                            userDoc.ref.update({
                                'shopId': shopIdNew,
                                'locations': locationsNew,
                                'staff': '',
                                'fixed': false,
                            });
                            shopRef.doc(shopDoc.id).collection('order').where('deliveryAt', '>', today).get().then((orderSnapshot) => {
                                if(orderSnapshot.empty) {
                                    console.log('No matching documents.');
                                    return;
                                }
                                orderSnapshot.forEach((orderDoc) => {
                                    orderDoc.ref.delete();
                                });
                            }).catch((e) => {
                                console.log('Error getting documents', e);
                            });
                        }
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
