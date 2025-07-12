//
//  SQLiteManager.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 12/07/25.
//

import Foundation
import SQLite3

class SQLiteManager {
    static let shared = SQLiteManager()
    private var db: OpaquePointer?
    
    private init() {
        openDatabase()
        createTable()
    }
    
    private func getDatabasePath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent("UserDatabase.sqlite").path
    }
    
    private func openDatabase() {
        sqlite3_open(getDatabasePath(), &db)
    }
    
    private func createTable() {
        let sql = """
        CREATE TABLE IF NOT EXISTS Users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT);
        """
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("User table is created successfully.")
            } else {
                print("User table creation failed.")
            }
        } else {
            print("User table creation failed.")
        }
        
        sqlite3_finalize(stmt)
    }
    
    func insertUser(_ userS: UserModel) -> Bool {
        let users = getAllUsers()
        for user in users{
            if user.id == userS.id || user.email == userS.email{
                return false
            }
        }
        
        let insertStatementString = "INSERT INTO Users (name, email, password) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (userS.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (userS.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (userS.password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("User is created successfully.")
                sqlite3_finalize(insertStatement)
                return true
            } else {
                print("Could not add.")
                return false
            }
        } else {
            print("INSERT statement is failed.")
            return false
        }
    }
              
    func getAllUsers() -> [UserModel] {
        let queryStatementString = "SELECT * FROM Users;"
        var queryStatement: OpaquePointer? = nil
        var users : [UserModel] = []
        if sqlite3_prepare_v2(db,  queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement,3)))
                
                users.append(UserModel(id: Int(id), name: name, email: email, password: password))
                print("User Details:")
                print("\(id) | \(name) | \(email) | \(password)")
            }
        } else {
            print("SELECT statement is failed.")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
    
    func getUserbyEmail(email:String) -> UserModel? {
        let queryStatementString = "SELECT * FROM Users WHERE email = ?;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,  queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (email as NSString).utf8String, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
                print("User Details:")
                print("\(id) | \(name) | \(email) | \(password)")
                
                return UserModel(id: Int(id), name: name, email: email, password: password)
            }
        } else {
            print("SELECT statement is failed.")
        }
        sqlite3_finalize(queryStatement)
        return nil
    }
    
    // Update user on User table
    func updateUser(name: String, password: String) -> Bool{
        let updateStatementString = "UPDATE Users SET name=?, password=? WHERE email=?;"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (password as NSString).utf8String, -1, nil)

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("User updated successfully.")
                sqlite3_finalize(updateStatement)
                return true
            } else {
                print("Could not update.")
                return false
            }
        } else {
            print("UPDATE statement is failed.")
            return false
        }
    }
    
}
