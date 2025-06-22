--PostgreSQL connection setup
\c interview_prep_db; --Connect to existing db

select datname FROM pg_database;