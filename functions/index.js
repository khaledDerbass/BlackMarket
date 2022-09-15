const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const database = admin.firestore();
const FieldValue = require('firebase-admin').firestore.FieldValue;

//firebase functions:log -n 1000

exports.RemoveEndedStories = functions.pubsub.schedule('0 0 * * *').onRun((context) => {
    database.collection("Store")
                            .onSnapshot((snapshot) => {

                              snapshot.forEach(doc => {
                                if (typeof doc.data().Stories !== 'undefined'){
                                console.log(doc.id, '=>', doc.data().NameEn);
                                for(var i =0 ; i < doc.data().Stories.length ; i++){
                                  console.log(doc.data().Stories[i].id, '=>', doc.data().Stories[i].createdAt);
                                  var date = new Date(doc.data().Stories[i].createdAt);
                                  date.setDate(date.getDate() + doc.data().Stories[i].duration);
                                  console.log("Delete Date ", '=>', date);
                                  var currentdate = new Date();
                                  if(currentdate >= date){
                                     console.log("Story will be deleted  ", '=>', doc.data().Stories[i].id);
                                     database.collection("Store").doc(doc.id).update({
                                          Stories: FieldValue.arrayRemove(doc.data().Stories[i])
                                     })
                                  }
                                }
                              }

                              });

                            });
    return console.log('successful RemoveEndedStories update');
});