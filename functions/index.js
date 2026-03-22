/**
 * Secure Plus – Cloud Functions
 *
 * Sends FCM push notifications when:
 * - Customer submits service request or maintenance ticket → notify admin
 * - Admin adds a new project → notify customers
 *
 * Prerequisites:
 * - Firebase project on Blaze plan
 * - Flutter app saves FCM tokens to Firestore collection "fcm_tokens"
 *   with fields: token, role ('admin' | 'customer'), updatedAt
 */

import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';

initializeApp();

const db = getFirestore();
const messaging = getMessaging();

const FCM_TOKENS = 'fcm_tokens';
const SERVICE_REQUESTS = 'service_requests';
const TICKETS = 'tickets';
const PROJECTS = 'projects';

async function getTokensByRole(role) {
  const snap = await db.collection(FCM_TOKENS).where('role', '==', role).get();
  return snap.docs.map((d) => d.data().token).filter(Boolean);
}

async function sendToTokens(tokens, title, body, data = {}) {
  if (tokens.length === 0) return;
  const message = {
    notification: { title, body, sound: 'default' },
    data: { ...data },
    tokens,
    android: {
      priority: 'high',
      notification: {
        channelId: 'default',
        defaultSound: true,
        defaultVibrateTimings: true,
      },
    },
    apns: { payload: { aps: { sound: 'default' } } },
  };
  try {
    const res = await messaging.sendEachForMulticast(message);
    console.log('FCM send success:', res.successCount, 'fail:', res.failureCount);
  } catch (e) {
    console.error('FCM send error:', e);
  }
}

// Customer submitted new installation request → notify admin
export const onServiceRequestCreated = onDocumentCreated(
  { document: `${SERVICE_REQUESTS}/{id}` },
  async (event) => {
    const snap = event.data;
    if (!snap) return;
    const data = snap.data();
    const name = data.name || 'A customer';
    const tokens = await getTokensByRole('admin');
    await sendToTokens(
      tokens,
      'New installation request',
      `${name} submitted a new CCTV installation request.`,
      { type: 'service_request', id: event.params.id }
    );
  }
);

// Customer submitted maintenance ticket → notify admin
export const onTicketCreated = onDocumentCreated(
  { document: `${TICKETS}/{id}` },
  async (event) => {
    const snap = event.data;
    if (!snap) return;
    const data = snap.data();
    const desc = (data.description || '').slice(0, 60);
    const tokens = await getTokensByRole('admin');
    await sendToTokens(
      tokens,
      'New maintenance ticket',
      desc ? `${desc}...` : 'A new maintenance ticket was submitted.',
      { type: 'ticket', id: event.params.id }
    );
  }
);

// Admin added new project → notify customers
export const onProjectCreated = onDocumentCreated(
  { document: `${PROJECTS}/{id}` },
  async (event) => {
    const snap = event.data;
    if (!snap) return;
    const data = snap.data();
    const title = data.title || 'New project';
    const tokens = await getTokensByRole('customer');
    await sendToTokens(
      tokens,
      'New completed site',
      `Secure Plus added: ${title}`,
      { type: 'project', id: event.params.id }
    );
  }
);
