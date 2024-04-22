
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//#Область ОписаниеПеременных
//Перем ЭтоНовыйДокумент;
//#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
//	Если ОбменДанными.Загрузка Тогда
//		Возврат;
//	КонецЕсли;
//
//	Если ЭтоНовый() Тогда
//		ТекстСообщения = СтрШаблон("Создан новый документ с датой %1 Дата,назначенный специалист %2", Дата,
//			ВКМ_Специалист);
//
//		ВКМ_Телеграмм.ЗаписатьСообщениеВСправочник(ТекстСообщения, Строка(Ссылка));
//	Иначе
//		ТекстСообщения = ПолучитьТекстИзменения();
//		Если ЗначениеЗаполнено(ТекстСообщения) Тогда
//			ВКМ_Телеграмм.ЗаписатьСообщениеВСправочник(ТекстСообщения, Строка(Ссылка));	
//			//ВКМ_Телеграмм.ОтправитьСообщениеВТелеграмм(ВКМ_ТекстСообщения);	
//		КонецЕсли;
//	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.ВКМ_ДатаНачала,
	|	ДоговорыКонтрагентов.ВКМ_ДатаОкончания,
	|	ДоговорыКонтрагентов.ВидДоговора,
	|	ДоговорыКонтрагентов.ВКМ_СтоимостьЧасаРаботы
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Ссылка = &Договор";

	Запрос.УстановитьПараметр("Договор", ВКМ_Договор);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Выборка.Следующий();
	ЭтоАбоненскоеОбслуживание = (Выборка.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.АбоненскоеОбслуживание);
	Если Не (ЭтоАбоненскоеОбслуживание И Дата >= Выборка.ВКМ_ДатаНачала И Дата <= Выборка.ВКМ_ДатаОкончания) Тогда
		Отказ = Истина;
		Если Не ЭтоАбоненскоеОбслуживание Тогда
			ТекстСообщения = "Договор не является договором абоненского обслуживания";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , ЭтотОбъект);
		Иначе
			ТекстСообщения = "Дата документа не входит в период действия договора";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;

	Если Не Отказ Тогда
		ИтогоЧасов = ВКМ_Работы.Итог("ВКМ_ЧасыКОплатеКлиенту");
		
		Движения.ВКМ_ВыполненныеКлиентуРаботы.Записывать = Истина;
		Движение = Движения.ВКМ_ВыполненныеКлиентуРаботы.Добавить();
		Движение.Период = Дата;
		Движение.ВКМ_Клиент =  ВКМ_Клиент;
		Движение.ВКМ_СуммаКОплате = Выборка.ВКМ_СтоимостьЧасаРаботы * ИтогоЧасов;
		Движение.ВКМ_КоличествоЧасов = ИтогоЧасов;		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

//#Область СлужебныеПроцедурыИФункции
//
//#КонецОбласти

#КонецЕсли