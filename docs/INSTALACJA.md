# Instalacja środowiska

Potrzebujesz trzech rzeczy: **Dockera** (uruchamia bazy), **DBeavera** (klient do pisania zapytań) i **materiałów** z repozytorium.
Instrukcja dla własnego komputera (Windows, macOS, Linux).

Wymagania: ok. 20 GB wolnego miejsca (obrazy baz zajmują kilka GB) i co najmniej 8 GB pamięci RAM.
Najbardziej wymagająca jest baza Oracle — Docker musi mieć do dyspozycji co najmniej 4 GB RAM (macOS: *Settings → Resources*; Windows z WSL 2: limit ustala WSL, domyślnie połowa pamięci komputera).

## Windows

1. **Docker Desktop:** https://docs.docker.com/desktop/ (instalator włączy WSL 2, jeśli trzeba — po instalacji zrestartuj komputer).
   Uruchom Docker Desktop i poczekaj, aż ikona wskaże, że działa.
2. **DBeaver Community:** https://dbeaver.io/download/
3. **Git:** https://git-scm.com/downloads (razem z nim dostajesz *Git Bash*).
4. **Materiały** (w *Git Bash* lub PowerShell):

```
git clone https://github.com/mhubacz/bazy-danych-student.git
cd bazy-danych-student
```

Jeśli prowadzący udostępnił paczkę ZIP — rozpakuj ją i wejdź do katalogu.

5. **Instrukcje:** otwórz stronę z instrukcjami w przeglądarce (PowerShell, w katalogu repozytorium):

```
start docs\index.html
```

6. **Test:** w PowerShell, w katalogu repozytorium:

```
cd labs\03-katedra-postgres
docker compose up -d --wait
```

Skrypt `./lab` działa w *Git Bash* lub WSL. W PowerShell używaj bezpośrednio poleceń `docker compose` z instrukcji.

## macOS

1. **Docker Desktop:** https://docs.docker.com/desktop/ (wybierz wersję dla swojego procesora: Apple Silicon lub Intel).
2. **DBeaver Community:** https://dbeaver.io/download/
3. **Git** jest w narzędziach Xcode (`git --version` w Terminalu zaproponuje instalację) lub ze strony https://git-scm.com/downloads
4. **Materiały** (Terminal):

```
git clone https://github.com/mhubacz/bazy-danych-student.git
cd bazy-danych-student
./lab site      # instrukcje w przeglądarce
./lab up 3
```

Obraz Oracle Free ma wersję dla procesorów ARM (komputery Apple Silicon); przy pierwszym uruchomieniu może być wolniejszy niż na Intelu.

## Linux (Ubuntu / Debian)

Jedno polecenie instaluje Dockera, DBeavera i pobiera materiały:

```
sudo apt install -y git
git clone https://github.com/mhubacz/bazy-danych-student.git
cd bazy-danych-student
bash install-linux.sh
```

Po instalacji **wyloguj się i zaloguj ponownie** (albo wpisz `newgrp docker`), żeby zadziałała grupa `docker`. Potem:

```
./lab site      # instrukcje w przeglądarce
./lab list
./lab up 3
```

Opcje instalatora: `bash install-linux.sh --help`. Na innych dystrybucjach skrypt zainstaluje Dockera, ale DBeavera zainstaluj ze strony https://dbeaver.io/download/.
Gdy `./lab` zgłasza „Permission denied”: `chmod +x lab` albo `bash lab up 3`.

## Pierwsze połączenie w DBeaver

*Baza danych → Nowe połączenie*, wybierz silnik i wpisz dane z karty „Połączenie” w instrukcji danego laboratorium:

| Silnik | Host | Port | Baza | Użytkownik / hasło |
|---|---|---|---|---|
| PostgreSQL (lab 3) | `localhost` | 5432 | `katedra` | `student` / `student` |
| MySQL (lab 4) | `localhost` | 3306 | `fabryka` | `student` / `student` |
| Oracle (lab 5, 6, dod.) | `localhost` | 1521 | **Service name:** `FREEPDB1` | `student` / `student` |

Uwagi:

- Przy pierwszym połączeniu DBeaver zaproponuje pobranie sterownika — zgódź się (**Download**).
- W Oracle wybierz łączenie przez **Service name**, nie przez SID.
- Jeśli MySQL zgłosi „Public Key Retrieval is not allowed”: *Edit Connection → Driver properties → `allowPublicKeyRetrieval` = `true`*.

## Pierwszy test

```
./lab site                # otwórz instrukcje w przeglądarce
./lab up 3                # uruchom bazę Katedra
./lab shell 3             # (opcjonalnie) konsola SQL w kontenerze; wyjście: \q
./lab down                # zatrzymaj; dane zostają
```

Coś nie działa? Zajrzyj do `docs/ROZWIAZYWANIE-PROBLEMOW.md`.
