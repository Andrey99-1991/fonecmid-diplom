#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//+AS, 20240503
	КомандаЗаполнить = Команды.Добавить("ВКМ_Заполнить");
	КомандаЗаполнить.Действие = "Подключаемый_ВКМ_Заполнить";
	КомандаЗаполнить.ИзменяетСохраняемыеДанные = Истина;
	
	КнопкаЗаполнить = Элементы.Добавить("Заполнить", Тип("КнопкаФормы"), Элементы.Товары.КоманднаяПанель);
	КнопкаЗаполнить.Заголовок = "Заполнить";
	КнопкаЗаполнить.ИмяКоманды = "ВКМ_Заполнить";
	//-AS, 20240503
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	РассчитатьСуммуСтроки(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	РассчитатьСуммуСтроки(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)

	РассчитатьСуммуДокумента();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУслуги

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;

	РассчитатьСуммуСтроки(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;

	РассчитатьСуммуСтроки(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура УслугиПриИзменении(Элемент)

	РассчитатьСуммуДокумента();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
//+AS, 20240503
Процедура Подключаемый_ВКМ_Заполнить(Команда)
	
	ВКМ_ЗаполнитьНаСервере();

КонецПроцедуры //-AS, 20240503

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РассчитатьСуммуСтроки(ТекущиеДанные)

	ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество;

	РассчитатьСуммуДокумента();

КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуДокумента()

	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");

КонецПроцедуры

&НаСервере
//+AS, 20240503
Процедура ВКМ_ЗаполнитьНаСервере()
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Договор, "ВидДоговора") <> Перечисления.ВидыДоговоровКонтрагентов.АбоненскоеОбслуживание Тогда
		Возврат;	
	КонецЕсли;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");	
	ДокументОбъект.ВыполнитьАвтозаполнение();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры //-AS, 20240503

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти