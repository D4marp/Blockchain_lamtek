# ============================================================
# REPO 4 — KAFKA (single-node, KRaft mode = TANPA Zookeeper)
# ============================================================
# Kafka tidak punya kode aplikasi, jadi image-nya hanya membungkus image resmi
# Confluent + default config. KRaft dipilih agar benar-benar SATU service/SATU
# container (cocok untuk "1 repo = 1 microservice"). Semua nilai di bawah bisa
# di-override lewat ENV saat deploy (lihat kafka.env.example).
FROM confluentinc/cp-kafka:7.5.0

# --- KRaft (broker + controller dalam 1 node) ---
ENV KAFKA_NODE_ID=1
ENV KAFKA_PROCESS_ROLES=broker,controller
ENV KAFKA_CONTROLLER_QUORUM_VOTERS=1@kafka:9093
ENV KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
ENV KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093

# >>> WAJIB cocok dengan KAFKA_BROKERS di backend <<<
ENV KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092
ENV KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
ENV KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT

# --- single-node: semua replication factor = 1 ---
ENV KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1
ENV KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1
ENV KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1
ENV KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0
ENV KAFKA_AUTO_CREATE_TOPICS_ENABLE=true
ENV KAFKA_LOG_RETENTION_HOURS=168

# Cluster ID KRaft WAJIB UUID base64 valid (22 char). Generate punya sendiri
# dengan: `docker run --rm confluentinc/cp-kafka:7.5.0 kafka-storage random-uuid`
ENV CLUSTER_ID=4L6g3nShT-eMCtK--X86sw

# Pre-create topik backend saat broker start (hindari crash consumer di broker baru).
COPY create-topics.sh /usr/local/bin/create-topics.sh
USER root
RUN chmod +x /usr/local/bin/create-topics.sh
USER appuser

EXPOSE 9092 9093

ENTRYPOINT ["/usr/local/bin/create-topics.sh"]
