# Bazy danych (SQL) — laboratoria w Dockerze

Sześć instrukcji laboratoryjnych (plus jedna dodatkowa) z baz danych. Bazy działają w kontenerach Docker na trzech silnikach:
**PostgreSQL**, **MySQL** i **Oracle**. Każde laboratorium od trzeciego ma przypisany jeden silnik i gotową bazę, która ładuje się sama.

## Szybki start

1. **Zainstaluj** Docker i DBeaver (Windows, macOS, Linux) — zob. [docs/INSTALACJA.md](docs/INSTALACJA.md).
2. **Pobierz materiały:**

```
git clone https://github.com/mhubacz/bazy-danych-student.git
cd bazy-danych-student
```

Możesz też użyć paczki ZIP z e-learningu.

3. **Otwórz instrukcje** — strona ze wszystkimi laboratoriami otworzy się w przeglądarce:

```
./lab site
```

   Pod każdym zadaniem wpisujesz swoje polecenie SQL, a na końcu generujesz sprawozdanie w PDF.
   Na Windows w PowerShell: `start docs\index.html` (albo otwórz plik `docs/index.html` dwuklikiem).

4. **Uruchom bazę laboratorium** (np. trzeciego) i połącz się w DBeaver:

```
./lab up 3
```

Na Windows w PowerShell zamiast `./lab up` użyj poleceń `docker compose` z instrukcji (lub *Git Bash*).

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
| `./lab clean` | usuwa kontenery i dane wszystkich laboratoriów — porządki na koniec zajęć (obrazy zostają) |
| `./lab clean --stanowisko` | komputer współdzielony w sali: dodatkowo usuwa materiały, połączenia DBeavera i dane przeglądarki |
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
