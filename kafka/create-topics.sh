#!/bin/bash
# ---------------------------------------------------------------------------
# Pre-create semua topik yang di-subscribe backend. Wajib: di broker KRaft yang
# baru, consumer NestJS yang subscribe ke topik belum-ada akan crash fatal
# ("This server does not host this topic-partition") sebelum auto-create selesai.
# Script ini start broker (entrypoint asli) lalu membuat topik di background.
# ---------------------------------------------------------------------------
set -e

BOOTSTRAP="${TOPIC_BOOTSTRAP:-localhost:9092}"
PARTITIONS="${TOPIC_PARTITIONS:-1}"
RF="${TOPIC_REPLICATION_FACTOR:-1}"

TOPICS="
cdc-lamtek-users cdc-lamtek-akreditasi cdc-lamtek-institusi
lamtek.data.query lamtek.data.query.soft-delete lamtek.data.file
lamtek.blockchain.transaction lamtek.blockchain.block lamtek.blockchain.contract.event
lamtek.akreditasi.created lamtek.akreditasi.updated lamtek.akreditasi.status.changed
lamtek.asesmen.assigned lamtek.asesmen.kecukupan.completed lamtek.asesmen.lapangan.completed
lamtek.document.uploaded lamtek.document.ipfs.stored lamtek.document.verified
lamtek.payment.created lamtek.payment.completed lamtek.payment.verified lamtek.payment.rejected
lamtek.user.registered lamtek.user.activated lamtek.user.deactivated
lamtek.notification.email lamtek.notification.push lamtek.notification.sms
lamtek.audit.log
"

(
  echo "[kafka-topics] menunggu broker siap ..."
  until kafka-topics --bootstrap-server "$BOOTSTRAP" --list >/dev/null 2>&1; do sleep 2; done
  echo "[kafka-topics] broker siap, membuat topik ..."
  for t in $TOPICS; do
    kafka-topics --bootstrap-server "$BOOTSTRAP" --create --if-not-exists \
      --topic "$t" --partitions "$PARTITIONS" --replication-factor "$RF" >/dev/null 2>&1 \
      && echo "  + $t"
  done
  echo "[kafka-topics] selesai."
) &

# Jalankan entrypoint resmi Confluent (start broker, foreground).
exec /etc/confluent/docker/run
