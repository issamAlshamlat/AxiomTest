//
//  WeatherDetailsViewController.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import UIKit

struct WeatherDataModel {
    let title: String
    let value: String
    let icon: String
    let timeZone: Int?
}

class WeatherDetailsViewController: UIViewController {

    private let weatherModel: WeatherResponseModel
    private let weatherDetailsPresenter: WeatherDetailsPresenter
    private var items: [WeatherDataModel] = []
    private let collectionViewLineSpacing: CGFloat = 10
    private var selectedDegreeUnit: DegreeUnit = DegreeUnit.fahrenheit
    
    private lazy var backgrounfImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = .skyImage
        return imageView
    }()

    private lazy var degreeUnitView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
        return view
    }()
    
    private lazy var fahrenheitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .MADarkBlue
        button.setTitle("F", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(fahrenheitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var celsiusButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .clear
        button.setTitleColor(.MADarkBlue, for: .normal)
        button.setTitle("C", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(celsiusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var weatherStatusImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: getWeatherImageNameBasedOnStatus())
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Date().formattedString()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Date().currentTimeString()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var degreeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        
        if let temp = weatherModel.main?.temp {
            label.text = "\(weatherDetailsPresenter.degreeInCurrentUnit(unit: selectedDegreeUnit.rawValue, value: temp))" + .degree_sign_string
        }
        
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        if let name = weatherModel.name, let country = weatherModel.sys?.country {
            label.text = name + "," +  country
        }
        
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private lazy var lowDegreeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        if let min = weatherModel.main?.temp_min {
            label.text = .low_degree_string + "\(weatherDetailsPresenter.degreeInCurrentUnit(unit: selectedDegreeUnit.rawValue, value: min))" + .degree_sign_string
        }
        
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var highDegreeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        if let max = weatherModel.main?.temp_max {
            label.text = .height_degree_string + "\(weatherDetailsPresenter.degreeInCurrentUnit(unit: selectedDegreeUnit.rawValue, value: max))" + .degree_sign_string
        }
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var lowHeightLabelsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [lowDegreeLabel, highDegreeLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var feelsLikeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        if let feelsLike = weatherModel.main?.feels_like {
            label.text = .feels_like_string + " \(weatherDetailsPresenter.degreeInCurrentUnit(unit: selectedDegreeUnit.rawValue, value: feelsLike))" + .degree_sign_string
        }
        
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private lazy var detailsView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .MADarkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = .details_string
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.itemSize = CGSize(width: (view.frame.width - (collectionViewLineSpacing * 4)) / 5, height: 120)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(WeatherDetailCollectionViewCell.self, forCellWithReuseIdentifier: WeatherDetailCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    init(presenter: WeatherDetailsPresenter) {
        self.weatherDetailsPresenter = presenter
        self.weatherModel = presenter.weatherResponseModel()
        self.items = presenter.createCollectionViewDataSource()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        detailsView.addRoundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
//        setupPresenterDelegate()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        
        view.addSubview(backgrounfImageView)
        view.addSubview(degreeUnitView)
        view.addSubview(fahrenheitButton)
        view.addSubview(celsiusButton)
        view.addSubview(weatherStatusImageView)
        view.addSubview(dateLabel)
        view.addSubview(timeLabel)
        view.addSubview(degreeLabel)
        view.addSubview(cityLabel)
        view.addSubview(lowDegreeLabel)
        view.addSubview(highDegreeLabel)
        view.addSubview(lowHeightLabelsStack)
        view.addSubview(feelsLikeLabel)
        view.addSubview(detailsView)
        view.addSubview(detailsLabel)
        view.addSubview(collectionView)
    }
    
//    private func setupPresenterDelegate() {
//        weatherDetailsPresenter.setViewDelegate(delegate: self)
//    }
    
    private func setupConstraints() {
        backgrounfImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(detailsView.snp.top).offset(40)
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        
        degreeUnitView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        fahrenheitButton.snp.makeConstraints {make in
            make.top.equalTo(degreeUnitView.snp.top)
            make.leading.equalTo(degreeUnitView.snp.leading)
            make.height.equalTo(degreeUnitView.snp.height)
            make.width.equalTo(degreeUnitView.snp.width).multipliedBy(0.5)
        }
        
        celsiusButton.snp.makeConstraints {make in
            make.top.equalTo(degreeUnitView.snp.top)
            make.trailing.equalTo(degreeUnitView.snp.trailing)
            make.height.equalTo(degreeUnitView.snp.height)
            make.width.equalTo(degreeUnitView.snp.width).multipliedBy(0.5)
        }
        
        weatherStatusImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(120)
            make.width.equalTo(200)
            make.bottom.equalTo(degreeLabel.snp.top)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.height.equalTo(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.greaterThanOrEqualToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalTo(dateLabel.snp.bottom)
            make.height.equalTo(20)
            make.trailing.greaterThanOrEqualToSuperview()
        }
        
        degreeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview()
        }
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(degreeLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview()
        }
        
        lowHeightLabelsStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
        }
        
        feelsLikeLabel.snp.makeConstraints { make in
            make.top.equalTo(lowHeightLabelsStack.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        detailsView.snp.makeConstraints { make in
            make.top.equalTo(feelsLikeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(detailsView.snp.top).offset(20)
            make.leading.equalTo(detailsView.snp.leading).offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(detailsView).inset(20)
            make.top.equalTo(detailsLabel.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func getWeatherImageNameBasedOnStatus() -> String {
        if let weatherStatus = weatherModel.weather[0].main {
            return WeatherStatus(rawValue: weatherStatus)?.imageName.lowercased() ?? WeatherStatus.getDefault().rawValue.lowercased()
        }
        return WeatherStatus.getDefault().rawValue.lowercased()
    }
    
    @objc private func fahrenheitButtonTapped() {
        selectedDegreeUnit = .fahrenheit
        fahrenheitButton.backgroundColor = .MADarkBlue
        fahrenheitButton.setTitleColor(.white, for: .normal)
        
        celsiusButton.backgroundColor = .white
        celsiusButton.setTitleColor(.MADarkBlue, for: .normal)
        degreeUnitChanged()
    }
    
    @objc private func celsiusButtonTapped() {
        selectedDegreeUnit = .celsius
        celsiusButton.backgroundColor = .MADarkBlue
        celsiusButton.setTitleColor(.white, for: .normal)
        
        fahrenheitButton.backgroundColor = .white
        fahrenheitButton.setTitleColor(.MADarkBlue, for: .normal)
        degreeUnitChanged()
    }
    
    private func degreeUnitChanged() {
        if let temp = weatherModel.main?.temp {
            degreeLabel.text = "\(weatherDetailsPresenter.degreeInCurrentUnit(unit: selectedDegreeUnit.rawValue, value: temp))"
        }
        
        if let min = weatherModel.main?.temp_min {
            lowDegreeLabel.text = .low_degree_string + "\(weatherDetailsPresenter.degreeInCurrentUnit(unit: selectedDegreeUnit.rawValue, value: min))" + .degree_sign_string
        }
        
        if let max = weatherModel.main?.temp_max {
            highDegreeLabel.text = .low_degree_string + "\(weatherDetailsPresenter.degreeInCurrentUnit(unit: selectedDegreeUnit.rawValue, value: max))" + .degree_sign_string
        }
        
        if let feelsLike = weatherModel.main?.feels_like {
            feelsLikeLabel.text = .feels_like_string + "\(weatherDetailsPresenter.degreeInCurrentUnit(unit: selectedDegreeUnit.rawValue, value: feelsLike))" + .degree_sign_string
        }
        
    }

}

extension WeatherDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherDetailCollectionViewCell.reuseIdentifier , for: indexPath) as! WeatherDetailCollectionViewCell
        
        
//        items = weatherDetailsPresenter.createCollectionViewDataSource()
        cell.configure(with: items[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewLineSpacing  // Adjust the spacing between rows as needed
    }
    
    
}
//
//extension WeatherDetailsViewController: WeatherDetailsViewDelegate {
//    func reloadData(with model: [WeatherDataModel]) {
//        self.items = model
//        collectionView.reloadData()
//    }
//}
