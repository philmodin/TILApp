//
//  CreateToken.swift
//  
//
//  Created by Philip Modin on 11/8/22.
//

import Fluent

struct CreateToken: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tokens")
			.id()
			.field("value", .string, .required)
			.field("userID", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.create()
	}
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tokens").delete()
	}
}
