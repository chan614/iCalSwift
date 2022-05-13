//
//  ICalComponent.swift
//  
//
//

import Foundation

public struct ICalComponent {
    let properties: [(name: String, value: String)]
    
    func findProperty(name: String) -> (name: String, value: String)? {
        return properties
            .filter { $0.name.hasPrefix(name) }
            .first
    }
    
    // DateTime
    func buildProperty(of name: String) -> ICalDateTime? {
        guard let prop = findProperty(name: name) else {
            return nil
        }
       
        return PropertyBuilder.buildDateTime(propName: prop.name, value: prop.value)
    }
    
    // Int
    func buildProperty(of name: String) -> Int? {
        guard let prop = findProperty(name: name) else {
            return nil
        }
        
        return Int(prop.value)
    }
    
    // String
    func buildProperty(of name: String) -> String? {
        guard let prop = findProperty(name: name) else {
            return nil
        }
        
        return prop.value
    }
    
    // Duration
    func buildProperty(of name: String) -> ICalDuration? {
        guard let prop = findProperty(name: name) else {
            return nil
        }
        
        return PropertyBuilder.buildDuration(value: prop.value)
    }
    
    // Array value
    func buildProperty(of name: String) -> [String] {
        guard let prop = findProperty(name: name) else {
            return []
        }
        
        return prop.value.components(separatedBy: ",")
    }
    
    // RRule
    func buildProperty(of name: String) -> ICalRRule? {
        guard let prop = findProperty(name: name) else {
            return nil
        }
        
        return PropertyBuilder.buildRRule(value: prop.value)
    }
    
    // URL
    func buildProperty(of name: String) -> URL? {
        guard let prop = findProperty(name: name) else {
            return nil
        }
        
        return URL(string: prop.value)
    }
}
