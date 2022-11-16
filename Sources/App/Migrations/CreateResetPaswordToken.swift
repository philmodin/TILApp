//
//  CreateResetPaswordToken.swift
//  
//
//  Created by Philip Modin on 11/15/22.
//

import Fluent

struct CreateResetPaswordToken: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("resetPasswordTokens")
			.id()
			.field("token", .string, .required)
			.field("userID", .uuid, .required, .references("users", "id"))
			.unique(on: "token")
			.create()
	}
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("resetPasswordTokens").delete()
	}
}
