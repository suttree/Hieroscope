import Foundation
import WidgetKit
import SwiftUI

let appGroupUserDefaultsID = "group.com.suttree.glyphe"

struct IconEntry: Codable {
    let date: Date
    let icons: [String]
}

struct RandomIconsEntry: TimelineEntry {
    let date: Date
    let icon1: UIImage
    let icon2: UIImage
    let icon3: UIImage
    let icon4: UIImage
}

enum WidgetSize {
    case small, medium, large
}

func dayString() -> String {
    let dayString = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
    return "\(dayString)"
}

struct HBorderView: View {
    var body: some View {
        let gradient = Gradient(stops: [
            .init(color: .clear, location: 0),
            .init(color: .clear, location: 0.25),
            .init(color: .white, location: 0.45),
            .init(color: .white, location: 0.55),
            .init(color: .clear, location: 0.75),
            .init(color: .clear, location: 1)
        ])
        
        return LinearGradient(gradient: gradient,
                              startPoint: .leading,
                              endPoint: .trailing)
            .frame(width: nil, height: 1)
    }
}

struct VBorderView: View {
    let isTop: Bool
    
    var body: some View {
        if isTop {
            let gradient = Gradient(stops: [
                .init(color: .clear, location: 0),
                .init(color: .clear, location: 0.55),
                .init(color: .white, location: 0.75),
                .init(color: .white, location: 1)
            ])
            
            return LinearGradient(gradient: gradient,
                                  startPoint: .top,
                                  endPoint: .bottom)
                .frame(width: 1, height: nil)
        } else {
            let gradient = Gradient(stops: [
                .init(color: .white, location: 0),
                .init(color: .white, location: 0.25),
                .init(color: .clear, location: 0.45),
                .init(color: .clear, location: 1)
            ])
            
            return LinearGradient(gradient: gradient,
                                  startPoint: .top,
                                  endPoint: .bottom)
                .frame(width: 1, height: nil)
        }
    }
}

struct RandomIconsWidgetEntryView: View {
    var entry: RandomIconsEntry

    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
            Group {
                switch widgetFamily {
                case .systemSmall:
                    VStack {
                        Image(uiImage: entry.icon1)
                            .resizable()
                            .scaledToFit()
                        Text(dayString())
                            .font(.system(.body, design: .serif).italic())
                            .foregroundColor(Color(white: 0.2))
                            .multilineTextAlignment(.center)
                            .padding(.top, 5)
                    }

                case .systemMedium:
                    HStack {
                        VStack(spacing: 0) {
                            Image(uiImage: entry.icon1)
                                .resizable()
                                .scaledToFit()
                                .padding(.bottom, 14)

                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 1)
                        }
                        .background(Color.clear)
                        
                        VStack(spacing: 0) {
                            Image(uiImage: entry.icon2)
                                .resizable()
                                .scaledToFit()
                                .padding(.bottom, 14)

                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 1)
                        }
                        .background(Color.clear)
                        
                        VStack(spacing: 0) {
                            Image(uiImage: entry.icon3)
                                .resizable()
                                .scaledToFit()
                                .padding(.bottom, 14)

                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 1)
                        }
                        .background(Color.clear)
                        
                        VStack(spacing: 0) {
                            Image(uiImage: entry.icon4)
                                .resizable()
                                .scaledToFit()
                                .padding(.bottom, 14)

                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 1)
                        }
                        .background(Color.clear)
                    }
                    Text(dayString())
                        .font(.system(.body, design: .serif).italic())
                        .foregroundColor(Color(white: 0.2))
                        .padding(.top, 5)

                case .systemLarge:
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Image(uiImage: entry.icon1)
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                            VBorderView(isTop: true)
                            Image(uiImage: entry.icon2)
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                        }
                        HBorderView()
                        HStack(spacing: 0) {
                            Image(uiImage: entry.icon3)
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                            VBorderView(isTop: false)
                            Image(uiImage: entry.icon4)
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                        }
                    }
                    .padding(0)
                    Text(dayString())
                        .font(.system(.body, design: .serif).italic())
                        .foregroundColor(Color(white: 0.2))
                        .padding(.top, 5)

                default:
                    Image(uiImage: entry.icon1)
                        .resizable()
                        .scaledToFit()
                }
            }
        .containerBackground(for: .widget) {
            Color(white: 0.95)
        }
    }
}

struct RandomIconsProvider: TimelineProvider {
    typealias Entry = RandomIconsEntry

    let defaults = UserDefaults(suiteName: appGroupUserDefaultsID)
    let lastUpdateKey = "LastUpdateDate"

    func placeholder(in context: Context) -> RandomIconsEntry {
        let icons = fetchRandomIconsIfNeeded(currentDate: Date())
        return RandomIconsEntry(date: Date(), icon1: icons[0], icon2: icons[1], icon3: icons[2], icon4: icons[3])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RandomIconsEntry) -> ()) {
        let icons = fetchRandomIconsIfNeeded(currentDate: Date())
        let entry = RandomIconsEntry(date: Date(), icon1: icons[0], icon2: icons[1], icon3: icons[2], icon4: icons[3])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        //resetDefaults()

        var entries: [RandomIconsEntry] = []

        let calendar = Calendar.current
        let currentDate = Date()

        guard let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: currentDate)) else { return }

        var icons = fetchRandomIconsIfNeeded(currentDate: currentDate)

        for hourOffset in stride(from: 0, to: 24, by: 6) {
            guard let entryDate = calendar.date(byAdding: .hour, value: hourOffset, to: currentDate) else { continue }

            if hourOffset != 0 {
                icons.rotate()
            }

            let entry = RandomIconsEntry(date: entryDate, icon1: icons[0], icon2: icons[1], icon3: icons[2], icon4: icons[3])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .after(startOfNextDay))
        completion(timeline)
    }

    func fetchRandomIconsIfNeeded(currentDate: Date) -> [UIImage] {
        guard let sharedDefaults = UserDefaults(suiteName: appGroupUserDefaultsID) else {
            return [UIImage(named: "1.png") ?? UIImage(), UIImage(named: "2.png") ?? UIImage(), UIImage(named: "3.png") ?? UIImage(), UIImage(named: "4.png") ?? UIImage()]
        }

        let lastUpdateDate = sharedDefaults.object(forKey: lastUpdateKey) as? Date ?? Date.distantPast
        
        if !Calendar.current.isDate(lastUpdateDate, inSameDayAs: currentDate) {
            let iconNames = ["0.png", "1.png", "2.png", "3.png", "4.png", "14.png", "15.png", "16.png", "17.png", "18.png", "19.png", "20.png", "21.png", "22.png", "23.png", "24.png", "25.png", "26.png", "27.png", "28.png", "29.png", "30.png", "31.png", "32.png", "33.png", "34.png", "35.png", "36.png", "37.png", "38.png", "39.png", "40.png", "41.png", "42.png", "43.png", "44.png", "45.png", "46.png", "47.png", "48.png", "49.png", "50.png", "51.png", "52.png", "53.png", "54.png", "55.png", "56.png", "57.png", "58.png", "59.png", "60.png", "61.png", "62.png", "63.png", "64.png", "65.png", "66.png", "67.png", "68.png", "69.png", "70.png", "71.png", "72.png", "74.png", "76.png", "78.png", "80.png", "82.png", "84.png", "85.png", "86.png", "88.png", "93.png", "94.png", "95.png", "96.png", "98.png", "101.png", "104.png", "105.png", "106.png", "107.png", "109.png", "110.png", "111.png", "112.png", "113.png", "114.png", "115.png", "116.png", "117.png", "118.png", "119.png", "120.png", "121.png", "122.png", "123.png", "124.png", "125.png", "126.png", "127.png", "128.png", "129.png", "130.png", "132.png", "133.png", "136.png", "137.png", "138.png", "139.png", "140.png", "141.png", "142.png", "143.png", "144.png", "145.png", "146.png", "147.png", "148.png", "149.png", "150.png", "151.png", "152.png", "153.png", "154.png", "155.png", "156.png", "157.png", "158.png", "159.png", "160.png", "161.png", "162.png", "163.png", "164.png", "165.png", "166.png", "167.png", "168.png", "169.png", "170.png", "171.png", "172.png", "173.png", "174.png", "175.png", "176.png", "177.png", "178.png", "179.png", "180.png", "181.png", "182.png", "184.png", "185.png", "186.png", "187.png", "188.png", "189.png", "190.png", "191.png", "192.png", "193.png", "194.png", "195.png", "196.png", "197.png", "198.png", "199.png", "200.png", "201.png", "202.png", "203.png", "204.png", "205.png", "206.png", "207.png", "208.png", "209.png", "210.png", "211.png", "212.png", "213.png", "214.png", "215.png", "216.png", "217.png", "218.png", "219.png", "220.png", "221.png", "222.png", "223.png", "224.png", "225.png", "226.png", "227.png", "228.png", "229.png", "230.png", "231.png", "232.png", "233.png", "234.png", "235.png", "236.png", "237.png", "238.png", "239.png", "240.png", "241.png", "242.png", "243.png", "244.png", "245.png", "246.png", "247.png", "248.png", "249.png", "250.png", "251.png", "252.png", "253.png", "254.png", "255.png", "256.png", "257.png", "258.png", "259.png", "260.png", "261.png", "262.png", "263.png", "264.png", "265.png", "266.png", "267.png", "268.png", "269.png", "270.png", "271.png", "272.png", "273.png", "274.png", "275.png", "276.png", "277.png", "278.png", "279.png", "280.png", "281.png", "282.png", "283.png", "284.png", "285.png", "286.png", "287.png", "288.png", "289.png", "290.png", "291.png", "292.png", "293.png", "294.png", "295.png", "296.png", "297.png", "298.png", "299.png", "300.png", "301.png", "302.png", "303.png", "304.png", "305.png", "306.png", "307.png", "308.png", "309.png", "310.png", "311.png", "312.png", "313.png", "314.png", "315.png", "316.png", "317.png", "318.png", "319.png", "320.png", "321.png", "322.png", "323.png", "324.png"].shuffled()

            let arraySlice: ArraySlice<String> = iconNames.prefix(4)
            let array = Array(arraySlice)
            
            sharedDefaults.set(array, forKey: "LastChosenIcons")
            sharedDefaults.set(currentDate, forKey: lastUpdateKey)
            
            let chosen_icons = iconNames.prefix(4)
            saveIconsForTheDay(icons: [chosen_icons.joined(separator: ", ")])
            return chosen_icons.map { UIImage(named: $0) ?? UIImage() }
        } else {
            let storedIconNames = sharedDefaults.stringArray(forKey: "LastChosenIcons") ?? ["1.png", "2.png", "3.png", "4.png"]
            //saveIconsForTheDay(icons: [storedIconNames.joined(separator: ", ")])
            return storedIconNames.map { UIImage(named: $0) ?? UIImage() }
        }
    }
}

func saveIconsForTheDay(icons: [String]) {
    let currentDate = Calendar.current.startOfDay(for: Date())
    
    print("1")
    print(currentDate)
    
    var entries = fetchIconEntries()
    
    print(entries)
    
    if !entries.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }) {
        let entry = IconEntry(date: currentDate, icons: icons)
        entries.append(entry)
        entries = Array(entries.suffix(7))
        saveIconEntries(entries)
    }
}

func fetchIconEntries() -> [IconEntry] {
    if let defaults = UserDefaults(suiteName: appGroupUserDefaultsID) {
        if let savedData = defaults.data(forKey: "IconEntries") {
            if let decodedEntries = try? JSONDecoder().decode([IconEntry].self, from: savedData) {
                return decodedEntries
            }
        }
    }
    return []
}

func saveIconEntries(_ entries: [IconEntry]) {
    if let encodedData = try? JSONEncoder().encode(entries) {
        if let defaults = UserDefaults(suiteName: appGroupUserDefaultsID) {
            print("2")
            print(encodedData)
            defaults.set(encodedData, forKey: "IconEntries")
        }
    }
}

func getSavedIconsFor(date: Date) -> [String]? {
    let entries = fetchIconEntries()
    return entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }?.icons
}

func resetDefaults() {
    if let bundleID = Bundle.main.bundleIdentifier {
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }
    
    if let defaults = UserDefaults(suiteName: appGroupUserDefaultsID) {
        defaults.removeObject(forKey: "IconEntries")
    }
}

extension Array {
    mutating func rotate() {
        if let firstElement = self.first {
            self.append(firstElement)
            self.removeFirst()
        }
    }
}
