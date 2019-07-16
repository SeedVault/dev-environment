#! /bin/bash
echo
if [ ! -e "./.env" ]; then
    export SECURE_POSTGRES_PASSWORD=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_SECRETS_SYSTEM=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_ACCOUNTS_OAUTH2_CLIENT_SECRET=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_WALLET_OAUTH2_CLIENT_SECRET=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    export SECURE_GREENHOUSE_OAUTH2_CLIENT_SECRET=$(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    sed -e "s/secure_postgres_password/${SECURE_POSTGRES_PASSWORD}/g" \
        -e "s/secure_secrets_system/${SECURE_SECRETS_SYSTEM}/g" \
        -e "s/secure_accounts_oauth2_client_secret/${SECURE_ACCOUNTS_OAUTH2_CLIENT_SECRET}/g" \
        -e "s/secure_wallet_oauth2_client_secret/${SECURE_WALLET_OAUTH2_CLIENT_SECRET}/g" \
        -e "s/secure_greenhouse_oauth2_client_secret/${SECURE_GREENHOUSE_OAUTH2_CLIENT_SECRET}/g" \
        ./.env.example > ./.env
    echo "File .env has been created"
else
   echo "The .env file already exists. Operation Cancelled"
fi
echo
