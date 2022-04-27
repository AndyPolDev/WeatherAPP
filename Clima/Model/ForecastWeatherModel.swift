import Foundation

struct ForecastWeatherModel {
    var cityName: String
    var weatherParameters: [WeatherParameters]
    
}

struct WeatherParameters {
    
    var conditionID: Int
    var temperature: Double
    var dateUnix: Int
    var cityTimezone: Int
    
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            return "cloud.rain"
        case 520...531:
            return "cloud.heavyrain"
        case 600...602:
            return "cloud.snow"
        case 511, 611...622:
            return "cloud.sleet"
        case 701...771:
            return "smoke"
        case 781:
            return "tornado"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
            
        default:
            return "cloud"
        }
    }
    
    var dateString: String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(dateUnix))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
}



