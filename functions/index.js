const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendBookingNotification = functions.firestore
  .document("leads/{leadId}")
  .onCreate(async (snap, context) => {
    const leadData = snap.data();
    const leadId = context.params.leadId;
    const city = leadData.city;
    const vehicleType = leadData.vehicleType;

    try {
      // Fetch all vendors matching the city and vehicle type
      const vendorSnapshot = await admin.firestore().collection("vendors")
        .where("city", "==", city)
        .where("vehicleType", "==", vehicleType)
        .get();

      if (vendorSnapshot.empty) {
        console.log("No vendors found matching the city and vehicle type.");
        return;
      }

      const tokens = [];
      const vendorIds = []; // Array to store vendor IDs

      // Prepare the payload for each vendor and collect vendor IDs
      vendorSnapshot.forEach((doc) => {
        const vendorData = doc.data();
        const vendorId = doc.id;
        const fcmToken = vendorData.fcmToken;

        if (fcmToken) {
          tokens.push(fcmToken);
          vendorIds.push(vendorId); // Add vendor ID to the array
        } else {
          console.log(`Vendor ${vendorData.name} is missing FCM Token.`);
        }
      });

      // Update the lead document with notified vendors before sending notifications
      await admin.firestore().collection("leads").doc(leadId).update({
        notifiedVendors: vendorIds,
      });

      // Send notifications if tokens are available
      if (tokens.length > 0) {
        const payload = {
          notification: {
            title: "New Lead Request",
            body: `A new lead in ${city} for a ${vehicleType} is available.`,
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
          data: {
            leadId: leadId,
            city: city,
            vehicleType: vehicleType,
          },
        };

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
