#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//AS
	УстановитьУсловноеОформление();
	//AS
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВКМ_ОтпускаСотрудников
&НаКлиенте
Процедура ВКМ_ОтпускаСотрудниковВКМ_ДатаНачалаПриИзменении(Элемент)
		//AS  
	    ЗаполнитьКоличествоДней();
	   //AS
КонецПроцедуры

#КонецОбласти  



#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ОткрытьДиаграмму(Команда)
	//AS
	ПараметрыФормы = Новый Структура("Ключ", Объект.Ссылка);
	ОткрытьФорму("Документ.ВКМ_ГрафикОтпусков.Форма.ВКМ_АнализГрафика", ПараметрыФормы);
	//AS
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьКоличествоДней()
	//AS
	Перем ТекДанные;
	
	ТекДанные = Элементы.ВКМ_ОтпускаСотрудников.ТекущиеДанные; 
	Если ЗначениеЗаполнено(ТекДанные.ВКМ_ДатаОкончания)
		И ЗначениеЗаполнено(ТекДанные.ВКМ_ДатаНачала) Тогда 
		ТекДанные.ВКМ_ВсегоДней = (ТекДанные.ВКМ_ДатаОкончания - ТекДанные.ВКМ_ДатаНачала) / 60 / 60 / 24;  
	КонецЕсли;
    //AS
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	//+AS
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
	//-AS
КонецПроцедуры

&НаКлиенте
Процедура ВКМ_ОтпускаСотрудниковВКМ_ДатаОкончанияПриИзменении(Элемент)
		//AS  
	    ЗаполнитьКоличествоДней();
	   //AS
КонецПроцедуры
#КонецОбласти





