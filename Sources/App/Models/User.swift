//
//  User.swift
//  
//
//  Created by Philip Modin on 10/23/22.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
	
	@Field(key: "password")
	var password: String
    
    @Field(key: "username")
    var username: String
    
    @Children(for: \.$user)
    var acronyms: [Acronym]
    
    init() {}
    
    init(
		id: UUID? = nil,
		name: String,
		username: String,
		password: String
	) {
        self.name = name
        self.username = username
		self.password = password
    }
	
	final class Public: Content {
		var id: UUID?
		var name: String
		var username: String
		
		init(id: UUID?, name: String, username: String) {
			self.id = id
			self.name = name
			self.username = username
		}
	}
}

extension User {
	func convertToPublic() -> User.Public {
		return User.Public(id: id, name: name, username: username)
	}
}

extension EventLoopFuture where Value: User {
	func convertToPublic() -> EventLoopFuture<User.Public> {
		return self.map { user in
			return user.convertToPublic()
		}
	}
}

extension Collection where Element: User {
	func convertToPublic() -> [User.Public] {
		return self.map { $0.convertToPublic()}
	}
}

extension EventLoopFuture where Value == Array<User> {
	func convertToPublic() -> EventLoopFuture<[User.Public]> {
		return self.map { $0.convertToPublic()}
	}
}
