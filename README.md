# Authentication API 
> Authenticate users from anywhere.

## Why?
I made this project to practice ruby and devise remote authentication strategies.

## Dependencies
- [Postgres](https://www.postgresql.org/) (Feel free to change, devise supports multiple databases.)
- [Ruby](https://www.ruby-lang.org/en/)
- [Bundler](https://bundler.io/) 

## Install
After cloning this repository, navigate to project folder and run:
```bash
bundle install
```

Run this command to generate a new secret key and copy it.
```
./bin/rails secret
```
Run the following command to open your api/config/credentials.yml.enc file and paste the key you just generated
```
For VSCode:
EDITOR="code --wait" rails credentials:edit --environment=development

Default editor:
rails credentials:edit --environment=development
```

```
devise_jwt_secret_key: PASTE NEW SECRET KEY HERE
```

Save and close.

Now, create the database and run migrations
```
rails db:create && rails db:migrate
```

then spin up the web server
```bash
rails s
```
Default port for this project is `3001`. You can change at `config/puma.rb`

## Usage
```
POST /signup

BODY

{
	"user": {
		"email": "fabio@email.com",
		"password": "123123"
	}
}

Response

{
	"status": {
		"code": 200,
		"message": "Signed up successfully.",
		"token": "eyJhbGciOiJIUzI1NiJ9....",
		"data": {
			"id": 1,
			"email": "fabio@email.com"
		}
	}
}
```

```
POST /login

BODY

{
	"user": {
		"email": "fabio@email.com",
		"password": "123123"
	}
}

Response

{
	"status": {
		"code": 200,
		"message": "Logged in successfully."
	},
	"data": {
		"token": "eyJhbGciOiJIUzI1NiJ9...",
		"user": {
			"id": 1,
			"email": "fabio@email.com"
		}
	}
}
```

```
DELETE /logout

Headers
Authorization Bearer eyJhbGciOiJIUzI1NiJ9....

Response
{
	"status": 200,
	"message": "Logged out successfully."
}
```
