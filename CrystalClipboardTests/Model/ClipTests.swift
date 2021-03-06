//
//  ClipTests.swift
//  CrystalClipboard
//
//  Created by Justin Mazzocchi on 8/24/17.
//  Copyright © 2017 Justin Mazzocchi. All rights reserved.
//

import XCTest
@testable import CrystalClipboard

class ClipTests: XCTestCase {
    func testDecoding() {
        let id = generateNumber()
        let text = generateString()
        let createdAt = Constants.ISO8601DateFormatter.string(from: Date())
        let userID = generateNumber()
        let jsonString = "{\"id\":\(id),\"text\":\"\(text)\",\"created_at\":\"\(createdAt)\",\"user_id\":\(userID)}"
        let jsonData = jsonString.data(using: .utf8)!
        let clip = try! ISO8601JSONDecoder().decode(Clip.self, from: jsonData)
        XCTAssertEqual(clip.id, id)
        XCTAssertEqual(clip.text, text)
        XCTAssertEqual(Constants.ISO8601DateFormatter.string(from: clip.createdAt), createdAt)
        XCTAssertEqual(clip.userID, userID)
    }
}
