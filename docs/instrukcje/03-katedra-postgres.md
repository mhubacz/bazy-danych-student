# Laboratorium 3/6 — Zapytania proste — baza „Katedra”

**Silnik:** PostgreSQL · **Baza:** Katedra

**Cel:** Proste zapytania SELECT: warunki, sortowanie, obliczenia i filtrowanie tekstu.

**Połączenie:** host: localhost · port: 5432 · baza: katedra · użytkownik: student · hasło: student

## Czynności wstępne

1. Docker działa, a bazy z poprzednich instrukcji są zatrzymane (`docker ps` nie pokazuje kontenerów z portem 5432).
2. Przejdź do katalogu laboratorium: `cd labs/03-katedra-postgres`.

## Przygotowanie bazy

Uruchom bazę. Dane (tabele `zespol`, `etat`, `pracownik`) wczytują się same ze skryptu `init/01_katedra.sql`:

```bash
docker compose up -d --wait
```

> Połącz się w DBeaver (dane powyżej). Reset bazy do stanu początkowego: `docker compose down -v`, a potem ponownie `docker compose up -d --wait`. Po zakończeniu pracy: `docker compose down` (dane zostają).

## Zadania

1. Przypuśćmy, że adiunktom zabiera się 20% pensji na podatek dochodowy. Zaproponuj obliczenie takiego podatku w oparciu o tabelę `pracownik`.
2. Wyświetl nazwisko, etat oraz płacę podstawową pracowników zespołów 10 i 20 zgodnie z alfabetycznym porządkiem nazwisk.
3. Wyświetl nazwiska i etaty wszystkich asystentów zespołu 20.
4. Wyświetl nazwiska i pensje oraz identyfikatory zespołów pracowników, których miesięczna pensja przekracza 2000.
5. Oblicz całkowite dochody roczne wszystkich profesorów.
6. Wybierz wszystkich pracowników, których płaca podstawowa jest mniejsza od dwukrotności płacy dodatkowej.
7. Wyznacz wszystkich adiunktów i profesorów, których płaca podstawowa jest wyższa od 1750.
8. Sporządź listę wszystkich asystentów uporządkowaną według daty zatrudnienia.
9. Wyświetl nazwiska pracowników zaczynające się na literę „M”.

## Uwagi

W zadaniu 9 `LIKE 'M%'` w PostgreSQL rozróżnia wielkość liter — użyj `ILIKE`, jeśli chcesz ją pominąć. W zadaniu 6 żaden pracownik nie spełnia warunku, więc pusty wynik jest poprawny; zwróć uwagę, jak SQL traktuje wartości NULL w kolumnie `placa_dod`.


## Koniec zajęć — zanim odejdziesz od komputera

1. **Najpierw sprawozdanie.** Wygeneruj sprawozdanie (PDF) i zapisz je poza komputerem w sali (e-mail, pendrive, chmura). Odpowiedzi są zapisane tylko w tej przeglądarce — czyszczenie je usunie. Kopię możesz też zachować przyciskiem „Zapisz odpowiedzi (JSON)”.
2. **Komputer w sali (współdzielony):** w katalogu z materiałami wykonaj `./lab clean --stanowisko` i wpisz `TAK`. Usuwa kontenery i dane baz, połączenia DBeavera, dane przeglądarki (także Twoje zalogowania), historię, Pobrane oraz same materiały — kolejna osoba zaczyna od czystego stanowiska.
3. **Własny komputer:** wystarczy `./lab down` (bazy zatrzymane, dane zostają na kolejne zajęcia) albo `./lab clean`, jeśli chcesz usunąć kontenery i dane laboratoriów. Obrazy baz zostają w obu przypadkach.
4. Na Windows bez Git Bash: `docker compose down` w katalogu laboratorium (lub `docker rm -f pg-lab mysql-lab oracle-lab` po instrukcji 1).

