//
//  UserTests.swift
//  
//
//  Created by Philip Modin on 10/25/22.
//

@testable import App
import XCTVapor

final class UserTests: XCTestCase {
    let usersName = "Alice"
    let usersUsername = "alicea"
    let usersURI = "/api/users/"
    var app: Application!
    
    override func setUpWithError() throws {
        app = try Application.testable()
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
    }
    
    func testUsersCanBeRetrievedFromAPI() throws {
        let user = try User.create(name: usersName, username: usersUsername, on: app.db)
        _ = try User.create(on: app.db)
        
        try app.test(.GET, usersURI, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let users = try response.content.decode([User].self)
            
            XCTAssertEqual(users.count, 2)
            XCTAssertEqual(users[0].name, usersName)
            XCTAssertEqual(users[0].username, usersUsername)
            XCTAssertEqual(users[0].id, user.id)
        })
    }
    
    func testUserCanBeSavedWithAPI() throws {
        let user = User(name: usersName, username: usersUsername)
        
        try app.test(.POST, usersURI, beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { response in
            let recievedUser = try response.content.decode(User.self)
            
            XCTAssertEqual(recievedUser.name, usersName)
            XCTAssertEqual(recievedUser.username, usersUsername)
            XCTAssertNotNil(recievedUser.id)
            
            try app.test(.GET, usersURI, afterResponse: { secondResponse in
                let users = try secondResponse.content.decode([User].self)
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users[0].name, usersName)
                XCTAssertEqual(users[0].username, usersUsername)
                XCTAssertEqual(users[0].id, recievedUser.id)
            })
        })
    }
    
    func testGettingASingleUserFromThewAPI() throws {
        let user = try User.create(
            name: usersName,
            username: usersUsername,
            on: app.db
        )
        
        try app.test(.GET, "\(usersURI)\(user.id!)", afterResponse: { response in
            let recievedUser = try response.content.decode(User.self)
            XCTAssertEqual(recievedUser.name, usersName)
            XCTAssertEqual(recievedUser.username, usersUsername)
            XCTAssertEqual(recievedUser.id, user.id)
        })
    }
}
