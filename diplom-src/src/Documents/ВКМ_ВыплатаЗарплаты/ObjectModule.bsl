
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_ВыплатаЗарплатыВКМ_Выплаты.ВКМ_Сотрудник,
	|	СУММА(ВКМ_ВыплатаЗарплатыВКМ_Выплаты.ВКМ_Сумма) КАК ВКМ_Сумма
	|ИЗ
	|	Документ.ВКМ_ВыплатаЗарплаты.ВКМ_Выплаты КАК ВКМ_ВыплатаЗарплатыВКМ_Выплаты
	|ГДЕ
	|	ВКМ_ВыплатаЗарплатыВКМ_Выплаты.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_ВыплатаЗарплатыВКМ_Выплаты.ВКМ_Сотрудник";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
		Движение.Период = ВКМ_ПериодРегистрации;
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.ВКМ_Сотрудник = Выборка.ВКМ_Сотрудник;
		Движение.ВКМ_Сумма = Выборка.ВКМ_Сумма;	
	КонецЦикла;
	
	Движения.ВКМ_ВзаиморасчетыССотрудниками.БлокироватьДляИзменения = Истина;
	
	Движения.Записать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	МИНИМУМ(ВКМ_ВыплатаЗарплатыВКМ_Выплаты.НомерСтроки) КАК НомерСтроки,
	|	ВКМ_ВыплатаЗарплатыВКМ_Выплаты.ВКМ_Сотрудник
	|ПОМЕСТИТЬ ВТДанные
	|ИЗ
	|	Документ.ВКМ_ВыплатаЗарплаты.ВКМ_Выплаты КАК ВКМ_ВыплатаЗарплатыВКМ_Выплаты
	|ГДЕ
	|	ВКМ_ВыплатаЗарплатыВКМ_Выплаты.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_ВыплатаЗарплатыВКМ_Выплаты.ВКМ_Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_Сотрудник,
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_СуммаОстаток,
	|	ВТДанные.НомерСтроки
	|ИЗ
	|	ВТДанные КАК ВТДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками.Остатки(&Период,) КАК
	|			ВКМ_ВзаиморасчетыССотрудникамиОстатки
	|		ПО ВТДанные.ВКМ_Сотрудник = ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_Сотрудник
	|ГДЕ
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_СуммаОстаток < 0";
	МоментВремениНовый = Новый МоментВремени(ВКМ_ПериодРегистрации, Ссылка);
	ГраницаНовый = Новый Граница(МоментВремениНовый, ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Период", ГраницаНовый);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Ошибки = Неопределено;
	Пока Выборка.Следующий() Цикл	
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ВКМ_Выплаты[%1].ВКМ_Сотрудник",
				СтрШаблон(НСтр("ru='Отрицательный остаток на строке %1'"), Выборка.НомерСтроки-1),"Объект.ВКМ_Выплаты", Выборка.НомерСтроки-1,
				НСтр("ru='Отрицательный остаток на строке %1'"), Выборка.НомерСтроки-1);
	КонецЦикла;
	
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки,Отказ);
	КонецЕсли;
	 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоОстаткамРегистраВзаиморасчетов() Экспорт

	ВКМ_Выплаты.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_Сотрудник,
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_СуммаОстаток
	|ИЗ
	|	РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками.Остатки(&Период,) КАК ВКМ_ВзаиморасчетыССотрудникамиОстатки
	|ГДЕ
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВКМ_СуммаОстаток > 0";
	Запрос.УстановитьПараметр("Период", КонецМесяца(ВКМ_ПериодРегистрации));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаВыплата = ВКМ_Выплаты.Добавить();
		СтрокаВыплата.ВКМ_Сотрудник = Выборка.ВКМ_Сотрудник;
		СтрокаВыплата.ВКМ_Сумма = Выборка.ВКМ_СуммаОстаток;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли