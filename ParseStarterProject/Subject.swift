//
//  Subject.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 15.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation

class Subject {
    
    let id:String
    let name:String
    let objectId:String
    var exercises = [String: Exercise]()
    
    public init(id:String, name:String, objectId:String) {
        
        self.id = id
        self.name = name
        self.objectId = objectId
    }
    
    func getId() -> String {
        
        return self.id
    }
    
    func getName() -> String {
        
        return self.name
    }
    
    func getObjectId() -> String {
        
        return self.objectId
    }
    
    func getExercises() -> [String: Exercise] {
        
        return self.exercises
    }
    
    func setExerciseForKey(key:String, exer:Exercise) {
        
        self.exercises[key] = exer
    }
}
