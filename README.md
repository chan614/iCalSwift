# iCalSwift

[iCalendar(RFC 5545)](https://tools.ietf.org/html/rfc5545#section-3.8.7.4) encoder and decoder for Swift

## Encode a VEvent

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

This will encode a `VEvent` to

```
BEGIN:VEVENT
DTSTAMP:20220305T092707Z
UID:example@gmail.com
CREATED:20220305T092707Z
DESCRIPTION:example
DTSTART:20220305T092707Z
LAST-MODIFIED:20220305T092707Z
LOCATION:1
PRIORITY:1
STATUS:CONFIRMED
SUMMARY:Spinning
TRANSP:SPAQUE
RECURRENCE-ID:20220305T092707Z
RRULE:FREQ=DAILY;INTERVAL=30;COUNT=3;BYMINUTE=10,30;BYDAY=1FR;WKST=SU
RDATE:20220305T092707Z
RDATE:20220305T092707Z
RDATE:20220305T092707Z
EXDATE:20220305T092707Z
EXDATE:20220305T092707Z
X-EXTEND-PROPERTY:TEST
BEGIN:VALAM
ACTION:AUDIO
TRIGGER:20220305T092707Z
DURATION:P0DT0H50M0S
END:VALAM
END:VEVENT
```

## Decode a VEvent

```swift
let sampleICS = """
BEGIN:VEVENT
DTSTAMP:20220305T092707
UID:example@gmail.com
...
END:VALAM
END:VEVENT
"""

let parser = ICalParser()
let vEvents = parser.parseEvent(ics: sampleICS)
       
vEvents.forEach { vEvent in
    print(vEvent.vEncoded)
}
```
