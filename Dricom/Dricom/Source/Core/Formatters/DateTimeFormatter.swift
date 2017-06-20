import Foundation

public final class DateTimeFormatter {
    
    // MARK: - Private properties
    
    private static let todayTimeFormatter = DateTimeFormatter.dateFormatterWithFormat("HH:mm")
    private static let todayDateTimeFormatter = DateTimeFormatter.dateFormatterWithFormat("Сегодня, HH:mm")
    
    private static let yesterdayDateFormatter = DateTimeFormatter.dateFormatterWithFormat("Вчера")
    private static let yesterdayDateTimeFormatter = DateTimeFormatter.dateFormatterWithFormat("Вчера, HH:mm")
    
    private static let weekdayDateFormatter = DateTimeFormatter.dateFormatterWithFormat("EEEE")
    private static let weekdayDateTimeFormatter = DateTimeFormatter.dateFormatterWithFormat("EEEE, HH:mm")
    
    private static let dayDateFormatter = DateTimeFormatter.dateFormatterWithFormat("d MMMM")
    private static let dayDateTimeFormatter = DateTimeFormatter.dateFormatterWithFormat("d MMMM, HH:mm")
    
    private static let yearDayDateFormatter = DateTimeFormatter.dateFormatterWithFormat("d MMMM yyyy")
    private static let yearDayDateTimeFormatter = DateTimeFormatter.dateFormatterWithFormat("d MMMM yyyy, HH:mm")
    
    private static let fullDateTimeFormatter = DateTimeFormatter.dateFormatterWithFormat("d MMMM yyyy, HH:mm")
    
    private static let timeFormatter = DateTimeFormatter.dateFormatterWithFormat("H:mm")
    private static let shortDateFormatter = DateTimeFormatter.dateFormatterWithFormat("dd.MM.yyyy")
    
    // currentCalendar() is an expensive operation (really)
    private static let currentCalendar: Calendar = Calendar.autoupdatingCurrent
    private static let russianLocale = Locale(identifier: "ru_RU")
    
    // MARK: - Public
    public static func lastMessageDateTimeText(
        _ date: Date,
        currentDate: Date = Date(),
        calendar: Calendar = currentCalendar) -> String
    {
        return messageDateTimeText(
            date,
            currentDate: currentDate,
            calendar: calendar,
            todayDateFormatter: todayTimeFormatter,
            yesterdayDateFormatter: yesterdayDateFormatter,
            weekdayDateFormatter: weekdayDateFormatter,
            dayDateFormatter: dayDateFormatter,
            yearDayDateFormatter: yearDayDateFormatter,
            fullDateFormatter: fullDateTimeFormatter
        )
    }
    
    // MARK: - Private
    private static func messageDateTimeText(
        _ date: Date,
        currentDate: Date,
        calendar: Calendar,
        todayDateFormatter: DateFormatter,
        yesterdayDateFormatter: DateFormatter,
        weekdayDateFormatter: DateFormatter,
        dayDateFormatter: DateFormatter,
        yearDayDateFormatter: DateFormatter,
        fullDateFormatter: DateFormatter) -> String
    {
        let midnights: Int = midnightsBetween(
            date,
            currentDate,
            calendar: calendar
        )
        
        let newYears: Int = newYearsBetween(
            date,
            currentDate,
            calendar: calendar
        )
        
        let formatter: DateFormatter
        
        switch midnights {
        case 0:
            formatter = todayDateFormatter
        case 1:
            formatter = yesterdayDateFormatter
        case 2...6:
            formatter = weekdayDateFormatter
        default:
            if newYears == 0 {
                let dateIsInFuture = date.compare(currentDate) == .orderedDescending
                
                if dateIsInFuture {
                    // Something gone wrong (most likely it's local time on device, which is incorrect), show full date
                    formatter = fullDateFormatter
                } else {
                    formatter = dayDateFormatter
                }
            } else {
                formatter = yearDayDateFormatter
            }
        }
        
        // 30 times faster than without this check, just fyi
        if formatter.timeZone != calendar.timeZone {
            formatter.timeZone = calendar.timeZone
        }
        
        return formatter.string(from: date).byCapitalizingFirstCharacter
    }
    
    private static func midnightsBetween(
        _ soonerDate: Date,
        _ laterDate: Date,
        calendar: Calendar = currentCalendar) -> Int
    {
        
        let soonerDay = (calendar as NSCalendar).ordinality(of: NSCalendar.Unit.day,
                                                            in: NSCalendar.Unit.era,
                                                            for: soonerDate)
        let laterDay = (calendar as NSCalendar).ordinality(of: NSCalendar.Unit.day,
                                                           in: NSCalendar.Unit.era, for: laterDate)
        
        return laterDay - soonerDay
    }
    
    private static func newYearsBetween(
        _ soonerDate: Date,
        _ laterDate: Date,
        calendar: Calendar = currentCalendar) -> Int
    {
        let soonerYear = (calendar as NSCalendar).ordinality(of: NSCalendar.Unit.year,
                                                             in: NSCalendar.Unit.era,
                                                             for: soonerDate)
        let laterYear = (calendar as NSCalendar).ordinality(of: NSCalendar.Unit.year,
                                                            in: NSCalendar.Unit.era,
                                                            for: laterDate)
        
        return laterYear - soonerYear
    }
    
    private static func dateFormatterWithFormat(_ format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = russianLocale
        dateFormatter.dateFormat = format
        return dateFormatter
    }
}
