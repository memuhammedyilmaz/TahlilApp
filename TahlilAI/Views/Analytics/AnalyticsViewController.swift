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
    
    private let dateRangeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.selectedSegmentIndex = 0
        control.backgroundColor = .backgroundGray
        control.selectedSegmentTintColor = .accentGreen
        control.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return control
    }()
    
    private let chartContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardBackground
        view.roundCorners(16)
        view.addShadow()
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
        view.backgroundColor = .backgroundGray
        view.roundCorners(12)
        return view
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardBackground
        view.roundCorners(16)
        view.addShadow()
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
        label.textColor = .accentRed
        return label
    }()
    
    private let normalTestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Normal Test: 0"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .accentGreen
        return label
    }()
    

    
    // MARK: - Properties
    private var testResults: [LabTestResult] = []
    private var filteredResults: [LabTestResult] = []
    private let labTestService = LabTestService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupFilterControls()
        setupActions()
        loadTestResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTestResults()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Analiz"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(contentView)
        
        [dateRangeSegmentedControl,
         chartContainerView, statsContainerView].forEach {
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
        
        dateRangeSegmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        chartContainerView.snp.makeConstraints { make in
            make.top.equalTo(dateRangeSegmentedControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo((view.frame.height - 200) / 2 - 75) // Ekranın yarısı kadar yükseklik
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
            make.height.equalTo((view.frame.height - 200) / 2 - 75) // Ekranın yarısı kadar yükseklik
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
    
    private func setupFilterControls() {
        // Date range filter
        let dateRanges = ["Son 7 Gün", "Son 30 Gün", "Son 3 Ay", "Tümü"]
        dateRangeSegmentedControl.removeAllSegments()
        
        for (index, range) in dateRanges.enumerated() {
            dateRangeSegmentedControl.insertSegment(withTitle: range, at: index, animated: false)
        }
        
        dateRangeSegmentedControl.addTarget(self, action: #selector(dateRangeChanged), for: .valueChanged)
    }
    

    
    private func setupActions() {
        // Add any additional actions here
    }
    
    // MARK: - Actions
    @objc private func dateRangeChanged() {
        applyFilters()
    }
    
    @objc private func openHistoryTapped() {
        let historyVC = HistoryViewController()
        let navController = UINavigationController(rootViewController: historyVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    // MARK: - Helper Methods

    
    private func loadTestResults() {
        // Clear any existing mock data
        labTestService.clearAllTestResults()
        
        testResults = labTestService.getAllTestResults()
        applyFilters()
        updateStats()
        updateChart()
    }
    
    private func applyFilters() {
        var filtered = testResults
        
        // Apply date range filter
        let calendar = Calendar.current
        let now = Date()
        
        switch dateRangeSegmentedControl.selectedSegmentIndex {
        case 0: // Last 7 days
            filtered = filtered.filter { result in
                calendar.dateInterval(of: .day, for: result.date)?.contains(now) == true ||
                calendar.isDate(result.date, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: now) ?? now) ||
                calendar.isDate(result.date, inSameDayAs: calendar.date(byAdding: .day, value: -2, to: now) ?? now) ||
                calendar.isDate(result.date, inSameDayAs: calendar.date(byAdding: .day, value: -3, to: now) ?? now) ||
                calendar.isDate(result.date, inSameDayAs: calendar.date(byAdding: .day, value: -4, to: now) ?? now) ||
                calendar.isDate(result.date, inSameDayAs: calendar.date(byAdding: .day, value: -5, to: now) ?? now) ||
                calendar.isDate(result.date, inSameDayAs: calendar.date(byAdding: .day, value: -6, to: now) ?? now)
            }
        case 1: // Last 30 days
            filtered = filtered.filter { result in
                result.date >= calendar.date(byAdding: .day, value: -30, to: now) ?? now
            }
        case 2: // Last 3 months
            filtered = filtered.filter { result in
                result.date >= calendar.date(byAdding: .month, value: -3, to: now) ?? now
            }
        default: // All
            break
        }
        
        filteredResults = filtered
    }
    
    private func updateStats() {
        let allTests = testResults.flatMap { $0.tests }
        let totalTests = allTests.count
        let abnormalTests = allTests.filter { $0.isAbnormal }.count
        let normalTests = totalTests - abnormalTests
        
        if totalTests == 0 {
            totalTestsLabel.text = "Toplam Test: 0"
            abnormalTestsLabel.text = "Anormal Test: 0"
            normalTestsLabel.text = "Normal Test: 0"
        } else {
            totalTestsLabel.text = "Toplam Test: \(totalTests)"
            abnormalTestsLabel.text = "Anormal Test: \(abnormalTests)"
            normalTestsLabel.text = "Normal Test: \(normalTests)"
        }
    }
    
    private func updateChart() {
        // Clear existing chart
        chartView.subviews.forEach { $0.removeFromSuperview() }
        
        let allTests = testResults.flatMap { $0.tests }
        
        if allTests.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "📊 Test Sonuçları Grafiği\n\nHenüz test sonucu bulunmuyor\n\nBu alanda gerçek bir grafik kütüphanesi\n(Charts, Core Graphics vb.) kullanılabilir"
            emptyLabel.font = .systemFont(ofSize: 14)
            emptyLabel.textColor = .secondaryLabel
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            
            chartView.addSubview(emptyLabel)
            emptyLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(16)
            }
        } else {
            let chartLabel = UILabel()
            chartLabel.text = "📊 Test Sonuçları Grafiği\n\nBu alanda gerçek bir grafik kütüphanesi\n(Charts, Core Graphics vb.) kullanılabilir"
            chartLabel.font = .systemFont(ofSize: 14)
            chartLabel.textColor = .secondaryLabel
            chartLabel.textAlignment = .center
            chartLabel.numberOfLines = 0
            
            chartView.addSubview(chartLabel)
            chartLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(16)
            }
        }
    }
}

