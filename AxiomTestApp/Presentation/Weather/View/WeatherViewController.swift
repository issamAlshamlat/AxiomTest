//
//  WeatherViewController.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation
import UIKit
import SnapKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var weatherPresenter: WeatherPresenter
    private var weatherModel: WeatherResponseModel!
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = .skyWithCloudsImage
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.placeholder = .enter_lat_lng_textfield_placeholder_string
        textField.setPlaceholderColor(.white)
        textField.setPadding(12)
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.setTitle(.search_string, for: .normal)
        button.setTitleColor(.MADarkBlue, for: .normal)
        button.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var userLocationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(userLocationTapped), for: .touchUpInside)
        button.setImage(.locationImage, for: .normal)
        return button
    }()
    
    init(presenter: WeatherPresenter) {
        self.weatherPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupPresenterAndFetchData()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        view.addSubview(textField)
        view.addSubview(searchButton)
        view.addSubview(userLocationButton)
        
        searchButton.addTarget(self, action: #selector(navigateToWeatherDetailsVC), for: .touchUpInside)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = .weather_string
    }
    
    private func setupConstraints() {

        backgroundImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        textField.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        userLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
    }
    
    private func setupPresenterAndFetchData() {
        let dependencyContainer = WeatherPresenterDependencyContainer.shared
        weatherPresenter = dependencyContainer.resolveWeatherPresenter()
        weatherPresenter.setViewDelegate(delegate: self)
    }
    
    @objc func searchTapped() {
        guard let text = textField.text, !text.isEmpty else{return}
        let coordinates = text.extractCoordinates()
        guard let lat = coordinates.latitude, let lng = coordinates.longitude else {return}
        
        let clLocationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        weatherPresenter.fetchWeatherData(location: clLocationCoordinates)
    }
    
    @objc func navigateToWeatherDetailsVC() {
        guard let weatherModel = weatherModel else {return}
        let weatherDetailsVC = WeatherDetailsViewController( presenter: WeatherDetailsPresenter(weather: weatherModel))
        self.navigationController?.pushViewController(weatherDetailsVC, animated: true)
    }
    
    @objc func userLocationTapped() {
        weatherPresenter.getUserLocationAndFetchData()
    }
}

extension WeatherViewController: WeatherViewDelegate {
    
    func showWeatherData(weather: WeatherResponseModel) {
        self.weatherModel = weather
        weatherPresenter.saveWeatherDataToDB(weather: weather)
        
        guard let weatherModel = weatherModel else {return}
        let weatherDetailsVC = WeatherDetailsViewController( presenter: WeatherDetailsPresenter(weather: weatherModel))
        self.navigationController?.pushViewController(weatherDetailsVC, animated: true)
    }
    
    func showError(error: String) {
        let toastView = ToastView(message: error)
        toastView.show()
    }
    
}
