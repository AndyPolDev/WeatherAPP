import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyWeatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func configure(with: WeatherParameters) {
        dateLabel.text = with.dateString
        dailyWeatherImage.image = UIImage(systemName: with.conditionName)
        temperatureLabel.text = with.temperatureString
    }
}
