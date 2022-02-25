import XCTest
@testable import ICalSwift

final class ICalSwiftTests: XCTestCase {
    
    func testICalEventToVEncoded() throws {
        let event = ICalEvent(
            dtstamp: Date(),
            uid: "example@gmail.com",
            classification: nil,
            created: Date(),
            description: "example",
            dtstart: .init(date: Date()),
            lastModified: Date(),
            location: "1",
            organizer: nil,
            priority: 1,
            seq: nil,
            status: "CONFIRMED",
            summary: "Spinning",
            transp: "SPAQUE",
            url: nil,
            dtend: nil,
            duration: nil,
            recurrenceID: Date(),
            rrule: .init(
                frequency: .daily,
                interval: 30,
                until: nil,
                count: 3,
                bySecond: nil,
                byMinute: [10, 30],
                byHour: nil,
                byDay: [.first(.friday)],
                byDayOfMonth: nil,
                byDayOfYear: nil,
                byWeekOfYear: nil,
                byMonth: nil,
                bySetPos: nil,
                startOfWorkweek: .sunday),
            rdates: [Date(), Date(), Date()],
            exrule: nil,
            exdates: [Date(), Date()],
            alarms: [.audioProp(trigger: Date(), duration: .init(totalSeconds: 300), repetition: nil, attach: nil)],
            timeZone: nil,
            extendProperties: ["X-MAILPLUG-PROPERTY": "TEST"])
        
        let vEncoded = event.vEncoded
        
        print(vEncoded)
        
        XCTAssertFalse(vEncoded.isEmpty)
    }
}
