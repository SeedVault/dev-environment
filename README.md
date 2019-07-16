# Local development environment on Docker

## Goals

* Build a local development environment in an **automatic** and **reproducible** way.
* Relieve developers from the tedious and error-prone effort of manually
configuring their programming environments.
* Help prevent the dreaded **"it works on my machine"** problem.

## Stack

* [Hydra 1.0](https://gethydra.sh/) - Hardened OAuth 2.0 & OpenID Connect Server.
* [Parity 2.5.5](https://www.parity.io/ethereum/) - Ethereum client with a private development chain mode.
* [PostgreSQL 11](https://www.postgresql.org) - Relational database management system (RDBMS)
* [Mailhog (latest)](https://github.com/mailhog/MailHog) - SMTP server with a GUI testing tool.

## Installation

---
⚠️ **WARNING**: This stack was developed for development environment only and
**it should never run on production**.

---

### Prerequisites

* You need both [Docker](https://docs.docker.com/) and [Docker-Compose](https://docs.docker.com/compose/) installed and working correctly on your dev machine.

* Make sure that ports `1025, 8025, 5432, 4444, 4445, 8545, 8546, 30303, 3000, 9000, 9001, 9002` are not being used by other services:

```bash
sudo netstat -tuplen | grep '1025\|8025\|5432\|4444\|4445\|8545\|8546\|30303\|3000\|9000\|9001\|9002'
```

### Installation steps

1. Clone this repository:

```bash
git clone git@github.com:SeedVault/dev-environment.git
```

2. Run `create-env.sh` to create a secure `.env` local configuration file. Optionally,
you can edit the `.env` file in a text editor to change the values to your needs.

```bash
./create-env.sh
```
3. Use `make` to automatically install and configure everything on your local
machine machine:

```bash
make install
```
4. The development environment should be up and running in your machine.

## Daily usage

| Command | Description |
|---|---|
| `make start`| Start the environment in the background and leave it running |
| `make logs`| View output from containers |
| `make status`| List all running containers |
| `make stop`| Stop the environment |


## Uninstallation

To uninstall the development environment and wipe both containers and data run
the following command:

```bash
make uninstall
```
