import os
import re
from dotenv import load_dotenv
from langchain.schema import HumanMessage, SystemMessage
from langchain_gigachat import GigaChat

import streamlit as st
from prettytable import PrettyTable
import pandas as pd

load_dotenv()
auth = os.environ['SBER_AUTH']

giga = GigaChat(
    credentials=auth,
    model='GigaChat',
    verify_ssl_certs=False
)

# Сообщение системы
system_message = SystemMessage(content="Помоги мне с генерацией и улучшением сценариев использования, пользовательских историй и критериев приемки.")

# Список сообщений
msgs = []

# Заголовок Streamlit
st.title("Генерация и улучшение")

# Раздел: Пользовательская история
st.header("Пользовательская история")
user_story_title = st.text_input("Заголовок:")
user_story_description = st.text_area("Описание:", height=120, key="us_description")

# Кнопки для генерации и улучшения пользовательской истории
generate_us_button = st.button("Сгенерировать US")
improve_us_button = st.button("Наштормить US")

# Раздел: Сценарий использования
st.header("Сценарий использования")
use_case_title = st.text_input("Название:")
use_case_description = st.text_area("Описание:", height=120, key="uc_description")

# Кнопки для генерации и улучшения сценария использования
generate_uc_button = st.button("Сгенерировать UC")
improve_uc_button = st.button("Улучшить UC")

# Раздел: Критерии приемки
st.header("Критерии приемки")
acceptance_criteria_title = st.text_input("Название:", key="ac_title")
acceptance_criteria_description = st.text_area("Описание:", height=120, key="ac_description")

# Кнопки для генерации и улучшения критериев приемки
generate_ac_button = st.button("Сгенерировать AC")
improve_ac_button = st.button("Улучшить AC")

# Логика обработки кнопок
if generate_us_button:
    human_message = HumanMessage(content=f"""
    Сформулировать пользовательскую историю: 
    Описание: {user_story_description}
    Контекст: Вы действуете в роли опытного системного аналитика.
    Требования: Дайте чёткий, лаконичный ответ, соответствующий вашему уровню компетенции.
    Пример: Как пользователь приложения, я хочу получать уведомления, чтобы сразу видеть сообщения при их поступлении.
    Шаблон: Как пользователь, я хочу иметь возможность [функционал], чтобы [преимущество].
    """)
    msgs.append(human_message)
    answer = giga([system_message] + msgs)
    msgs.append(answer)
    st.markdown(f"**Ответ:** {answer.content}")

if improve_us_button:
    human_message = HumanMessage(content=f"""
    Улучшение пользовательской истории: 
    Название: {user_story_title}
    Описание: {user_story_description}

    Предложите дополнительные сценарии использования, которые могут расширить функциональность этой user story. Подумайте о различных ролях пользователей, контекстах использования и возможных ограничениях.
    """)
    msgs.append(human_message)
    answer = giga([system_message] + msgs)
    msgs.append(answer)
    st.markdown(f"**Улучшения:** {answer.content}")

def extract_elements_from_user_story(user_story):
    elements = {}
    
    # Extract title
    match = re.search(r'(как пользователь, я хочу)(.*)', user_story, re.IGNORECASE)
    if match:
        elements['title'] = f"Просмотр каталога товаров онлайн"
        
    # Extract description
    match = re.search(r'(чтобы)(.*)', user_story, re.IGNORECASE)
    if match:
        elements['description'] = match.group(2).strip()
    
    # Extract participants
    elements['participants'] = ['Пользователь']
    
    # Extract preconditions
    elements['preconditions'] = ['Авторизация']
    
    # Extract triggers
    elements['triggers'] = ['Посещение страницы каталога']
    
    # Extract results
    elements['results'] = ['Возможность выбора и заказа товаров']
    
    # Extract main scenario
    elements['main_scenario'] = [
        '1. Пользователь заходит на сайт.',
        '2. Пользователь выбирает категорию "Товар".',
        '3. Пользователь просматривает доступные товары.',
        '4. Пользователь добавляет понравившиеся товары в корзину.',
        '5. Пользователь оформляет заказ.'
    ]
    
    # Extract extensions
    elements['extensions'] = [
        '3a. Если пользователь не находит нужный товар, система предлагает воспользоваться поиском.'
    ]
    
    return elements

def generate_use_case(elements):
    # Create a PrettyTable instance
    table = PrettyTable()
    table.field_names = ["Элемент", "Значение"]
    
    # Populate the table with extracted elements
    for key, value in elements.items():
        if isinstance(value, list):
            value = "\n".join(value)
        table.add_row([key.capitalize(), value])
    
    # Convert PrettyTable to Pandas DataFrame
    df = pd.DataFrame.from_records(table._rows, columns=table._field_names)
    
    return df

# Streamlit app logic
if generate_uc_button:
    human_message = HumanMessage(content=f"""
    Сформировать вариант использования:
    Название: {use_case_title}
    Описание: {use_case_description}

    Пример:
    Вариант использования: Поместить товар в корзину
    Область действия: Мобильное приложение интернет-магазина
    Основное действующее лицо: Зарегистрированный пользователь мобильного приложения
    Второстепенное действующее лицо: Интернет-магазин
    Предусловие: Пользователь аутентифицировался в системе и находится на детальной странице товара.
    Гарантии успеха: Товар успешно добавлен в корзину пользователя.
    Триггер: Пользователь нажимает кнопку "Добавить в корзину" на детальной странице товара.
    Описание:
    1. Пользователь выбирает количество товара, которое он хочет добавить в корзину.
    2. Система проверяет доступность выбранного количества товара на складе.
    3. Система уведомляет пользователя о доступности товара.
    4. Если товар доступен, система запрашивает подтверждение добавления товара в корзину.
    5. Пользователь подтверждает добавление товара в корзину.
    6. Система добавляет выбранный товар в корзину пользователя.
    7. Система уведомляет пользователя об успешном добавлении товара в корзину.
    8. Пользователь продолжает взаимодействие с приложением.
    Расширение:
    3.1. Если выбранное количество товара недоступно, система предлагает пользователю изменить количество или выбрать другой товар.
    3.2. Пользователь изменяет количество товара или выбирает другой товар.
    3.3. Система возвращает пользователя к шагу 2.
    """)
    msgs.append(human_message)
    answer = giga([system_message] + msgs)
    msgs.append(answer)
    st.markdown(f"**Ответ:** {answer.content}")

if improve_uc_button:
    human_message = HumanMessage(content=f"Improve Use Case: Title: {use_case_title}, Description: {use_case_description}")
    msgs.append(human_message)
    answer = giga([system_message] + msgs)
    msgs.append(answer)

    # Преобразуем ответ в таблицу
    rows = answer.content.split("\n")
    df = pd.DataFrame({"Ответ системы": rows})

    # Добавляем новый столбец 'Рекомендация' и заполняем его значениями из первого столбца
    df['Рекомендация'] = df['Ответ системы'].apply(lambda x: x.split(':')[0].strip())
    df['Значение'] = df['Ответ системы'].apply(lambda x: x.split(':', maxsplit=1)[1].strip() if ':' in x else '')

    # Удаляем исходный столбец 'Ответ системы'
    del df['Ответ системы']

    st.markdown(f"**Рекомендации по улучшению:**")
    st.table(df)

if generate_ac_button:
    human_message = HumanMessage(content=f"""
    Сформулировать критерии приемки: 
    Название: {acceptance_criteria_title}
    Описание: {acceptance_criteria_description}
    Контекст: Вы действуете в роли опытного тестировщика.
    Требования: Дайте чёткие, формализованные критерии приемки, соответствующие стандартам качества.
    Пример: Функциональность - Генерация отчетов. Дано - Пользователь авторизован в системе. Когда - Пользователь выбирает период и формат отчета. Тогда - Система генерирует отчет в выбранном формате и отправляет его на электронную почту пользователя.
    Шаблон: Функциональность - [название функции]. Дано - [начальное состояние]. Когда - [действие пользователя]. Тогда - [ожидаемый результат].
    """)
    msgs.append(human_message)
    answer = giga([system_message] + msgs)
    msgs.append(answer)
    st.markdown(f"**Ответ:** {answer.content}")

if improve_ac_button:
    human_message = HumanMessage(content=f"""Улучшить критерии приемки: Заголовок: {acceptance_criteria_title}. Описание: {acceptance_criteria_description}.
    
Критерии приемки должны соответствовать следующему шаблону: Функциональность - [Название функции]. Дано - [Начальное состояние]. Когда - [Действие пользователя]. Тогда - [Ожидаемый результат].
    
Пример: Функциональность - Генерация отчетов. Дано - Пользователь авторизован в системе. Когда - Пользователь выбирает период и формат отчета. Тогда - Система генерирует отчет в выбранном формате и отправляет его на электронную почту пользователя.""")
    msgs.append(human_message)
    answer = giga([system_message] + msgs)
    msgs.append(answer)
    st.markdown(f"**Ответ:** {answer.content}")