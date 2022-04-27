import Foundation

struct ForecastWeatherData: Codable {
    let city: ForecastCity
    let list: [ForecastList]
}


struct ForecastCity: Codable {
    let timezone: Int
    let name: String
}

struct ForecastList: Codable {
    let dt: Int
    let main: ForecastMain
    let weather: [ForecastWeather]
}


struct ForecastMain: Codable {
    let temp: Double
}

struct ForecastWeather: Codable {
    let id: Int
}
