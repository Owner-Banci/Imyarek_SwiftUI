//
//  UserProfileWorker.swift
//  Imyarek_SwiftUI
//
//  Created by maftuna murtazaeva on 17.05.2025.
//

//===============================================================
//  Core/Services/DatabaseService+UserProfile.swift
//===============================================================

import Foundation
import SQLite3

public enum DBError: Error {
    case generic(String)
}

extension DatabaseService {
    
    // Создаёт таблицу, если нужно
    func createProfileTableIfNeeded() {
        let sql = """
        CREATE TABLE IF NOT EXISTS UserProfile(
            ID TEXT PRIMARY KEY,
            ProfileJson TEXT NOT NULL
        );
        """
        _ = executeSQL(sql)
    }
    
    /// Вычитывает профиль из БД или возвращает дефолтный.
    func fetchUserProfile(id: String = "current") async throws -> UserProfile {
        // Явно указываем тип для continuation
        return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<UserProfile, Error>) in
            queue.async { [weak self] in
                guard let self = self else {
                    return cont.resume(throwing: DBError.generic("DB deallocated"))
                }
                self.createProfileTableIfNeeded()
                
                // Попробуем загрузить JSON
                let sql = "SELECT ProfileJson FROM UserProfile WHERE ID = ? LIMIT 1;"
                var stmt: OpaquePointer?
                var profile: UserProfile?
                
                if sqlite3_prepare_v2(self.db, sql, -1, &stmt, nil) == SQLITE_OK {
                    sqlite3_bind_text(stmt, 1, (id as NSString).utf8String, -1, nil)
                    if sqlite3_step(stmt) == SQLITE_ROW,
                       let cStr = sqlite3_column_text(stmt, 0),
                       let data = String(cString: cStr).data(using: .utf8) {
                        profile = try? JSONDecoder().decode(UserProfile.self, from: data)
                    }
                }
                sqlite3_finalize(stmt)
                
                // Если нет записи — возвращаем дефолт (не сохраняем автоматически)
                if profile == nil {
                    profile = UserProfile(
                        name:        "Имя",
                        age:         18,
                        gender:      .female,
                        bio:         "",
                        interests:   [],
                        socialLinks: [],
                        photoName:   "person.crop.circle"
                    )
                }
                
                cont.resume(returning: profile!)
            }
        }
    }
    
    /// Сохраняет профиль в БД (JSON)
    func saveUserProfile(_ profile: UserProfile, id: String = "current") async throws {
        let data = try JSONEncoder().encode(profile)
        guard let json = String(data: data, encoding: .utf8) else {
            throw DBError.generic("Encoding failure")
        }
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            queue.async { [weak self] in
                guard let self = self else {
                    return cont.resume(throwing: DBError.generic("DB deallocated"))
                }
                self.createProfileTableIfNeeded()
                
                let sql = "REPLACE INTO UserProfile (ID, ProfileJson) VALUES (?, ?);"
                var stmt: OpaquePointer?
                
                if sqlite3_prepare_v2(self.db, sql, -1, &stmt, nil) == SQLITE_OK {
                    sqlite3_bind_text(stmt, 1, (id as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(stmt, 2, (json as NSString).utf8String, -1, nil)
                    if sqlite3_step(stmt) == SQLITE_DONE {
                        sqlite3_finalize(stmt)
                        return cont.resume()
                    }
                }
                sqlite3_finalize(stmt)
                cont.resume(throwing: DBError.generic("SQL error"))
            }
        }
    }
}
