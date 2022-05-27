//
//  VContentLines.swift
//  
//
//

import Foundation

/// See https://tools.ietf.org/html/rfc5545#section-3.1
public struct VContentLine: VEncodable {
    private static let maxLength: Int = 75
    
    public let key: String
    public let values: [VPropertyEncodable]

    public var vEncoded: String {
        let encoded = values.map { value in
            let paramsToString = value.parameters
                .map { ";\($0.key)=\(quote($0.values.joined(separator: ","), if: $0.values.count > 1))" }
                .joined()
            
            let line = "\(key)\(paramsToString):\(value.vEncoded)"
            let chunks = line.chunks(ofLength: Self.maxLength)
            
            assert(!chunks.isEmpty)
            
            // From the RFC (section 3.1):
            //
            // Lines of text SHOULD NOT be longer than 75 octets, excluding the line
            // break.  Long content lines SHOULD be split into a multiple line
            // representations using a line "folding" technique.  That is, a long
            // line can be split between any two characters by inserting a CRLF
            // immediately followed by a single linear white-space character (i.e.,
            // SPACE or HTAB).  Any sequence of CRLF followed immediately by a
            // single linear white-space character is ignored (i.e., removed) when
            // processing the content type.
            
            return chunks
                .enumerated()
                .map { (index, chunk) in index > 0 ? " \(chunk)" : chunk }
                .map { "\($0)\r\n" }
                .joined()
        }.joined()

        return encoded
    }

    public init(key: String, values: [VPropertyEncodable]) {
        self.key = key
        self.values = values
    }

    // Multi line
    public static func lines(_ key: String, _ values: [VPropertyEncodable]?) -> VContentLine? {
        guard let values = values, !values.isEmpty else {
            return nil
        }
        
        return .init(key: key, values: values)
    }
    
    // Single line
    public static func line(_ key: String, _ value: VPropertyEncodable?) -> VContentLine? {
        guard let value = value else {
            return nil
        }
        
        return .init(key: key, values: [value])
    }
    
    private func quote(_ str: String, if predicate: Bool) -> String {
        predicate ? "\"\(str)\"" : str
    }
}
