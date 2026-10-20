# Bazy danych (SQL) — laboratoria w Dockerze

Sześć instrukcji laboratoryjnych (plus jedna dodatkowa) z baz danych. Bazy działają w kontenerach Docker na trzech silnikach:
**PostgreSQL**, **MySQL** i **Oracle**. Każde laboratorium od trzeciego ma przypisany jeden silnik i gotową bazę, która ładuje się sama.

## Szybki start (komputer w sali)

1. **Pobierz najnowsze materiały.** Polecenia usuwają starą kopię (jeśli została po poprzednich zajęciach) i pobierają aktualną do katalogu domowego:

```
rm -rf ~/bazy-danych-student
git clone https://github.com/mhubacz/bazy-danych-student.git ~/bazy-danych-student
cd ~/bazy-danych-student
```

2. **Wyczyść stanowisko** (najlepiej przy zamkniętej przeglądarce) i potwierdź, wpisując `TAK`:

```
./lab clean
```

3. **Otwórz instrukcje** i wykonuj tę, którą wskaże prowadzący — każda instrukcja sama mówi, jak uruchomić potrzebną bazę:

```
./lab site
```

Pod zadaniami wpisujesz swoje rozwiązania, a na końcu generujesz sprawozdanie w PDF.

*Własny komputer:* najpierw zainstaluj Docker i DBeaver ([docs/INSTALACJA.md](docs/INSTALACJA.md)), a zamiast `./lab clean` używaj `./lab clean --dom`.
W Windows PowerShell pobranie materiałów i otwarcie instrukcji wygląda tak:

```
Remove-Item -Recurse -Force "$HOME\bazy-danych-student" -ErrorAction SilentlyContinue
git clone https://github.com/mhubacz/bazy-danych-student.git "$HOME\bazy-danych-student"
cd "$HOME\bazy-danych-student"
start docs\index.html
```

## Koniec zajęć

1. **Wyślij sprawozdanie:** wygeneruj sprawozdanie (PDF) i prześlij je na [sprawozdania.kia.prz.edu.pl](https://sprawozdania.kia.prz.edu.pl) — przed czyszczeniem, bo odpowiedzi są zapisane tylko w przeglądarce.
2. **Zamknij przeglądarkę i wyczyść stanowisko:** `./lab clean` (potwierdź, wpisując `TAK`) — usuwa kontenery, dane baz,
   połączenia DBeavera, dane przeglądarki, historię i Pobrane. Kolejna osoba zaczyna od czystego komputera.

*Pracujesz na własnym komputerze?* Zamiast kroku 2 wystarczy `./lab down` (dane zostają) albo `./lab clean --dom` (usuwa tylko kontenery i dane laboratoriów). Obrazy baz zostają.

## Laboratoria

| Nr | Silnik | Baza | Temat | Katalog |
|---|---|---|---|---|
| 1/6 | wszystkie | — | Uruchamianie bazy w kontenerze | `labs/01-docker-podstawy` |
| 2/6 | wszystkie | — | Docker Compose, wolumeny, różnice dialektów | `labs/02-docker-compose` |
| 3/6 | PostgreSQL | Katedra | Proste zapytania SELECT | `labs/03-katedra-postgres` |
| 4/6 | MySQL | Fabryka | INSERT, UPDATE, DELETE | `labs/04-fabryka-mysql` |
| 5/6 | Oracle | Firma handlowa | Warunki, daty, pierwsze złączenia | `labs/05-firma-oracle-1` |
| 6/6 | Oracle | Firma handlowa | JOIN, GROUP BY, agregaty | `labs/06-firma-oracle-2` |
| dod. | Oracle | OT | Złączenia wielotabelowe | `labs/07-ot-rozszerzenie` |

## Najczęstsze polecenia

| Polecenie | Co robi |
|---|---|
| `./lab site` | otwiera stronę z instrukcjami w przeglądarce |
| `./lab list` | lista laboratoriów |
| `./lab up N` | uruchamia bazę laboratorium N (zatrzymuje inne) |
| `./lab shell N` | konsola SQL w kontenerze |
| `./lab down` | zatrzymuje wszystko; **dane zostają** |
| `./lab reset N` | wraca do stanu początkowego (**kasuje dane** tego laboratorium) |
| `./lab clean` | komputer w sali (początek i koniec zajęć): usuwa kontenery, dane baz, połączenia DBeavera i dane przeglądarki (materiały i obrazy zostają) |
| `./lab clean --dom` | własny komputer: usuwa tylko kontenery i dane laboratoriów |
| `./lab update` | pobiera nowe materiały |
| `./lab help` | pełna lista |

Dane logowania w całym kursie: użytkownik `student`, hasło `student`. Porty: PostgreSQL 5432, MySQL 3306, Oracle 1521 (Service name `FREEPDB1`).
Naraz działa jedno laboratorium (porty są wspólne).

## Dokumentacja

| Dla kogo | Plik |
|---|---|
| Student | [docs/INSTALACJA.md](docs/INSTALACJA.md), [docs/ROZWIAZYWANIE-PROBLEMOW.md](docs/ROZWIAZYWANIE-PROBLEMOW.md) |
| Wydruki | `docs/instrukcje/*.md` — instrukcje w Markdown |

## Struktura

```
lab, install-linux.sh     pomocnik i instalator dla Linuxa
labs/                     laboratoria: lab.yaml, compose.yaml, init/ (skrypty SQL)
shared/                   wspólne skrypty Oracle i schemat OT
docs/                     strona z instrukcjami (index.html), wydruki i pomoc
```

Schemat bazy OT: © oracletutorial.com, do celów edukacyjnych (zob. `shared/ot/NOTICE.md`).
