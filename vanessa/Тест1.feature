﻿#language: ru

@tree


Функционал: <описание фичи>

Как <Роль> я хочу
<описание функционала> 
чтобы <бизнес-эффект>   

Контекст:
	Дано Я подключаю  TestClient "ИмяКлиента" логин "Менеджер" пароль "123"

Сценарий: <описание сценария>
И В командном интерфейсе я выбираю 'Обслуживание клиентов' 'Обслуживание клиентов'
Тогда открылось окно 'Обслуживание клиентов'
И я нажимаю на кнопку с именем 'ФормаСоздать'
Тогда открылось окно 'Обслуживание клиента (создание)'
И из выпадающего списка с именем "Клиент" я выбираю точное значение 'Интеррин'
И из выпадающего списка с именем "Договор" я выбираю точное значение 'Договор обслуживания за 2023 г.'
И в поле с именем 'ДатаПроведенияРабот' я ввожу текст '15.06.2024'
И я перехожу к следующему реквизиту
И в поле с именем 'ВремяНачалаРабот' я ввожу текст ' 8:00:00'
И я перехожу к следующему реквизиту
И в поле с именем 'ВремяОкончанияРабот' я ввожу текст '11:00:00'
И я перехожу к следующему реквизиту
И из выпадающего списка с именем "Специалист" я выбираю точное значение 'Андрей'
И в поле с именем 'ОписаниеПроблемы' я ввожу текст 'Обновление 1с'
И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
И я жду закрытия окна 'Обслуживание клиента (создание) *' в течение 20 секунд
Тогда открылось окно 'Обслуживание клиентов'
И я нажимаю на кнопку с именем 'ФормаСоздать'
Тогда открылось окно 'Обслуживание клиента (создание)'
И из выпадающего списка с именем "Клиент" я выбираю точное значение 'Интеррин'
И из выпадающего списка с именем "Договор" я выбираю точное значение 'Договор обслуживания за 2023 г.'
И в поле с именем 'ДатаПроведенияРабот' я ввожу текст '15.06.2024'
И я перехожу к следующему реквизиту
И в поле с именем 'ВремяНачалаРабот' я ввожу текст ' 8:00:00'
И я перехожу к следующему реквизиту
И в поле с именем 'ВремяОкончанияРабот' я ввожу текст '15:00:00'
И я перехожу к следующему реквизиту
И из выпадающего списка с именем "Специалист" я выбираю точное значение 'Влад'
И в поле с именем 'ОписаниеПроблемы' я ввожу текст 'Не работает принтер'
И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
И я жду закрытия окна 'Обслуживание клиента (создание) *' в течение 20 секунд
