//
//  ICalSubTimeZone.swift
//  
//
//

import Foundation

/// Provide a grouping of component properties that defines a
/// time zone.
///
/// See https://tools.ietf.org/html/rfc5545#section-3.6.5
public class ICalSubTimeZone: VComponent {
    public let component = ICalComponent.daylight
    
    /// This property specifies when the calendar component begins.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.2.4
    public var dtstart: Date
    
    /// This property specifies the offset that is in use in this
    /// time zone observance.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.3.4
    public var tzOffsetTo: String
    
    /// This property specifies the offset that is in use prior to
    /// this time zone observance.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.3.3
    public var tzOffsetFrom: String
    
    /// This property defines a rule or repeating pattern for
    /// recurring events, to-dos, journal entries, or time zone
    /// definitions.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.5.3
    public var rrule: ICalRule?
    
    /// This property specifies the customary designation for a
    /// time zone description.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.3.2
    public var tzName: String?
    
    public var properties: [VContentLine?] {
        [
            .line(ICalProperty.tzOffsetFrom, tzOffsetFrom),
            .line(ICalProperty.rrule, rrule),
            .line(ICalProperty.dtstart, dtstart),
            .line(ICalProperty.tzName, tzName),
            .line(ICalProperty.tzOffsetTo, tzOffsetTo)
        ]
    }
    
    public init(
        dtstart: Date,
        tzOffsetTo: String,
        tzOffsetFrom: String,
        rrule: ICalRule? = nil,
        tzName: String? = nil
    ) {
        self.dtstart = dtstart
        self.tzOffsetTo = tzOffsetTo
        self.tzOffsetFrom = tzOffsetFrom
        self.rrule = rrule
        self.tzName = tzName
    }
}
