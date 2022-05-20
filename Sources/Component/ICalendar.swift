//
//  ICalendar.swift
//
//
//

import Foundation

/// A collection of calendaring and scheduling information.
///
/// See https://tools.ietf.org/html/rfc5545#section-3.4
public struct ICalendar: VComponent {
    public let component = Constant.Component.calendar

    /// The identifier corresponding to the highest version number
    /// or the minimum and maximum range of the iCalendar specification
    /// that is required in order to interpret the iCalendar object.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.7.4
    public let version = "2.0"

    /// The identifier for the product that created the iCalendar
    /// object.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.7.3
    public var prodid: ICalProductIdentifier

    /// The calendar scale for the calendar information specified
    /// in this iCalendar object.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.7.1
    public var calscale: String?

    /// The iCalendar object method associated with the calendar
    /// object.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.7.2
    public var method: String?

    public var events: [ICalEvent]
    public var timeZones: [ICalTimeZone]
    public var alarms: [ICalAlarm]

    public var children: [VComponent] {
        [events, timeZones, alarms]
            .compactMap { $0 as? [VComponent] }
            .flatMap { $0 }
    }
    
    public var properties: [VContentLine?] {
        [
            .line(Constant.Prop.version, version),
            .line(Constant.Prop.prodid, prodid),
            .line(Constant.Prop.calscale, calscale),
            .line(Constant.Prop.method, method)
        ]
    }

    public init(
        prodid: ICalProductIdentifier = .init(),
        calscale: String? = nil,
        method: String? = nil,
        events: [ICalEvent] = [],
        timeZones: [ICalTimeZone] = [],
        alarms: [ICalAlarm] = []
    ) {
        self.prodid = prodid
        self.calscale = calscale ?? "GREGORIAN"
        self.method = method
        self.events = events
        self.timeZones = timeZones
        self.alarms = alarms
    }
}
