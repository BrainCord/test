#!/bin/bash

# Обновление списка пакетов
sudo apt-get update

# Установка необходимых пакетов
sudo apt-get install -y ca-certificates curl gnupg

# Создание директории для ключей apt
sudo install -m 0755 -d /etc/apt/keyrings

# Добавление официального GPG ключа Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Настройка прав доступа для ключа
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Добавление репозитория Docker в список источников пакетов
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновление списка пакетов после добавления нового репозитория
sudo apt-get update

# Установка Docker Engine, CLI и плагинов
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Запуск тестового контейнера Docker
sudo docker run hello-world

# Клонирование репозитория simple-taiko-node
git clone https://github.com/lagunovsky/simple-taiko-node.git

# Переход в каталог проекта
cd simple-taiko-node

# Запрос значений для конфигурации
echo "Введите значения для конфигурации:"
read -p "L1_ENDPOINT_HTTP: " L1_ENDPOINT_HTTP
read -p "L1_ENDPOINT_WS: " L1_ENDPOINT_WS
read -p "ENABLE_PROPOSER (true/false): " ENABLE_PROPOSER
read -p "L1_PROPOSER_PRIVATE_KEY: " L1_PROPOSER_PRIVATE_KEY
read -p "PROVER_ENDPOINTS: " PROVER_ENDPOINTS

# Путь к файлу конфигурации
ENV_FILE="/root/simple-taiko-node/.env.sample"

# Обновление файла конфигурации
sed -i "s|^L1_ENDPOINT_HTTP=.*|L1_ENDPOINT_HTTP=${L1_ENDPOINT_HTTP}|" "$ENV_FILE"
sed -i "s|^L1_ENDPOINT_WS=.*|L1_ENDPOINT_WS=${L1_ENDPOINT_WS}|" "$ENV_FILE"
sed -i "s|^ENABLE_PROPOSER=.*|ENABLE_PROPOSER=${ENABLE_PROPOSER}|" "$ENV_FILE"
sed -i "s|^L1_PROPOSER_PRIVATE_KEY=.*|L1_PROPOSER_PRIVATE_KEY=${L1_PROPOSER_PRIVATE_KEY}|" "$ENV_FILE"
sed -i "s|^PROVER_ENDPOINTS=.*|PROVER_ENDPOINTS=${PROVER_ENDPOINTS}|" "$ENV_FILE"

# Создание копии файла как .env
cp "$ENV_FILE" "$(dirname "$ENV_FILE")/.env"

echo "Конфигурация завершена и сохранена в .env.sample и .env"

# Запуск контейнеров с помощью Docker Compose
docker compose up -d

echo -e "\033[33mNODE STARTED!!! LET'S FCKN GOO!!!\033[0m"

