//
//  Exercise.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 22.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation

//This class stores information and content of a exercise. 

class Exercise {
    
    private let id:String
    private let name:String
    private let subjectId:String
    private var amounts = [String: (Double, Double)]()
    private var mostUsedResource = [String: Int]()
    private var answers = [Answer]()
    
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
    
    private func amountHasKey(key:String) -> Bool {
        
        if getAmounts().keys.contains(key) {
            
            return true
        }
        return false
    }
    
    func getAmounts() -> [String: (Double, Double)] {
        
        return self.amounts
    }
    
    //Returns a amount for a given key. The key must be a valid amount key. For instance 'googleAmount'
    func getAmountFromKey(key:String) -> (Double, Double) {
        
        if amountHasKey(key: key) {
            
            return getAmounts()[key]!
        }
        return (0,0)
    }
    
    //Adds a amount for the paramter key in a dictionairy. The key must be a valid amountkey.
    func addAmountForKey(key:String, amount:Double) {
        
        if !amountHasKey(key: key) {
            
            self.amounts[key] = (amount, 1)
        } else {
            
            self.amounts[key]!.0 += amount
            self.amounts[key]!.1 += 1
            
        }
    }
    
    private func resourceHasKey(key:String) -> Bool {
        
        if(self.mostUsedResource.keys.contains(key)) {
            
            return true
        }
        return false
    }
    
    //Adds one to the 'mostUsedResource' dictionairy. This will be added if the amount for the given key is larger than alle the other amounts
    func addMostUsedResourceForKey(key:String) {
        
        if(!self.resourceHasKey(key:key)) {
            
            self.mostUsedResource[key] = 1
            
        } else {
            
            self.mostUsedResource[key]! += 1
        }
    }
    
    func getMostUsedResourceFromKey(key:String) -> Int {
        
        if(resourceHasKey(key: key)) {
            
            return self.mostUsedResource[key]!
        }
        return 0
    }
    
    func getMostUsedResources() -> [String: Int] {
    
        return self.mostUsedResource
    }
    
    func addAnswer(answer:Answer) {
        
        self.answers.append(answer)
        
    }
    
    func getAnswers() -> [Answer] {
        
        return self.answers
    }
}
