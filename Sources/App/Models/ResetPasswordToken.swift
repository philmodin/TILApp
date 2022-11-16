//
//  ResetPasswordToken.swift
//  
//
//  Created by Philip Modin on 11/15/22.
//

import Fluent
import Vapor

final class ResetPasswordToken: Model, Content {
	static let schema = "resetPasswordTokens"
	
	@ID
	var id: UUID?
	
	@Field(key: "token")
	var token: String
	
	@Parent(key: "userID")
	var user: User
	
	init() {}
	
	init(id: UUID? = nil, token: String, userID: User.IDValue) {
		self.id = id
		self.token = token
		self.$user.id = userID
	}
}
