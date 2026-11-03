# Laboratorium 3/6 — Zapytania proste — baza „Katedra”

**System bazodanowy:** PostgreSQL · **Baza:** Katedra

**Cel:** Proste zapytania SELECT: warunki, sortowanie, obliczenia i filtrowanie tekstu.

**Połączenie:** host: localhost · port: 5432 · baza: katedra · użytkownik: student · hasło: student

## Czynności wstępne

1. Bazy z poprzednich zajęć są wyłączone — wszystkie laboratoria używają tych samych portów (5432, 3306, 1521). Wyłączysz je poleceniem `~/bazy-danych-student/lab down`. Jeśli `docker compose up` mimo to zgłosi zajęty port, sprawdź `docker ps` i zatrzymaj kontener, który go zajmuje (`docker stop nazwa`).
2. Przejdź do katalogu laboratorium: `cd ~/bazy-danych-student/labs/03-katedra-postgres`.

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


## Koniec zajęć

1. **Wyślij sprawozdanie.** Wygeneruj sprawozdanie (PDF) i prześlij je na [sprawozdania.kia.prz.edu.pl](https://sprawozdania.kia.prz.edu.pl). Odpowiedzi są zapisane tylko w tej przeglądarce.
2. **Wyłącz maszynę wirtualną.** Na kolejnych zajęciach zostanie przywrócona migawka `Czysta` — sprzątać nie trzeba, ale nic niewysłanego nie przetrwa.
3. *Pracujesz na własnym komputerze?* `./lab down` zatrzymuje bazy (dane zostają na kolejne zajęcia), a `./lab clean` usuwa kontenery i dane laboratoriów (obrazy zostają). Na Windows bez Git Bash: `docker compose down` w katalogu laboratorium.

