FROM elixir:1.8 AS development

ENV PS1 "🐳 \[\033[1;36m\]\W\[\033[0;35m\] # \[\033[0m\]"

FROM development AS builder

ENV MIX_ENV=prod

RUN mix local.hex --force
RUN mix local.rebar --force

COPY . /build
WORKDIR /build

RUN mix deps.get
RUN mix release

FROM elixir:1.8

ENV REPLACE_OS_VARS true
ENTRYPOINT ["/calculator/bin/calculator"]
CMD ["foreground"]

COPY --from=builder /build/_build/prod/rel/calculator /calculator
