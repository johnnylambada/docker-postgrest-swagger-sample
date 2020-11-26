# Docker PostgREST Swagger Example

John Lombardo

Nov 26, 2020

## Introduction

This example docker compose app makes it easy to try out postgREST using docker. It's derived from the postgREST tutorials 0 and 1. It ends up being a bit more complicated than you might expect because postgREST [does not add the securityDefinitions](https://github.com/PostgREST/postgrest/issues/1082) to the swagger JSON that it generates. To get around this, I added a proxy nginx server that stuffs the necessary JSON into the result that postgREST generates. I hope to remove this hack in the near future when the postgREST is fixed.

So the stack for this example is:

* swagger
* nginx acting as a proxy for...
* ... postgREST
* postgres

The following tutorials and web sites were helpful in making this example

* The postgREST tutorials: [tutorial0](http://postgrest.org/en/v7.0.0/tutorials/tut0.html) and [tutorial1](http://postgrest.org/en/v7.0.0/tutorials/tut1.html1)
* [postgREST docker config](https://hub.docker.com/r/postgrest/postgrest/)
* [jwt.io](https://jwt.io/)

## tl;dr

To run it simply:

```
git clone https://github.com/johnnylambada/docker-postgrest-swagger-sample.git
cd docker-postgrest-swagger-sample
./start.sh
```

The `start.sh` script sets up the host environment then fires off a `docker-compose` to start the four docker containers that comprise this app. When the app is fully up, you'll see a line that looks like this:

```
postgrest_1        | Connection successful
```

At that point you can visit http://localhost:8080 and you'll see the swagger screen.

* Press the `Authorize` button and an authorization dialog will appear.
* Paste the following in the "value" box:

```
Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjQ3NjIxMDY4NTYsImlhdCI6MTYwNjQxMTY1Niwicm9sZSI6InRvZG9fdXNlciJ9.rDSsIAyahco2KySYs6m8Mj4M3oHwC3ncf86itJdLahc
```

* Then click `Authorize` then `Close`.

You can now hit all of the APIs using swagger. First, hit the `GET /todos` API to see that there are only two todo items. Then add another todo item using the `POST /todos` api. When you do use the POST api, make sure you trim the sample JSON to just:

```
{
  "task": "type something here"
}
```

Once you've done that, re-execute the `GET /todos` API to see that there is a new task.


## The configuration files

There are only four files involved involved in this app.

### `start.sh`

The start.sh app is quite simple. It removes any previous database, defines the `TODO_SECRET` used to generate JWT tokens, then starts the docker containers using `docker-compose`.

### `todo.sql`

The todo.sql file creates the `api` schema that is exposed through postgREST. It also creates the `todo` table and various roles. This is all explained well in the postgREST tutorials #0 and #1.

### `docker-compose.yml`

This file sets up the docker containers used in this example.

### `nginx.conf`

This file sets up the nginx proxy that re-writes postgREST's JSON output to include the necessary `securityDefinitions` section. Without this, the `Authorize` button would not appear on the swagger web page.