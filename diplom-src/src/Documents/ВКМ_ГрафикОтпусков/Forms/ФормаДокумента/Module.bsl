#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВКМ_ОтпускаСотрудников

&НаКлиенте
Процедура ВКМ_ОтпускаСотрудниковВКМ_ДатаНачалаПриИзменении(Элемент)
	
	ЗаполнитьКоличествоДней();
	
КонецПроцедуры

#КонецОбласти  

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДиаграмму(Команда)
	
	ПараметрыФормы = Новый Структура("Ключ", Объект.Ссылка);
	АдресВх = ПоместитьДанныеВоВременноеХранилищеТз(); 
	ПараметрыФормы.Вставить("АдресВх", АдресВх);
	ОткрытьФорму("Документ.ВКМ_ГрафикОтпусков.Форма.ВКМ_АнализГрафика", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПоместитьДанныеВоВременноеХранилищеТз() 
	
	Адрес = ПоместитьВоВременноеХранилище(ЭтотОбъект.Объект.ВКМ_ОтпускаСотрудников.Выгрузить()); 
	
	Возврат Адрес;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьКоличествоДней()
	
	Перем ТекДанные;
	
	ТекДанные = Элементы.ВКМ_ОтпускаСотрудников.ТекущиеДанные; 
	Если ЗначениеЗаполнено(ТекДанные.ВКМ_ДатаОкончания)
		И ЗначениеЗаполнено(ТекДанные.ВКМ_ДатаНачала) Тогда 
		ТекДанные.ВКМ_ВсегоДней = ((ТекДанные.ВКМ_ДатаОкончания - ТекДанные.ВКМ_ДатаНачала) / 60 / 60 / 24 + 1);  
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ЦветПоле = Элемент.Поля.Элементы.Добавить();
	// Имя поля таблицы
	ЦветПоле.Поле = Новый ПолеКомпоновкиДанных("ВКМ_ОтпускаСотрудниковВКМ_Сотрудник");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ВКМ_ОтпускаСотрудников.ВКМ_ВсегоДней");
	
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 28;
	ОтборЭлемента.Использование = Истина;

	//Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.Красный);
	//Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	//Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Начальное значение'")); 
	Элемент.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВКМ_ОтпускаСотрудниковВКМ_ДатаОкончанияПриИзменении(Элемент)
	
	ЗаполнитьКоличествоДней();
	
КонецПроцедуры

#КонецОбласти





