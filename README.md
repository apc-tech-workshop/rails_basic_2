# sample code for apc rails workshop.

- [api doc & mock](http://docs.apcrailsws.apiary.io/)

# topic

- rspec & guard
  - routing
  - controller
    - API
  - model
    - factory_girl_rails
- model
  - model : hoge
    - geocoding
- heroku
  - gitignore

# note

## rspec

```
$ cd apc_rails_ws/

$ git init
$ git checkout -b develop
$ echo '# apc rails workshop' > README.md
$ git add .
$ git commit -m 'first commit'

$ bundle install --path=vendor/bundle
$ echo '/vendor/bundle/*' >> .gitignore

$ bundle exec rails new .


