//
//  VEncodable.swift
//
//
//

/// Represents something that can be encoded
/// in a format like V or vCard.
public protocol VEncodable {
    /// The encoded string in the format.
    var vEncoded: String { get }
}
