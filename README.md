# Skrypt Instalacyjny na Ubuntu

Ten skrypt automatyzuje instalację i konfigurację oprogramowania oraz usług na systemie Ubuntu. Wykorzystuje `apt` jako menedżera pakietów, instalując niezbędne oprogramowanie, konfigurując shell `zsh`, uruchamiając usługę Cockpit oraz konfigurując `samba`, `ufw`, `ssh`, `pyenv`, i wiele innych.

## Lista Instalowanych Pakietów

Poniżej znajduje się lista pakietów instalowanych przez skrypt:

1. **git** - system kontroli wersji.
2. **curl** - narzędzie do transferu danych z URL.
3. **btop** - narzędzie do monitorowania zasobów systemowych.
4. **python3** - język programowania Python 3.
5. **python3-pip** - menedżer pakietów dla Pythona 3.
6. **zsh** - alternatywna powłoka Unix.
7. **cockpit** - interfejs webowy do zarządzania systemem.
8. **samba** - oprogramowanie do współdzielenia plików i drukarek.
9. **bat** - narzędzie do wyświetlania plików tekstowych z kolorowaniem składni (alias dla `batcat`).
10. **neofetch** - narzędzie do wyświetlania informacji o systemie.
11. **openssh-server** - serwer SSH.
12. **postgresql** - system zarządzania bazami danych SQL.
13. **postgresql-contrib** - dodatkowe moduły dla PostgreSQL.
14. **build-essential** - pakiet narzędzi do kompilacji oprogramowania.
15. **libssl-dev** - biblioteka SSL (deweloperska wersja).
16. **mc** - menedżer plików Midnight Commander.
17. **eza** - ulepszona wersja `ls`.
18. **fzf** - narzędzie do wyszukiwania w terminalu.
19. **qemu-guest-agent** - agent dla maszyn wirtualnych QEMU.

Skrypt dodatkowo instaluje i konfiguruje `Oh My Posh`, oraz różne wtyczki dla `zsh`.

## Funkcjonalność

1. **Aktualizacja systemu**
   - Aktualizacja listy pakietów (`apt update`) i instalacja aktualizacji (`apt upgrade`).

2. **Instalacja niezbędnych pakietów**
   - Instalacja `git`, `curl`, `btop`, `python3`, `zsh`, `cockpit`, `samba`, `bat`, `neofetch`, `openssh-server`, `postgresql`, `mc` i innych.

3. **Konfiguracja `pyenv` nieaktualne**
   - Instalacja `pyenv` i jego konfiguracja dla `bash` i `zsh`.
   - Instalacja najnowszej wersji Pythona i ustawienie jej jako globalnej.

4. **Konfiguracja powłoki `zsh`**
   - Instalacja i konfiguracja `Oh My Posh` z wybranym motywem.
   - Instalacja i aktywacja wtyczek `zsh` takich jak `zsh-autosuggestions`, `fast-syntax-highlighting`, `fzf-tab` i inne.

5. **Konfiguracja `samba`** (opcjonalnie)
   - Udostępnienie katalogu domowego użytkownika jako zasobu sieciowego.

6. **Konfiguracja `ufw`**
   - Konfiguracja zapory sieciowej `ufw` i dodanie reguł dla `ssh`, `samba`, `cockpit`, i innych usług.

7. **Konfiguracja `ssh`**
   - Instalacja serwera SSH.

8. **Konfiguracja PostgreSQL** (opcjonalnie)
   - Instalacja PostgreSQL i ustawienie hasła dla użytkownika `postgres`.

9. **Dodanie interfejsu dummy za pomocą `nmcli`** (opcjonalnie)
   - Dodanie interfejsu sieciowego typu dummy z przykładową konfiguracją IP.

10. **Tworzenie dodatkowych katalogów**
    - Tworzenie katalogów `Dokumenty` i `Projekty` w katalogu domowym użytkownika.

## Użycie

Uruchom skrypt:
```bash
chmod +x setup.sh && ./setup.sh
