# Laboratorium 1/6 — Uruchamianie bazy danych w kontenerze Docker

**Silnik:** wszystkie silniki

**Cel:** Uruchomić własny serwer bazy w kontenerze i połączyć się z nim klientem graficznym. Ten sam schemat działania dla trzech silników.

**Połączenie:** host: localhost · użytkownik: student · hasło: student · porty: PostgreSQL 5432, MySQL 3306, Oracle 1521

## Czynności wstępne

1. Zainstaluj Docker (Windows/macOS: Docker Desktop, Linux: Docker Engine) — patrz `docs/INSTALACJA.md`.
2. Sprawdź instalację: `docker --version` oraz `docker compose version`.
3. Zainstaluj klienta DBeaver Community.

## Przygotowanie bazy

**Docker w pigułce.** Docker uruchamia programy w **kontenerach** — odizolowanych „pudełkach”, w których program ma wszystko, czego potrzebuje do działania. Dzięki temu serwer bazy danych uruchomisz jednym poleceniem, bez instalowania go w systemie, a po zajęciach usuniesz go bez śladu. Najważniejsze pojęcia:

| Pojęcie | Co to jest | Przykład |
|---|---|---|
| **obraz** (image) | gotowy szablon programu: pliki i ustawienia; pobierasz go raz | `postgres:17` (nazwa:wersja) |
| **kontener** (container) | uruchomiona kopia obrazu; z jednego obrazu można uruchomić wiele kontenerów | `pg-lab` |
| **rejestr** (registry) | serwer, z którego pobiera się obrazy (domyślnie Docker Hub) | `docker pull mysql:8.4` |
| **port** (`-p`) | „drzwi” z Twojego komputera do programu w kontenerze, zapis `port_komputera:port_kontenera` | `-p 5432:5432` — DBeaver łączy się z `localhost:5432` |
| **zmienna środowiskowa** (`-e`) | ustawienie przekazywane do kontenera przy starcie | `-e POSTGRES_PASSWORD=student` |
| **wolumen** (volume) | trwałe miejsce na dane, niezależne od kontenera — temat instrukcji 2/6 | `pg-data` |

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

> Budowa polecenia: `docker run` — utwórz i uruchom kontener · `--name pg-lab` — nazwa kontenera · `-e ZMIENNA=wartość` — ustawienia (użytkownik, hasło, nazwa bazy) · `-p 5432:5432` — udostępnienie portu · `-d` — praca w tle · na końcu nazwa obrazu.

> Oracle przy pierwszym starcie potrzebuje kilku minut — w tym czasie wykonaj zadania 1–6 z obrazem `hello-world`. Gotowość widać w logach (`docker logs -f oracle-lab`) po komunikacie `DATABASE IS READY TO USE!`.

## Zadania

1. Uruchom najprostszy kontener: `docker run hello-world`. Przeczytaj komunikat i opisz własnymi słowami kroki, które wykonał Docker.

   **Podpowiedź:**

   Komunikat sam wymienia kroki (lista 1–4). Jeśli obrazu nie było na komputerze, na początku zobaczysz też `Unable to find image 'hello-world:latest' locally` i pobieranie. Brak znacznika wersji oznacza `:latest`.

2. Wyświetl pobrane obrazy (`docker images`) oraz kontenery: `docker ps` i `docker ps -a`. Dlaczego kontenera z zadania 1 nie widać w `docker ps`?

   **Podpowiedź:**

   `docker ps` pokazuje tylko **działające** kontenery, `docker ps -a` — wszystkie. Zwróć uwagę na kolumnę `STATUS` (np. `Exited (0)`) i na nazwę nadaną automatycznie w kolumnie `NAMES`.

3. Uruchom `docker run hello-world` jeszcze dwa razy i ponownie wykonaj `docker ps -a`. Ile jest teraz kontenerów? Czy obraz był pobierany ponownie? Następnie uruchom `docker run --rm hello-world` i sprawdź, czy przybył kolejny kontener.

   **Podpowiedź:**

   Każde `docker run` tworzy **nowy** kontener z tego samego obrazu. Obraz pobierany jest tylko raz. Opcja `--rm` usuwa kontener automatycznie po zakończeniu działania.

4. Utwórz kontener z własną nazwą: `docker run --name moj-hello hello-world`. Wykonaj to samo polecenie drugi raz — jaki błąd się pojawił i dlaczego? Uruchom istniejący kontener ponownie: `docker start -a moj-hello`.

   **Podpowiedź:**

   Nazwa kontenera musi być unikalna, więc drugie `docker run --name moj-hello` kończy się błędem `Conflict… already in use`. `docker start` uruchamia **istniejący** kontener zamiast tworzyć nowy; `-a` wyświetla jego wynik w terminalu.

5. Sprawdź, co wypisał kontener i jak zakończył działanie: `docker logs moj-hello` oraz `docker inspect -f '{{.State.ExitCode}}' moj-hello`. Co oznacza kod wyjścia 0?

   **Podpowiedź:**

   `docker logs` pokazuje wszystko, co program wypisał (także z wcześniejszych uruchomień). `docker inspect` zwraca pełny opis kontenera; `-f` wybiera jedno pole. Kod 0 oznacza poprawne zakończenie programu.

6. Posprzątaj: usuń kontener `docker rm moj-hello`, a potem wszystkie zatrzymane kontenery `docker container prune` (potwierdź literą `y`). Na koniec spróbuj usunąć obraz `docker rmi hello-world` — kiedy się to udaje, a kiedy nie?

   **Podpowiedź:**

   Obrazu nie da się usunąć, dopóki istnieje kontener (także zatrzymany), który z niego powstał — stąd kolejność: najpierw kontenery, potem obraz. Usunięcie obrazu nie szkodzi: przy kolejnym `docker run hello-world` zostanie pobrany ponownie.

7. Sprawdź, czy kontenery baz danych działają: `docker ps` (kolumny `STATUS` i `PORTS`).
8. Połącz się w DBeaver z PostgreSQL (host `localhost`, port `5432`, baza `student`, użytkownik `student`, hasło `student`).

   **Podpowiedź:**

   W DBeaver: *Database* → *New Database Connection* → **PostgreSQL** → *Next*. Wpisz host, port, bazę, użytkownika i hasło, kliknij *Test Connection* (za pierwszym razem DBeaver zaproponuje pobranie sterownika — zgódź się), potem *Finish*.

9. Utwórz tabelę `student` (numer indeksu, imię, nazwisko, e-mail, skrót kierunku studiów) i dodaj do niej swoje dane poleceniem `INSERT`.

   **Podpowiedź:**

   Otwórz edytor SQL (prawy przycisk na połączeniu → *SQL Editor* → *Open SQL script*, skrót **Ctrl+]**). Wzór dla PostgreSQL — wpisz swoje dane zamiast przykładowych; **Ctrl+Enter** wykonuje polecenie pod kursorem, **Alt+X** cały skrypt:

   ```sql
   CREATE TABLE student (
       nr_indeksu  integer PRIMARY KEY,
       imie        varchar(30) NOT NULL,
       nazwisko    varchar(40) NOT NULL,
       email       varchar(60),
       kierunek    varchar(10)
   );
   
   -- zamień przykładowe wartości na swoje dane
   INSERT INTO student (nr_indeksu, imie, nazwisko, email, kierunek)
   VALUES (123456, 'Jan', 'Kowalski', 'jan.kowalski@example.com', 'INF');
   ```

   `PRIMARY KEY` oznacza, że numer indeksu musi być unikalny — próba dodania drugiego wiersza z tym samym numerem zakończy się błędem. `NOT NULL` wymusza podanie wartości. Teksty w SQL zapisujesz w apostrofach: `'Jan'`.

10. Wyświetl dane: `SELECT * FROM student;`

   **Podpowiedź:**

   Wpisz zapytanie w edytorze SQL i naciśnij **Ctrl+Enter** — wynik pojawi się w panelu pod edytorem. Ten sam widok otrzymasz graficznie: dwuklik na tabeli w drzewie → zakładka *Data*. Jeśli nowej tabeli nie widać w drzewie, odśwież je (**F5**).

11. Połącz się z MySQL (port `3306`, baza `student`) oraz z Oracle (port `1521`, połączenie przez **Service name** `FREEPDB1`, użytkownik `student`). Powtórz dwa poprzednie kroki i zanotuj różnice w składni.

   **Podpowiedź:**

   Nowe połączenia tworzysz tak samo jak dla PostgreSQL (*Database* → *New Database Connection*). Polecenia z zadania 9 trzeba lekko dostosować — silniki różnią się nazwami typów:

   |  | PostgreSQL | MySQL | Oracle |
   |---|---|---|---|
   | liczba całkowita (nr indeksu) | `integer` | `INT` | `NUMBER(10)` |
   | tekst (imię, e-mail, kierunek) | `varchar(30)` | `VARCHAR(30)` | `VARCHAR2(30)` |

   Po utworzeniu tabeli możesz podejrzeć, jak dany silnik zapisał jej definicję: prawy przycisk na tabeli w drzewie (odśwież je klawiszem **F5**) → *Generate SQL* → *DDL*. Porównaj te definicje między silnikami. W Oracle nazwy zapisane bez cudzysłowów trafiają do bazy wielkimi literami (`STUDENT`).

   **MySQL — błąd „Public Key Retrieval is not allowed”.** To typowe przy pierwszym połączeniu z MySQL 8. W oknie połączenia przejdź na zakładkę *Driver properties*, znajdź właściwość `allowPublicKeyRetrieval`, ustaw ją na `true` i połącz się ponownie (dla istniejącego połączenia: prawy przycisk → *Edit Connection* → *Driver properties*).

12. Zatrzymaj i uruchom ponownie kontener: `docker stop pg-lab`, potem `docker start pg-lab`. Sprawdź, czy dane zostały zachowane.
13. Usuń kontenery: `docker rm -f pg-lab mysql-lab oracle-lab`. Uruchom `pg-lab` od nowa tym samym poleceniem i sprawdź, co stało się z danymi.
14. Dla chętnych: wejdź do kontenera i wykonaj zapytanie z wiersza poleceń — `docker exec -it pg-lab psql -U student`.

## Uwagi

Ta instrukcja nie używa jeszcze wolumenów, dlatego po `docker rm` dane znikają. Trwałe przechowywanie danych poznasz w instrukcji 2/6. Przed następnymi laboratoriami usuń kontenery z tej instrukcji (polecenie z zadania 13) — porty muszą być wolne.


## Koniec zajęć — zanim odejdziesz od komputera

1. **Wyślij sprawozdanie.** Wygeneruj sprawozdanie (PDF) i prześlij je na [sprawozdania.kia.prz.edu.pl](https://sprawozdania.kia.prz.edu.pl). Zrób to przed czyszczeniem — odpowiedzi są zapisane tylko w tej przeglądarce.
2. **Wyczyść stanowisko.** W katalogu z materiałami wykonaj `./lab clean` i wpisz `TAK`. Polecenie usuwa kontenery i dane baz, połączenia DBeavera, dane przeglądarki (także Twoje zalogowania), historię, Pobrane oraz same materiały — kolejna osoba zaczyna od czystego komputera.
3. *Pracujesz na własnym komputerze?* Zamiast czyszczenia stanowiska wystarczy `./lab down` (bazy zatrzymane, dane zostają na kolejne zajęcia) albo `./lab clean --dom` (usuwa tylko kontenery i dane laboratoriów; obrazy zostają). Na Windows bez Git Bash: `docker compose down` w katalogu laboratorium.

