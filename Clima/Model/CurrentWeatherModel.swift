import Foundation

struct CurrentWeatherModel {
    let conditoinID: Int
    let conditionDescription: String
    let windSpeed: Double
    let cityName: String
    let temperature: Double
    let feelsLikeTemperature: Double
    let pressure: Int
    let humidity: Int
    
    
    var windSpeedString: String {
        return String(format: "%.1f", windSpeed)
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var feelsLikeTemperatureString: String {
        return String(format: "%.1f", feelsLikeTemperature)
    }
    
    var convertedPressure: String {
        return String(format: "%.0f", Double(pressure) / 1.33322)
    }
    
    var conditionName: String {
        switch conditoinID {
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
}
