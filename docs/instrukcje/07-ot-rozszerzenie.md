# Laboratorium dod. — Laboratorium dodatkowe — schemat OT (Oracle)

**Silnik:** Oracle · **Baza:** OT

**Cel:** Złączenia wielotabelowe na rozbudowanym schemacie: klienci, zamówienia, produkty, magazyny i lokalizacje.

**Połączenie:** host: localhost · port: 1521 · Service name: FREEPDB1 · użytkownik: student · hasło: student

## Czynności wstępne

1. Docker działa, a poprzednie bazy są zatrzymane.
2. Przejdź do katalogu laboratorium: `cd labs/07-ot-rozszerzenie`.
3. Przejrzyj diagram ER schematu OT (sekcja „Bazy danych” na stronie z instrukcjami).

## Przygotowanie bazy

Uruchom bazę (osobny wolumen — nie nadpisuje bazy „Firma handlowa”). Schemat i dane wczytują się ze skryptów `ot_schema.sql` i `ot_data.sql`:

```bash
docker compose up -d
docker compose logs -f oracle
```

> Poczekaj na komunikat `DATABASE IS READY TO USE!`. Źródło schematu: oracletutorial.com (wyłącznie do celów edukacyjnych).

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


## Koniec zajęć — zanim odejdziesz od komputera

1. **Najpierw sprawozdanie.** Wygeneruj sprawozdanie (PDF) i zapisz je poza komputerem w sali (e-mail, pendrive, chmura). Odpowiedzi są zapisane tylko w tej przeglądarce — czyszczenie je usunie. Kopię możesz też zachować przyciskiem „Zapisz odpowiedzi (JSON)”.
2. **Komputer w sali (współdzielony):** w katalogu z materiałami wykonaj `./lab clean --stanowisko` i wpisz `TAK`. Usuwa kontenery i dane baz, połączenia DBeavera, dane przeglądarki (także Twoje zalogowania), historię, Pobrane oraz same materiały — kolejna osoba zaczyna od czystego stanowiska.
3. **Własny komputer:** wystarczy `./lab down` (bazy zatrzymane, dane zostają na kolejne zajęcia) albo `./lab clean`, jeśli chcesz usunąć kontenery i dane laboratoriów. Obrazy baz zostają w obu przypadkach.
4. Na Windows bez Git Bash: `docker compose down` w katalogu laboratorium (lub `docker rm -f pg-lab mysql-lab oracle-lab` po instrukcji 1).

