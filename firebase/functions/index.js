const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  let firestore = admin.firestore();
  let userRef = firestore.doc("users/" + user.uid);
  await firestore.collection("users").doc(user.uid).delete();
});

// One-time (protected) seeding endpoint to create placeholder documents so
// collections are visible in the Firestore Console.
//
// Enable and set a token:
//   firebase -P <project> functions:config:set seed.enabled=true seed.token="YOUR_TOKEN"
//
// Call:
//   https://<region>-<project>.cloudfunctions.net/seedFirestoreCollections?token=YOUR_TOKEN
//
// Disable after:
//   firebase -P <project> functions:config:unset seed
exports.seedFirestoreCollections = functions.https.onRequest(
  async (req, res) => {
    try {
      const cfg = functions.config().seed || {};
      const enabled = `${cfg.enabled || ""}`.toLowerCase() === "true";
      const expectedToken = `${cfg.token || ""}`;
      const providedToken = `${req.query.token || ""}`;

      if (!enabled) {
        return res.status(403).json({ ok: false, error: "seed_not_enabled" });
      }
      if (!expectedToken || providedToken !== expectedToken) {
        return res.status(401).json({ ok: false, error: "invalid_token" });
      }

      const db = admin.firestore();
      const now = admin.firestore.FieldValue.serverTimestamp();

      const writes = [];

      writes.push(
        db
          .collection("RideVariables")
          .doc("default")
          .set(
            {
              region: "default",
              CostOfRide: 0,
              CostPerDistance: 0,
              CostPerMinute: 0,
              CorporateCostOfRide: 0,
              CorporateCostPerDistance: 0,
              CorporateCostPerMinute: 0,
              FloatBasic: 0,
              FloatCooprate: 0,
              _seeded: true,
              _seededAt: now,
            },
            { merge: true }
          )
      );

      writes.push(
        db.collection("users").doc("_placeholder").set(
          {
            uid: "_placeholder",
            email: "placeholder@roadygo.invalid",
            display_name: "Placeholder User",
            photo_url: "",
            phone_number: "",
            created_time: now,
            _seeded: true,
            _seededAt: now,
          },
          { merge: true }
        )
      );

      writes.push(
        db.collection("passenger").doc("_placeholder").set(
          {
            Name: "Placeholder Passenger",
            email: "placeholder@roadygo.invalid",
            MobileNumber: "",
            Location: "",
            _seeded: true,
            _seededAt: now,
          },
          { merge: true }
        )
      );

      writes.push(
        db.collection("driver").doc("_placeholder").set(
          {
            driver_name: "Placeholder Driver",
            driver_phone: "",
            car_model: "",
            car_plate: "",
            image_url: "",
            online: false,
            _seeded: true,
            _seededAt: now,
          },
          { merge: true }
        )
      );

      writes.push(
        db.collection("ride").doc("_placeholder").set(
          {
            status: "Placeholder",
            ride_type: "Scheduled",
            pickup_address: "",
            destination_address: "",
            is_driver_assigned: false,
            ride_fee: 0,
            scheduled_time: now,
            start_time: now,
            user_number: "",
            _seeded: true,
            _seededAt: now,
          },
          { merge: true }
        )
      );

      await Promise.all(writes);
      return res.json({ ok: true, seeded: true });
    } catch (e) {
      console.error(e);
      return res.status(500).json({ ok: false, error: "seed_failed" });
    }
  }
);
