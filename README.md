# Bazy danych (SQL) — laboratoria w Dockerze

Sześć instrukcji laboratoryjnych (plus jedna dodatkowa) z baz danych. Bazy działają w kontenerach Docker w trzech systemach bazodanowych:
**PostgreSQL**, **MySQL** i **Oracle**. Każde laboratorium od trzeciego ma przypisany jeden system bazodanowy i gotową bazę, która ładuje się sama.

## Szybki start (komputer w sali)

0. **Przywróć maszynę do stanu początkowego** (przy wyłączonej maszynie): w VirtualBox zaznacz maszynę → *Migawki* →
   zaznacz migawkę `Czysta` → *Przywróć* (na pytanie o zapisanie bieżącego stanu odpowiedz **nie**), potem uruchom maszynę.

1. **Pobierz najnowsze materiały.** Polecenia usuwają starą kopię (jeśli została po poprzednich zajęciach) i pobierają aktualną do katalogu domowego:

```
rm -rf ~/bazy-danych-student
git clone https://github.com/mhubacz/bazy-danych-student.git ~/bazy-danych-student
cd ~/bazy-danych-student
```

2. **Otwórz instrukcje** i wykonuj tę, którą wskaże prowadzący — każda instrukcja sama mówi, jak uruchomić potrzebną bazę:

```
./lab site
```

Pod zadaniami wpisujesz swoje rozwiązania, a na końcu generujesz sprawozdanie w PDF.

*Własny komputer:* najpierw zainstaluj Docker i DBeaver ([docs/INSTALACJA.md](docs/INSTALACJA.md)), a po zajęciach zatrzymaj bazy poleceniem `./lab down` (lub usuń je razem z danymi: `./lab clean`).
W Windows PowerShell pobranie materiałów i otwarcie instrukcji wygląda tak:

```
Remove-Item -Recurse -Force "$HOME\bazy-danych-student" -ErrorAction SilentlyContinue
git clone https://github.com/mhubacz/bazy-danych-student.git "$HOME\bazy-danych-student"
cd "$HOME\bazy-danych-student"
start docs\index.html
```

## Koniec zajęć

1. **Wyślij sprawozdanie:** wygeneruj sprawozdanie (PDF) i prześlij je na [sprawozdania.kia.prz.edu.pl](https://sprawozdania.kia.prz.edu.pl).
2. **Wyłącz maszynę wirtualną.** Kolejna osoba przywróci migawkę `Czysta`, więc nic nie trzeba sprzątać — ale też nic, czego nie wysłałeś, nie przetrwa.

*Własny komputer:* `./lab down` (bazy zatrzymane, dane zostają) albo `./lab clean` (usuwa kontenery i dane laboratoriów; obrazy zostają).

## Laboratoria

| Nr | System | Baza | Temat | Katalog |
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
| `./lab clean` | usuwa kontenery i dane wszystkich laboratoriów (obrazy zostają) |
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
