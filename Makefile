setup:
	mix deps.get
	mix ecto.create
	mix ecto.migrate

drop:
	mix ecto.drop

create:
	mix ecto.create
	mix ecto.migrate

migrate:
	mix ecto.migrate

start:
	mix phx.server

routes:
	mix phx.routes

sample:
	curl http://localhost:4000/api/v1/createsample
