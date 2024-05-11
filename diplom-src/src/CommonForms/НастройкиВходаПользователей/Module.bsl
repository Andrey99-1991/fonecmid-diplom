///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказатьНастройкиВнешнихПользователей = Параметры.ПоказатьНастройкиВнешнихПользователей;
	
	ПредлагаемыеЗначенияНастроек = Новый Структура;
	ПредлагаемыеЗначенияНастроек.Вставить("МинимальнаяДлинаПароля", 8);
	ПредлагаемыеЗначенияНастроек.Вставить("МаксимальныйСрокДействияПароля", 30);
	ПредлагаемыеЗначенияНастроек.Вставить("МинимальныйСрокДействияПароля", 1);
	ПредлагаемыеЗначенияНастроек.Вставить("ЗапретитьПовторениеПароляСредиПоследних", 10);
	ПредлагаемыеЗначенияНастроек.Вставить("ПросрочкаРаботыВПрограммеДоЗапрещенияВхода", 45);
	
	Если ПоказатьНастройкиВнешнихПользователей Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВнешниеПользователи");
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Настройки входа внешних пользователей'");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПользователиСлужебный.НастройкиВхода().ВнешниеПользователи);
	Иначе
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПользователиСлужебный.НастройкиВхода().Пользователи);
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из ПредлагаемыеЗначенияНастроек Цикл
		Если ЗначениеЗаполнено(ЭтотОбъект[КлючИЗначение.Ключ]) Тогда
			ЭтотОбъект[КлючИЗначение.Ключ + "Включить"] = Истина;
		Иначе
			ЭтотОбъект[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
			Элементы[КлючИЗначение.Ключ].Доступность = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	ВидимостьГруппыВосстановлениеПароля = Ложь;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		Элементы.ПредупреждениеНастройкаВСервисе.Видимость = Истина;
		Элементы.ФормаЗаписатьИЗакрыть.Доступность = Ложь;
		Элементы.ГруппаНастройки.Доступность = Ложь;
		
	Иначе
		
		НастройкиВосстановленияПароля = ПользователиСлужебный.НастройкиВосстановленияПароля();
		Если НастройкиВосстановленияПароля <> Неопределено Тогда
			ВидимостьГруппыВосстановлениеПароля =
			    НастройкиВосстановленияПароля.СпособВосстановленияПароля
			  = ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы(
			        "ОтправкаКодаПодтвержденияПоЗаданнымПараметрам")
			Или НастройкиВосстановленияПароля.СпособВосстановленияПароля
			  = ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы(
			        "ОтправкаКодаПодтвержденияЧерезСтандартныйСервис");
		КонецЕсли;
	
	КонецЕсли;
	
	Элементы.ПредупреждениеВосстановлениеПароля.Видимость = ВидимостьГруппыВосстановлениеПароля;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПарольДолженОтвечатьТребованиямСложностиПриИзменении(Элемент)
	
	Если МинимальнаяДлинаПароля < 7 Тогда
		МинимальнаяДлинаПароля = 7;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МинимальнаяДлинаПароляПриИзменении(Элемент)
	
	Если МинимальнаяДлинаПароля < 7
	  И ПарольДолженОтвечатьТребованиямСложности Тогда
		
		МинимальнаяДлинаПароля = 7;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаВключитьПриИзменении(Элемент)
	
	ИмяНастройки = Лев(Элемент.Имя, СтрДлина(Элемент.Имя) - СтрДлина("Включить"));
	
	Если ЭтотОбъект[Элемент.Имя] = Ложь Тогда
		ЭтотОбъект[ИмяНастройки] = ПредлагаемыеЗначенияНастроек[ИмяНастройки];
	КонецЕсли;
	
	Элементы[ИмяНастройки].Доступность = ЭтотОбъект[Элемент.Имя];
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаСервере();
	Оповестить("Запись_НаборКонстант", Новый Структура, "НастройкиВходаПользователей");
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьНаСервере()
	
	Настройки = Пользователи.НовоеОписаниеНастроекВхода();
	Настройки.ПарольДолженОтвечатьТребованиямСложности = ПарольДолженОтвечатьТребованиямСложности;
	
	Для Каждого КлючИЗначение Из ПредлагаемыеЗначенияНастроек Цикл
		Если ЭтотОбъект[КлючИЗначение.Ключ + "Включить"] Тогда
			Настройки[КлючИЗначение.Ключ] = ЭтотОбъект[КлючИЗначение.Ключ];
		Иначе
			Настройки[КлючИЗначение.Ключ] = 0;
		КонецЕсли;
	КонецЦикла;
	
	Пользователи.УстановитьНастройкиВхода(Настройки, ПоказатьНастройкиВнешнихПользователей);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
