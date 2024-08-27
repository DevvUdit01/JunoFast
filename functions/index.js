const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendBookingNotification = functions.firestore
  .document("leads/{leadId}")
  .onCreate(async (snap) => {
    const leadData = snap.data();
    const city = leadData.city;
    const vehicleType = leadData.vehicleType;

    try {
      // Fetch all vendors matching the city and vehicle type
      const vendorSnapshot = await admin.firestore().collection("vendors")
        .where("city", "==", city)
        .where("vehicle", "==", vehicleType)
        .get();

      // Prepare the notification message
      const payload = {
        notification: {
          title: "New Lead Available",
          body: `A new lead has been assigned to you in ${city} for your ${vehicleType}.`,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      // Collect FCM tokens
      const tokens = [];
      vendorSnapshot.forEach((doc) => {
        const fcmToken = doc.data().fcmToken;
        if (fcmToken) {
          tokens.push(fcmToken);
        }
      });

      // Send notifications if tokens are available
      if (tokens.length > 0) {
        const response = await admin.messaging().sendMulticast({ tokens, ...payload });
        console.log(`Notifications sent successfully: ${response.successCount} messages sent.`);
      } else {
        console.log("No vendor tokens available for the specified city and vehicle type.");
      }
    } catch (error) {
      console.error("Error fetching vendors or sending notifications:", error);
    }
  });
