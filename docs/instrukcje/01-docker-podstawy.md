# Laboratorium 1/6 — Uruchamianie bazy danych w kontenerze Docker

**Silnik:** wszystkie silniki

**Cel:** Uruchomić własny serwer bazy w kontenerze i połączyć się z nim klientem graficznym. Ten sam schemat działania dla trzech silników.

**Połączenie:** host: localhost · użytkownik: student · hasło: student · porty: PostgreSQL 5432, MySQL 3306, Oracle 1521

## Czynności wstępne

1. Zainstaluj Docker (Windows/macOS: Docker Desktop, Linux: Docker Engine) — patrz `docs/INSTALACJA.md`.
2. Sprawdź instalację: `docker --version` oraz `docker compose version`.
3. Zainstaluj klienta DBeaver Community.

## Przygotowanie bazy

Pobierz obrazy trzech silników (obraz Oracle ma ponad 1 GB — pobieranie chwilę trwa):

```bash
docker pull postgres:17
docker pull mysql:8.4
docker pull gvenzl/oracle-free:23
```

Jeśli wykonujesz tę instrukcję kolejny raz, usuń kontenery z poprzedniego podejścia (przy pierwszym podejściu komunikat `No such container` jest normalny):

```bash
docker rm -f pg-lab mysql-lab oracle-lab
```

> Chcesz wrócić do kontenerów z poprzedniego podejścia razem z ich danymi? Zamiast usuwać je i tworzyć od nowa, uruchom je ponownie: `docker start pg-lab mysql-lab oracle-lab`. Polecenie `docker ps` pokazuje tylko działające kontenery — zatrzymane zobaczysz w `docker ps -a`.

Uruchom każdy silnik jednym poleceniem. We wszystkich trzech użytkownik i hasło to `student`:

```bash
docker run --name pg-lab -e POSTGRES_USER=student -e POSTGRES_PASSWORD=student -e POSTGRES_DB=student -p 5432:5432 -d postgres:17
docker run --name mysql-lab -e MYSQL_ROOT_PASSWORD=student -e MYSQL_USER=student -e MYSQL_PASSWORD=student -e MYSQL_DATABASE=student -p 3306:3306 -d mysql:8.4
docker run --name oracle-lab -e ORACLE_PASSWORD=student -e APP_USER=student -e APP_USER_PASSWORD=student -p 1521:1521 -d gvenzl/oracle-free:23
```

> Oracle przy pierwszym starcie potrzebuje kilku minut. Gotowość widać w logach (`docker logs -f oracle-lab`) po komunikacie `DATABASE IS READY TO USE!`.

## Zadania

1. Sprawdź działające kontenery: `docker ps`.
2. Połącz się w DBeaver z PostgreSQL (host `localhost`, port `5432`, baza `student`, użytkownik `student`, hasło `student`).
3. Utwórz tabelę `pracownik` (id, nazwisko, etat, placa) i dodaj kilka wierszy (np. poleceniem `INSERT`).

   **Podpowiedź:**

   **Sposób 1 — graficznie.** W DBeaver w drzewie po lewej rozwiń połączenie: `student` → `Schemas` → `public`, kliknij prawym przyciskiem `Tables` → *Create New Table*. Wpisz nazwę tabeli, w zakładce *Columns* dodaj kolumny (prawy przycisk → *Create New Column*) i zapisz (**Ctrl+S**). Przed zapisem DBeaver pokaże polecenie SQL, które wykona za Ciebie — przeczytaj je, przyda się w zadaniu 5. Wiersze dodasz w zakładce *Data* (przycisk dodawania wiersza, potem **Ctrl+S**).

   **Sposób 2 — poleceniem SQL.** Otwórz edytor SQL (prawy przycisk na połączeniu → *SQL Editor* → *Open SQL script*, skrót **Ctrl+]**). Wzór dla PostgreSQL — dopisz własne wiersze; **Ctrl+Enter** wykonuje polecenie pod kursorem, **Alt+X** cały skrypt:

   ```sql
   CREATE TABLE pracownik (
       id        integer PRIMARY KEY,
       nazwisko  varchar(30) NOT NULL,
       etat      varchar(20),
       placa     numeric(8,2)
   );
   
   INSERT INTO pracownik (id, nazwisko, etat, placa)
   VALUES (1, 'Kowalski', 'ASYSTENT', 4500);
   ```

   `PRIMARY KEY` oznacza, że `id` musi być unikalny — drugi wiersz z tym samym `id` zakończy się błędem. `numeric(8,2)` to liczba z dwoma miejscami po przecinku (np. płaca).

4. Wyświetl dane: `SELECT * FROM pracownik;`

   **Podpowiedź:**

   Wpisz zapytanie w edytorze SQL i naciśnij **Ctrl+Enter** — wynik pojawi się w panelu pod edytorem. Ten sam widok otrzymasz graficznie: dwuklik na tabeli w drzewie → zakładka *Data*. Jeśli nowej tabeli nie widać w drzewie, odśwież je (**F5**).

5. Połącz się z MySQL (port `3306`, baza `student`) oraz z Oracle (port `1521`, połączenie przez **Service name** `FREEPDB1`, użytkownik `student`). Powtórz dwa poprzednie kroki i zanotuj różnice w składni.

   **Podpowiedź:**

   Nowe połączenia tworzysz tak samo jak dla PostgreSQL (*Database* → *New Database Connection*). Polecenia z zadania 3 trzeba lekko dostosować — silniki różnią się nazwami typów:

   |  | PostgreSQL | MySQL | Oracle |
   |---|---|---|---|
   | liczba całkowita | `integer` | `INT` | `NUMBER(10)` |
   | tekst | `varchar(30)` | `VARCHAR(30)` | `VARCHAR2(30)` |
   | kwota | `numeric(8,2)` | `DECIMAL(8,2)` | `NUMBER(8,2)` |
   | tabele w drzewie DBeaver | `student` → `Schemas` → `public` → `Tables` | `student` → `Tables` | `Schemas` → `STUDENT` → `Tables` |

   Najprościej porównać składnię, tworząc tabelę graficznie w każdym silniku i czytając polecenie SQL, które DBeaver pokazuje przed zapisem. W Oracle nazwy zapisane bez cudzysłowów trafiają do bazy wielkimi literami (`PRACOWNIK`). Jeśli MySQL zgłosi „Public Key Retrieval is not allowed”, zajrzyj do `docs/ROZWIAZYWANIE-PROBLEMOW.md`.

6. Zatrzymaj i uruchom ponownie kontener: `docker stop pg-lab`, potem `docker start pg-lab`. Sprawdź, czy dane zostały zachowane.
7. Usuń kontenery: `docker rm -f pg-lab mysql-lab oracle-lab`. Uruchom `pg-lab` od nowa tym samym poleceniem i sprawdź, co stało się z danymi.
8. Dla chętnych: wejdź do kontenera i wykonaj zapytanie z wiersza poleceń — `docker exec -it pg-lab psql -U student`.

## Uwagi

Ta instrukcja nie używa jeszcze wolumenów, dlatego po `docker rm` dane znikają. Trwałe przechowywanie danych poznasz w instrukcji 2/6. Przed następnymi laboratoriami usuń kontenery z tej instrukcji (polecenie z zadania 7) — porty muszą być wolne.

