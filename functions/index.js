const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const database = admin.firestore();

//firebase functions:log -n 50

exports.RemoveEndedStories = functions.pubsub.schedule('1 2 * * *').onRun((context) => {
    database.collection("Store")
                            .onSnapshot((snapshot) => {
                              const data = snapshot.docs.map((doc) => ({
                                id: doc.id,
                                ...doc.data(),
                              }));

                              snapshot.forEach(doc => {
                                console.log(doc.id, '=>', doc.data());
                                console.log(doc.id, '=>', doc.data().NameEn);
                                console.log(doc.id, '=>', doc.data().Stories);
                              });

                            });
    return console.log('successful RemoveEndedStories update');
});