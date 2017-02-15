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
    
    public init(id:String, name:String) {
        
        self.id = id
        self.name = name
    }
    
    func getId() -> String {
        
        return self.id
    }
    
    func getName() -> String {
        
        return self.name
    }
    
    
}
