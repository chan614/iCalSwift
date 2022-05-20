//
//  Constant.swift
//  
//
//

import Foundation

public enum Constant {
    public enum Prop {
        public static let begin = "BEGIN"
        public static let end = "END"
        
        public static let dtstamp = "DTSTAMP"
        public static let uid = "UID"
        public static let classification = "CLASS"
        public static let created = "CREATED"
        public static let description = "DESCRIPTION"
        public static let dtstart = "DTSTART"
        public static let lastModified = "LAST-MODIFIED"
        public static let location = "LOCATION"
        public static let organizer = "ORGANIZER"
        public static let priority = "PRIORITY"
        public static let seq = "SEQ"
        public static let status = "STATUS"
        public static let summary = "SUMMARY"
        public static let transp = "TRANSP"
        public static let url = "URL"
        public static let dtend = "DTEND"
        public static let duration = "DURATION"
        public static let recurrenceID = "RECURRENCE-ID"
        public static let rrule = "RRULE"
        public static let rdates = "RDATE"
        public static let exdates = "EXDATE"
        
        public static let version = "VERSION"
        public static let prodid = "PRODID"
        public static let calscale = "CALSCALE"
        public static let method = "METHOD"
        
        public static let tzOffsetFrom = "TZOFFSETFROM"
        public static let tzName = "TZNAME"
        public static let tzOffsetTo = "TZOFFSETTO"
        public static let tzid = "TZID"
        
        public static let action = "ACTION"
        public static let trigger = "TRIGGER"
        public static let repetition = "REPEAT"
        public static let attach = "ATTACH"
        
        public static let frequency = "FREQ"
        public static let interval = "INTERVAL"
        public static let until = "UNTIL"
        public static let count = "COUNT"
        public static let bySecond = "BYSECOND"
        public static let byMinute = "BYMINUTE"
        public static let byHour = "BYHOUR"
        public static let byDay = "BYDAY"
        public static let byDayOfMonth = "BYMONTHDAY"
        public static let byDayOfYear = "BYYEARDAY"
        public static let byWeekOfYear = "BYWEEKNO"
        public static let byMonth = "BYMONTH"
        public static let bySetPos = "BYSETPOS"
        public static let startOfWorkweek = "WKST"
    }
    
    public enum Component {
        public static let calendar = "VCALENDAR"
        public static let event = "VEVENT"
        public static let alarm = "VALAM"
        public static let timeZone = "VTIMEZONE"
        public static let daylight = "DAYLIGHT"
        public static let standard = "STANDARD"
    }
    
    public enum Format {
        public static let dateOnly = "yyyyMMdd"
        public static let dt = "yyyyMMdd'T'HHmmss"
        public static let utc = "yyyyMMdd'T'HHmmss'Z'"
    }
}
