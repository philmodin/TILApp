//
//  CreateUser.swift
//  
//
//  Created by Philip Modin on 10/23/22.
//

import Fluent

struct CreateUser: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required)
			.field("password", .string, .required)
			.field("email", .string, .required)
			.field("profilePicture", .string)
			.unique(on: "username")
			.unique(on: "email")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
