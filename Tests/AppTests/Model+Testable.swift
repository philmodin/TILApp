//
//  Model+Testable.swift
//  
//
//  Created by Philip Modin on 10/25/22.
//

@testable import App
import Fluent

extension User {
    static func create(
        name: String = "Luke",
        username: String = "lukes",
        on databse: Database
    ) throws -> User {
        let user = User(name: name, username: username)
        try user.save(on: databse).wait()
        return user
    }
}
