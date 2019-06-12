//
//  FirebaseManagerTest.swift
//  MarvelHeroesAppTests
//
//  Created by LocalUser on 5/24/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import XCTest
@testable import MarvelHeroesApp

class FirebaseManagerTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateUser() {
        let mock = FirebaseManagerMock()
        let manager = FirebaseManager()
        mock.createUser(email: "Test100@mail.ru", password: "1234")
        manager.createUser(email: "Test100@mail.ru", password: "123456")
    }
    
    func testFail() {
        XCTFail()
    }
}
