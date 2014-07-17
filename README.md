Uke
===

Baza pozwoleń UKE, aplikacja umożliwia zaimportowanie bazy a także jej przeglądanie. Aby rozpocząć pracę w aplikacji należy ją zainstalować:

```
git clone https://github.com/arekk/uke.git
cd uke
bundle install
cp config/database-default.yml config/database.yml
cp config/secrets-default.yml config/secrets.yml
```

Następnie poprzez edycję config/database.yml należy zaktualizować konfigurację nazwy bazy i danych serwera, a także poprzez
edycję config/secrets.yml zaktualizować secret aplikacji (można wygenerować via rake secret) a także wprowadzić klucz Google
Maps API (https://developers.google.com/maps/documentation/javascript/tutorial?hl=pl)

W następnej kolejności:

```
rake db:migrate
rake assets:precompile
```

Arkusze z wykazem pozwoleń należy pobrać ze stron UKE: http://www.uke.gov.pl/pozwolenia-radiowe-dla-klasycznych-sieci-radiokomunikacji-ruchomej-ladowej-5458 i zapisać w katalogu

```
tmp/ss
```

a następnie uruchomić skrypt importu:

```
rails r bin/ss_import.rb
```
