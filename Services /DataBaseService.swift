import Foundation // Импортируем модуль Foundation, содержащий базовые классы и функции
import SQLite3 // Импортируем модуль SQLite3 для работы с базой данных SQLite

// Определяем финальный класс DatabaseService для работы с базой данных
final class DatabaseService {
    
    // Создаём статическую переменную для доступа к единственному экземпляру класса
    static let shared = DatabaseService()
    
    private var db: OpaquePointer? // Указатель на базу данных
    // Создаём последовательную очередь для выполнения операций с базой
    private let queue = DispatchQueue(label: "com.imyarek.database.queue", qos: .utility)
    
    // Приватный инициализатор, который вызывается при создании экземпляра класса
    private init() {
        openDatabase() // Открываем базу данных
        createTables() // Создаём необходимые таблицы
    }
    
    // Функция для открытия базы данных
    private func openDatabase() {
        // Получаем путь к директории документов пользователя (на симуляторе)
        guard let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("❌ Не удалось получить доступ к папке документов") // Завершаем выполнение, если не удалось получить путь
        }

        // Формируем путь до .sqlite файла
        let dbPath = docsUrl.appendingPathComponent("imyarek.sqlite").path

//        // ✅ Выводим путь в консоль
//        print("📂 Путь к базе данных: \(dbPath)")

        // Открываем базу
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            fatalError("❌ Не удалось открыть базу данных по пути \(dbPath)") // Завершаем выполнение, если не удалось открыть базу
        }
    }

    // Функция для создания таблиц в базе данных
    private func createTables() {
        // SQL-запрос для создания таблицы пользователей
        let createUserTable = """
        CREATE TABLE IF NOT EXISTS User (
            ID TEXT PRIMARY KEY,
            Name TEXT,
            Description TEXT,
            SocialLinks TEXT,
            PhotoPath TEXT,
            BanStatus INTEGER DEFAULT 0
        );
        """
        
        // SQL-запрос для создания таблицы чатов
        let createChatTable = """
        CREATE TABLE IF NOT EXISTS Chat (
            ID TEXT PRIMARY KEY,
            User1ID TEXT,
            User2ID TEXT,
            StartTime INTEGER
        );
        """
        
        // SQL-запрос для создания таблицы сообщений
        let createMessageTable = """
        CREATE TABLE IF NOT EXISTS Message (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            ChatID TEXT,
            SenderID TEXT,
            Text TEXT,
            Timestamp INTEGER
        );
        """
        
        // SQL-запрос для создания таблицы жалоб
        let createComplaintTable = """
        CREATE TABLE IF NOT EXISTS Complaint (
            ID TEXT PRIMARY KEY,
            Reason TEXT,
            DateCreated INTEGER,
            UserID TEXT,
            MessageID INTEGER
        );
        """
        
        // Выполняем SQL-запросы на создание таблиц
        _ = executeSQL(createUserTable)
        _ = executeSQL(createChatTable)
        _ = executeSQL(createMessageTable)
        _ = executeSQL(createComplaintTable)
    }
    
    // Функция для выполнения SQL-запроса
    @discardableResult
    private func executeSQL(_ sql: String) -> Bool {
        var errorMessage: UnsafeMutablePointer<Int8>? = nil // Указатель на сообщение об ошибке
        let result = sqlite3_exec(db, sql, nil, nil, &errorMessage) // Выполняем SQL-запрос
        if result != SQLITE_OK, let errorMessage = errorMessage {
            let message = String(cString: errorMessage) // Преобразуем сообщение об ошибке в строку
            print("SQL error: \(message)") // Выводим сообщение об ошибке
            return false // Возвращаем false, если произошла ошибка
        }
        return true // Возвращаем true, если запрос выполнен успешно
    }
    
    // Деинициализатор, который вызывается при освобождении экземпляра класса
    deinit {
        sqlite3_close(db) // Закрываем базу данных
    }
    
    // MARK: - Асинхронные CRUD операции
    
    /// Асинхронная функция для добавления пользователя в базу
    func insertUser(id: String, name: String, description: String?, socialLinks: String?, photoPath: String?) async {
        await withCheckedContinuation { continuation in // Используем checked continuation для асинхронного выполнения
            queue.async { [weak self] in // Выполняем код в очереди
                guard let self = self else {
                    continuation.resume() // Возвращаем управление, если экземпляр класса был освобождён
                    return
                }
                
                // SQL-запрос для вставки нового пользователя
                let sql = """
                INSERT INTO User (ID, Name, Description, SocialLinks, PhotoPath)
                VALUES (?, ?, ?, ?, ?);
                """
                
                var stmt: OpaquePointer? = nil // Указатель на подготовленный SQL-запрос
                if sqlite3_prepare_v2(self.db, sql, -1, &stmt, nil) == SQLITE_OK { // Подготавливаем SQL-запрос
                    // Привязываем параметры к запросу
                    sqlite3_bind_text(stmt, 1, (id as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(stmt, 2, (name as NSString).utf8String, -1, nil)
                    
                    // Привязываем описание, если оно присутствует
                    if let desc = description {
                        sqlite3_bind_text(stmt, 3, (desc as NSString).utf8String, -1, nil)
                    } else {
                        sqlite3_bind_null(stmt, 3) // Привязываем NULL, если описание отсутствует
                    }
                    
                    // Привязываем социальные ссылки, если они присутствуют
                    if let social = socialLinks {
                        sqlite3_bind_text(stmt, 4, (social as NSString).utf8String, -1, nil)
                    } else {
                        sqlite3_bind_null(stmt, 4) // Привязываем NULL, если социальные ссылки отсутствуют
                    }
                    
                    // Привязываем путь к фото, если он присутствует
                    if let photo = photoPath {
                        sqlite3_bind_text(stmt, 5, (photo as NSString).utf8String, -1, nil)
                    } else {
                        sqlite3_bind_null(stmt, 5) // Привязываем NULL, если путь к фото отсутствует
                    }
                    
                    // Выполняем запрос на вставку
                    if sqlite3_step(stmt) != SQLITE_DONE {
                        print("Ошибка при вставке пользователя") // Выводим сообщение об ошибке, если вставка не удалась
                    }
                } else {
                    print("Ошибка подготовки запроса для вставки пользователя") // Выводим сообщение об ошибке, если подготовка запроса не удалась
                }
                sqlite3_finalize(stmt) // Освобождаем ресурсы, связанные с подготовленным запросом
                continuation.resume() // Возвращаем управление после завершения операции
            }
        }
    }
    
    /// Асинхронная функция для выборки сообщений из определённого чата
    func fetchMessages(forChat chatID: String) async -> [(id: Int, senderID: String, text: String, timestamp: Int)] {
        await withCheckedContinuation { continuation in // Используем checked continuation для асинхронного выполнения
            queue.async { [weak self] in // Выполняем код в очереди
                guard let self = self else {
                    continuation.resume(returning: []) // Возвращаем пустой массив, если экземпляр класса был освобождён
                    return
                }
                
                // SQL-запрос для выборки сообщений из чата
                let sql = "SELECT ID, SenderID, Text, Timestamp FROM Message WHERE ChatID = ? ORDER BY Timestamp;"
                var stmt: OpaquePointer? // Указатель на подготовленный SQL-запрос
                var messages = [(Int, String, String, Int)]() // Массив для хранения сообщений
                
                if sqlite3_prepare_v2(self.db, sql, -1, &stmt, nil) == SQLITE_OK { // Подготавливаем SQL-запрос
                    sqlite3_bind_text(stmt, 1, (chatID as NSString).utf8String, -1, nil) // Привязываем ID чата
                    
                    while sqlite3_step(stmt) == SQLITE_ROW { // Проходим по результатам выборки
                        let id = sqlite3_column_int(stmt, 0) // Получаем ID сообщения
                        let senderCStr = sqlite3_column_text(stmt, 1) // Получаем ID отправителя
                        let textCStr = sqlite3_column_text(stmt, 2) // Получаем текст сообщения
                        let timestamp = sqlite3_column_int(stmt, 3) // Получаем временной штамп
                        
                        // Преобразуем полученные значения в строки
                        let senderID = senderCStr != nil ? String(cString: senderCStr!) : ""
                        let text = textCStr != nil ? String(cString: textCStr!) : ""
                        messages.append((Int(id), senderID, text, Int(timestamp))) // Добавляем сообщение в массив
                    }
                } else {
                    print("Ошибка подготовки запроса для выборки сообщений") // Выводим сообщение об ошибке, если подготовка запроса не удалась
                }
                sqlite3_finalize(stmt) // Освобождаем ресурсы, связанные с подготовленным запросом
                continuation.resume(returning: messages) // Возвращаем массив сообщений
            }
        }
    }
    
    /// Асинхронная функция для добавления сообщения в чат
    func insertMessage(chatID: String, senderID: String, text: String, timestamp: Int) async {
        await withCheckedContinuation { continuation in // Используем checked continuation для асинхронного выполнения
            queue.async { [weak self] in // Выполняем код в очереди
                guard let self = self else {
                    continuation.resume() // Возвращаем управление, если экземпляр класса был освобождён
                    return
                }
                
                // SQL-запрос для вставки нового сообщения
                let sql = """
                INSERT INTO Message (ChatID, SenderID, Text, Timestamp)
                VALUES (?, ?, ?, ?);
                """
                
                var stmt: OpaquePointer? = nil // Указатель на подготовленный SQL-запрос
                if sqlite3_prepare_v2(self.db, sql, -1, &stmt, nil) == SQLITE_OK { // Подготавливаем SQL-запрос
                    // Привязываем параметры к запросу
                    sqlite3_bind_text(stmt, 1, (chatID as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(stmt, 2, (senderID as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(stmt, 3, (text as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(stmt, 4, Int32(timestamp)) // Привязываем временной штамп
                    
                    // Выполняем запрос на вставку
                    if sqlite3_step(stmt) != SQLITE_DONE {
                        print("Ошибка при вставке сообщения") // Выводим сообщение об ошибке, если вставка не удалась
                    }
                } else {
                    print("Ошибка подготовки запроса для вставки сообщения") // Выводим сообщение об ошибке, если подготовка запроса не удалась
                }
                sqlite3_finalize(stmt) // Освобождаем ресурсы, связанные с подготовленным запросом
                continuation.resume() // Возвращаем управление после завершения операции
            }
        }
    }
    
    /// Асинхронная функция для удаления чатов и сообщений, старше указанного временного штампа
    func deleteOldChats(olderThan timestamp: Int) async {
        await withCheckedContinuation { continuation in // Используем checked continuation для асинхронного выполнения
            queue.async { [weak self] in // Выполняем код в очереди
                guard let self = self else {
                    continuation.resume() // Возвращаем управление, если экземпляр класса был освобождён
                    return
                }
                
                // SQL-запрос для удаления сообщений старше указанного временного штампа
                let deleteMessagesSQL = "DELETE FROM Message WHERE ChatID IN (SELECT ID FROM Chat WHERE StartTime < ?);"
                // SQL-запрос для удаления чатов старше указанного временного штампа
                let deleteChatsSQL = "DELETE FROM Chat WHERE StartTime < ?;"
                
                // Выполняем оба запроса
                for sql in [deleteMessagesSQL, deleteChatsSQL] {
                    var stmt: OpaquePointer? // Указатель на подготовленный SQL-запрос
                    if sqlite3_prepare_v2(self.db, sql, -1, &stmt, nil) == SQLITE_OK { // Подготавливаем SQL-запрос
                        sqlite3_bind_int(stmt, 1, Int32(timestamp)) // Привязываем временной штамп
                        // Выполняем запрос на удаление
                        if sqlite3_step(stmt) != SQLITE_DONE {
                            print("Ошибка удаления старых данных для SQL: \(sql)") // Выводим сообщение об ошибке, если удаление не удалось
                        }
                    } else {
                        print("Ошибка подготовки запроса удаления для SQL: \(sql)") // Выводим сообщение об ошибке, если подготовка запроса не удалась
                    }
                    sqlite3_finalize(stmt) // Освобождаем ресурсы, связанные с подготовленным запросом
                }
                continuation.resume() // Возвращаем управление после завершения операции
            }
        }
    }
}
