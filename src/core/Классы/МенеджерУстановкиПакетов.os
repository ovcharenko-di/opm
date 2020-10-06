#Использовать fluent
#Использовать fs
#Использовать logos
#Использовать tempfiles

Перем Лог;
Перем мВременныйКаталогУстановки;

Перем ТекущийРежимУстановкиПакетов;
Перем КэшУстановленныхПакетов;
Перем ЦелевойКаталогУстановки;
Перем КаталогУстановкиЗависимостей;
Перем КаталогСистемныхБиблиотек;
Перем КешУстановленныхПакетов;
Перем ИмяСервера;

Перем УстанавливатьЗависимости;
Перем УстанавливатьЗависимостиРазработчика;
Перем СоздаватьФайлыЗапуска;

Процедура ПриСозданииОбъекта(Знач ВходящийРежимУстановкиПакетов = Неопределено, Знач ВходящийКаталогУстановки = Неопределено, Знач ВходящийКаталогУстановкиЗависимостей = Неопределено, Знач ВходящийИмяСервера = "")
	
	ПутьККаталогуЛокальнойУстановки = ОбъединитьПути(
					ТекущийКаталог(),
					КонстантыOpm.ЛокальныйКаталогУстановкиПакетов
				);

	Если Не ВходящийРежимУстановкиПакетов = Неопределено Тогда
		УстановитьРежимУстановкиПакетов(ВходящийРежимУстановкиПакетов);
	Иначе
		УстановитьРежимУстановкиПакетов(РежимУстановкиПакетов.Глобально);
	КонецЕсли;

	Если Не ВходящийКаталогУстановки = Неопределено Тогда
		УстановитьЦелевойКаталог(ВходящийКаталогУстановки);
	ИначеЕсли ТекущийРежимУстановкиПакетов = РежимУстановкиПакетов.Локально Тогда
		УстановитьЦелевойКаталог(ПутьККаталогуЛокальнойУстановки);
	Иначе
		КаталогСистемныхБиблиотек = ПолучитьКаталогСистемныхБиблиотек();
		УстановитьЦелевойКаталог(КаталогСистемныхБиблиотек);
	КонецЕсли;

	Если Не ВходящийКаталогУстановкиЗависимостей = Неопределено Тогда
		УстановитьКаталогЗависимостей(ВходящийКаталогУстановкиЗависимостей);
	Иначе
		Если ТекущийРежимУстановкиПакетов = РежимУстановкиПакетов.Локально Тогда
			УстановитьКаталогЗависимостей(ПутьККаталогуЛокальнойУстановки);
		Иначе
			КаталогСистемныхБиблиотек = ПолучитьКаталогСистемныхБиблиотек();
			УстановитьКаталогЗависимостей(КаталогСистемныхБиблиотек);
		КонецЕсли;
	КонецЕсли;

	КешУстановленныхПакетов = Новый Соответствие;
	УстанавливатьЗависимости = Истина;
	УстанавливатьЗависимостиРазработчика = Ложь;
	СоздаватьФайлыЗапуска = Истина;
	ИмяСервера = ВходящийИмяСервера;
КонецПроцедуры

Процедура УстанавливатьЗависимости(Знач ПУстанавливатьЗависимости) Экспорт
	УстанавливатьЗависимости = ПУстанавливатьЗависимости;
КонецПроцедуры

Процедура УстанавливатьЗависимостиРазработчика(Знач ПУстанавливатьЗависимостиРазработчика) Экспорт
	УстанавливатьЗависимостиРазработчика = ПУстанавливатьЗависимостиРазработчика;
КонецПроцедуры

Процедура СоздаватьФайлыЗапуска(Знач ПСоздаватьФайлыЗапуска) Экспорт
	СоздаватьФайлыЗапуска = ПСоздаватьФайлыЗапуска;
КонецПроцедуры

Процедура УстановитьРежимУстановкиПакетов(Знач ЗначениеРежимУстановкиПакетов) Экспорт
	
	ТекущийРежимУстановкиПакетов = ЗначениеРежимУстановкиПакетов;

	Если ТекущийРежимУстановкиПакетов = РежимУстановкиПакетов.Локально Тогда
		ПутьККаталогуЛокальнойУстановки = ОбъединитьПути(
			ТекущийКаталог(),
			КонстантыOpm.ЛокальныйКаталогУстановкиПакетов
		);
		Если КаталогУстановкиЗависимостей = КаталогСистемныхБиблиотек Тогда
			УстановитьКаталогЗависимостей(ПутьККаталогуЛокальнойУстановки);
		КонецЕсли;
	
	Иначе
		УстановитьКаталогЗависимостей(КаталогСистемныхБиблиотек);
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьЦелевойКаталог(Знач ЗначениеЦелевойКаталогУстановки) Экспорт
	Лог.Отладка("Каталог установки пакета '%1'", ЗначениеЦелевойКаталогУстановки);
	ФС.ОбеспечитьКаталог(ЗначениеЦелевойКаталогУстановки);
	ЦелевойКаталогУстановки = ЗначениеЦелевойКаталогУстановки;
КонецПроцедуры

Процедура УстановитьКаталогЗависимостей(Знач ВыходящийКаталог) Экспорт

	КаталогУстановкиЗависимостей = ВыходящийКаталог;
	
КонецПроцедуры

Процедура УстановитьПакетПоОписанию(Знач ЗависимостьПакета) Экспорт
	
	Если ЗависимостьПакета.ДляРазработки Тогда
		Если УстанавливатьЗависимостиРазработчика Тогда
			Лог.Информация("<%1> отмечена как зависимость для разработчика. Устанавливаем.", ЗависимостьПакета.ИмяПакета);
		Иначе
			Лог.Информация("<%1> отмечена как зависимость для разработчика, " + 
				"но установка зависимостей для разработчика не активирована. Пропускаем.", ЗависимостьПакета.ИмяПакета);
			Возврат;
		КонецЕсли;
	КонецЕсли;

	УстановитьПакетПоИмениИВерсии(ЗависимостьПакета.ИмяПакета, ЗависимостьПакета.МинимальнаяВерсия, Истина);

КонецПроцедуры

Процедура УстановитьПакетИзАрхива(Знач ФайлПакета, 
								Знач ЭтоЗависимыйПакет = Ложь, 
								Знач УдалятьКаталогПриОшибкеУстановки = Истина) Экспорт
	
	КаталогУстановки = ?(ЭтоЗависимыйПакет, КаталогУстановкиЗависимостей, ЦелевойКаталогУстановки);
	УстановкаПакета = Новый УстановкаПакета();
	УстановкаПакета.СоздаватьФайлЗапуска(СоздаватьФайлыЗапуска);
	УстановкаПакета.УстановитьЦелевойКаталог(КаталогУстановки);
	Лог.Отладка("КаталогУстановки: %1", КаталогУстановки);
	Если ЭтоЗависимыйПакет Тогда
		УстановкаПакета.УстановитьКешПакетов(КешУстановленныхПакетов);
	КонецЕсли;
	Лог.Отладка("ТекущийРежимУстановкиПакетов: %1", ТекущийРежимУстановкиПакетов);
	УстановкаПакета.УстановитьРежимУстановкиПакета(ТекущийРежимУстановкиПакетов);
	
	Попытка
		УстановкаПакета.УстановитьПакетИзАрхива(ФайлПакета, УдалятьКаталогПриОшибкеУстановки);
	Исключение
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;
		
	МанифестПакета = УстановкаПакета.ПолучитьМанифестПакета();
	ИмяПакета = МанифестПакета.Свойства().Имя;

	ПолныйПутьККаталогуУстановки = Новый Файл(КаталогУстановки).ПолноеИмя;
	ИмяКаталогаЛокальныхЗависимостей = КонстантыOpm.ЛокальныйКаталогУстановкиПакетов;

	ПутьККаталогуЛокальныхЗависимостей = ОбъединитьПути(ПолныйПутьККаталогуУстановки, ИмяПакета, ИмяКаталогаЛокальныхЗависимостей);

	Если УстанавливатьЗависимости Тогда
		// Тут надо корректно найти имя пакета в пути
		Если ФС.КаталогСуществует(ПутьККаталогуЛокальныхЗависимостей) Тогда
			РазрешитьЗависимостиПакетаЛокально(МанифестПакета, ПутьККаталогуЛокальныхЗависимостей);
		Иначе
			РазрешитьЗависимостиПакета(МанифестПакета);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПакетПоИмениИВерсии(Знач ИмяПакета, Знач ВерсияПакета, ЗНач ЭтоЗависимыйПакет = Ложь) Экспорт
	
	ФайлПакета = РаботаСПакетами.ПолучитьПакет(ИмяПакета, ВерсияПакета, , ИмяСервера);
	УстановитьПакетИзАрхива(ФайлПакета, ЭтоЗависимыйПакет);

КонецПроцедуры

Процедура РазрешитьЗависимостиПакета(Знач Манифест) Экспорт
	
	Зависимости = Манифест.Зависимости();
	Если Зависимости.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановленныеПакеты = ПолучитьУстановленныеПакеты();

	Для Каждого Зависимость Из Зависимости Цикл
		Лог.Информация("Устанавливаю зависимость: " + Зависимость.ИмяПакета);

		Если Не УстановленныеПакеты.ПакетУстановлен(Зависимость, КаталогУстановкиЗависимостей) Тогда
			// скачать
			// определить зависимости и так по кругу
			УстановитьПакетПоОписанию(Зависимость);
			УстановленныеПакеты.Обновить();
		Иначе
			Лог.Информация("" + Зависимость.ИмяПакета + " уже установлен. Пропускаем.");
			// считаем, что версия всегда подходит
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура РазрешитьЗависимостиПакетаЛокально(Манифест, ПутьККаталогуЛокальныхЗависимостей)
	
	Зависимости = Манифест.Зависимости();
	Если Зависимости.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановленныеПакеты = ПолучитьУстановленныеПакеты();

	Для Каждого Зависимость Из Зависимости Цикл
		Лог.Информация("Устанавливаю зависимость: <%1> из каталога локальных зависимостей", Зависимость.ИмяПакета);

		Если УстановленныеПакеты.ПакетУстановлен(Зависимость, КаталогУстановкиЗависимостей) Тогда
			Лог.Информация("<%1> уже установлен. Пропускаем.", Зависимость.ИмяПакета);
			Продолжить;
		КонецЕсли;
		
		ПутьККаталогуПакетаЗависимостиИсточник = ОбъединитьПути(ПутьККаталогуЛокальныхЗависимостей, Зависимость.ИмяПакета);

		Если ФС.КаталогСуществует(ПутьККаталогуПакетаЗависимостиИсточник) Тогда

			ПутьККаталогуПакетаЗависимостиПриемник = ОбъединитьПути(КаталогУстановкиЗависимостей, Зависимость.ИмяПакета);
			ФС.КопироватьСодержимоеКаталога(ПутьККаталогуПакетаЗависимостиИсточник, ПутьККаталогуПакетаЗависимостиПриемник);
		
		Иначе

			УстановитьПакетПоОписанию(Зависимость);
		
		КонецЕсли;

		УстановленныеПакеты.Обновить();

	КонецЦикла;

КонецПроцедуры

Функция ПолучитьУстановленныеПакеты()
	
	КэшУстановленныхПакетов = Новый КэшУстановленныхПакетов(КаталогУстановкиЗависимостей);

	Возврат КэшУстановленныхПакетов;

КонецФункции

Функция ПолучитьКаталогСистемныхБиблиотек()
	
	СистемныеБиблиотеки = ОбъединитьПути(КаталогПрограммы(), ПолучитьЗначениеСистемнойНастройки("lib.system"));
	Лог.Отладка("СистемныеБиблиотеки %1", СистемныеБиблиотеки);
	Если СистемныеБиблиотеки = Неопределено Тогда
		ВызватьИсключение "Не определен каталог системных библиотек";
	КонецЕсли;
	
	Возврат СистемныеБиблиотеки;
	
КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.app.opm");
//Лог.УстановитьУровень(УровниЛога.Отладка);
