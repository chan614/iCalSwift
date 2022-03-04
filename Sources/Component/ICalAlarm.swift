//
//  ICalAlarm.swift
//  
//
//

import Foundation

/// Provide a grouping of component properties that define an
/// alarm.
///
/// See https://tools.ietf.org/html/rfc5545#section-3.6.6
public struct ICalAlarm: VComponent {
    public let component = ICalComponent.alarm
    
    /// This property defines the action to be invoked when an
    /// alarm is triggered.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.6.1
    public var action: String
    
    /// This property specifies when an alarm will trigger.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.6.3
    public var trigger: Date
    
    /// This property defines a short summary or subject for the
    /// calendar component.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.1.12
    public var summary: String?
    
    /// This property provides a more complete description of the
    /// calendar component than that provided by the "SUMMARY" property.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.1.5
    public var description: String?
    
    /// This value type is used to identify properties that contain
    /// a duration of time.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.3.6
    public var duration: ICalDuration?
    
    /// This property defines the number of times the alarm should
    /// be repeated, after the initial trigger.
    /// ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.6.2
    public var repetition: Int?
    
    /// This property provides the capability to associate a
    ///document object with a calendar component.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.1.1
    public var attach: String?
    
    public var properties: [VContentLine?] {
        [
            .line(ICalProperty.action, action),
            .line(ICalProperty.trigger, trigger),
            .line(ICalProperty.description, description),
            .line(ICalProperty.summary, summary),
            .line(ICalProperty.duration, duration),
            .line(ICalProperty.repetition, repetition),
            .line(ICalProperty.attach, attach)
        ]
    }
    
    public static func audioProp(
        trigger: Date,
        duration: ICalDuration? = nil,
        repetition: Int? = nil,
        attach: String? = nil
    ) -> ICalAlarm {
        return .init(
            action: "AUDIO",
            trigger: trigger,
            summary: nil,
            description: nil,
            duration: duration,
            repetition: repetition,
            attach: attach)
    }
    
    public static func displayProp(
        trigger: Date,
        description: String,
        duration: ICalDuration? = nil,
        repetition: Int? = nil
    ) -> ICalAlarm {
        return .init(
            action: "DISPLAY",
            trigger: trigger,
            summary: nil,
            description: description,
            duration: duration,
            repetition: repetition,
            attach: nil)
    }
    
    public static func emailProp(
        trigger: Date,
        description: String,
        summary: String,
        duration: ICalDuration? = nil,
        repetition: Int? = nil,
        attach: String? = nil
    ) -> ICalAlarm {
        return .init(
            action: "EMAIL",
            trigger: trigger,
            summary: summary,
            description: description,
            duration: duration,
            repetition: repetition,
            attach: attach)
    }
}
