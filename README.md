# iCalSwift

[iCalendar(RFC 5545)](https://tools.ietf.org/html/rfc5545#section-3.8.7.4) encoder and decoder for Swift

## Creating a VEvent

---

 

```swift
let alarm = ICalAlarm.audioProp(
            trigger: Date(),
            duration: .init(totalSeconds: 3000),
            repetition: nil,
            attach: nil)

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
            rrule: nil,
            rdates: [Date(), Date(), Date()],
            exrule: nil,
            exdates: [Date(), Date()],
            alarms: [alarm],
            timeZone: nil,
            extendProperties: ["X-EXTEND-PROPERTY": "TEST"])

let vEncoded = event.vEncoded
        
print(vEncoded)
```

This will decode a `VEvent` to
