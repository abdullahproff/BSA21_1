# 03. Use Case

## Заголовок
Добавление данных о приеме пищи с помощью приложения
## Акторы
Пользователи приложения, (сторонняя система?)
## Предусловия
- Приложение "Здоровье" установлено на устройство, поддерживающее IOS
- Устройство имеет достаточный заряд для работы
- Пользователь авторизован в приложении
- Приложение заупщено
- Пользователь находится на главном экране Аналитики Дневника Питания
## Ограничения
- 
## Триггер
Пользователь нажимает кнопку "Добавить прием пищи"
## Основной сценарий
1. Система отображает экран Добавления приема пищи
2. Клиент выбирает тип приема, редактирует/оставляет текущие дату и время, нажимает кнопку "Добавить продукт"
3. Система отображает экран Выбора продукта
4. Клиент добавляет касанием нужные продукты, при необходимости пользуется поиском , редактирует вес продуктов при необходимости (касание по полю "Вес"), нажимает кнопку "Сохранить"
5. Система отображает экран Добавления приема пищи
6. Клиент нажимает кнопку "Сохранить"
7. Система сохраняет данные о приеме пищи в историю, отображает главный экран Аналитики с обновленными диаграммами в соответсвии с сохраненными данными
## Альтернативный сценарий
2. а. Клиент не нашел нужный продукт и нажимает кнопку "Добавить новый продукт"
3. а. Система отображает экран Создания/редактирования продукта
4. а. Клиент заполняет обязательные поля для нового продукта и нажимает кнопку "Сохранить"
5. а. Система сохраняет изменения о новом продукте и добавляет его в базу продуктов
- Переход к шагу 3 основного сценария 

2. б. Клиент хочет отредактировать существующий пордукт и свайпает по нему вправо и нажимает на появившуюся иконку "Редактировать"
3. б. Система отображает экран Создания/редактирования продукта
## Исключительный сценарий
2. а. Клиент нажимает кнопку "Отменить сохранение"
3. а. Система отображает главный экран Аналитики без сохранения данных о приеме пищи
## Результат/Критерии успеха
Прием пищи сохранен в историю, экран Аналитики обновлен в соответствии с сохраненными данными
