﻿#language: ru

@tree

Функционал: <описание фичи>

Как <Роль> я хочу
<описание функционала> 
чтобы <бизнес-эффект>   

Контекст:
	Дано Я подключаю  TestClient "ИмяКлиента" логин "Специалист" пароль "123"

Сценарий: <описание сценария>
И В командном интерфейсе я выбираю 'Отчеты' 'Анализ выставленных актов'
Тогда открылось окно 'Основной'
И я нажимаю кнопку выбора у поля с именем "КомпоновщикНастроекПользовательскиеНастройкиЭлемент0Значение"
Тогда открылось окно 'Выберите период'
И я нажимаю на кнопку с именем 'Select'
Тогда открылось окно 'Основной'
И я нажимаю на кнопку с именем 'СформироватьОтчет'
