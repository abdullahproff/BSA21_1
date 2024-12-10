#!/bin/bash

# Путь к виртуальному окружению
VENV_PATH="./venv"

# Проверка, существует ли виртуальное окружение
if [ ! -d "$VENV_PATH" ]; then
  echo "Виртуальное окружение не найдено. Создаем виртуальное окружение..."
  python3 -m venv venv
fi

# Активируем виртуальное окружение
source "$VENV_PATH/bin/activate"

# Устанавливаем зависимости
pip install --upgrade pip
pip install requests 

echo "Запуск Streamlit..."
streamlit run easy.py

# Деактивируем виртуальное окружение после выполнения
deactivate
