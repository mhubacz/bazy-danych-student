-- Baza "Katedra" — wersja dla PostgreSQL (z kolumna imie)
-- Ładowany AUTOMATYCZNIE przy pierwszym starcie kontenera (docker compose up).

DROP TABLE IF EXISTS pracownik;
DROP TABLE IF EXISTS zespol;
DROP TABLE IF EXISTS etat;

CREATE TABLE zespol (
    id_zesp  smallint PRIMARY KEY,
    nazwa    varchar(20) NOT NULL,
    adres    varchar(20)
);

CREATE TABLE etat (
    nazwa      varchar(10) PRIMARY KEY,
    placa_min  numeric(6,2) NOT NULL CHECK (placa_min > 0),
    placa_max  numeric(6,2) NOT NULL CHECK (placa_max < 5000)
);

CREATE TABLE pracownik (
    numer      smallint PRIMARY KEY,
    nazwisko   varchar(25) NOT NULL,
    imie       varchar(25),
    etat       varchar(10) REFERENCES etat(nazwa),
    szef       smallint REFERENCES pracownik(numer),
    pracuje_od date DEFAULT CURRENT_DATE,
    placa_pod  numeric(6,2) NOT NULL CHECK (placa_pod > 0),
    placa_dod  numeric(6,2),
    id_zesp    smallint REFERENCES zespol(id_zesp)
);

INSERT INTO zespol (id_zesp, nazwa, adres) VALUES
    (10, 'ADMINISTRACJA',      'PIOTROWO 3A'),
    (20, 'BAZY DANYCH',        'WIEŻOWA 75'),
    (30, 'SIECI KOMPUTEROWE',  'GARBARY 3'),
    (40, 'SYSTEMY OPERACYJNE', 'PIOTROWO 3A'),
    (50, 'TRANSLATORY',        'MANSFELDA 4');

INSERT INTO etat (nazwa, placa_min, placa_max) VALUES
    ('STAŻYSTA',   800, 1000),
    ('SEKRETARKA', 900, 1200),
    ('ASYSTENT',  1000, 1600),
    ('ADIUNKT',   1600, 2000),
    ('PROFESOR',  2000, 2500),
    ('DYREKTOR',  2500, 3200);

INSERT INTO pracownik (numer, nazwisko, imie, etat, szef, pracuje_od, placa_pod, placa_dod, id_zesp) VALUES
    (1000, 'Lech',      'Adam',       'DYREKTOR',   NULL, DATE '1971-01-01', 3160,  570, 10),
    (1080, 'Koliberek', 'Anna',       'SEKRETARKA', 1000, DATE '1983-02-20', 1150, NULL, 10),
    (1010, 'Podgajny',  'Piotr',      'PROFESOR',   1000, DATE '1975-05-01', 2180,  420, 20),
    (1040, 'Rus',       'Marek',      'ADIUNKT',    1010, DATE '1979-09-15', 1750, NULL, 20),
    (1070, 'Muszyński', 'Tomasz',     'ADIUNKT',    1010, DATE '1985-05-01', 1600, NULL, 20),
    (1060, 'Misiecki',  'Paweł',      'ASYSTENT',   1010, DATE '1985-03-01', 1400, NULL, 20),
    (1090, 'Palusz',    'Ewa',        'ASYSTENT',   1040, DATE '1989-09-15', 1200, NULL, 20),
    (1020, 'Delcki',    'Krzysztof',  'PROFESOR',   1000, DATE '1977-09-01', 2050,  270, 30),
    (1030, 'Maleja',    'Barbara',    'ADIUNKT',    1020, DATE '1968-07-01', 1750, NULL, 30),
    (1100, 'Warski',    'Michał',     'ASYSTENT',   1030, DATE '1987-07-14', 1350, NULL, 30),
    (1110, 'Rajski',    'Aleksandra', 'STAŻYSTA',   1030, DATE '1990-07-01',  900, NULL, 30),
    (1050, 'Lubicz',    'Jerzy',      'ADIUNKT',    1000, DATE '1983-09-01', 1780, NULL, 40),
    (1120, 'Orka',      'Katarzyna',  'ASYSTENT',   1050, DATE '1988-04-01', 1350, NULL, 40),
    (1130, 'Kolski',    'Grzegorz',   'STAŻYSTA',   1050, DATE '1991-09-01',  900, NULL, 40);
