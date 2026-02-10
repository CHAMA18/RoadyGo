/**
 * One-time seeding script to ensure required collections exist in Firestore.
 *
 * Firestore is schemaless; collections are created when the first document is
 * written. This script writes minimal placeholder documents.
 *
 * Usage:
 *   cd firebase/functions
 *   npm install
 *   firebase login --reauth
 *   npm run seed:firestore
 */

const admin = require("firebase-admin");

if (!admin.apps.length) {
  admin.initializeApp({
    projectId: process.env.GCLOUD_PROJECT || "max-taxi-admin-7n82h1",
  });
}

const db = admin.firestore();

async function ensureDoc(col, id, data) {
  const ref = db.collection(col).doc(id);
  const snap = await ref.get();
  if (snap.exists) {
    return false;
  }
  await ref.set(
    {
      ...data,
      _seeded: true,
      _seededAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true }
  );
  return true;
}

async function main() {
  // Minimal placeholders aligned to `firebase/SCHEMA.md`.
  const writes = [];

  writes.push(
    ensureDoc("RideVariables", "default", {
      region: "default",
      CostOfRide: 0,
      CostPerDistance: 0,
      CostPerMinute: 0,
      CorporateCostOfRide: 0,
      CorporateCostPerDistance: 0,
      CorporateCostPerMinute: 0,
      FloatBasic: 0,
      FloatCooprate: 0,
    })
  );

  // These collections are normally populated by app logic; placeholders only.
  writes.push(
    ensureDoc("users", "_placeholder", {
      uid: "_placeholder",
      email: "placeholder@roadygo.invalid",
      display_name: "Placeholder User",
      photo_url: "",
      phone_number: "",
      created_time: admin.firestore.FieldValue.serverTimestamp(),
    })
  );

  writes.push(
    ensureDoc("passenger", "_placeholder", {
      Name: "Placeholder Passenger",
      email: "placeholder@roadygo.invalid",
      MobileNumber: "",
      Location: "",
      // UserId is a DocumentReference; leave unset in placeholder.
    })
  );

  writes.push(
    ensureDoc("driver", "_placeholder", {
      driver_name: "Placeholder Driver",
      driver_phone: "",
      car_model: "",
      car_plate: "",
      image_url: "",
      online: false,
      // user_id/region are DocumentReference; leave unset in placeholder.
    })
  );

  writes.push(
    ensureDoc("ride", "_placeholder", {
      status: "Placeholder",
      ride_type: "Scheduled",
      pickup_address: "",
      destination_address: "",
      is_driver_assigned: false,
      ride_fee: 0,
      scheduled_time: admin.firestore.FieldValue.serverTimestamp(),
      start_time: admin.firestore.FieldValue.serverTimestamp(),
      user_number: "",
      // PassengerId/driver_uid and LatLng fields are left unset.
    })
  );

  const results = await Promise.all(writes);
  const createdCount = results.filter(Boolean).length;
  console.log(
    createdCount === 0
      ? "Seed: nothing to do (all placeholder docs already exist)."
      : `Seed: created ${createdCount} placeholder docs.`
  );
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
