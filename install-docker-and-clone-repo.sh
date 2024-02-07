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
git clone https://github.com/taikoxyz/simple-taiko-node.git

# Переход в каталог проекта
cd simple-taiko-node

# Запрос данных у пользователя
echo "Введите значения для конфигурации:"
read -p "L1_ENDPOINT_HTTP: " L1_ENDPOINT_HTTP
read -p "L1_ENDPOINT_WS: " L1_ENDPOINT_WS
read -p "ENABLE_PROPOSER (true/false): " ENABLE_PROPOSER
read -p "L1_PROPOSER_PRIVATE_KEY: " L1_PROPOSER_PRIVATE_KEY
read -p "PROVER_ENDPOINTS: " PROVER_ENDPOINTS

# Обновление .env.sample с введенными значениями
cat > .env.sample <<EOF
L1_ENDPOINT_HTTP=$L1_ENDPOINT_HTTP
L1_ENDPOINT_WS=$L1_ENDPOINT_WS
ENABLE_PROPOSER=$ENABLE_PROPOSER
L1_PROPOSER_PRIVATE_KEY=$L1_PROPOSER_PRIVATE_KEY
PROVER_ENDPOINTS=$PROVER_ENDPOINTS
EOF

# Создание дубликата файла под названием .env
cp .env.sample .env

# Вывод сообщения о завершении
echo "Конфигурация завершена и сохранена в .env.sample и .env"
