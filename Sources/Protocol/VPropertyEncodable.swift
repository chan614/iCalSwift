//
//  VPropertyEncodable.swift
//
//
//

/// Represents something that can be encoded in
/// a format like V, but may require
/// additional parameters in the content line.
public protocol VPropertyEncodable: VEncodable {
    /// The additional parameters.
    var parameters: [ICalParameter] { get }
}

public extension VPropertyEncodable {
    var parameters: [ICalParameter] { [] }
    
    func parameter(key: String) -> ICalParameter? {
        parameters.first(where: { $0.key == key })
    }
}
