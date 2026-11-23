import 'package:sqflite/sqflite.dart';

const List<String> schemaStatements = [
  '''
  CREATE TABLE users (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT,
    role TEXT NOT NULL,
    locale TEXT,
    is_demo INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE vehicles (
    id TEXT PRIMARY KEY,
    owner_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    make TEXT NOT NULL,
    model TEXT NOT NULL,
    year_ad INTEGER NOT NULL,
    plate_roman TEXT NOT NULL,
    plate_devanagari TEXT NOT NULL,
    province TEXT,
    fuel TEXT,
    transmission TEXT,
    color TEXT,
    chassis_masked TEXT,
    engine_masked TEXT,
    initial_odometer INTEGER NOT NULL DEFAULT 0,
    photo_asset TEXT,
    created_at TEXT NOT NULL,
    is_seed INTEGER NOT NULL DEFAULT 0
  )
  ''',
  '''
  CREATE TABLE records (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    event_date TEXT NOT NULL,
    odometer_km INTEGER,
    workshop TEXT,
    cost_npr INTEGER,
    document_no TEXT,
    source TEXT NOT NULL DEFAULT 'ownerRecorded',
    created_at TEXT NOT NULL,
    is_seed INTEGER NOT NULL DEFAULT 0
  )
  ''',
  '''
  CREATE TABLE evidence (
    id TEXT PRIMARY KEY,
    record_id TEXT NOT NULL REFERENCES records(id) ON DELETE CASCADE,
    kind TEXT NOT NULL,
    file_path TEXT NOT NULL,
    thumb_path TEXT,
    mime TEXT,
    width INTEGER,
    height INTEGER,
    size_bytes INTEGER NOT NULL DEFAULT 0,
    label TEXT,
    created_at TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE reminders (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    due_date TEXT NOT NULL,
    target_odometer INTEGER,
    status TEXT NOT NULL DEFAULT 'due',
    notes TEXT
  )
  ''',
  '''
  CREATE TABLE report_snapshots (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL,
    token TEXT NOT NULL UNIQUE,
    created_at TEXT NOT NULL,
    payload_json TEXT NOT NULL,
    include_costs INTEGER NOT NULL DEFAULT 1,
    include_evidence INTEGER NOT NULL DEFAULT 1,
    pdf_path TEXT
  )
  ''',
  '''
  CREATE TABLE saved_reports (
    id TEXT PRIMARY KEY,
    token TEXT NOT NULL UNIQUE,
    snapshot_json TEXT NOT NULL,
    saved_at TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE sus_responses (
    id TEXT PRIMARY KEY,
    participant_code TEXT,
    role TEXT,
    answers_json TEXT NOT NULL,
    sus_score REAL NOT NULL,
    comment TEXT,
    created_at TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE app_events (
    id TEXT PRIMARY KEY,
    type TEXT NOT NULL,
    at TEXT NOT NULL,
    meta_json TEXT
  )
  ''',
  'CREATE INDEX idx_records_vehicle ON records(vehicle_id, event_date DESC)',
  'CREATE INDEX idx_evidence_record ON evidence(record_id)',
  'CREATE INDEX idx_vehicles_owner ON vehicles(owner_id)',
  'CREATE INDEX idx_reminders_vehicle ON reminders(vehicle_id, status)',
  'CREATE INDEX idx_snapshots_token ON report_snapshots(token)',
  'CREATE INDEX idx_saved_token ON saved_reports(token)',
];

Future<void> createSchema(DatabaseExecutor db) async {
  for (final statement in schemaStatements) {
    await db.execute(statement);
  }
}
