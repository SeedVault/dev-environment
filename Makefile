ifeq (,$(wildcard ./.env))
  $(error "File .env not found. Run create-env.sh to create a .env file")
endif
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
	@echo
	@echo Creating self-signed SSL keys...
	@echo
	@if [ ! -d ./certs ]; then \
	mkdir -p certs; \
	openssl req -x509 -newkey rsa:4096 -keyout ./certs/key.pem -out ./certs/cert.pem -days 365 -nodes -subj "/C=US/ST=California/L=Emeryville/O=SEED Token/OU=SEED Technologies/CN=seedtoken.io"; \
	fi
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
	@echo
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
	--callbacks $(ACCOUNTS_OAUTH2_CALLBACK_URL) \
	--token-endpoint-auth-method client_secret_post \
	--name $(ACCOUNTS_OAUTH2_NAME) \
	--logo-uri $(ACCOUNTS_OAUTH2_LOGO_URL) \
	--tos-uri $(ACCOUNTS_OAUTH2_TOS_URL) \
	--policy-uri $(ACCOUNTS_OAUTH2_POLICY_URL)
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
	--callbacks $(WALLET_OAUTH2_CALLBACK_URL) \
	--token-endpoint-auth-method client_secret_post \
	--name $(WALLET_OAUTH2_NAME) \
	--logo-uri $(WALLET_OAUTH2_LOGO_URL) \
	--tos-uri $(WALLET_OAUTH2_TOS_URL) \
	--policy-uri $(WALLET_OAUTH2_POLICY_URL)
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
	--callbacks $(GREENHOUSE_OAUTH2_CALLBACK_URL) \
	--token-endpoint-auth-method client_secret_post \
	--name $(GREENHOUSE_OAUTH2_NAME) \
	--logo-uri $(GREENHOUSE_OAUTH2_LOGO_URL) \
	--tos-uri $(GREENHOUSE_OAUTH2_TOS_URL) \
	--policy-uri $(GREENHOUSE_OAUTH2_POLICY_URL)
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
