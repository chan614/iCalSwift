//
//  ICalEvent.swift
//
//
//

import Foundation

/// Provides a grouping of component properties that
/// describes an event.
///
/// See https://tools.ietf.org/html/rfc5545#section-3.6.1
public struct ICalEvent: VComponent {
    public let component = Constant.Component.event
    
    /// In the case of an iCalendar object that specifies a
    /// "METHOD" property, this property specifies the date and time that
    /// the instance of the iCalendar object was created.  In the case of
    /// an iCalendar object that doesn't specify a "METHOD" property, this
    /// property specifies the date and time that the information
    /// associated with the calendar component was last revised in the
    /// calendar store.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.7.2
    public var dtstamp: Date
    
    /// This property defines the persistent, globally unique
    /// identifier for the calendar component.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.4.7
    public var uid: String
    
    /// This property defines the access classification for a
    /// calendar component.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.1.3
    public var classification: String?
    
    /// This property specifies the date and time that the calendar
    /// information was created by the calendar user agent in the calendar
    /// store.
    ///
    /// Note: This is analogous to the creation date and time for a
    /// file in the file system.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.7.1
    public var created: Date?
    
    /// This property provides a more complete description of the
    /// calendar component than that provided by the "SUMMARY" property.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.1.5
    public var description: String?
    
    /// This property specifies when the calendar component begins.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.2.4
    public var dtstart: ICalDateTime?
    
    /// This property specifies the date and time that the
    /// information associated with the calendar component was last
    /// revised in the calendar store.
    ///
    /// Note: This is analogous to the modification date and time for a
    /// file in the file system.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.7.3
    public var lastModified: Date?
    
    /// This property defines the intended venue for the activity
    /// for the activity.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.1.7
    public var location: String?
    
    /// This property defines the organizer for a calendar component.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.4.3
    public var organizer: String? // TODO: Add more structure
    
    /// This property defines the relative priority for a calendar component.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.1.9
    public var priority: Int?
    
    /// This property defines the revision sequence number of the
    /// calendar component within a sequence of revisions.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.7.4
    public var seq: Int?
    
    /// This property defines the overall status or confirmation
    /// for the calendar component.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.1.11
    public var status: String?
    
    /// This property defines a short summary or subject for the
    /// calendar component.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.1.12
    public var summary: String?
    
    /// This property defines whether or not an event is
    /// transparent to busy time searches.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.2.7
    public var transp: String?
    
    /// This property defines a Uniform Resource Locator (URL)
    /// associated with the iCalendar object.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.4.6
    public var url: URL?
    
    // Mutually exclusive specifications of end date
    /// This property specifies the date and time that a calendar
    /// component ends.
    ///
    /// Must have the same 'ignoreTime'-value as tstart.
    /// Mutually exclusive to 'due'.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.2.2
    public var dtend: ICalDateTime? {
        willSet {
            if newValue != nil {
                duration = nil
            }
        }
    }
    
    /// This property specifies a positive duration of time.
    ///
    /// Mutually exclusive to 'due'.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.2.5
    public var duration: ICalDuration? {
        willSet {
            if newValue != nil {
                dtend = nil
            }
        }
    }
    
    /// This property is used in conjunction with the "UID" and
    /// "SEQUENCE" properties to identify a specific instance of a
    /// recurring "VEVENT", "VTODO", or "VJOURNAL" calendar component.
    /// The property value is the original value of the "DTSTART" property
    /// of the recurrence instance.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.4.4
    public var recurrenceID: Date?
    
    /// This property defines a rule or repeating pattern for
    /// recurring events, to-dos, journal entries, or time zone
    /// definitions.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.5.3
    public var rrule: ICalRRule?
    
    /// This property defines the list of DATE-TIME values for
    /// recurring events, to-dos, journal entries, or time zone
    /// definitions.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.5.2
    public var rdate: ICalDateTimes?
    
    /// This property defines the list of DATE-TIME exceptions for
    /// recurring events, to-dos, journal entries, or time zone
    /// definitions.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.8.5.1
    public var exdate: ICalDateTimes?
    
    /// This property provides the capability to associate a
    /// document object with a calendar component.
    ///
    /// See https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.1.1
    public var attachments: [ICalAttachment]?
    
    /// key: custom property name
    /// value: VPropertyEncodable
    public var extendProperties: [String: VPropertyEncodable]?
    
    // TODO: Define properties that can be specified multiple times:
    // public var attendees
    // public var categories
    // public var comments
    // public var contacts
    // public var rstatus
    // public var related
    
    public var alarms: [ICalAlarm]
    
    public var timeZone: ICalTimeZone?
    
    public var isAllDay: Bool {
        dtstart?.isDateOnly == true
    }
    
    public var children: [VComponent] {
        guard let timeZone = self.timeZone else { return alarms }
        
        var children: [VComponent] = alarms
        children.insert(timeZone, at: 0)
        
        return children
    }
    
    public var properties: [VContentLine?] {
        [
            .line(Constant.Prop.dtstamp, dtstamp),
            .line(Constant.Prop.uid, uid),
            .line(Constant.Prop.classification, classification),
            .line(Constant.Prop.created, created),
            .line(Constant.Prop.description, description),
            .line(Constant.Prop.dtstart, dtstart),
            .line(Constant.Prop.lastModified, lastModified),
            .line(Constant.Prop.location, location),
            .line(Constant.Prop.organizer, organizer),
            .line(Constant.Prop.priority, priority),
            .line(Constant.Prop.seq, seq),
            .line(Constant.Prop.status, status),
            .line(Constant.Prop.summary, summary),
            .line(Constant.Prop.transp, transp),
            .line(Constant.Prop.url, url),
            .line(Constant.Prop.dtend, dtend),
            .line(Constant.Prop.duration, duration),
            .line(Constant.Prop.recurrenceID, recurrenceID),
            .line(Constant.Prop.rrule, rrule),
            .line(Constant.Prop.rdate, rdate),
            .line(Constant.Prop.exdate, exdate),
            .lines(Constant.Prop.attach, attachments)
        ] + extendPropertiesLine
    }
    
    public var extendPropertiesLine: [VContentLine?] {
        extendProperties?.map {
            return .line($0.key, $0.value)
        } ?? []
    }
    
    public init(
        dtstamp: Date = Date(),
        uid: String = UUID().uuidString,
        classification: String? = nil,
        created: Date? = Date(),
        description: String? = nil,
        dtstart: ICalDateTime? = nil,
        lastModified: Date? = Date(),
        location: String? = nil,
        organizer: String? = nil,
        priority: Int? = nil,
        seq: Int? = nil,
        status: String? = nil,
        summary: String? = nil,
        transp: String? = nil,
        url: URL? = nil,
        dtend: ICalDateTime? = nil,
        duration: ICalDuration? = nil,
        recurrenceID: Date? = nil,
        rrule: ICalRRule? = nil,
        rdate: ICalDateTimes? = nil,
        exdate: ICalDateTimes? = nil,
        alarms: [ICalAlarm] = [],
        timeZone: ICalTimeZone? = nil,
        extendProperties: [String: VPropertyEncodable]? = nil
    ) {
        self.dtstamp = dtstamp
        self.uid = uid
        self.classification = classification
        self.created = created
        self.description = description
        self.dtstart = dtstart
        self.lastModified = lastModified
        self.location = location
        self.organizer = organizer
        self.priority = priority
        self.seq = seq
        self.status = status
        self.summary = summary
        self.transp = transp
        self.url = url
        self.recurrenceID = recurrenceID
        self.rrule = rrule
        self.rdate = rdate
        self.exdate = exdate
        self.dtend = dtend
        self.duration = duration
        self.alarms = alarms
        self.timeZone = timeZone
        self.extendProperties = extendProperties
        
        assert(dtend == nil || duration == nil, "End date/time and duration must not be specified together!")
    }
}
