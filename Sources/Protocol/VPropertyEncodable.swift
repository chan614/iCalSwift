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
    var parameters: [(String, [String])] { get }
}

public extension VPropertyEncodable {
    var parameters: [(String, [String])] { [] }
}
