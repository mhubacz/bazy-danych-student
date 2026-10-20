# Laboratorium 2/6 — Wiele silników i Docker Compose

**Silnik:** wszystkie silniki

**Cel:** Uruchomić trzy silniki jednym poleceniem, poznać wolumeny i porównać różnice w składni SQL.

**Połączenie:** host: localhost · użytkownik: student · hasło: student · baza: student · porty: PostgreSQL 5432, MySQL 3306, Oracle 1521 (Service name: FREEPDB1) · Adminer: http://localhost:8080

## Czynności wstępne

1. Zakończ instrukcję 1/6 (usuń jej kontenery: `docker rm -f pg-lab mysql-lab oracle-lab`).
2. Przejdź do katalogu laboratorium: `cd labs/02-docker-compose`.

## Przygotowanie bazy

Przeczytaj plik `compose.yaml` z tego katalogu. Opisuje on cztery usługi — trzy bazy i klienta Adminer:

Plik `labs/02-docker-compose/compose.yaml`:

```yaml
# Laboratorium 2/6 — trzy silniki naraz + Adminer (klient w przeglądarce).
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

Uruchom cały zestaw i sprawdź stan (opcja `--wait` czeka, aż bazy będą gotowe):

```bash
docker compose up -d --wait
docker compose ps
```

## Zadania

1. Wskaż w pliku `compose.yaml`, gdzie podano obrazy, porty, zmienne środowiskowe i wolumeny.
2. Otwórz `http://localhost:8080` (Adminer) i połącz się z PostgreSQL (serwer `postgres`) oraz MySQL (serwer `mysql`). Użytkownik i hasło: `student`. Do Oracle użyj DBeaver.
3. W każdym z trzech silników utwórz tę samą tabelę z kluczem automatycznym i porównaj składnię (`IDENTITY` / `SERIAL` / `AUTO_INCREMENT`).
4. Wykonaj w każdym silniku zapytanie łączące imię i nazwisko w jedną kolumnę i filtrujące po dacie. Zapisz, gdzie składnia się różni (`||` vs `CONCAT`, zapis daty).
5. Zatrzymaj zestaw poleceniem `docker compose down`, uruchom go ponownie (`docker compose up -d --wait`) i sprawdź, czy Twoje tabele nadal istnieją. Dlaczego dane przetrwały?
6. Usuń zestaw razem z danymi: `docker compose down -v`. Co się stało z tabelami po ponownym uruchomieniu?

## Uwagi

Jeśli `up` zgłasza zajęty port 5432/3306/1521, zatrzymaj lub usuń kontenery, które go zajmują (`docker ps`, `docker stop nazwa` lub `docker rm -f nazwa`). Oracle przy pierwszym starcie potrzebuje kilku minut — `--wait` poczeka na niego. Pamiętaj, że każde z laboratoriów 3–7 używa tych samych portów, więc przed ich uruchomieniem wykonaj `docker compose down`.


## Koniec zajęć — zanim odejdziesz od komputera

1. **Najpierw sprawozdanie.** Wygeneruj sprawozdanie (PDF) i zapisz je poza komputerem w sali (e-mail, pendrive, chmura). Odpowiedzi są zapisane tylko w tej przeglądarce — czyszczenie je usunie. Kopię możesz też zachować przyciskiem „Zapisz odpowiedzi (JSON)”.
2. **Komputer w sali (współdzielony):** w katalogu z materiałami wykonaj `./lab clean --stanowisko` i wpisz `TAK`. Usuwa kontenery i dane baz, połączenia DBeavera, dane przeglądarki (także Twoje zalogowania), historię, Pobrane oraz same materiały — kolejna osoba zaczyna od czystego stanowiska.
3. **Własny komputer:** wystarczy `./lab down` (bazy zatrzymane, dane zostają na kolejne zajęcia) albo `./lab clean`, jeśli chcesz usunąć kontenery i dane laboratoriów. Obrazy baz zostają w obu przypadkach.
4. Na Windows bez Git Bash: `docker compose down` w katalogu laboratorium (lub `docker rm -f pg-lab mysql-lab oracle-lab` po instrukcji 1).

