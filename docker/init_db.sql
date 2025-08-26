CREATE SCHEMA IF NOT EXISTS fraud_data;
CREATE SCHEMA IF NOT EXISTS monitoring;
CREATE SCHEMA IF NOT EXISTS mlflow;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

CREATE TYPE fraud_data.fraud_taxonomy AS ENUM (
    'card_fraud',
    'identity_theft', 
    'account_takeover',
    'merchant_fraud',
    'application_fraud',
    'money_laundering',
    'synthetic_identity',
    'first_party_fraud',
    'friendly_fraud',
    'return_fraud'
);

CREATE TYPE fraud_data.generation_status AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'failed',
    'validated'
);

CREATE TABLE IF NOT EXISTS fraud_data.generation_jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    taxonomy fraud_data.fraud_taxonomy NOT NULL,
    requested_samples INTEGER NOT NULL,
    generated_samples INTEGER DEFAULT 0,
    status fraud_data.generation_status DEFAULT 'pending',
    config JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    error_message TEXT
);

CREATE TABLE IF NOT EXISTS fraud_data.generated_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_id UUID REFERENCES fraud_data.generation_jobs(id),
    taxonomy fraud_data.fraud_taxonomy NOT NULL,
    event_data JSONB NOT NULL,
    privacy_score FLOAT,
    fidelity_score FLOAT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS monitoring.drift_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    metric_type VARCHAR(50) NOT NULL,
    metric_value FLOAT NOT NULL,
    feature_name VARCHAR(100),
    threshold_exceeded BOOLEAN DEFAULT FALSE,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS monitoring.privacy_validations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_id UUID REFERENCES fraud_data.generation_jobs(id),
    validation_type VARCHAR(50) NOT NULL,
    passed BOOLEAN NOT NULL,
    details JSONB,
    validated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_generation_jobs_status ON fraud_data.generation_jobs(status);
CREATE INDEX idx_generation_jobs_taxonomy ON fraud_data.generation_jobs(taxonomy);
CREATE INDEX idx_generated_events_job_id ON fraud_data.generated_events(job_id);
CREATE INDEX idx_generated_events_taxonomy ON fraud_data.generated_events(taxonomy);
CREATE INDEX idx_drift_metrics_recorded_at ON monitoring.drift_metrics(recorded_at DESC);
CREATE INDEX idx_privacy_validations_job_id ON monitoring.privacy_validations(job_id);

CREATE USER fraud_gen_reader WITH PASSWORD 'readonly_pass';
GRANT USAGE ON SCHEMA fraud_data TO fraud_gen_reader;
GRANT USAGE ON SCHEMA monitoring TO fraud_gen_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA fraud_data TO fraud_gen_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA monitoring TO fraud_gen_reader;

COMMENT ON SCHEMA fraud_data IS 'Schema for synthetic fraud data generation';
COMMENT ON SCHEMA monitoring IS 'Schema for monitoring and drift detection metrics';
