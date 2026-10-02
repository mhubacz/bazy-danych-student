# Laboratorium dod. — Laboratorium dodatkowe — schemat OT (Oracle)

**Silnik:** Oracle · **Baza:** OT

**Cel:** Złączenia wielotabelowe na rozbudowanym schemacie: klienci, zamówienia, produkty, magazyny i lokalizacje.

**Połączenie:** host: localhost · port: 1521 · Service name: FREEPDB1 · użytkownik: student · hasło: student

## Czynności wstępne

1. Docker działa, a poprzednie bazy są zatrzymane.
2. Przejdź do katalogu laboratorium: `cd labs/07-ot-rozszerzenie`.
3. Przejrzyj diagram ER schematu OT (sekcja „Bazy danych” w tym skoroszycie).

## Przygotowanie bazy

Uruchom bazę (osobny wolumen — nie nadpisuje bazy „Firma handlowa”). Schemat i dane wczytują się ze skryptów `ot_schema.sql` i `ot_data.sql`:

```bash
docker compose up -d
docker compose logs -f oracle
```

> Poczekaj na komunikat `DATABASE IS READY TO USE!`. Źródło schematu: oracletutorial.com (wyłącznie do celów edukacyjnych).

> Poniższe zadania to propozycje do edycji przez prowadzącego.

## Zadania

1. Wyświetl klientów (`CUSTOMERS`) z limitem kredytowym powyżej 5000, posortowanych malejąco po limicie.
2. Wyświetl zamówienia (`ORDERS`) ze statusem „Pending” wraz z nazwą klienta.
3. Policz zamówienia każdego klienta (nazwa klienta, liczba zamówień), od największej liczby.
4. Oblicz wartość zamówienia jako sumę `quantity * unit_price` z tabeli `ORDER_ITEMS` dla 10 zamówień o największej wartości.
5. Wyświetl produkty (`PRODUCTS`) z kategorii „CPU” (`PRODUCT_CATEGORIES`) wraz z ceną cennikową.
6. Wyświetl magazyny (`WAREHOUSES`) wraz z miastem i nazwą kraju (`LOCATIONS`, `COUNTRIES`).
7. Wyświetl pracowników (`EMPLOYEES`) wraz z nazwiskami ich przełożonych (złączenie tabeli z samą sobą).

## Uwagi

Limit liczby wierszy w Oracle zapisujesz jako `FETCH FIRST n ROWS ONLY`. Skrypt OT ładuje się dłużej niż pozostałe (blisko 3000 poleceń INSERT).

