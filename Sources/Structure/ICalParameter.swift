//
//  ICalParameter.swift
//  
//
//

import Foundation

public struct ICalParameter: Equatable {
    public let key: String
    public var values: [String]
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key
    }
}
