
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//+AS, 20240420
	Элементы.ГруппаАбоненскоеОбслуживание.Видимость = Ложь;
	Если Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.АбоненскоеОбслуживание") Тогда
		Элементы.ГруппаАбоненскоеОбслуживание.Видимость = Истина;
	КонецЕсли;
	//-AS, 20240420
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)
	
	//+AS, 20240420
	Элементы.ГруппаАбоненскоеОбслуживание.Видимость = Ложь;
	Если Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.АбоненскоеОбслуживание") Тогда
		Элементы.ГруппаАбоненскоеОбслуживание.Видимость = Истина;
	КонецЕсли;
	//-AS, 20240420

КонецПроцедуры

#КонецОбласти