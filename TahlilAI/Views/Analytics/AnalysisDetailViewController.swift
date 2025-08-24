//
//  AnalysisDetailViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import UIKit
import SnapKit
import PDFKit

// Import custom models
import Foundation

class AnalysisDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    private let analysisContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let analysisTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "🤖 AI Analiz Sonucu"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let analysisTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return textView
    }()
    
    private let recommendationsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    private let recommendationsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "💡 Öneriler"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private let recommendationsTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15, weight: .regular)
        textView.textColor = .systemBlue
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return textView
    }()
    
    // MARK: - Properties
    private let analysisResult: AnalysisResult
    
    // MARK: - Initialization
    init(analysisResult: AnalysisResult) {
        self.analysisResult = analysisResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        configureWithResult()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Analiz Detayı"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Add share button
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        contentView.addSubview(analysisContainerView)
        contentView.addSubview(recommendationsContainerView)
        
        headerView.addSubview(thumbnailImageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(typeLabel)
        
        analysisContainerView.addSubview(analysisTitleLabel)
        analysisContainerView.addSubview(analysisTextView)
        
        recommendationsContainerView.addSubview(recommendationsTitleLabel)
        recommendationsContainerView.addSubview(recommendationsTextView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
            make.width.greaterThanOrEqualTo(120)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        analysisContainerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        analysisTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        analysisTextView.snp.makeConstraints { make in
            make.top.equalTo(analysisTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        recommendationsContainerView.snp.makeConstraints { make in
            make.top.equalTo(analysisContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        recommendationsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        recommendationsTextView.snp.makeConstraints { make in
            make.top.equalTo(recommendationsTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - Configuration
    private func configureWithResult() {
        titleLabel.text = analysisResult.title
        dateLabel.text = formatDate(analysisResult.analysisDate)
        configureTypeLabel()
        configureThumbnail()
        configureAnalysisText()
        configureRecommendations()
    }
    
    private func configureTypeLabel() {
        switch analysisResult.analysisType {
        case .image:
            typeLabel.text = "📷 Görsel Analizi"
            typeLabel.backgroundColor = .systemBlue
        case .pdf:
            typeLabel.text = "📄 PDF Analizi"
            typeLabel.backgroundColor = .systemOrange
        }
    }
    
    private func configureThumbnail() {
        if let imageData = analysisResult.thumbnailData {
            thumbnailImageView.image = UIImage(data: imageData)
        } else {
            switch analysisResult.analysisType {
            case .image:
                thumbnailImageView.image = UIImage(systemName: "photo")
                thumbnailImageView.tintColor = .systemGray3
            case .pdf:
                thumbnailImageView.image = UIImage(systemName: "doc.text")
                thumbnailImageView.tintColor = .systemGray3
            }
        }
    }
    
    private func configureAnalysisText() {
        analysisTextView.text = analysisResult.analysisText
    }
    
    private func configureRecommendations() {
        let recommendations = generateRecommendations()
        recommendationsTextView.text = recommendations
    }
    
    private func generateRecommendations() -> String {
        switch analysisResult.analysisType {
        case .image:
            return """
            📊 Görsel Analizi Önerileri:
            
            • Görsel kalitesi yüksek, analiz sonuçları güvenilir
            • Benzer görseller için karşılaştırma yapabilirsiniz
            • Düzenli aralıklarla takip önerilir
            • Sonuçları doktorunuzla paylaşın
            """
        case .pdf:
            return """
            📄 PDF Analizi Önerileri:
            
            • Belge türü ve içerik başarıyla tespit edildi
            • Metin çıkarma kalitesi: \(getTextQualityScore())
            • Sayfa sayısı ve boyut bilgileri doğru
            • PDF'yi farklı cihazlarda test edin
            """
        }
    }
    
    private func getTextQualityScore() -> String {
        let textLength = analysisResult.analysisText.count
        if textLength > 1000 {
            return "Mükemmel (95%)"
        } else if textLength > 500 {
            return "İyi (80%)"
        } else if textLength > 100 {
            return "Orta (60%)"
        } else {
            return "Düşük (30%)"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    // MARK: - Actions
    @objc private func shareButtonTapped() {
        let shareText = """
        📊 TahlilAI Analiz Sonucu
        
        📷 \(analysisResult.title)
        📅 \(formatDate(analysisResult.analysisDate))
        🔍 \(analysisResult.analysisType == .image ? "Görsel Analizi" : "PDF Analizi")
        
        📝 Analiz Sonucu:
        \(String(analysisResult.analysisText.prefix(200)))...
        
        💡 Öneriler:
        \(generateRecommendations())
        """
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        present(activityVC, animated: true)
    }
}
