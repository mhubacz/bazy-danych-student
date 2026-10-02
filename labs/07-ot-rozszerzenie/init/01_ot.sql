-- Wykonywane jako SYS (CDB) — łączymy się z kontem student w FREEPDB1.
CONNECT student/student@//localhost/FREEPDB1
SET DEFINE OFF
@/lab-sql/ot_schema.sql
@/lab-sql/ot_data.sql
COMMIT;
