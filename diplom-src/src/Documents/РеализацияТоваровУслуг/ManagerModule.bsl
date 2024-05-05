
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
        КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
        КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
        КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
        КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//+AS, 20240505
	// Акт
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Акт";
	КомандаПечати.Представление = НСтр("ru = 'Акт выполненных работ'");
	КомандаПечати.Порядок = 5;
	//-AS, 20240505
	
КонецПроцедуры

// Сформировать печатные формы объектов
//Параметры:
//   МассивОбъектов - ТаблицаЗначений - 
//ПараметрыПечати - ТаблицаЗначений - 
//КоллекцияПечатныхФорм - ТаблицаЗначений - 
//ОбъектыПечати - ТаблицаЗначений -
 //ПараметрыВывода - ТаблицаЗначений -
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	//+AS, 20240505
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Акт");
	Если ПечатнаяФорма <> Неопределено Тогда
		ПечатнаяФорма.ТабличныйДокумент = ПечатьАкта(МассивОбъектов, ОбъектыПечати);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт'");
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ПФ_MXL_ВКМ_Акт";
	КонецЕсли;
	//-AS, 20240505

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//+AS, 20240505
Функция ПечатьАкта(МассивОбъектов, ОбъектыПечати)

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Акт";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ПФ_MXL_ВКМ_Акт");

	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);

	ПервыйДокумент = Истина;

	Пока ДанныеДокументов.Следующий() Цикл

		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ПервыйДокумент = Ложь;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет);

		ВывестиРеквизитыСторон(ДанныеДокументов, ТабличныйДокумент, Макет);

		ВывестиТоварыУслуги(ДанныеДокументов, ТабличныйДокумент, Макет);

	//	ВывестиПодвалАкта(ДанныеДокументов, ТабличныйДокумент, Макет);
		
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,
			ДанныеДокументов.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции //-AS, 20240505

//+AS, 20240505
Функция ПолучитьДанныеДокументов(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
	|	РеализацияТоваровУслуг.Номер КАК Номер,
	|	РеализацияТоваровУслуг.Дата КАК Дата,
	|	РеализацияТоваровУслуг.Организация КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Организация) КАК ОрганизацияПредставление,
	|	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
	|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Контрагент) КАК КонтрагентПредставление,
	|	РеализацияТоваровУслуг.Договор КАК Договор,
	|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Договор) КАК ДоговорПредставление,
	|	РеализацияТоваровУслуг.СуммаДокумента КАК СуммаДокумента,
	|	РеализацияТоваровУслуг.Ответственный КАК Ответственный,
	|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Ответственный) КАК ОтветственныйПредставление,
	|	РеализацияТоваровУслуг.Товары.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		ПРЕДСТАВЛЕНИЕ(Номенклатура) КАК НоменклатураПредставление,
	|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ПРЕДСТАВЛЕНИЕ(Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма) КАК Товары,
	|	РеализацияТоваровУслуг.Услуги.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		ПРЕДСТАВЛЕНИЕ(Номенклатура) КАК НоменклатураПредставление,
	|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ПРЕДСТАВЛЕНИЕ(Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма) КАК Услуги
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка В (&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Возврат Запрос.Выполнить().Выбрать();
		
КонецФункции //-AS, 20240505

Процедура ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьЗаголовокДокумента = Макет.ПолучитьОбласть("Заголовок");
	
	ДанныеПечати = Новый Структура;
	
	ШаблонЗаголовка = "Акт %1 от %2";
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	
	ОбластьЗаголовокДокумента.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьЗаголовокДокумента);
	
КонецПроцедуры

Процедура ВывестиРеквизитыСторон(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьОрганизацияКонтрагент = Макет.ПолучитьОбласть("ОрганизацияКонтрагент");
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("Контрагент", ДанныеДокументов.КонтрагентПредставление);
	ДанныеПечати.Вставить("Договор", ДанныеДокументов.ДоговорПредставление);
	ДанныеПечати.Вставить("Организация", ДанныеДокументов.ОрганизацияПредставление);
	
	ОбластьОрганизацияКонтрагент.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьОрганизацияКонтрагент);
		
КонецПроцедуры

Процедура ВывестиТоварыУслуги(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьИтого = Макет.ПолучитьОбласть("Итого");
	
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	ВыборкаТовары = ДанныеДокументов.Товары.Выбрать();
	Пока ВыборкаТовары.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(ВыборкаТовары);
		ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ВыборкаУслуги = ДанныеДокументов.Услуги.Выбрать();
	Пока ВыборкаУслуги.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(ВыборкаУслуги);
		ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	//ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("Всего", ДанныеДокументов.СуммаДокумента);
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	//ПрописьЧисла = ЧислоПрописью(2341.56, ФормСтрока, ПарПредмета);
	//ПараметрыВалюты = "рубль, рубля, рублей, м,,,,,0";
	ОбластьИтого.Параметры.СуммаПрописью = ЧислоПрописью(ДанныеДокументов.СуммаДокумента,ФормСтрока, ПарПредмета);
	ОбластьИтого.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьИтого);
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
КонецПроцедуры

#КонецОбласти

#КонецЕсли