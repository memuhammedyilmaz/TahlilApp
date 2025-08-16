//
//  HistoryViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import SnapKit

class HistoryViewController: UIViewController {
    
    // MARK: - UI Components
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Henüz test sonucu bulunmuyor"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
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
        view.addSubview(emptyStateLabel)
    }
    
    private func setupConstraints() {
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
} 
