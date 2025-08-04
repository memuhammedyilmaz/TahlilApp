//
//  HistoryViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import SnapKit

// MARK: - Test Filter
enum TestFilter {
    case all
    case normal
    case abnormal
    
    var title: String {
        switch self {
        case .all: return "Tümü"
        case .normal: return "Normal"
        case .abnormal: return "Anormal"
        }
    }
}

class HistoryViewController: UIViewController {
    
    // MARK: - UI Components
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HistoryTestResultCell.self, forCellReuseIdentifier: "HistoryTestResultCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Henüz test sonucu bulunmuyor"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    private var allTests: [LabTest] = []
    private var filteredTests: [LabTest] = []
    private let labTestService = LabTestService()
    private var selectedFilter: TestFilter = .all
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupTableView()
        loadAllTests()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllTests()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Geçmiş Testler"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        closeButton.tintColor = .systemGray
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(filterStackView)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        setupFilterButtons()
    }
    
    private func setupConstraints() {
        filterStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterStackView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    private func setupFilterButtons() {
        let filters: [TestFilter] = [.all, .normal, .abnormal]
        
        for filter in filters {
            let button = createFilterButton(for: filter)
            filterStackView.addArrangedSubview(button)
        }
        
        // Set initial selection
        updateFilterSelection()
    }
    
    private func createFilterButton(for filter: TestFilter) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(filter.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.tag = filter.hashValue
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        let filters: [TestFilter] = [.all, .normal, .abnormal]
        if let filter = filters.first(where: { $0.hashValue == sender.tag }) {
            selectedFilter = filter
            updateFilterSelection()
            filterTests()
        }
    }
    
    private func updateFilterSelection() {
        for subview in filterStackView.arrangedSubviews {
            guard let button = subview as? UIButton else { continue }
            let filters: [TestFilter] = [.all, .normal, .abnormal]
            if let filter = filters.first(where: { $0.hashValue == button.tag }) {
                if filter == selectedFilter {
                    button.backgroundColor = .systemBlue
                    button.setTitleColor(.white, for: .normal)
                } else {
                    button.backgroundColor = .systemGray6
                    button.setTitleColor(.label, for: .normal)
                }
            }
        }
    }
    
    private func loadAllTests() {
        let testResults = labTestService.getAllTestResults()
        allTests = testResults.flatMap { result in
            result.tests.map { test in
                // Create a new test with the result's date
                return LabTest(
                    id: test.id,
                    name: test.name,
                    value: test.value,
                    unit: test.unit,
                    normalRange: test.normalRange,
                    date: result.date, // Use the result's date
                    category: test.category
                )
            }
        }
        
        // Sort by date (newest first)
        allTests.sort { $0.date > $1.date }
        
        filterTests()
    }
    
    private func filterTests() {
        switch selectedFilter {
        case .all:
            filteredTests = allTests
        case .normal:
            filteredTests = allTests.filter { !$0.isAbnormal }
        case .abnormal:
            filteredTests = allTests.filter { $0.isAbnormal }
        }
        
        if filteredTests.isEmpty {
            emptyStateLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTestResultCell", for: indexPath) as! HistoryTestResultCell
        let test = filteredTests[indexPath.row]
        cell.configure(with: test)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - HistoryTestResultCell
class HistoryTestResultCell: UITableViewCell {
    
    private let containerView = UIView()
    private let testNameLabel = UILabel()
    private let testValueLabel = UILabel()
    private let testStatusLabel = UILabel()
    private let testDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        [testNameLabel, testValueLabel, testStatusLabel, testDateLabel].forEach {
            containerView.addSubview($0)
        }
        
        containerView.backgroundColor = .cardBackground
        containerView.roundCorners(12)
        containerView.addShadow()
        
        testNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        testNameLabel.textColor = .label
        
        testValueLabel.font = .systemFont(ofSize: 14)
        testValueLabel.textColor = .secondaryLabel
        
        testStatusLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        testDateLabel.font = .systemFont(ofSize: 12)
        testDateLabel.textColor = .tertiaryLabel
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        testNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        testValueLabel.snp.makeConstraints { make in
            make.top.equalTo(testNameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
        }
        
        testStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(testValueLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        testDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with test: LabTest) {
        testNameLabel.text = test.name
        testValueLabel.text = "\(test.value) \(test.unit)"
        
        if test.isAbnormal {
            testNameLabel.textColor = .systemRed
            testStatusLabel.text = "Anormal"
            testStatusLabel.textColor = .systemRed
        } else {
            testNameLabel.textColor = .label
            testStatusLabel.text = "Normal"
            testStatusLabel.textColor = .label
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        testDateLabel.text = dateFormatter.string(from: test.date)
    }
} 