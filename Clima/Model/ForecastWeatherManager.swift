protocol ForecastWeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: ForecastWeatherManager, weather: ForecastWeatherModel)
    func didFailwithError(_ weatherManager: ForecastWeatherManager, error: Error)
    
}

import Foundation
import CoreLocation

struct ForecastWeatherManager {
    
    var delegate: ForecastWeatherManagerDelegate?
    
    let forecastWeatherURL = "https://api.openweathermap.org/data/2.5/forecast?units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(forecastWeatherURL)&appid=\(K.appid)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(forecastWeatherURL)&appid=\(K.appid)&lat=\(latitude)&lon=\(longitude)"
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
                if let weather = self.parseJSON(safeData) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
        // 4. Start the task
        task.resume()
    }
    
   
    func parseJSON(_ forecastWeatherData: Data) -> ForecastWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastWeatherData.self, from: forecastWeatherData)
            
            var weatherParametersArray = [WeatherParameters]()
            
            for itemList in decodedData.list {
                let cityTimezone = decodedData.city.timezone
                let dateUnix = itemList.dt
                let temperature = itemList.main.temp
                let conditionID = itemList.weather[0].id
                
                let weatherParameters = WeatherParameters(conditionID: conditionID, temperature: temperature, dateUnix: dateUnix, cityTimezone: cityTimezone)
                
                weatherParametersArray.append(weatherParameters)
                
            }
            
            let forecastWeather = ForecastWeatherModel(cityName: decodedData.city.name, weatherParameters: weatherParametersArray)
            
            return forecastWeather
        } catch {
            self.delegate?.didFailwithError(self, error: error)
            return nil
        }
    }
    
}

