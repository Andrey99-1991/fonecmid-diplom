
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	ВыполнитьОбработку();
	ОбщегоНазначенияКлиент.СообщитьПользователю("Обработка завершена!",, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьОбработку()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
    ОбработкаОбъект.ЗаполнитьГрафик(ВыборПериода.ДатаНачала, ВыборПериода.ДатаОкончания, ВыходныеДни);	
	
КонецПроцедуры

#КонецОбласти
