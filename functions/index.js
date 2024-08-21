const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendTaskNotification = functions.firestore
    .document('tasks/{taskId}')
    .onCreate(async (snapshot, context) => {
        const taskData = snapshot.data();
        const city = taskData.city;
        const vehicle = taskData.vehicle;

        // Log context information
        console.log(`Event ID: ${context.eventId}`);
        console.log(`Timestamp: ${context.timestamp}`);
        console.log(`Task ID: ${context.params.taskId}`);

        // Get vendors matching the task criteria
        const vendorQuery = admin.firestore().collection('vendors')
            .where('city', '==', city)
            .where('vehicle', '==', vehicle);

        const vendorDocs = await vendorQuery.get();
        const tokens = vendorDocs.docs.map(doc => doc.data().fcmToken);

        // Construct the notification payload
        const payload = {
            notification: {
                title: 'New Task Available',
                body: `A new task is available for your ${vehicle} in ${city}.`,
            },
        };

        // Send the notification to all matched vendors
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent:', response);
    });
