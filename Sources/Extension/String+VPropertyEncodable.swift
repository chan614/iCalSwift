//
//  String+VPropertyEncodable.swift
//
//
//

import Foundation

extension String: VPropertyEncodable {
    public var vEncoded: String {
        self.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: ",", with: "\\,")
            .replacingOccurrences(of: ";", with: "\\;")
            .replacingOccurrences(of: "\n", with: "\\n")
    }
}
