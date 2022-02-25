//
//  Int+VPropertyEncodable.swift
//
//
//

extension Int: VPropertyEncodable {
    public var vEncoded: String {
        String(self)
    }
}
