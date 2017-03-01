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
    var amounts = [String(): (Double(), Double())]
    
    public init(id:String, name:String, subId:String) {
        
        self.id = id
        self.name = name
        self.subjectId = subId
        self.amounts = [String(): (Double(), Double())]
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
    
    private func amountHasKey(key:String) -> Bool {
        
        if getAmounts().keys.contains(key) {
            
            return true
        }
        
        return false
    }
    
    func getAmounts() -> [String: (Double, Double)] {
        
        return self.amounts
    }
    
    func getAmountFromKey(key:String) -> (Double, Double) {
        
        if amountHasKey(key: key) {
            
            return getAmounts()[key]!
        }
        return (0,0)
    }
    
    func addAmountForKey(key:String, amount:Double) {
        
        if !amountHasKey(key: key) {
            
            self.amounts[key]! = (amount, 1)
        } else {
            
            self.amounts[key]!.0 += amount
            self.amounts[key]!.1 += 1
            
        }
    }
    
    
}
