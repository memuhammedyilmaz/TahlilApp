//
//  PremiumViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import SnapKit

class PremiumViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let premiumIconView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        return view
    }()
    
    private let premiumIconLabel: UILabel = {
        let label = UILabel()
        label.text = "👑"
        label.font = .systemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TahlilAI Premium"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sınırsız analiz ve gelişmiş özellikler"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()
    
    private let pricingCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        // Add shadow manually
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.masksToBounds = false
        return view
    }()
    
    private let pricingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium Plan"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "₺19.99"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.text = "aylık"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Premium'a Geç", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Satın Alımları Geri Yükle", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .clear
        return button
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Aboneliğiniz otomatik olarak yenilenir. İstediğiniz zaman iptal edebilirsiniz."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Premium"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerView, pricingCardView, featuresStackView].forEach {
            contentView.addSubview($0)
        }
        
        [premiumIconView, titleLabel, subtitleLabel].forEach {
            headerView.addSubview($0)
        }
        
        premiumIconView.addSubview(premiumIconLabel)
        
        [pricingTitleLabel, priceLabel, periodLabel, subscribeButton, restoreButton, termsLabel].forEach {
            pricingCardView.addSubview($0)
        }
        
        setupFeatures()
    }
    
    private func setupFeatures() {
        let features = [
            ("🔍", "Sınırsız Test Analizi", "Günlük limit olmadan istediğiniz kadar test analiz edin"),
            ("📊", "Detaylı Raporlar", "Gelişmiş grafikler ve trend analizleri"),
            ("🔔", "Özel Bildirimler", "Test sonuçlarınız için kişiselleştirilmiş uyarılar"),
            ("☁️", "Bulut Yedekleme", "Tüm verileriniz güvenle bulutta saklanır"),
            ("🎯", "AI Destekli Öneriler", "Yapay zeka ile kişiselleştirilmiş sağlık önerileri"),
            ("📱", "Öncelikli Destek", "7/24 premium müşteri desteği")
        ]
        
        for (icon, title, description) in features {
            let featureView = createFeatureView(icon: icon, title: title, description: description)
            featuresStackView.addArrangedSubview(featureView)
        }
    }
    
    private func createFeatureView(icon: String, title: String, description: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        // Add shadow manually
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.masksToBounds = false
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = .systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
        [iconLabel, titleLabel, descriptionLabel].forEach {
            containerView.addSubview($0)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconLabel.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        return containerView
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        premiumIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        premiumIconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(premiumIconView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        pricingCardView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        featuresStackView.snp.makeConstraints { make in
            make.top.equalTo(pricingCardView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        pricingTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(pricingTitleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.top.equalTo(subscribeButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        termsLabel.snp.makeConstraints { make in
            make.top.equalTo(restoreButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupActions() {
        subscribeButton.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func subscribeButtonTapped() {
        // Premium subscription logic
        let alert = UIAlertController(title: "Premium'a Geç", message: "Premium aboneliğiniz başlatılıyor...", preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true) {
                let successAlert = UIAlertController(title: "Başarılı!", message: "Premium aboneliğiniz aktif edildi.", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "Tamam", style: .default))
                self.present(successAlert, animated: true)
            }
        }
    }
    
    @objc private func restoreButtonTapped() {
        let alert = UIAlertController(title: "Satın Alımları Geri Yükle", message: "Önceki satın alımlarınız kontrol ediliyor...", preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true) {
                let resultAlert = UIAlertController(title: "Kontrol Tamamlandı", message: "Geri yüklenecek satın alım bulunamadı.", preferredStyle: .alert)
                resultAlert.addAction(UIAlertAction(title: "Tamam", style: .default))
                self.present(resultAlert, animated: true)
            }
        }
    }
} 
