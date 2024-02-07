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

