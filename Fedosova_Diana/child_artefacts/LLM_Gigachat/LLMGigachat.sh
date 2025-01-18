#!/bin/sh

# # Проверка, установлен ли токен
if [ -z "$GIGACHAT_TOKEN" ]; then
    echo "Введите Authorization key:"
    read TOKEN
    export GIGACHAT_TOKEN=$TOKEN
    echo "Authorization key успешно установлен для текущей сессии."
else
    echo "Authorization key уже установлен."
fi
