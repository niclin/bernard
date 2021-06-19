# README

## Initial

```
rake db:create db:migrate
yarn install

```

## Start Server

```
rails server
```

## Start Webpack Compile Server

```
./bin/webpack-dev-server

```

## Some Know How

*Main or Common used js logic import in*

Used: `<%= javascript_pack_tag 'dashboard', 'data-turbolinks-track': 'reload' %>`

FilePath:`app/javascript/packs/application.js`

*SpecialPage used js logic import like this*

Used: `<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>`

FilePath:`app/javascript/packs/dashboard.js`


*Theme style put in*

File: `.css`

FilePath: `bernard/app/assets/stylesheets/theme_libs/*`

*Theme relative min js put in*

File: `min.js`

FilePath: `bernard/public/javascripts/*`


## Node Module Version

"bootstrap": "^5.0.1",
"@popperjs/core": "2.9.2"
"webpack-dev-server": "^3.11.2"
