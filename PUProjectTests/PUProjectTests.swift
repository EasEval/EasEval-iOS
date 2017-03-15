//
//  PUProjectTests.swift
//  PUProjectTests
//
//  Created by August Lund Eilertsen on 08.03.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import XCTest

class PUProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        //XCUIApplication().launch()
    
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUtilitiesDouble() {
        
        let roundedDouble = Utilities.getRoundedDouble(double: 2.4535)
        XCTAssertNotNil(roundedDouble)
    }
    
    func testUtilitiesColorGenerator() {
        
        let color = Utilities.getRandomColor(divideNum: 255)
        XCTAssertNotNil(color)
    }
    
    func getTestExercise() -> Exercise {
        
        let newExercise = Exercise(id: "TestID", name: "TestName", subId: "SubId")
        newExercise.addMostUsedResourceForKey(key: "TestKey")
        newExercise.addMostUsedResourceForKey(key: "TestKey2")
        newExercise.addMostUsedResourceForKey(key: "TestKey")
        
        newExercise.addAmountForKey(key: "Key_1", amount: 20.0)
        newExercise.addAmountForKey(key: "Key_1", amount: 67.0)
        newExercise.addAmountForKey(key: "Key_2", amount: 30.0)
        
        return newExercise
    }
    
    func testExerciseObject() {
        
        let newExercise = getTestExercise()
        
        XCTAssertEqual(newExercise.getMostUsedResourceFromKey(key: "TestKey"), 2)
        XCTAssertEqual(newExercise.getMostUsedResourceFromKey(key: "TestKey2"), 1)
        XCTAssertEqual(newExercise.getMostUsedResourceFromKey(key: "TestKey3"), 0)
       
        XCTAssertEqual(newExercise.getAmountFromKey(key: "Key_1").0, 87.0)
        XCTAssertEqual(newExercise.getAmountFromKey(key: "Key_1").1, 2)
        XCTAssertEqual(newExercise.getAmountFromKey(key: "Key_2").0, 30.0)
        XCTAssertEqual(newExercise.getAmountFromKey(key: "Key_2").1, 1)
        
        XCTAssertEqual(newExercise.getId(), "TestID")
        XCTAssertEqual(newExercise.getName(), "TestName")
        XCTAssertEqual(newExercise.getSubjectId(), "SubId")
        
        XCTAssertNotNil(newExercise.getMostUsedResources())
        XCTAssertNotNil(newExercise.getAmounts())
        
    }
    
    func testSubjectObject() {
        
        let testSubject = Subject(id: "SubID", name: "Name", objectId: "ObjID")
        
        XCTAssertEqual(testSubject.getName(), "Name")
        XCTAssertEqual(testSubject.getId(), "SubID")
        XCTAssertEqual(testSubject.getObjectId(), "ObjID")
        
        let addExercise = getTestExercise()
        
        testSubject.setExerciseForKey(key: "TMA4100", exer: addExercise)
    
        XCTAssertEqual(testSubject.getExercises()["TMA4100"]!.getName(), addExercise.getName())
        XCTAssertEqual(testSubject.getExercises().count, 1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
