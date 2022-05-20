//
//  Date+VPropertyEncodable.swift
//  
//
//

import Foundation

extension Date: VPropertyEncodable {
    public var vEncoded: String {
        ICalDateTime(type: .dateTime, date: self, tzid: nil).vEncoded
    }
}
