-- Skrypty .sql z initdb.d obraz gvenzl/oracle-free wykonuje jako SYS (w CDB).
-- Dlatego najpierw łączymy się z kontem student w bazie FREEPDB1, a dopiero potem ładujemy dane.
CONNECT student/student@//localhost/FREEPDB1
SET DEFINE OFF
-- Pierwsze DROP-y w bdemobld.sql zakończą się błędem ORA-00942 (tabel jeszcze nie ma) — to normalne.
@/lab-sql/bdemobld.sql
COMMIT;
