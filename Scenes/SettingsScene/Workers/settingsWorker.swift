//
////
////  SettingsWorker.swift
////  Imyarek_SwiftUI
////
////  Работа с локальной SQLite‑базой (таблицы User и UserFilter)
////
//
//import Foundation
//import SQLite3
//
//// MARK: - Protocol
//
//public protocol SettingsWorkerProtocol: AnyActor {
//    func fetchProfile() async throws -> SettingsProfile
//    func save(profile: SettingsProfile) async throws
//}
//
//// MARK: - Implementation
//
//public actor SettingsWorker: SettingsWorkerProtocol {
//
//    // MARK: Private
//
//    private var db: OpaquePointer?
//    private let userId: String
//
//    // MARK: Init / Deinit
//
//    public init(userId: String = "currentUser") {
//        self.userId = userId
//        openDatabase()
//        createFilterTableIfNeeded()
//    }
//
//    deinit {
//        sqlite3_close(db)
//    }
//
//    // MARK: SettingsWorkerProtocol
//
//    public func fetchProfile() async throws -> SettingsProfile {
//        // ensure User row exists
//        try ensureUserRow()
//        var profile = SettingsProfile(
//            id: userId,
//            nickname: "Имя",
//            description: nil,
//            avatarSystemImage: "swift",
//            gender: nil,
//            age: nil,
//            peerGender: nil,
//            peerAge: nil
//        )
//
//        let sql = """
//        SELECT u.Name,
//               u.Description,
//               u.PhotoPath,
//               uf.UserGender,
//               uf.UserAge,
//               uf.PeerGender,
//               uf.PeerAge
//        FROM User u
//        LEFT JOIN UserFilter uf ON u.ID = uf.UserID
//        WHERE u.ID = ? LIMIT 1;
//        """
//
//        var stmt: OpaquePointer?
//        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
//            throw SQLiteError.prepare
//        }
//        defer { sqlite3_finalize(stmt) }
//
//        sqlite3_bind_text(stmt, 1, userId, -1, nil)
//
//        if sqlite3_step(stmt) == SQLITE_ROW {
//            if let cString = sqlite3_column_text(stmt, 0) {
//                profile.nickname = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(stmt, 1) {
//                profile.description = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(stmt, 2) {
//                profile.avatarSystemImage = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(stmt, 3) {
//                profile.gender = Gender(rawValue: String(cString: cString))
//            }
//            if let cString = sqlite3_column_text(stmt, 4) {
//                profile.age = AgeRange(rawValue: String(cString: cString))
//            }
//            if let cString = sqlite3_column_text(stmt, 5) {
//                profile.peerGender = Gender(rawValue: String(cString: cString))
//            }
//            if let cString = sqlite3_column_text(stmt, 6) {
//                profile.peerAge = AgeRange(rawValue: String(cString: cString))
//            }
//        }
//
//        return profile
//    }
//
//    public func save(profile: SettingsProfile) async throws {
//        try saveUser(profile)
//        try saveFilter(profile)
//    }
//
//    // MARK: Helpers
//
//    private func openDatabase() {
//        guard let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            fatalError("Не удалось получить директорию Documents")
//        }
//        let dbPath = docsURL.appendingPathComponent("imyarek.sqlite").path
//        if sqlite3_open(dbPath, &db) != SQLITE_OK {
//            fatalError("Не удалось открыть базу данных")
//        }
//    }
//
//    private func createFilterTableIfNeeded() {
//        let createSQL = """
//        CREATE TABLE IF NOT EXISTS UserFilter (
//            UserID TEXT PRIMARY KEY,
//            UserGender TEXT,
//            UserAge TEXT,
//            PeerGender TEXT,
//            PeerAge TEXT,
//            FOREIGN KEY(UserID) REFERENCES User(ID)
//        );
//        """
//        _ = try? execute(sql: createSQL)
//    }
//
//    private func ensureUserRow() throws {
//        let existing = try scalarInt(sql: "SELECT COUNT(*) FROM User WHERE ID = ?", params: [userId])
//        if existing == 0 {
//            _ = try execute(sql: "INSERT INTO User (ID, Name) VALUES (?, ?);", params: [userId, "Имя"])
//        }
//    }
//
//    private func saveUser(_ profile: SettingsProfile) throws {
//        let sql = """
//        INSERT OR REPLACE INTO User (ID, Name, Description, PhotoPath)
//        VALUES (?,?,?,?);
//        """
//        _ = try execute(sql: sql, params: [
//            profile.id,
//            profile.nickname,
//            profile.description,
//            profile.avatarSystemImage
//        ])
//    }
//
//    private func saveFilter(_ profile: SettingsProfile) throws {
//        let sql = """
//        INSERT OR REPLACE INTO UserFilter
//        (UserID, UserGender, UserAge, PeerGender, PeerAge)
//        VALUES (?,?,?,?,?);
//        """
//        _ = try execute(sql: sql, params: [
//            profile.id,
//            profile.gender?.rawValue,
//            profile.age?.rawValue,
//            profile.peerGender?.rawValue,
//            profile.peerAge?.rawValue
//        ])
//    }
//
//    // MARK: SQLite helpers
//
//    @discardableResult
//    private func execute(sql: String, params: [Any?] = []) throws -> Int {
//        var stmt: OpaquePointer?
//        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
//            throw SQLiteError.prepare
//        }
//        defer { sqlite3_finalize(stmt) }
//        bind(params: params, to: stmt)
//        guard sqlite3_step(stmt) == SQLITE_DONE else {
//            throw SQLiteError.step
//        }
//        return Int(sqlite3_changes(db))
//    }
//
//    private func scalarInt(sql: String, params: [Any?]) throws -> Int {
//        var result = 0
//        var stmt: OpaquePointer?
//        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { throw SQLiteError.prepare }
//        defer { sqlite3_finalize(stmt) }
//        bind(params: params, to: stmt)
//        if sqlite3_step(stmt) == SQLITE_ROW {
//            result = Int(sqlite3_column_int(stmt, 0))
//        }
//        return result
//    }
//
//    private func bind(params: [Any?], to stmt: OpaquePointer?) {
//        for (index, value) in params.enumerated() {
//            let idx = Int32(index + 1)
//            if value == nil {
//                sqlite3_bind_null(stmt, idx)
//            } else if let text = value as? String {
////                sqlite3_bind_text(stmt, idx, text, -1, SQLITE_TRANSIENT)
//            } else if let intVal = value as? Int {
//                sqlite3_bind_int(stmt, idx, Int32(intVal))
//            }
//        }
//    }
//
//    enum SQLiteError: Error {
//        case prepare
//        case step
//    }
//}
