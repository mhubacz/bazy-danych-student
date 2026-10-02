# Rozwiązywanie problemów

Najpierw sprawdź stan: `./lab status` (lub `docker ps`) i logi: `./lab logs N` (N = numer laboratorium).
Większość kłopotów to zajęty port, zbyt mało pamięci albo baza, która jeszcze się uruchamia.

## Docker

**`permission denied ... /var/run/docker.sock` (Linux)**
Twój użytkownik nie jest w grupie `docker` albo nie zalogowałeś się ponownie po instalacji.
`sudo usermod -aG docker $USER`, potem wyloguj się i zaloguj (lub `newgrp docker`). Sprawdź: `groups`.

**`Cannot connect to the Docker daemon` (Windows/macOS)**
Docker Desktop nie jest uruchomiony. Uruchom go i poczekaj, aż będzie gotowy. Na Linuxie: `sudo systemctl start docker`.

**`port is already allocated` / `address already in use`**
Port 5432, 3306 lub 1521 jest zajęty. Najczęstsze przyczyny:

- działa inne laboratorium: `./lab down` zatrzymuje wszystkie (lub `docker compose down` w jego katalogu),
- zostały kontenery z instrukcji 1/6: `docker rm -f pg-lab mysql-lab oracle-lab`,
- na komputerze działa lokalnie zainstalowany PostgreSQL/MySQL: zatrzymaj tę usługę. Sprawdź, co zajmuje port: `docker ps` oraz (Linux/macOS) `sudo lsof -i :5432`.

**Brak miejsca na dysku**
`docker system df` pokaże zajęcie. Usuń nieużywane dane: `docker system prune` (usuwa zatrzymane kontenery i nieużywane sieci; **nie** używaj `-a` ani `--volumes`, jeśli chcesz zachować pobrane obrazy i swoje dane).

## Baza nie startuje lub jest pusta

**Oracle długo startuje albo kończy się błędem**
Pierwszy start trwa kilka minut. Obserwuj: `./lab logs 5`. Gotowość oznacza komunikat `DATABASE IS READY TO USE!`.
Jeśli kontener się restartuje lub znika, najczęściej brakuje pamięci: w Docker Desktop zwiększ RAM (*Settings → Resources*) do co najmniej 4 GB.
Komunikaty `ORA-00942` na początku ładowania danych (instrukcje DROP nieistniejących tabel) są normalne.

**Tabele nie istnieją, choć uruchomiłem laboratorium**
Skrypty z `init/` wykonują się **tylko przy pierwszym starcie z pustym wolumenem**. Jeśli wolumen już istniał (np. po przerwanym starcie), zacznij od nowa:
`./lab reset N` albo `docker compose down -v && docker compose up -d`. Uwaga: to kasuje Twoje zmiany w tej bazie.

**Chcę wrócić do stanu początkowego**
`./lab reset N` (z pytaniem o potwierdzenie). Laboratoria 5 i 6 współdzielą bazę — reset jednego resetuje oba.

**Zniekształcone polskie znaki w MySQL**
W DBeaver połączenie powinno używać UTF-8 (to domyślne ustawienie). Przy pracy w konsoli kontenera użyj `./lab shell 4`, która ustawia `utf8mb4`.
Jeśli dane już zostały załadowane błędnie, wykonaj `./lab reset 4`.

## Połączenie w DBeaver

**Oracle: `ORA-12514` / `listener does not currently know of service`**
Łączysz się przez SID zamiast **Service name**. Wybierz *Service name* i wpisz `FREEPDB1`. Jeśli baza jeszcze się uruchamia, odczekaj do komunikatu `DATABASE IS READY TO USE!`.

**Oracle: `ORA-01017 invalid username/password`**
Użytkownik i hasło to `student` / `student` (małymi literami). To samo dotyczy PostgreSQL i MySQL.

**MySQL: `Public Key Retrieval is not allowed`**
*Edit Connection → Driver properties → `allowPublicKeyRetrieval` = `true`*.

**DBeaver nie może pobrać sterownika**
Sieć (np. uczelniana) blokuje pobieranie. Spróbuj z innej sieci (np. hotspot z telefonu).
Ostatecznie możesz wskazać sterownik ręcznie: *Database → Driver Manager → Edit Driver → Libraries*.

## Skrypty i repozytorium

**`./lab: Permission denied`**
`chmod +x lab` (lub uruchamiaj `bash lab up 3`). Po rozpakowaniu ZIP-a na niektórych systemach bit wykonywalności ginie.

**`bad interpreter: /usr/bin/env: 'bash\r'` (Windows)**
Pliki mają zakończenia linii Windows. W repozytorium wymuszono LF (`.gitattributes`), więc pomaga ponowne sklonowanie
(`git config --global core.autocrlf input` przed klonowaniem) albo konwersja: `dos2unix lab`.

**`remote: Repository not found` / `Authentication failed`**
Sprawdź, czy adres repozytorium jest poprawny (bez literówek) i czy jesteś online. Gdy problem nie znika, skontaktuj się z prowadzącym.

**`./lab update` kończy się błędem**
Zmieniłeś pliki w katalogu repozytorium. Zapisz swoje pliki poza nim i wykonaj `./lab update --force` (**odrzuca lokalne zmiany**).

**Linux z SELinux (np. Fedora): `permission denied` przy montowaniu `init/`**
Dopisz `:z` do montowania w `compose.yaml`, np. `./init:/docker-entrypoint-initdb.d:ro,z`.

## Nadal nie działa?

Skopiuj wynik poniższych poleceń i wyślij prowadzącemu razem z opisem, co robiłeś:

```
docker version
docker compose version
./lab status
./lab logs N        # N = numer laboratorium; przerwij Ctrl+C
```
