# Laboratorium 5/6 — Baza „Firma handlowa” — część I

**Silnik:** Oracle · **Baza:** Firma handlowa

**Cel:** Warunki złożone, przedziały, daty i pierwsze złączenia.

**Połączenie:** host: localhost · port: 1521 · Service name: FREEPDB1 · użytkownik: student · hasło: student

## Czynności wstępne

1. Docker działa, a poprzednie bazy są zatrzymane.
2. Przejdź do katalogu laboratorium: `cd labs/05-firma-oracle-1`.

## Przygotowanie bazy

Uruchom bazę. Pierwszy start trwa kilka minut — Oracle inicjalizuje się, a skrypt `init/01_firma.sql` ładuje dane ze skryptu `bdemobld.sql`:

```bash
docker compose up -d
docker compose logs -f oracle
```

> Gdy w logach pojawi się `DATABASE IS READY TO USE!`, zakończ podgląd (Ctrl+C) i połącz się w DBeaver — wybierz połączenie przez **Service name** `FREEPDB1`. Błędy `ORA-00942` na początku ładowania (instrukcje DROP nieistniejących tabel) są normalne. Laboratorium 6/6 kontynuuje tę samą bazę.

## Zadania

1. Wprowadź do tabeli `CUSTOMER` nowy wpis, podając w kolumnie `NAME` swoje imię i nazwisko. Pozostałe dane wg własnego uznania.
2. Napisz polecenie SQL zwracające nazwisko, imię i pensję pracowników (`EMPLOYEE`), którzy otrzymują prowizję większą niż 900 lub mniejszą niż 500.
3. Napisz polecenie SQL zwracające wyroby (nazwa) wraz z ceną minimalną i cennikową (`PRODUCT`, `PRICE`), w których opisie występuje słowo „TENNIS”, a nie ma słowa „BALL”.
4. Napisz polecenie SQL zwracające klientów z miast „DALLAS” i „NEW YORK”, których limit kredytowy przekracza 10000.
5. Napisz polecenie SQL zwracające nazwiska i imiona pracowników pracujących na etatach „STAFF” lub „SALESPERSON” (tabela `JOBS`), zatrudnionych po 1 kwietnia 1985.
6. Napisz polecenie SQL zwracające nazwisko, imię i pensję pracowników, których podwójna prowizja jest większa od pensji i zostali zatrudnieni po 1 maja 1985.
7. Napisz polecenie SQL zwracające zamówienia (identyfikator, data, wartość) z tabeli `SALES_ORDER`, których wartość przekracza 1000.
8. Wprowadź do tabeli `EMPLOYEE` nowy wpis, podając swoje imię i nazwisko. Pozostałe dane wg własnego uznania.
9. Napisz polecenie SQL zwracające identyfikatory zamówień sprzed 2 kwietnia 1990, których wartość przekracza 1000.
10. Napisz polecenie SQL zwracające nazwisko, imię i pensję pracowników zatrudnionych po 31 marca 1985, którzy otrzymują prowizję.
11. Napisz polecenie SQL zwracające klientów i ich sprzedawców z limitem kredytowym powyżej 5000 (nazwa, adres, limit, nazwisko i imię pracownika — sprzedawcy).
12. Napisz polecenie SQL zwracające nazwisko, imię i pensję pracowników, których pensja mieści się w przedziale 2000–3000.
13. Napisz polecenie SQL zwracające zamówienia (identyfikator zamówienia, data jego złożenia, nazwa klienta) dla zamówień o wartości powyżej 200.

## Uwagi

Daty zapisuj jako `DATE '1985-04-01'`. Imię i nazwisko łączysz operatorem `||`. Zapytanie bez tabeli zapisuje się w Oracle tradycyjnie z `FROM dual` (od wersji 23ai `FROM` można pominąć). W DBeaver domyślnie działa tryb auto-commit, więc `INSERT` zatwierdza się od razu.

