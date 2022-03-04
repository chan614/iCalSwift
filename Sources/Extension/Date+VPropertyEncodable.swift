//
//  Date+VPropertyEncodable.swift
//  
//
//

import Foundation

extension Date: VPropertyEncodable {
    public var vEncoded: String {
        ICalDateTime(date: self).vEncoded
    }
}
