import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var felsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionWeahterLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    

    var currentWeatherManager = CurrentWeatherManager()
    var forecastWeatherManager = ForecastWeatherManager()
    let locationManager = CLLocationManager()
    var forecastWeather: ForecastWeatherModel?
    
    var array = [1, 2, 3, 4, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        currentWeatherManager.delegate = self
        forecastWeatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //tableView.backgroundColor = .none
        let timestamp = NSDate().timeIntervalSince1970
        let startForecastWeatherParameters = [WeatherParameters(conditionID: 500, temperature: 25.0, dateUnix: Int(timestamp), cityTimezone: 0)]
        forecastWeather?.cityName = ""
        forecastWeather?.weatherParameters = startForecastWeatherParameters
        tableView.reloadData()
        
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
    }
    @IBAction func searchGeoPositionPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

extension WeatherViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter the City name"
            return true
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            currentWeatherManager.fetchWeather(cityName: city)
            forecastWeatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let safeForecastWeather = forecastWeather {
            return safeForecastWeather.weatherParameters.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else {
            return UITableViewCell()
        }
        if let safeForecastWeather = forecastWeather {
            DispatchQueue.main.async {
                cell.configure(with: safeForecastWeather.weatherParameters[indexPath.row])
            }
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}

extension WeatherViewController: CurrentWeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: CurrentWeatherManager, weather: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.felsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.pressureLabel.text = weather.convertedPressure
            self.humidityLabel.text = String(weather.humidity)
            self.windSpeedLabel.text = weather.windSpeedString
            self.descriptionWeahterLabel.text = weather.conditionDescription
            
        }
        
    }
    
    func didFailwithError(_ weatherManager: CurrentWeatherManager, error: Error) {
        print(error.localizedDescription)
    }
    
}

extension WeatherViewController: ForecastWeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: ForecastWeatherManager, weather: ForecastWeatherModel) {
        forecastWeather = weather
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailwithError(_ weatherManager: ForecastWeatherManager, error: Error) {
        print(error.localizedDescription)
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let safelocation = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = safelocation.coordinate.latitude
            let lon = safelocation.coordinate.longitude
            currentWeatherManager.fetchWeather(latitude: lat, longitude: lon)
            forecastWeatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
