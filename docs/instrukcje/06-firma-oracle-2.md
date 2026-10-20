# Laboratorium 6/6 — Złączenia, grupowanie i funkcje agregujące

**Silnik:** Oracle · **Baza:** Firma handlowa

**Cel:** JOIN, GROUP BY, COUNT, AVG i HAVING na bazie „Firma handlowa”.

**Połączenie:** host: localhost · port: 1521 · Service name: FREEPDB1 · użytkownik: student · hasło: student

## Czynności wstępne

1. Docker działa, a poprzednie bazy są zatrzymane.
2. Przejdź do katalogu laboratorium: `cd labs/06-firma-oracle-2`.

## Przygotowanie bazy

Uruchom bazę. To ta sama baza i ten sam wolumen co w instrukcji 5/6 — jeśli baza była już utworzona, dane i Twoje zmiany są na miejscu:

```bash
docker compose up -d
docker compose logs -f oracle
```

> Poczekaj na komunikat `DATABASE IS READY TO USE!` (Ctrl+C kończy podgląd logów). Reset do stanu początkowego: `docker compose down -v`, potem ponownie `docker compose up -d`.

## Zadania

1. Napisz polecenie SQL zwracające klientów i ich sprzedawców z limitem kredytowym powyżej 5000 (nazwa, adres, limit, nazwisko i imię pracownika — sprzedawcy).
2. Napisz polecenie SQL zwracające łączną liczbę sztuk każdego wyrobu zamówionego po 1990 roku (id, opis, liczba sztuk).
3. Napisz polecenie SQL zwracające nazwisko, imię i pensję pracowników, których pensja mieści się w przedziale 2000–3000.
4. Napisz polecenie SQL zwracające zamówienia (identyfikator zamówienia, data jego złożenia, nazwa klienta) dla zamówień o wartości powyżej 200.
5. Wyświetl nazwę klienta i wartość zamówienia złożonego przez niego, pod warunkiem że wartość zamówienia jest z przedziału <1000, 3000> i zamówienie złożono po 10 maja 1991. Posortuj wynik po wartościach zamówień.
6. Dla zamówień spełniających warunki z poprzedniego zadania wyświetl średnią wartość zamówienia każdego klienta. Pogrupuj wiersze po nazwie klienta (`GROUP BY`); średnią liczy funkcja `AVG(total)` — użyj jej zamiast samej wartości zamówienia.
7. Ilu pracowników zatrudnionych jest na poszczególnych etatach? Pokaż nazwę etatu (tabela `JOBS`) i liczbę pracowników. Wykonaj w dwóch krokach: najpierw nazwa etatu i `employee_id` posortowane po nazwie etatu, potem grupowanie (`GROUP BY`) i `COUNT`.
8. Każdy klient obsługiwany jest przez pewnego pracownika. Wyświetl imię i nazwisko pracownika oraz ilu klientów obsługuje. Pracownicy, którzy nie obsługują klientów, nie powinni wystąpić w wyniku (bez złączeń zewnętrznych).
9. Zmodyfikuj poprzednie zadanie tak, żeby wynik pokazywał liczbę klientów w poszczególnych miastach (imię i nazwisko, miasto, liczba klientów).
10. Napisz polecenie SQL zwracające wydziały (`DEPARTMENT`), które mają więcej niż 3 pracowników.

## Uwagi

`JOIN`, `GROUP BY`, `HAVING`, `COUNT` i `AVG` działają standardowo. Imię i nazwisko łączysz operatorem `||`. Zadania 1–4 powtarzają materiał z 5/6 — to celowa powtórka przed grupowaniem.


## Koniec zajęć — zanim odejdziesz od komputera

1. **Najpierw sprawozdanie.** Wygeneruj sprawozdanie (PDF) i zapisz je poza komputerem w sali (e-mail, pendrive, chmura). Odpowiedzi są zapisane tylko w tej przeglądarce — czyszczenie je usunie. Kopię możesz też zachować przyciskiem „Zapisz odpowiedzi (JSON)”.
2. **Komputer w sali (współdzielony):** w katalogu z materiałami wykonaj `./lab clean --stanowisko` i wpisz `TAK`. Usuwa kontenery i dane baz, połączenia DBeavera, dane przeglądarki (także Twoje zalogowania), historię, Pobrane oraz same materiały — kolejna osoba zaczyna od czystego stanowiska.
3. **Własny komputer:** wystarczy `./lab down` (bazy zatrzymane, dane zostają na kolejne zajęcia) albo `./lab clean`, jeśli chcesz usunąć kontenery i dane laboratoriów. Obrazy baz zostają w obu przypadkach.
4. Na Windows bez Git Bash: `docker compose down` w katalogu laboratorium (lub `docker rm -f pg-lab mysql-lab oracle-lab` po instrukcji 1).

