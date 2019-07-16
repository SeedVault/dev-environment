include .env
export
DSN=postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@postgresql:$(POSTGRES_PORT)/$(HYDRA_DATABASE)?sslmode=disable

.PHONY: all install logs start status stop uninstall

all:
	@echo
	@echo "Usage:"
	@echo "	make [option]"
	@echo
	@echo "Options:"
	@echo "	install		Install the multi-container environment for development"
	@echo "	logs		View output from containers"
	@echo "	start		Start the environment in the background and leave it running"
	@echo "	status		List all running containers"
	@echo "	stop		Stop the containers"
	@echo "	uninstall	Uninstall the multi-container environment and wipe both containers and data"
	@echo

install:
	@docker-compose down && docker network create $(NETWORK_NAME)
	@echo
	@echo "Installing containers..."
	@echo
	@docker-compose pull && docker-compose build && docker-compose up -d
	@echo
	@echo "Waiting for the database..."
	@sleep 20 && while ! nc -q 1 127.0.0.1 $(POSTGRES_PORT) </dev/null; do sleep 20; done
	@echo
	@echo "Performing database schema migrations..."
	@echo
	@docker run -it --rm --network $(NETWORK_NAME) $(HYDRA_IMAGE) migrate sql --yes $(DSN)
	@echo
	@echo "Restarting containers..."
	@echo
	@docker-compose stop && docker-compose up -d
	@echo "Creating OAuth2 client for Accounts..."
	@echo
	docker run --rm -it \
	--network $(NETWORK_NAME) \
	$(HYDRA_IMAGE) \
	clients create \
    --endpoint http://hydra:4445 \
    --id $(ACCOUNTS_OAUTH2_CLIENT_ID) \
    --secret $(ACCOUNTS_OAUTH2_CLIENT_SECRET) \
    --grant-types client_credentials,authorization_code,refresh_token \
    --response-types token,code,id_token \
	--callbacks $(ACCOUNTS_OAUTH2_REDIRECT_URI) \
	--token-endpoint-auth-method client_secret_post
	@echo
	@echo "Creating OAuth2 client for Wallet..."
	@echo
	docker run --rm -it \
	--network $(NETWORK_NAME) \
	$(HYDRA_IMAGE) \
	clients create \
    --endpoint http://hydra:4445 \
    --id $(WALLET_OAUTH2_CLIENT_ID) \
    --secret $(WALLET_OAUTH2_CLIENT_SECRET) \
    --grant-types client_credentials,authorization_code,refresh_token \
    --response-types token,code,id_token \
	--callbacks $(WALLET_OAUTH2_REDIRECT_URI) \
	--token-endpoint-auth-method client_secret_post
	@echo
	@echo "Creating OAuth2 client for Greenhouse..."
	@echo
	docker run --rm -it \
	--network $(NETWORK_NAME) \
	$(HYDRA_IMAGE) \
	clients create \
    --endpoint http://hydra:4445 \
    --id $(GREENHOUSE_OAUTH2_CLIENT_ID) \
    --secret $(GREENHOUSE_OAUTH2_CLIENT_SECRET) \
    --grant-types client_credentials,authorization_code,refresh_token \
    --response-types token,code,id_token \
	--callbacks $(GREENHOUSE_OAUTH2_REDIRECT_URI) \
	--token-endpoint-auth-method client_secret_post
	@echo
	@docker-compose ps
	@echo
	@echo "Done".
	@echo

logs:
	@docker-compose logs

start:
	@docker-compose up -d
	@echo
	@docker-compose ps

status:
	@docker-compose ps

stop:
	@docker-compose stop

uninstall:
	@docker-compose down && rm -Rf ./volumes
