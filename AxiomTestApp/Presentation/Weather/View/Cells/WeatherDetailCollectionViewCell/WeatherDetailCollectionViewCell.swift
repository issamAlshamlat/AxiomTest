//
//  WeatherDetailCollectionViewCell.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import UIKit

class WeatherDetailCollectionViewCell: UICollectionViewCell {
        
    static let reuseIdentifier = "WeatherDetailCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .MADarkBlue
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(icon)
        contentView.addSubview(valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(4)
        }

        icon.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(8)
            make.centerX.centerY.equalToSuperview()
        }

        valueLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(icon.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(4)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset any cell-specific properties or states here
    }
    
    func configure(with model: WeatherDataModel) {
        titleLabel.text = model.title
        icon.image = UIImage(named: model.icon)
        
        let dateInstance = Date()
        
        if let timeZone = model.timeZone {
            if let timeString = dateInstance.timeStringFromTimeIntervalString(model.value, timeZone: timeZone) {
                valueLabel.text = timeString
            }
        }else {
            valueLabel.text = model.value
        }
        
    }
    
}
