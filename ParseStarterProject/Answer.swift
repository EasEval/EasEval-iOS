//
//  Answer.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 15.03.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation

//This class stores all necessary information and content of a student answer to a exercise
class Answer {
    
    private var googleAmount:Double
    private var solutionsAmount:Double
    private var curriculumAmount:Double
    private var lectureAmount:Double
    private var otherAmount:Double
    private var rating:Double
    private var time:Double
    private var comment:String
    
    init(gAm:Double, sAm:Double, cAm:Double, lAm:Double, oAm:Double, rating:Double, time:Double, comment:String) {
        
        self.googleAmount = gAm
        self.solutionsAmount = sAm
        self.curriculumAmount = cAm
        self.lectureAmount = lAm
        self.otherAmount = oAm
        self.rating = rating
        self.time = time
        self.comment = comment
    }
    
    func setGoogleAmount(val:Double) {
        
        self.googleAmount = val
    }
    
    func setSolutionsAmount(val:Double) {
        
        self.solutionsAmount = val
    }
    
    func setCurriculumAmount(val:Double) {
        
        self.curriculumAmount = val
    }
    
    func setLectureAmount(val:Double) {
        
        self.lectureAmount = val
    }
    
    func setOtherAmount(val:Double) {
        
        self.otherAmount = val
    }
    
    func setRating(val:Double) {
        
        self.rating = val
    }
    
    func setTime(val:Double) {
        
        self.time = val
    }
    
    func setComment(com:String) {
        
        self.comment = com
    }
    
    func getGoogleAmount() -> Double {
        
        return self.googleAmount
    }
    
    func getSolutionsAmount() -> Double {
        
        return self.solutionsAmount
    }
    
    func getCurriculumAmount() -> Double {
        
        return self.curriculumAmount
    }

    func getLectureAmount() -> Double {
        
        return self.lectureAmount
    }

    func getotherAmount() -> Double {
        
        return self.otherAmount
    }
    
    func getRating() -> Double {
        
        return self.rating
    }
    func getTime() -> Double {
        
        return self.time
    }

    func getComment() -> String {
        
        return self.comment
    }
}




