# Renault collector

Collect data from Renault ZE and push it to InfluxDB 2. Tested with Renault ZOE.

## Build image

```bash
docker build -t renault-collector .
```

## Run container

Prepare an `.env` file (see `.env.example`). Then:

```bash
docker run --env-file .env renault-collector app/main.rb
```

Copyright (c) 2021 Georg Ledermann, released under the MIT License
