-- Baza "Fabryka" — wersja dla MySQL
-- Ładowany AUTOMATYCZNIE przy pierwszym starcie kontenera (docker compose up).
-- Nazwy kolumn bez polskich znaków (przelozony, usunieta) dla uproszczenia;
-- dane zawierają polskie znaki (utf8mb4).

-- Wymuszamy UTF-8 po stronie klienta, niezależnie od ustawień domyślnych (polskie znaki w danych).
SET NAMES utf8mb4;

DROP TABLE IF EXISTS operator_maszyna;
DROP TABLE IF EXISTS awarie;
DROP TABLE IF EXISTS maszyny;
DROP TABLE IF EXISTS operatorzy;
DROP TABLE IF EXISTS hale;

CREATE TABLE hale (
    id_hali  TINYINT PRIMARY KEY,
    nazwa    VARCHAR(30),
    adres    TEXT
);

CREATE TABLE maszyny (
    id_maszyny        SMALLINT PRIMARY KEY AUTO_INCREMENT,
    nazwa             VARCHAR(30),
    data_uruchomienia DATE,
    id_hali           TINYINT,
    FOREIGN KEY (id_hali) REFERENCES hale(id_hali)
);

CREATE TABLE operatorzy (
    id_operatora      SMALLINT PRIMARY KEY AUTO_INCREMENT,
    nazwisko          VARCHAR(25),
    imie              VARCHAR(25),
    data_zatrudnienia DATE,
    placa             DECIMAL(6,2),
    przelozony        SMALLINT,
    FOREIGN KEY (przelozony) REFERENCES operatorzy(id_operatora)
);

CREATE TABLE operator_maszyna (
    id_operatora  SMALLINT,
    id_maszyny    SMALLINT,
    PRIMARY KEY (id_operatora, id_maszyny),
    FOREIGN KEY (id_operatora) REFERENCES operatorzy(id_operatora),
    FOREIGN KEY (id_maszyny)   REFERENCES maszyny(id_maszyny)
);

CREATE TABLE awarie (
    czas        DATE,
    usunieta    CHAR(1),
    opis        TEXT,
    id_maszyny  SMALLINT,
    FOREIGN KEY (id_maszyny) REFERENCES maszyny(id_maszyny)
);

INSERT INTO hale (id_hali, nazwa) VALUES
    (1, 'Hala produkcyjna 1'),
    (2, 'Magazyn A'),
    (3, 'Budynek administracyjny');

INSERT INTO maszyny (id_maszyny, nazwa, data_uruchomienia, id_hali) VALUES
    (10, 'Obrabiarka numeryczna',       '2001-10-23', 1),
    (20, 'Wózek widłowy "Lemur"',       '2011-03-27', 2),
    (30, 'Suwnica',                     '2001-03-11', 1),
    (40, 'Ploter tnący A-32',           '2014-02-10', 3),
    (50, 'Tokarka',                     '2006-07-05', 1),
    (60, 'Prasa hydrauliczna',          '2003-11-09', 1),
    (70, 'Wózek widłowy "Lemur lux"',   '2014-03-13', 2);

INSERT INTO operatorzy (id_operatora, nazwisko, imie, data_zatrudnienia, placa, przelozony) VALUES
    (10, 'SCHWARZENEGGER', 'ARNOLD',    '2003-03-30', 1050, NULL),
    (20, 'MACGYVER',       'ANGUS',     '2006-11-12',  900,   10),
    (30, 'BOND',           'JAMES',     '2002-03-13', 1100, NULL),
    (40, 'NORRIS',         'CHUCK',     '2009-10-21',  870,   10),
    (50, 'STALLONE',       'SYLVESTER', '2010-01-01',  999,   30),
    (60, 'WILLIS',         'BRUCE',     '2008-05-21',  800,   10);

INSERT INTO operator_maszyna (id_operatora, id_maszyny) VALUES
    (10, 30), (10, 60), (20, 10), (30, 20), (30, 70), (40, 50), (60, 40);

INSERT INTO awarie (czas, usunieta, id_maszyny, opis) VALUES
    ('2013-07-07', 'T', 50, 'Nie kręci się'),
    ('2023-12-10', 'T', 20, 'Podnośnik nie działa'),
    ('2007-01-11', 'T', 40, 'Nie włącza się'),
    ('2012-03-11', NULL, 20, 'Zbyt wolno jedzie'),
    ('2017-11-12', NULL, 60, 'Niedokładnie prasuje');

CREATE OR REPLACE VIEW maszyny_uszkodzone AS
    SELECT m.id_maszyny, m.nazwa
    FROM maszyny m JOIN awarie a ON m.id_maszyny = a.id_maszyny
    WHERE COALESCE(a.usunieta, 'N') = 'N';
