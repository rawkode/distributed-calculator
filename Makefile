TESTS 	=
USER_ID = $(shell id -u)

.PHONY: up dshell deps compile test lint clean kafka

.hex:
	@mix do local.hex --force, local.rebar --force

lint:
	@mix format --check-formatted

deps: .hex
	@mix deps.get

up: deps
	@mix run --no-halt

compile: deps
	@mix compile

format:
	@mix format --check-equivalent

test: deps es
	@MIX_ENV=test mix test

unit-tests: deps
	@MIX_ENV=test mix test --only unit

integration-tests: deps es
	@MIX_ENV=test mix test --only integration

stale: deps es
	@MIX_ENV=test mix test --stale

coveralls: deps
	@MIX_ENV=test mix coveralls

clean: deps
	@mix clean

#######
# Docker Stuff
#######
dshell:
	@docker-compose up -d influxdb
	@sleep 4
	@docker-compose exec influxdb influx -import -path=/tmp/schemas.txt
	@docker-compose run --rm --user $(USER_ID) --service-ports --use-aliases --entrypoint=bash elixir --norc

dclean:
	@docker-compose down -v
	@rm -rf _build deps .hex .mix .cache .bash_history
