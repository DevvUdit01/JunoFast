const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendBookingNotification = functions.firestore
  .document("leads/{leadId}")
  .onCreate(async (snap) => {
    const leadData = snap.data();
    const city = leadData.city;
    const vehicleType = leadData.vehicleType; // Ensure this matches the field name in 'leads'

    try {
      // Fetch all vendors matching the city and vehicle type
      const vendorSnapshot = await admin.firestore().collection("vendors")
        .where("city", "==", city)
        .where("vehicleType", "==", vehicleType)  // Updated to use 'vehicleType'
        .get();

      // Check if no vendors are found
      if (vendorSnapshot.empty) {
        console.log("No vendors found matching the city and vehicle type.");
        return;
      }

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
        const vendorData = doc.data();
        console.log(`Vendor found: ${vendorData.name} in ${vendorData.city} with vehicle type ${vendorData.vehicleType}`);

        const fcmToken = vendorData.fcmToken;
        if (fcmToken) {
          tokens.push(fcmToken);
        } else {
          console.log(`Vendor ${vendorData.name} is missing FCM Token.`);
        }
      });

      // Send notifications if tokens are available
      if (tokens.length > 0) {
        const response = await admin.messaging().sendMulticast({ tokens, ...payload });

        // Log detailed response for debugging
        response.responses.forEach((res, idx) => {
          if (!res.success) {
            console.error(`Failed to send notification to token ${tokens[idx]}: ${res.error}`);
          }
        });
        console.log(`Notifications sent successfully: ${response.successCount} messages sent.`);
      } else {
        console.log("No vendor tokens available for the specified city and vehicle type.");
      }
    } catch (error) {
      console.error("Error fetching vendors or sending notifications:", error);
    }
  });