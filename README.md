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
mkdir tmp/ss
```
Arkusze z wykazem pozwoleń znajdują się na stronach UKE: 

https://dane.gov.pl/dataset/1070

Należy zacząć od utworzenia importu odpowiadającego dacie publikacji pozwoleń, dla przykładu arkusze opublikowane zostały 2014-10-10:

```
rails r bin/ss_import_create.rb --release-date=2014-10-10
```

Następnie w katalogu tmp/ss/2014-10-10 zapisać wszystkie arkusze (lub wybrane)
W następnej kolejności uruchomić skrypt importu:

```
rails r bin/ss_import.rb --release-date=2014-10-10
```
