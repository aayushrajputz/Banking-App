postgres:
	docker stop some-postgres || true
	docker rm some-postgres || true
	docker run --name some-postgres -p 5432:5432 \
	-e POSTGRES_USER=postgres \
	-e POSTGRES_PASSWORD=postgres \
	-d postgres:13-trixie

createdb:
	docker exec -it some-postgres createdb --username=postgres --owner=postgres simple_bank

dropdb:
	docker exec -it some-postgres dropdb simple_bank

recreate-db:
	docker exec -i some-postgres dropdb --if-exists simple_bank --username=postgres
	docker exec -i some-postgres createdb --username=postgres --owner=postgres simple_bank

migrateup:
	migrate -path db/migration -database "postgres://postgres:postgres@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgres://postgres:postgres@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate
