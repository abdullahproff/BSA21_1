#!/usr/bin/env python3

import os
from getpass import getpass
from langchain_core.messages import HumanMessage
from langchain_gigachat.chat_models import GigaChat

def main():
    # Проверяем наличие токена
    if 'GIGACHAT_TOKEN' not in os.environ:
        token = getpass(prompt="Введите Authorization key: ")
        os.environ['GIGACHAT_TOKEN'] = token
        print("Authorization key не установлен для текущей сессии.")
    else:
        print("Authorization key уже установлен.")
    
    # Запрашиваем вопрос у пользователя
    brainstorm_question = input("Введите задание: \n")
    
    # Формируем запрос для GigaChat
    prompt = f"""
    Ты находишься в роли эксперта по системному анализу.
    Отвечай мне, как аналитику уровня junior.
    Напиши, пожалуйста, план для сценария "{brainstorm_question}".
    """
    
    # Подключаемся к GigaChat
    giga = GigaChat(credentials=os.environ.get('GIGACHAT_TOKEN'), verify_ssl_certs=False)
    
    # Отправляем запрос и получаем ответ
    response = giga.invoke([HumanMessage(content=prompt)])
    
    # Выводим результат
    print("\nОтвет:")
    print(response.content)

if __name__ == "__main__":
    main()
    
    