#! /bin/bash
echo
if [ ! -e "./.env" ]; then
    export SECURE_REDIS_PASSWORD=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_MONGO_PASSWORD=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_POSTGRES_PASSWORD=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_HYDRA_SECRETS_SYSTEM=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_ACCOUNTS_SESSION_SECRET=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_ACCOUNTS_API_KEY=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_ACCOUNTS_OAUTH2_CLIENT_SECRET=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_WALLET_API_KEY=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_WALLET_SESSION_SECRET=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_WALLET_OAUTH2_CLIENT_SECRET=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_GREENHOUSE_SESSION_SECRET=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_GREENHOUSE_OAUTH2_CLIENT_SECRET=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    sed -e "s/secure_redis_password/${SECURE_REDIS_PASSWORD}/g" \
        -e "s/secure_mongo_password/${SECURE_MONGO_PASSWORD}/g" \
        -e "s/secure_postgres_password/${SECURE_POSTGRES_PASSWORD}/g" \
        -e "s/secure_hydra_secrets_system/${SECURE_HYDRA_SECRETS_SYSTEM}/g" \
        -e "s/secure_accounts_session_secret/${SECURE_ACCOUNTS_SESSION_SECRET}/g" \
        -e "s/secure_accounts_api_key/${SECURE_ACCOUNTS_API_KEY}/g" \
        -e "s/secure_accounts_oauth2_client_secret/${SECURE_ACCOUNTS_OAUTH2_CLIENT_SECRET}/g" \
        -e "s/secure_wallet_api_key/${SECURE_WALLET_API_KEY}/g" \
        -e "s/secure_wallet_session_secret/${SECURE_WALLET_SESSION_SECRET}/g" \
        -e "s/secure_wallet_oauth2_client_secret/${SECURE_WALLET_OAUTH2_CLIENT_SECRET}/g" \
        -e "s/secure_greenhouse_session_secret/${SECURE_GREENHOUSE_SESSION_SECRET}/g" \
        -e "s/secure_greenhouse_oauth2_client_secret/${SECURE_GREENHOUSE_OAUTH2_CLIENT_SECRET}/g" \
        ./.env.example > ./.env
    echo "File .env has been created"
else
   echo "The .env file already exists. Operation Cancelled"
fi
echo
