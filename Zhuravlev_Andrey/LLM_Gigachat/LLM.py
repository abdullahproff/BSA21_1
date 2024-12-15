#!/usr/bin/env python3

import os
from getpass import getpass
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_gigachat.chat_models import GigaChat


def main():
    # Проверяем наличие токена
    if 'GIGACHAT_TOKEN' not in os.environ:
        token = getpass(prompt="Введите Authorization key: ")
        os.environ['GIGACHAT_TOKEN'] = token
        print("Authorization key не установлен для текущей сессии.")
    else:
        print("Authorization key уже установлен.")
    
    # Запрашиваем вопрос
    brainstorm_question = input("Введите Use case : \n")
    prompt = f"""
    Ты находишься в роли эксперта по системному анализу.
    Отвечай мне, как аналитику уровня junior.
    Напиши, пожалуйста, Use Case для сценария "{brainstorm_question}".
    Структура Use Case должна содержать:
    1. Название сценария
    2. Преусловия
    3. Ограничения
    4. Акторы
    5. Основной сценарий
    6. Альтернативный сценарий
    7. Исключительные сценарии

    Альтернативный сценарий - это способ достижения изначальной цели основного сценария, но другим путём.
    Ограничения - это, например, размер фото файла или любое другое ограничение, за рамки которого не получится выйти в рамках сценариев в Use Case.
    """
    # Подключаемся к GigaChat
    giga = GigaChat(credentials=os.environ.get('GIGACHAT_TOKEN'), verify_ssl_certs=False)
    response = giga.invoke([HumanMessage(content=prompt)])
    
    # Выводим результат
    print("\nОтвет:")
    print(response.content)


if __name__ == "__main__":
    main()

"""
Напиши, пожалуйста Use case, для фичи по добавлению аватара как в Telegram.
"""