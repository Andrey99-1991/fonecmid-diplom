
#Область ОбработчикиСобытийЭлементовТаблицыФормыСозданныеДокументы

&НаКлиенте
Процедура СозданныеДокументыДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

    НастройкиКД = Новый НастройкиКомпоновкиДанных;

    Отбор = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    Отбор.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ВКМ_ДатаНачала");
   	Отбор.ВидСравнения     = ВидСравненияКомпоновкиДанных.Меньше;
   	Отбор.ПравоеЗначение   = КонецМесяца(Объект.Период);
   	Отбор.Использование    = Истина;
   	Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
    
    Отбор = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
   	Отбор.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ВКМ_ДатаОкончания");
  	Отбор.ВидСравнения     = ВидСравненияКомпоновкиДанных.Больше;
  	Отбор.ПравоеЗначение   = НачалоМесяца(Объект.Период);
    Отбор.Использование    = Истина;
    Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;


    ПараметрыФормы = Новый Структура;
    ПараметрыФормы.Вставить("ФиксированныеНастройки", НастройкиКД);

    ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	//Запуск фонового задания на сервере.  
	ДлительнаяОперация = НачатьВыполнениеДлительнойОперации();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.Интервал = 1;
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
			ДлительнаяОперация,
			Новый ОписаниеОповещения("ВыполнениеДлительнойПроцедурыЗавершение",ЭтотОбъект),ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДоговорам(Команда)
	ЗаполнитьПоДоговорамНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НачатьВыполнениеДлительнойОперации()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Нстр("ru = 'Получение сложных данных'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Период",Объект.Период);
	СтруктураДанных.Вставить("МассивДоговоров",Объект.СозданныеДокументы.Выгрузить().ВыгрузитьКолонку("Договор"));
	Возврат ДлительныеОперации.ВыполнитьФункцию(УникальныйИдентификатор,"Обработки.ВКМ_МассовоеСозданиеАктов.СоздатьНаРеализации",СтруктураДанных);
	
КонецФункции 

&НаКлиенте
Процедура ВыполнениеДлительнойПроцедурыЗавершение(Результат, ДополнительныеПараметры) Экспорт
 
	Если Результат = Неопределено Тогда      
		 Возврат;
 	КонецЕсли; 
	
 	Если Результат.Статус = "Ошибка" Тогда
  		ПоказатьПредупреждение(,Результат.КраткоеПредставлениеОшибки);
	Иначе
		ДлительныеОперацииЗавершениеНаСервере(Результат.АдресРезультата);
		УдалитьИзВременногоХранилища(Результат.АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры
 
&НаСервере
Процедура ДлительныеОперацииЗавершениеНаСервере(АдресХранилища)
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища); 
	Объект.СозданныеДокументы.Загрузить(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДоговорамНаСервере()  
	
	Объект.СозданныеДокументы.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка Как Договор
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.АбоненскоеОбслуживание)
	|	И НЕ ДоговорыКонтрагентов.ПометкаУдаления"; 
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		 Стр = Объект.СозданныеДокументы.Добавить();
		 ЗаполнитьЗначенияСвойств(Стр,Выборка);
	 КонецЦикла;	
	 
КонецПроцедуры

#КонецОбласти