//
//  ToastView.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation
import UIKit
import SnapKit

class ToastView: UIView {
    
    private let view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    private let toastLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }()
    
    init(message: String) {
        super.init(frame: .zero)

        configureUI()
        toastLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func configureUI() {
        addSubview(view)
        addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }
    
    func show(duration: TimeInterval = 2.0, completion: (() -> Void)? = nil) {
        if let topView = UIApplication.shared.keyWindow {
            topView.addSubview(self)

            self.snp.makeConstraints { make in
                make.bottom.equalTo(topView.safeAreaLayoutGuide.snp.bottom)
                make.width.equalToSuperview().multipliedBy(0.9)
                make.centerX.equalToSuperview()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.hide(completion: completion)
            }
        }

    }
    
    private func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
}
