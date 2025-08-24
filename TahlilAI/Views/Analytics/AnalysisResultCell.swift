//
//  AnalysisResultCell.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import UIKit
import SnapKit

class AnalysisResultCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        selectionStyle = .none
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(chevronImageView)
    }
    
    private func setupConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-12)
            make.top.equalToSuperview().offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.centerY.equalTo(dateLabel)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(60)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
    }
    
    // MARK: - Configuration
    func configure(with result: AnalysisResult) {
        titleLabel.text = result.title
        dateLabel.text = formatDate(result.analysisDate)
        
        // Configure type label
        configureTypeLabel(for: result.analysisType)
        
        // Configure thumbnail
        configureThumbnail(for: result)
    }
    
    private func configureTypeLabel(for type: AnalysisType) {
        switch type {
        case .image:
            typeLabel.text = "📷 Görsel"
            typeLabel.backgroundColor = .systemBlue
        case .pdf:
            typeLabel.text = "📄 PDF"
            typeLabel.backgroundColor = .systemOrange
        }
    }
    
    private func configureThumbnail(for result: AnalysisResult) {
        switch result.analysisType {
        case .image:
            if let imageData = result.thumbnailData {
                thumbnailImageView.image = UIImage(data: imageData)
            } else {
                thumbnailImageView.image = UIImage(systemName: "photo")
                thumbnailImageView.tintColor = .systemGray3
            }
        case .pdf:
            if let imageData = result.thumbnailData {
                thumbnailImageView.image = UIImage(data: imageData)
            } else {
                thumbnailImageView.image = UIImage(systemName: "doc.text")
                thumbnailImageView.tintColor = .systemGray3
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    // MARK: - Override
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        typeLabel.text = nil
    }
}
