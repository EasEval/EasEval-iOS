//
//  Exercise.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 22.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation

class Exercise {
    
    let id:String
    let name:String
    let subjectId:String
    
    public init(id:String, name:String, subId:String) {
        
        self.id = id
        self.name = name
        self.subjectId = subId
    }
    
    func getId() -> String {
        
        return self.id
    }
    
    func getName() -> String {
        
        return self.name
    }
    
    func getSubjectId() -> String {
        
        return self.subjectId
    }
    
    
}
