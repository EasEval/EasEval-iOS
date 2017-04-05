//
//  PUProjectTests.swift
//  PUProjectTests
//
//  Created by August Lund Eilertsen on 08.03.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import XCTest

//This class test the different isolated classes widely used in the application
class PUProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }

    override func tearDown() {
        
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
    
    func testAnswerAndExerciseClass() {
        
        let google_amount = 10.0
        let solutions_amount = 20.0
        let curriculum_amount = 50.0
        let lecture_amount = 10.0
        let other_amount = 10.0
        let rating = 40.0
        let time = 20.0
        
        let testAnswer = Answer(gAm: google_amount, sAm: solutions_amount, cAm: curriculum_amount, lAm: lecture_amount, oAm: other_amount, rating: rating, time: time, comment: "Good")
        
        XCTAssertEqual(testAnswer.getTime(), time)
        XCTAssertEqual(testAnswer.getRating(), rating)
        XCTAssertEqual(testAnswer.getGoogleAmount(), google_amount)
        XCTAssertEqual(testAnswer.getSolutionsAmount(), solutions_amount)
        XCTAssertEqual(testAnswer.getCurriculumAmount(), curriculum_amount)
        XCTAssertEqual(testAnswer.getLectureAmount(), lecture_amount)
        XCTAssertEqual(testAnswer.getotherAmount(), other_amount)
        
        let testExercise = Exercise(id: "2XX3", name: "TestExer", subId: "TMA4100")
        
        testExercise.addAnswer(answer: testAnswer)
        
        XCTAssertEqual(testExercise.getAnswers()[0].getTime(), time)
        XCTAssertEqual(testExercise.getAnswers()[0].getRating(), rating)
        XCTAssertEqual(testExercise.getAnswers()[0].getGoogleAmount(), google_amount)
        XCTAssertEqual(testExercise.getAnswers()[0].getSolutionsAmount(), solutions_amount)
        XCTAssertEqual(testExercise.getAnswers()[0].getCurriculumAmount(), curriculum_amount)
        XCTAssertEqual(testExercise.getAnswers()[0].getLectureAmount(), lecture_amount)
        XCTAssertEqual(testExercise.getAnswers()[0].getotherAmount(), other_amount)
        
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
}
