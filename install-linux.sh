#!/usr/bin/env bash
# install-linux.sh — instalacja środowiska laboratoryjnego na Linuxie.
#
# Instaluje: Docker + Docker Compose, git, DBeaver Community; klonuje repozytorium z materiałami
# (jeśli skrypt nie jest już uruchamiany z jego wnętrza); opcjonalnie pobiera obrazy baz.
# Założenia: Ubuntu/Debian (pełna obsługa). Na innych dystrybucjach Docker instaluje
# oficjalny skrypt get.docker.com, a DBeavera trzeba zainstalować ręcznie (https://dbeaver.io/download/).
#
# Użycie:  bash install-linux.sh [opcje]
#   --pull-images     pobierz od razu obrazy baz (kilka GB; przydatne przy budowie obrazu VM)
#   --no-dbeaver      pomiń instalację DBeavera
#   --no-clone        nie klonuj repozytorium
#   --repo URL        adres repozytorium (domyślnie LAB_REPO_URL poniżej)
#   --dir KATALOG     gdzie sklonować repozytorium (domyślnie ~/bazy-danych-student)
#   -h, --help        pomoc
set -euo pipefail

# >>> PROWADZĄCY: ustaw raz adres swojego repozytorium <<<
LAB_REPO_URL="${LAB_REPO_URL:-https://github.com/mhubacz/bazy-danych-student.git}"

PULL_IMAGES=0
WITH_DBEAVER=1
DO_CLONE=1
CLONE_DIR=""

info() { echo "==> $*"; }
warn() { echo "UWAGA: $*" >&2; }
die()  { echo "Błąd: $*" >&2; exit 1; }

usage() { awk 'NR>1 && /^#/ {sub(/^# ?/,""); print; next} NR>1 {exit}' "${BASH_SOURCE[0]}"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --pull-images) PULL_IMAGES=1 ;;
    --no-dbeaver)  WITH_DBEAVER=0 ;;
    --no-clone)    DO_CLONE=0 ;;
    --repo)        shift; LAB_REPO_URL="${1:?brak adresu po --repo}" ;;
    --dir)         shift; CLONE_DIR="${1:?brak katalogu po --dir}" ;;
    -h|--help)     usage; exit 0 ;;
    *)             die "nieznana opcja: $1 (użyj --help)" ;;
  esac
  shift
done

[ "$(uname -s)" = "Linux" ] || die "ten skrypt jest dla Linuxa. Na Windows/macOS: docs/INSTALACJA.md."

# --- kto jest „studentem" (docelowym użytkownikiem) ---
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
  TARGET_USER="${SUDO_USER:-root}"
else
  command -v sudo > /dev/null 2>&1 || die "brak sudo — uruchom jako root lub zainstaluj sudo."
  SUDO="sudo"
  TARGET_USER="$(id -un)"
fi
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
as_user() { if [ "$(id -un)" = "$TARGET_USER" ]; then "$@"; else sudo -u "$TARGET_USER" "$@"; fi; }

HAS_APT=0
command -v apt-get > /dev/null 2>&1 && HAS_APT=1
ARCH="$(uname -m)"

# --- 1. pakiety podstawowe ---
if [ "$HAS_APT" -eq 1 ]; then
  info "Aktualizacja listy pakietów i instalacja narzędzi podstawowych"
  $SUDO apt-get update -y
  $SUDO apt-get install -y curl git ca-certificates
else
  command -v curl > /dev/null 2>&1 || die "zainstaluj curl i git, potem uruchom skrypt ponownie."
  command -v git  > /dev/null 2>&1 || die "zainstaluj git, potem uruchom skrypt ponownie."
fi

# --- 2. Docker + Compose ---
if command -v docker > /dev/null 2>&1; then
  info "Docker już zainstalowany: $(docker --version)"
else
  info "Instalacja Dockera (oficjalny skrypt get.docker.com)"
  TMP_GET="$(mktemp)"
  curl -fsSL https://get.docker.com -o "$TMP_GET"
  $SUDO sh "$TMP_GET"
  rm -f "$TMP_GET"
fi

if command -v systemctl > /dev/null 2>&1; then
  $SUDO systemctl enable --now docker || warn "nie udało się włączyć usługi docker (systemctl)."
fi

if [ "$TARGET_USER" != "root" ]; then
  info "Dodaję użytkownika $TARGET_USER do grupy docker"
  $SUDO usermod -aG docker "$TARGET_USER"
fi

$SUDO docker compose version > /dev/null 2>&1 || die "brak wtyczki 'docker compose' (zainstaluj docker-compose-plugin)."
info "Test Dockera (hello-world)"
if $SUDO docker run --rm hello-world > /dev/null 2>&1; then
  echo "    Docker działa."
else
  warn "test hello-world nie powiódł się (brak internetu?). Sprawdź później: docker run hello-world"
fi

# --- 3. DBeaver Community ---
if [ "$WITH_DBEAVER" -eq 1 ]; then
  if command -v dbeaver-ce > /dev/null 2>&1 || command -v dbeaver > /dev/null 2>&1; then
    info "DBeaver już zainstalowany"
  elif [ "$HAS_APT" -eq 1 ] && { [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "amd64" ]; }; then
    info "Instalacja DBeaver Community (pakiet .deb ze strony dbeaver.io)"
    TMP_DEB="$(mktemp --suffix=.deb)"
    if curl -fsSL https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -o "$TMP_DEB" \
       && $SUDO apt-get install -y "$TMP_DEB"; then
      echo "    DBeaver zainstalowany."
    else
      warn "instalacja DBeavera nie powiodła się. Pobierz ręcznie: https://dbeaver.io/download/"
    fi
    rm -f "$TMP_DEB"
  elif command -v snap > /dev/null 2>&1; then
    info "Instalacja DBeaver Community (snap)"
    $SUDO snap install dbeaver-ce || warn "instalacja snap nie powiodła się. Pobierz ręcznie: https://dbeaver.io/download/"
  else
    warn "nie umiem automatycznie zainstalować DBeavera na tym systemie: https://dbeaver.io/download/"
  fi
fi

# --- 4. Repozytorium z materiałami ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR=""
if [ -d "$SCRIPT_DIR/labs" ] && [ -f "$SCRIPT_DIR/lab" ]; then
  REPO_DIR="$SCRIPT_DIR"
  info "Skrypt uruchomiony z repozytorium: $REPO_DIR (pomijam klonowanie)"
elif [ "$DO_CLONE" -eq 1 ]; then
  REPO_DIR="${CLONE_DIR:-$TARGET_HOME/bazy-danych-student}"
  if [ -d "$REPO_DIR/.git" ]; then
    info "Repozytorium już istnieje: $REPO_DIR"
  else
    case "$LAB_REPO_URL" in
      *TWOJ-LOGIN*) die "ustaw adres repozytorium (opcja --repo URL lub zmienna LAB_REPO_URL w skrypcie)." ;;
    esac
    info "Klonowanie $LAB_REPO_URL do $REPO_DIR"
    as_user git clone "$LAB_REPO_URL" "$REPO_DIR"
  fi
fi

if [ -n "$REPO_DIR" ] && [ -f "$REPO_DIR/lab" ]; then
  chmod +x "$REPO_DIR/lab" 2> /dev/null || true
fi

# --- 5. Obrazy baz (opcjonalnie) ---
if [ "$PULL_IMAGES" -eq 1 ]; then
  if [ -z "$REPO_DIR" ]; then
    warn "brak repozytorium — nie wiem, które obrazy pobrać."
  else
    info "Pobieram obrazy baz (to może potrwać; Oracle ma ponad 1 GB)"
    grep -h '^[[:space:]]*image:' "$REPO_DIR"/labs/*/compose.yaml | awk '{print $2}' | sort -u | while read -r img; do
      echo "    docker pull $img"
      $SUDO docker pull "$img" > /dev/null || warn "nie udało się pobrać $img"
    done
  fi
fi

# --- podsumowanie ---
echo
info "Gotowe."
echo "  1) Wyloguj się i zaloguj ponownie (albo wpisz: newgrp docker), żeby zadziałała grupa docker."
if [ -n "$REPO_DIR" ]; then
  echo "  2) cd \"$REPO_DIR\""
  echo "  3) ./lab list        # lista laboratoriów"
  echo "     ./lab up 3        # np. baza Katedra na PostgreSQL"
  echo "     ./lab site        # instrukcje (skoroszyt) w przeglądarce"
fi
