//
//  AnalyticsViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import SnapKit

class AnalyticsViewController: UIViewController {
    
    // MARK: - UI Components
    private let contentView = UIView()
    
    private let chartContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        // Add shadow manually
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.masksToBounds = false
        return view
    }()
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "📈 Test Trendleri"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        // Add shadow manually
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.masksToBounds = false
        return view
    }()
    
    private let statsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "📋 İstatistikler"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let totalTestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Toplam Test: 0"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let abnormalTestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Anormal Test: 0"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemRed
        return label
    }()
    
    private let normalTestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Normal Test: 0"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGreen
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
        title = "Analiz"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(contentView)
        
        [chartContainerView, statsContainerView].forEach {
            contentView.addSubview($0)
        }
        
        [chartTitleLabel, chartView].forEach {
            chartContainerView.addSubview($0)
        }
        
        [statsTitleLabel, totalTestsLabel, abnormalTestsLabel, normalTestsLabel].forEach {
            statsContainerView.addSubview($0)
        }
        
        // Add tap gesture to open history
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openHistoryTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        chartContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo((view.frame.height - 200) / 2 - 75)
        }
        
        chartTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(chartTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        statsContainerView.snp.makeConstraints { make in
            make.top.equalTo(chartContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo((view.frame.height - 200) / 2 - 75)
        }
        
        statsTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        totalTestsLabel.snp.makeConstraints { make in
            make.top.equalTo(statsTitleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        abnormalTestsLabel.snp.makeConstraints { make in
            make.top.equalTo(totalTestsLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        normalTestsLabel.snp.makeConstraints { make in
            make.top.equalTo(abnormalTestsLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupActions() {
        // Add any additional actions here
    }
    
    // MARK: - Actions
    @objc private func openHistoryTapped() {
        let historyVC = HistoryViewController()
        let navController = UINavigationController(rootViewController: historyVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

