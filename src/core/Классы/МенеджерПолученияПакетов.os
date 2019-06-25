Перем Лог;

Перем ИндексДоступныхПакетов;
Перем ИндексКешаПакетов;
Перем ИндексСерверовПакетов;

Процедура ПриСозданииОбъекта()

	Инициализировать();

КонецПроцедуры

Функция ПолучитьПакет(Знач ИмяПакета, Знач ВерсияПакета, ПутьКФайлуПакета = "", ИмяСервера = "") Экспорт

	Если Не ПакетДоступен(ИмяПакета) Тогда
		
		ТекстИсключения = СтрШаблон("Ошибка установки пакета %1: Пакет не найден", ИмяПакета);
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;

	ИмяПакета = ОпределитьИмяАрхива(ИмяПакета);
	
	Если ВерсияПакета <> Неопределено Тогда
		ФайлПакета = ИмяПакета + "-" + ВерсияПакета + ".ospx";
	Иначе
		ФайлПакета = ИмяПакета + ".ospx";
	КонецЕсли;
	
	Лог.Информация("Скачиваю файл: " + ФайлПакета);

	Если ПустаяСтрока(ПутьКФайлуПакета) Тогда
		ПутьКФайлуПакета = ВременныеФайлы.НовоеИмяФайла("ospx");
	КонецЕсли;

	ИмяРесурса = ИмяПакета + "/" + ФайлПакета;
	
	ПереченьСерверов = ИндексКешаПакетов[ИмяПакета];

	Ответ = ЗапроситьПакет(ПереченьСерверов, ИмяСервера, ИмяРесурса);
	
	Если Не Ответ = Неопределено Тогда
		Лог.Отладка("Файл получен");
		Ответ.ПолучитьТелоКакДвоичныеДанные().Записать(ПутьКФайлуПакета);
		Ответ.Закрыть();
		Лог.Отладка("Соединение закрыто");
	Иначе
		ТекстИсключения = СтрШаблон("Ошибка установки пакета %1: Нет соединения", ИмяПакета);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;

	Возврат ПутьКФайлуПакета;

КонецФункции

Функция ЗапроситьПакет(Знач ПереченьСерверов, Знач ИмяСервера, Знач ИмяРесурса)
	
	ПакетУспешноПолучен = Ложь;
	ОтветСервера = Неопределено;
	
	// Если указан нужный сервер, то только его и будем использовать 
	Если ЗначениеЗаполнено(ИмяСервера) Тогда
		
		Сервер = ИндексСерверовПакетов[ИмяСервера];
		ОтветСервера = ЗапроситьПакетССервера(Сервер, ИмяРесурса);

	Иначе
		
		// поиск пакета на серверах
		Для Каждого ДоступныйСервер Из ПереченьСерверов Цикл
			
			Сервер = ИндексСерверовПакетов[ДоступныйСервер.Ключ];
			ОтветСервера = ЗапроситьПакетССервера(Сервер, ИмяРесурса);
			Если ОтветСервера <> Неопределено Тогда
				
				Прервать;

			КонецЕсли;
			
		КонецЦикла;

	КонецЕсли;

	Если ОтветСервера <> Неопределено Тогда
		
		Лог.Отладка("Ресурс %1 успешно получен с %2", ИмяРесурса, Сервер.ПолучитьИмя());
		Возврат ОтветСервера;

	КонецЕсли;

	Возврат Неопределено;

КонецФункции

Функция ЗапроситьПакетССервера(Сервер, ИмяРесурса)
	
	ОтветСервера = Неопределено;
	Если Сервер.СерверДоступен() Тогда
			
		ОтветСервера = Сервер.ПолучитьРесурс(ИмяРесурса);
		Если ОтветСервера <> Неопределено Тогда
			
			Если ОтветСервера.КодСостояния = 200 Тогда
						
				Возврат ОтветСервера;
						
			КонецЕсли;

			ОтветСервера.Закрыть();

			Лог.Информация("Ошибка подключения к хабу %1 <%2>",
							Сервер.ПолучитьИмя(),
							ОтветСервера.КодСостояния);
							
			ОтветСервера = Неопределено;
			
		КонецЕсли;

	КонецЕсли;
	
	Возврат ОтветСервера;
	
КонецФункции

// Функция по имени пакета определяет имя архива в хабе
// https://github.com/oscript-library/opm/issues/50
// Имена файлов в хабе регистрозависимы, однако имена пакетов по обыкновению регистронезависимы
Функция ОпределитьИмяАрхива(Знач ИмяПакета)
  
	Если ИндексДоступныхПакетов.Получить(ИмяПакета) = Неопределено Тогда
 
		Для Каждого мПакет Из ИндексДоступныхПакетов Цикл
 
			// Проводим регистронезависимое сравнение имён
			Если нрег(мПакет.Ключ) = нрег(ИмяПакета) Тогда
 
				// и возвращаем ровно то имя, которое хранится в хабе (с учётом регистра)
				Возврат мПакет.Ключ;
 
			КонецЕсли;
 
		КонецЦикла;
 
	КонецЕсли;
 
	Возврат ИмяПакета;
 
КонецФункции

Процедура Инициализировать()
	
	Лог.Отладка("Менеджер получения пакетов инициализация - НАЧАЛО");
	ОбновитьИндексСерверовПакетов();
	ОбновитьИндексКешаПакетов();
	ОбновитьИндексДоступныхПакетов();
	Лог.Отладка("Менеджер получения пакетов инициализация - ЗАВЕРШЕНО");
	
КонецПроцедуры

Функция ПолучитьДоступныеПакеты() Экспорт
	
	Возврат Новый ФиксированноеСоответствие(ИндексКешаПакетов);
	
КонецФункции

Функция ПакетДоступен(Знач ИмяПакета) Экспорт
	
	Если ИндексДоступныхПакетов.Получить(ИмяПакета) = Неопределено Тогда
 
		Для Каждого мПакет Из ИндексДоступныхПакетов Цикл
 
			// Проводим регистронезависимое сравнение имён
			Если нрег(мПакет.Ключ) = нрег(ИмяПакета) Тогда
 
				// и возвращаем ровно то имя, которое хранится в хабе (с учётом регистра)
				Возврат Истина;
 
			КонецЕсли;
 
		КонецЦикла;
 
	Иначе
		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;

КонецФункции

Процедура ОбновитьИндексСерверовПакетов() Экспорт
	
	ИндексСерверовПакетов = Новый Соответствие;

	Настройки = НастройкиOpm.ПолучитьНастройки();
	СервераПакетов = Настройки.СервераПакетов;

	Для каждого НастройкаСервера Из СервераПакетов Цикл
		
		ТекущийСерверПакетов = СоздатьСерверПакетовПоНастройке(НастройкаСервера);
		ИндексСерверовПакетов.Вставить(НастройкаСервера.Имя, ТекущийСерверПакетов);

	КонецЦикла;

КонецПроцедуры

// ИменаДоступныхСерверов
//	Возвращает список доступных серверов-зеркал с пакетами
//  Возвращаемое значение:
//   Массив - Список имен
//
Функция ИменаДоступныхСерверов() Экспорт
	
	ИменаПакетов = Новый Массив();
	СервераПакетов = НастройкиOpm.ПолучитьНастройки().СервераПакетов;

	Для каждого НастройкаСервера Из СервераПакетов Цикл
		
		ИменаПакетов.Добавить(НастройкаСервера.Имя);
		
	КонецЦикла;
	
	Возврат ИменаПакетов;
	
КонецФункции

Функция СоздатьСерверПакетовПоНастройке(Знач НастройкаСервера)
	
	Возврат Новый СерверПакетов(НастройкаСервера.Имя, 
								НастройкаСервера.Сервер, 
								НастройкаСервера.ПутьНаСервере, 
								НастройкаСервера.РесурсПубликацииПакетов, 
								НастройкаСервера.Порт, 
								НастройкаСервера.Приоритет)

КонецФункции

Процедура ОбновитьИндексДоступныхПакетов() Экспорт

	// Учесть версии пакетов
	ИндексДоступныхПакетов = Новый Соответствие;
	
	Лог.Отладка("Обновляю кеш доступных пакетов");
		
	Для каждого ПакетКеша Из ИндексКешаПакетов Цикл
	
		ИндексДоступныхПакетов.Вставить(ПакетКеша.Ключ, Истина);

	КонецЦикла;
	
	Лог.Отладка("Кеш доступных пакетов - ОБНОВЛЕН");

КонецПроцедуры

Процедура ОбновитьИндексКешаПакетов() Экспорт

	ИндексКешаПакетов = Новый Соответствие;

	Для каждого ТекущийСерверПакетов Из ИндексСерверовПакетов Цикл
		
		ИмяСервера = ТекущийСерверПакетов.Ключ;
		КлассСервера = ТекущийСерверПакетов.Значение;

		Пакеты = КлассСервера.ПолучитьПакеты();
		
		Лог.Отладка("Добавляю в кеш пакеты <%2> сервера: %1", ИмяСервера, Пакеты.Количество());
		
		ДобавитьПакетыВИндексКеша(Пакеты, ИмяСервера);

	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьПакетыВИндексКеша(Знач ПакетыСервера, Знач ИмяСервера)

	Для каждого Пакет Из ПакетыСервера Цикл
		
		КлючПакета = Пакет.Ключ;
		ВерсииПакета = Пакет.Значение;
		Лог.Отладка("Добавляю пакет: %1 в кеш для сервера %2", КлючПакета, ИмяСервера);
		Если ИндексКешаПакетов[КлючПакета] = Неопределено Тогда
			ИндексКешаПакетов.Вставить(КлючПакета, Новый Соответствие);
		КонецЕсли;

		ИндексКешаПакетов[КлючПакета].Вставить(ИмяСервера, ВерсииПакета)

	КонецЦикла;
	
КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.app.opm");
