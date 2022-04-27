protocol CurrentWeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: CurrentWeatherManager, weather: CurrentWeatherModel)
    
    func didFailwithError(_ weatherManager: CurrentWeatherManager, error: Error)
    
}

import Foundation
import CoreLocation

struct CurrentWeatherManager {
    
    var delegate: CurrentWeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&appid=\(K.appid)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&appid=\(K.appid)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        // 1. Create URL
        guard let url = URL(string: urlString) else {
            print("Error: can't create URL")
            return
        }
        // 2. Create URLSession
        let session = URLSession(configuration: .default)
        
        // 3. Give the session task
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailwithError(self, error: error!)
                return
            }
            if let safeData = data {
                if let weather = self.parseJSON(currentWeatherData: safeData) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
        // 4. Start the task
        task.resume()
    }
    
    func parseJSON(currentWeatherData: Data) -> CurrentWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrentWeatherData.self, from: currentWeatherData)
            let id = decodedData.weather[0].id
            let conditionDescription = decodedData.weather[0].description
            let temp = decodedData.main.temp
            let feelsLikeTemp = decodedData.main.feels_like
            let cityName = decodedData.name
            let windSpeed = decodedData.wind.speed
            let pressure = decodedData.main.pressure
            let humidity = decodedData.main.humidity
            
            let currentWeather = CurrentWeatherModel(conditoinID: id, conditionDescription: conditionDescription, windSpeed: windSpeed, cityName: cityName, temperature: temp, feelsLikeTemperature: feelsLikeTemp, pressure: pressure, humidity: humidity)
            
            return currentWeather
            
        } catch {
            self.delegate?.didFailwithError(self, error: error)
            return nil
        }
    }
    
}

