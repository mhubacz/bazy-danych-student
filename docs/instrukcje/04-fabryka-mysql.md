# Laboratorium 4/6 — INSERT, UPDATE, DELETE — baza „Fabryka”

**Silnik:** MySQL · **Baza:** Fabryka

**Cel:** Modyfikacja danych poleceniami INSERT, UPDATE i DELETE oraz zapytania z warunkami i prostymi złączeniami.

**Połączenie:** host: localhost · port: 3306 · baza: fabryka · użytkownik: student · hasło: student

## Czynności wstępne

1. Docker działa, a poprzednie bazy są zatrzymane (`docker compose down` w ich katalogach).
2. Przejdź do katalogu laboratorium: `cd labs/04-fabryka-mysql`.

## Przygotowanie bazy

Uruchom bazę. Tabele (`hale`, `maszyny`, `operatorzy`, `operator_maszyna`, `awarie`) wczytują się same ze skryptu `init/01_fabryka.sql`:

```bash
docker compose up -d --wait
```

> Połącz się w DBeaver (dane powyżej). Jeśli DBeaver zgłosi „Public Key Retrieval is not allowed”, w ustawieniach połączenia (*Edit Connection* → *Driver properties*) ustaw `allowPublicKeyRetrieval` na `true`. W tym laboratorium modyfikujesz dane, więc reset do stanu początkowego jest przydatny: `docker compose down -v`, a potem `docker compose up -d --wait`.

## Zadania

1. Dodaj nowego operatora o Twoim imieniu i nazwisku, przy czym przełożonym będzie BOND. Reszta danych wg uznania.
2. Dodaj nową maszynę „Pakowarka próżniowa” do Magazynu A.
3. Tokarka zaczęła zgrzytać. Wprowadź informację o tej awarii.
4. Podwyższ o 20% płace operatorów, którzy nie mają przełożonego.
5. BRUCE WILLIS dostał uprawnienia obsługi wózka widłowego i obsługuje wózki wraz z BONDem. Wprowadź odpowiednie informacje do bazy.
6. Napisz polecenie SQL zwracające nazwiska i płace operatorów, którzy zarabiają więcej niż 1000, a mniej niż 2000.
7. Napisz polecenie SQL zwracające maszyny, których jeszcze nie uruchomiono.
8. Napisz polecenie SQL zwracające nazwiska i płace operatorów, którzy mają przełożonych.
9. Napisz polecenie SQL zwracające maszyny uruchomione między rokiem 2010 a 2012.
10. Napisz polecenie SQL zwracające maszyny ze wszystkich hal poza halą nr 1.
11. Napisz polecenie SQL zwracające daty wszystkich awarii oraz nazwy maszyn, które im uległy.
12. Napisz polecenie zwracające maszyny wraz z imionami i nazwiskami operatorów, którzy je obsługują.
13. Napisz polecenie SQL zwracające nazwy maszyn oraz nazwy hal, w których te maszyny się znajdują.

## Uwagi

Klucze `id_maszyny` i `id_operatora` mają `AUTO_INCREMENT` — w zadaniach 1–2 nie podawaj ich ręcznie. Datę zapisujesz jako `'2010-01-01'`. W zadaniu 3 skorzystaj z `CURDATE()` jako daty awarii. Uwaga: w MySQL operator `||` oznacza OR, a nie łączenie tekstu.


## Koniec zajęć — zanim odejdziesz od komputera

1. **Wyślij sprawozdanie.** Wygeneruj sprawozdanie (PDF) i prześlij je na [sprawozdania.kia.prz.edu.pl](https://sprawozdania.kia.prz.edu.pl). Zrób to przed czyszczeniem — odpowiedzi są zapisane tylko w tej przeglądarce.
2. **Wyczyść stanowisko.** W katalogu z materiałami wykonaj `./lab clean --stanowisko` i wpisz `TAK`. Polecenie usuwa kontenery i dane baz, połączenia DBeavera, dane przeglądarki (także Twoje zalogowania), historię, Pobrane oraz same materiały — kolejna osoba zaczyna od czystego komputera.
3. *Pracujesz na własnym komputerze?* Zamiast czyszczenia stanowiska wystarczy `./lab down` (bazy zatrzymane, dane zostają na kolejne zajęcia) albo `./lab clean` (usuwa kontenery i dane laboratoriów; obrazy zostają). Na Windows bez Git Bash: `docker compose down` w katalogu laboratorium.

