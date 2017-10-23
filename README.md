# README

Project Credo is a tool for curating, commenting on, and sharing lists of research papers.

If you've ever done research on how coffee affects your body, interventions or preventative measures for cancers, or how to build muscle mass most effectively, you're not alone...and now you can work together to research the questions that vex humanity.

It is a humble first step on what is hopefully a path towards greater scientific consensus among both academics and laypersons.

Project Credo is open-source by design, under a GPLv3 license.

## Development

### Requirements:

- docker
- docker-compose
- Internet connection

### Installation

1. Install docker: https://docs.docker.com/engine/installation/
1. `git clone https://github.com/projectcredo/projectcredo.git` (or your favorite protocol)
1. `cd` into the directory
1. Create a `.env` file in the root directory
1. `docker-compose build` whenever you add a gem - in this case, you'll be installing all of them
1. `docker-compose run app rails db:create db:schema:load db:migrate db:seed` - to create the database, load the schema, migrate any lingering migrations, and then seed with test data
1. `docker-compose up` to run the rails server

#### .env file

Your `.env` file will be used for supplying your docker instances with environment variables, and docker won't start without it. You can `cp .env.example .env` to start. One of the important ones is `DOCKER_HOST_IP`, which will tell Rails which IP addresses are allowed to see console and debug output.

On Unix-like environments, you can use `docker inspect projectcredo_postgres_1 -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $@` to figure out your IP Address. Note: you may need to change the app name from `projectcredo_postgres_1` to match your postgres docker name.

This often results in `DOCKER_HOST_IP=172.18.0.1/16`.

### Visiting the site locally

The site's address unfortunately depends on what system you're on. Linux and Mac OS seem to be fine mounting it at `localhost:3000`, but on Windows, we've needed to find the docker container's IP address in order to actually see the site. You may need to figure out what your docker container's IP address is.

### Working with rails inside Docker container

The development the project is setup to run in a Docker container, so instead of running commands locally like `bundle` or `rails <command>` you need to prepend them with `docker-compose run app`.
For example, to add new gems instead of running `bundle` command you need to run: `docker-compose run app bundle`.


### Contributing

Submit a pull request against the develop branch and fill out the Pull Request template.

#### Testing

1. `docker-compose run app rails db:environment:set RAILS_ENV=test`
1. `docker-compose run app rails webpacker:compile` - if assets were not compiled previously
1. `docker-compose run app rails test`

### Reporting issues

Start a new issue and fill out the issues template as well as you can.
