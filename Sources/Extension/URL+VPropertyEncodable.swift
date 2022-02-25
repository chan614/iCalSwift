//
//  URL+VPropertyEncodable.swift
//
//
//

import Foundation

extension URL: VPropertyEncodable {
    public var vEncoded: String {
        absoluteString
    }
}
