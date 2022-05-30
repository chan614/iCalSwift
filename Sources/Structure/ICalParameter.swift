//
//  ICalParameter.swift
//  
//
//

import Foundation

public struct ICalParameter: Equatable {
    public let key: String
    public var values: [String]
    
    public init(key: String, values: [String]) {
        self.key = key
        self.values = values
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key
    }
}
