# Laboratorium 2/6 — Wiele silników i Docker Compose

**Silnik:** wszystkie silniki

**Cel:** Uruchomić trzy silniki jednym poleceniem z pliku Compose, poznać wolumeny (trwałe dane) i porównać składnię SQL w trzech silnikach.

**Połączenie:** host: localhost · użytkownik: student · hasło: student · baza: student · porty: PostgreSQL 5432, MySQL 3306, Oracle 1521 (Service name: FREEPDB1) · Adminer: http://localhost:8080

## Czynności wstępne

1. Porty 5432, 3306 i 1521 są wolne: jeśli w tej sesji zostały kontenery z instrukcji 1, usuń je (`docker rm -f pg-lab mysql-lab oracle-lab` albo `./lab clean`).
2. Przejdź do katalogu laboratorium: `cd ~/bazy-danych-student/labs/02-docker-compose`.

## Przygotowanie bazy

**Docker Compose w pigułce.** W instrukcji 1 każdy kontener uruchamiałeś osobnym, długim poleceniem `docker run`. Compose zapisuje te same ustawienia w pliku `compose.yaml` i uruchamia cały zestaw jednym poleceniem. Najważniejsze pojęcia:

| Pojęcie | Co to jest | W pliku `compose.yaml` |
|---|---|---|
| **usługa** (service) | jeden kontener opisany w pliku; nazwa usługi jest też nazwą hosta w sieci zestawu | `postgres:`, `mysql:`, `oracle:`, `adminer:` |
| **projekt** | cały zestaw usług; jego nazwa jest przedrostkiem nazw kontenerów i wolumenów | `name: lab02-wiele-silnikow` |
| **wolumen nazwany** | trwałe miejsce na dane, które przetrwa usunięcie kontenera | `volumes: ["pg-data:/var/lib/postgresql/data"]` |
| **sieć** | wspólna sieć zestawu: usługi widzą się po nazwach (np. Adminer łączy się z serwerem `postgres`) | tworzona automatycznie |
| **healthcheck** | test gotowości usługi; `--wait` czeka, aż wszystkie będą zdrowe (`healthy`) | `healthcheck:` |

Plik `compose.yaml` z tego katalogu opisuje cztery usługi — trzy bazy i klienta WWW Adminer:

Plik `labs/02-docker-compose/compose.yaml`:

```yaml
# Laboratorium 2/6 — trzy silniki naraz + Adminer (klient w przeglądarce; obsługuje PostgreSQL i MySQL, NIE Oracle).
# Uruchomienie:  docker compose up -d      Zatrzymanie:  docker compose down
# Dane są w wolumenach; kasuje je dopiero:  docker compose down -v
name: lab02-wiele-silnikow

services:
  postgres:
    image: postgres:17
    environment:
      POSTGRES_USER: student
      POSTGRES_PASSWORD: student
      POSTGRES_DB: student
    ports: ["5432:5432"]
    volumes: ["pg-data:/var/lib/postgresql/data"]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -h 127.0.0.1 -U student -d student"]
      interval: 5s
      timeout: 3s
      retries: 20

  mysql:
    image: mysql:8.4
    environment:
      MYSQL_ROOT_PASSWORD: student
      MYSQL_USER: student
      MYSQL_PASSWORD: student
      MYSQL_DATABASE: student
    ports: ["3306:3306"]
    volumes: ["mysql-data:/var/lib/mysql"]
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h 127.0.0.1 -uroot -pstudent --silent"]
      interval: 5s
      timeout: 3s
      retries: 30

  oracle:
    image: gvenzl/oracle-free:23
    environment:
      ORACLE_PASSWORD: student
      APP_USER: student
      APP_USER_PASSWORD: student
    ports: ["1521:1521"]
    volumes: ["oracle-data:/opt/oracle/oradata"]
    healthcheck:
      test: ["CMD", "healthcheck.sh"]
      interval: 10s
      timeout: 5s
      retries: 30
      start_period: 120s

  adminer:
    image: adminer
    ports: ["8080:8080"]
    depends_on: [postgres, mysql]

volumes:
  pg-data:
  mysql-data:
  oracle-data:
```

| Polecenie | Działanie |
|---|---|
| `docker compose up -d` | utwórz i uruchom cały zestaw w tle (`--wait` — poczekaj na gotowość) |
| `docker compose ps` | stan usług zestawu |
| `docker compose logs -f oracle` | logi jednej usługi na żywo (Ctrl+C kończy podgląd) |
| `docker compose down` | zatrzymaj i usuń kontenery — **wolumeny z danymi zostają** |
| `docker compose down -v` | jak wyżej, ale usuwa też wolumeny — **dane znikają** |

> Wszystkie polecenia `docker compose` wykonuj w katalogu z plikiem `compose.yaml`.

## Zadania

1. Uruchom cały zestaw i sprawdź stan usług. Oracle przy pierwszym starcie potrzebuje kilku minut — w tym czasie wykonaj zadanie 2.

   ```bash
   docker compose up -d
   docker compose ps
   ```

   **Podpowiedź:**

   W kolumnie `STATUS` zobaczysz `health: starting`, a po chwili `healthy`. Polecenie `docker compose up -d --wait` czeka, aż wszystkie usługi będą gotowe — przy Oracle to kilka minut. Nazwy kontenerów mają postać `projekt-usługa-1`, np. `lab02-wiele-silnikow-postgres-1`.

2. Wskaż w pliku `compose.yaml`, gdzie podano obrazy, porty, zmienne środowiskowe i wolumeny. Które opcje polecenia `docker run` z instrukcji 1 (zadanie 8) im odpowiadają?

   **Podpowiedź:**

   | `docker run` | `compose.yaml` |
   |---|---|
   | `--name pg-lab` | nazwa usługi (`postgres:`) + nazwa projektu |
   | `-e POSTGRES_USER=student` | `environment:` |
   | `-p 5432:5432` | `ports:` |
   | *brak — dane w kontenerze* | `volumes:` (wolumen nazwany) |
   | `-d` | `docker compose up -d` |
   | `postgres:17` na końcu | `image:` |

3. Otwórz `http://localhost:8080` (Adminer) i zaloguj się do PostgreSQL (System: PostgreSQL, serwer `postgres`) oraz do MySQL (System: MySQL, serwer `mysql`); użytkownik, hasło i baza: `student`. Z Oracle połącz się w SQL Developer — jak w instrukcji 1 (Adminer w tym zestawie nie obsługuje Oracle).

   **Podpowiedź:**

   Adminer działa **w kontenerze** w tej samej sieci co bazy, dlatego jako serwer podajesz **nazwę usługi** (`postgres`, `mysql`), a nie `localhost` — dla Adminera `localhost` to jego własny kontener. Wybranie w Adminerze systemu *Oracle* kończy się błędem `None of the supported PHP extensions (OCI8, PDO_OCI) are available` — obraz `adminer` nie zawiera sterownika Oracle, dlatego do Oracle służy SQL Developer. DBeaver i SQL Developer działają poza Dockerem, więc łączą się z `localhost` i portem udostępnionym przez `ports:`. Połączenia z instrukcji 1 mogły zniknąć (po przywróceniu migawki `Czysta`) — utwórz je ponownie: Oracle `localhost:1521`, **Service name** `FREEPDB1`, `student`/`student`.

4. W każdym z trzech silników utwórz tabelę `osoba` (`id` — klucz główny nadawany automatycznie, `imie`, `nazwisko`, `data_urodzenia`) i dodaj do niej **swoje dane** oraz co najmniej dwie inne osoby, nie podając `id`. Porównaj składnię klucza automatycznego.

   **Podpowiedź:**

   Kolumna `id` ma się wypełniać sama — w `INSERT` wymieniasz tylko pozostałe kolumny. Składnia klucza automatycznego:

   | PostgreSQL | MySQL | Oracle |
   |---|---|---|
   | `id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY` (starszy skrót: `id SERIAL PRIMARY KEY`) | `id INT AUTO_INCREMENT PRIMARY KEY` | `id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY` |

   Typy pozostałych kolumn dobierz jak w instrukcji 1 (`varchar` / `VARCHAR` / `VARCHAR2`), a datę zapisz typem `date` / `DATE`. Datę w `INSERT` najbezpieczniej podać jako `DATE '2001-05-12'` — działa we wszystkich trzech silnikach.

5. W każdym silniku napisz zapytanie, które zwraca imię i nazwisko połączone w jedną kolumnę (ze spacją) dla osób urodzonych po 1 stycznia 2000. Zapisz, gdzie składnia się różni.

   **Podpowiedź:**

   Łączenie tekstu: `||` w PostgreSQL i Oracle, `CONCAT(a, ' ', b)` w MySQL — tam `||` oznacza OR i zwróci 0. Jeśli wynik jest pusty, dodaj w zadaniu 4 osobę urodzoną po 2000 roku. Zestawienie różnic znajdziesz w sekcji „Różnice dialektów” na stronie z instrukcjami.

6. Zatrzymaj zestaw poleceniem `docker compose down`, wyświetl wolumeny (`docker volume ls`), uruchom zestaw ponownie (`docker compose up -d --wait`) i sprawdź, czy tabele `osoba` nadal istnieją. Dlaczego dane przetrwały, choć w instrukcji 1 po `docker rm` znikały?

   **Podpowiedź:**

   `docker compose down` usuwa kontenery, ale nie wolumeny nazwane — na liście zobaczysz np. `lab02-wiele-silnikow_pg-data`. Bazy zapisują dane właśnie w wolumenach, więc nowe kontenery widzą stare dane. W instrukcji 1 kontenery nie miały wolumenów, więc dane były w samym kontenerze.

7. Usuń zestaw razem z danymi: `docker compose down -v`, sprawdź `docker volume ls` i uruchom zestaw ponownie. Co się stało z tabelami? Kiedy w praktyce używa się opcji `-v`?

   **Podpowiedź:**

   `-v` usuwa wolumeny zestawu, więc bazy startują od zera — tak samo działa `./lab reset N` w kolejnych laboratoriach (powrót do stanu początkowego bazy).

8. Dla chętnych: wejdź do konsoli SQL w kontenerze bez instalowania klienta — `docker compose exec postgres psql -U student` (wyjście: `\q`) — i wykonaj `SELECT * FROM osoba;`.

## Uwagi

Przed laboratoriami 3–7 zatrzymaj zestaw (`docker compose down` w tym katalogu albo `./lab down`) — używają tych samych portów 5432, 3306 i 1521. Jeśli `up` zgłasza zajęty port, sprawdź `docker ps` i zatrzymaj kontener, który go zajmuje (`docker stop nazwa`).


## Koniec zajęć

1. **Wyślij sprawozdanie.** Wygeneruj sprawozdanie (PDF) i prześlij je na [sprawozdania.kia.prz.edu.pl](https://sprawozdania.kia.prz.edu.pl). Odpowiedzi są zapisane tylko w tej przeglądarce.
2. **Wyłącz maszynę wirtualną.** Na kolejnych zajęciach zostanie przywrócona migawka `Czysta` — sprzątać nie trzeba, ale nic niewysłanego nie przetrwa.
3. *Pracujesz na własnym komputerze?* `./lab down` zatrzymuje bazy (dane zostają na kolejne zajęcia), a `./lab clean` usuwa kontenery i dane laboratoriów (obrazy zostają). Na Windows bez Git Bash: `docker compose down` w katalogu laboratorium.

