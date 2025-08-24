//
//  ScanViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import PhotosUI
import SnapKit
import AVFoundation
import PDFKit
import UniformTypeIdentifiers

// Import custom models and services
import Foundation

class ScanViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let instructionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "📷 Fotoğraf çekin, görsel seçin veya PDF yükleyin. Yapay zeka ile analiz başlatın!"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "📷 Fotoğraf ekleyin veya \n 📄 PDF dosyası yükleyin."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let fileInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📷 Kamera", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🖼️ Galeri", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let pdfButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📄 PDF", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🤖 AI ile Analiz Et", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.alpha = 0.6
        return button
    }()
    
    private let creditLabel: UILabel = {
        let label = UILabel()
        label.text = "💎 Kalan Kredi: 10"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Görsel AI ile analiz ediliyor..."
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🔄 Sıfırla", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemPurple
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private let viewModel = ScanViewModel()
    private var selectedImage: UIImage?
    private var selectedPDF: PDFDocument?
    private var aiResults: String?
    private var currentDataSource: DataSource = .none
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    private enum DataSource {
        case none, image, pdf
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "AI Görsel Analiz"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }
    
    private func setupUI() {
        // Simple background color instead of gradient
        view.backgroundColor = .systemBackground
        
        view.addSubview(instructionContainer)
        view.addSubview(imageContainerView)
        view.addSubview(cameraButton)
        view.addSubview(galleryButton)
        view.addSubview(pdfButton)
        view.addSubview(analyzeButton)
        view.addSubview(creditLabel)
        view.addSubview(progressLabel)
        view.addSubview(resetButton)
        view.addSubview(fileInfoLabel)
        view.addSubview(loadingIndicator)
        
        instructionContainer.addSubview(instructionLabel)
        imageContainerView.addSubview(imageView)
        imageContainerView.addSubview(placeholderLabel)
    }
    
    private func setupConstraints() {
        instructionContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.top.equalTo(instructionContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        fileInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(fileInfoLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo((view.frame.width - 60) / 3)
            make.height.equalTo(50)
        }
        
        galleryButton.snp.makeConstraints { make in
            make.top.equalTo(fileInfoLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo((view.frame.width - 60) / 3)
            make.height.equalTo(50)
        }
        
        pdfButton.snp.makeConstraints { make in
            make.top.equalTo(fileInfoLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo((view.frame.width - 60) / 3)
            make.height.equalTo(50)
        }
        
        analyzeButton.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        creditLabel.snp.makeConstraints { make in
            make.top.equalTo(analyzeButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(creditLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.top).offset(8)
            make.trailing.equalTo(imageContainerView.snp.trailing).offset(-8)
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(imageContainerView)
        }
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageContainerTapped))
        imageContainerView.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(imageContainerLongPressed))
        longPressGesture.minimumPressDuration = 0.5
        imageContainerView.addGestureRecognizer(longPressGesture)
        
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        pdfButton.addTarget(self, action: #selector(pdfButtonTapped), for: .touchUpInside)
        analyzeButton.addTarget(self, action: #selector(analyzeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func imageContainerTapped() {
        hapticFeedback.impactOccurred()
        showImageSourceAlert()
    }
    
    @objc private func imageContainerLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            hapticFeedback.impactOccurred(intensity: 0.8)
            showLongPressOptions()
        }
    }
    
    @objc private func cameraButtonTapped() {
        hapticFeedback.impactOccurred()
        checkCameraPermission { granted in
            if granted {
                self.openCamera()
            } else {
                self.showPermissionAlert(for: "Kamera")
            }
        }
    }
    
    @objc private func galleryButtonTapped() {
        hapticFeedback.impactOccurred()
        checkPhotoLibraryPermission { granted in
            if granted {
                self.openPhotoLibrary()
            } else {
                self.showPermissionAlert(for: "Galeri")
            }
        }
    }
    
    @objc private func pdfButtonTapped() {
        hapticFeedback.impactOccurred()
        openDocumentPicker()
    }
    
    @objc private func analyzeButtonTapped() {
        hapticFeedback.impactOccurred()
        guard currentDataSource != .none else { return }
        
        // Show loading state
        loadingIndicator.startAnimating()
        progressLabel.isHidden = false
        analyzeButton.isEnabled = false
        analyzeButton.alpha = 0.6
        
        // Update progress message based on data source
        switch currentDataSource {
        case .image:
            progressLabel.text = "📷 Görsel OCR ile analiz ediliyor..."
        case .pdf:
            progressLabel.text = "📄 PDF OCR ile analiz ediliyor..."
        case .none:
            break
        }
        
        viewModel.onAnalysisComplete = { [weak self] aiResult in
            self?.handleAnalysisComplete(aiResult)
        }
        
        viewModel.onAnalysisError = { [weak self] errorMessage in
            self?.handleAnalysisError(errorMessage)
        }
        
        viewModel.onAIProgress = { [weak self] progressMessage in
            self?.progressLabel.text = progressMessage
        }
        
        switch currentDataSource {
        case .image:
            if let image = selectedImage {
                viewModel.processImage(image)
            }
        case .pdf:
            if let pdf = selectedPDF {
                viewModel.processPDF(pdf)
            }
        case .none:
            break
        }
    }
    
    @objc private func resetButtonTapped() {
        hapticFeedback.impactOccurred(intensity: 0.6)
        resetUI()
    }
    
    // MARK: - Helper Methods
    private func showImageSourceAlert() {
        let alert = UIAlertController(title: "Veri Seç", message: "Veri kaynağını seçin", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "📷 Kamera", style: .default) { [weak self] _ in
            self?.cameraButtonTapped()
        })
        
        alert.addAction(UIAlertAction(title: "🖼️ Galeri", style: .default) { [weak self] _ in
            self?.galleryButtonTapped()
        })
        
        alert.addAction(UIAlertAction(title: "📄 PDF", style: .default) { [weak self] _ in
            self?.pdfButtonTapped()
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        viewModel.checkCameraPermission(completion: completion)
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        viewModel.checkPhotoLibraryPermission(completion: completion)
    }
    
    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    private func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    private func showPermissionAlert(for feature: String) {
        let alert = UIAlertController(
            title: "İzin Gerekli",
            message: "\(feature.capitalized) erişimi için ayarlardan izin vermeniz gerekiyor.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ayarlar", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func handleAnalysisComplete(_ aiResult: String) {
        self.aiResults = aiResult
        
        // Update UI
        loadingIndicator.stopAnimating()
        progressLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        
        // Save analysis result
        saveAnalysisResult(aiResult)
        
        // AI sonuçlarını print et
        printAIResults(aiResult)
        
        // Kullanıcıya bilgi ver
        showAlert(message: "AI analizi tamamlandı! Sonuçlar kaydedildi ve analiz listesinde görüntülenebilir.")
    }
    
    /// AI sonuçlarını print eder
    private func printAIResults(_ aiResult: String) {
        // AI Analiz Sonucu
    }
    
    private func handleAnalysisError(_ errorMessage: String) {
        loadingIndicator.stopAnimating()
        progressLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        
        showAlert(message: errorMessage)
    }
    
    private func updateUIForSelectedImage() {
        placeholderLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        currentDataSource = .image
        resetButton.isHidden = false
        
        // Show file info with animation
        if let image = selectedImage {
            let imageSize = image.size
            let fileSize = "Görsel: \(Int(imageSize.width))×\(Int(imageSize.height)) piksel"
            fileInfoLabel.text = fileSize
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
                self.fileInfoLabel.isHidden = false
                self.fileInfoLabel.alpha = 1.0
            }
        }
        
        // Reset previous results
        aiResults = nil
        selectedPDF = nil
        
        // Success haptic feedback
        let successFeedback = UINotificationFeedbackGenerator()
        successFeedback.notificationOccurred(.success)
    }
    
    private func updateUIForSelectedPDF(_ pdf: PDFDocument) {
        placeholderLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        currentDataSource = .pdf
        resetButton.isHidden = false
        
        // Show file info with animation
        let pageCount = pdf.pageCount
        let documentTitle = pdf.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String ?? "PDF Belgesi"
        let fileInfo = "📄 \(documentTitle)\n📖 \(pageCount) sayfa"
        fileInfoLabel.text = fileInfo
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
            self.fileInfoLabel.isHidden = false
            self.fileInfoLabel.alpha = 1.0
        }
        
        // Show PDF preview using PDFService
        if let pdfImage = PDFService.shared.renderFirstPageAsImage(from: pdf, scale: 1.5) {
            imageView.image = pdfImage
            
            // Add subtle animation for image transition
            imageView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseInOut) {
                self.imageView.alpha = 1.0
            }
        } else {
            // Fallback to placeholder if rendering fails
            placeholderLabel.text = "📄 PDF yüklendi - \(pdf.pageCount) sayfa"
            placeholderLabel.isHidden = false
        }
        
        // Reset previous results
        aiResults = nil
        selectedImage = nil
        
        // Success haptic feedback
        let successFeedback = UINotificationFeedbackGenerator()
        successFeedback.notificationOccurred(.success)
    }
    
    private func resetUI() {
        // Animate the reset
        UIView.animate(withDuration: 0.3, animations: {
            self.placeholderLabel.alpha = 0
            self.fileInfoLabel.alpha = 0
            self.imageView.alpha = 0
        }) { _ in
            self.placeholderLabel.isHidden = false
            self.placeholderLabel.text = "📷 Fotoğraf eklemek için dokunun\n📄 PDF yüklemek için dokunun"
            self.analyzeButton.isEnabled = false
            self.analyzeButton.alpha = 0.6
            self.currentDataSource = .none
            self.imageView.image = nil
            self.selectedImage = nil
            self.selectedPDF = nil
            self.aiResults = nil
            self.resetButton.isHidden = true
            self.progressLabel.isHidden = true
            self.fileInfoLabel.isHidden = true
            
            // Fade back in
            UIView.animate(withDuration: 0.3) {
                self.placeholderLabel.alpha = 1.0
                self.imageView.alpha = 1.0
            }
        }
    }
    
    private func showLongPressOptions() {
        guard currentDataSource != .none else { return }
        
        let alert = UIAlertController(title: "Seçenekler", message: "Ne yapmak istiyorsunuz?", preferredStyle: .actionSheet)
        
        switch currentDataSource {
        case .image:
            alert.addAction(UIAlertAction(title: "📷 Yeni Fotoğraf Çek", style: .default) { [weak self] _ in
                self?.cameraButtonTapped()
            })
            alert.addAction(UIAlertAction(title: "🖼️ Galeriden Seç", style: .default) { [weak self] _ in
                self?.galleryButtonTapped()
            })
            
        case .pdf:
            alert.addAction(UIAlertAction(title: "📄 PDF Detayları", style: .default) { [weak self] _ in
                self?.showPDFDetails()
            })
            alert.addAction(UIAlertAction(title: "📄 Yeni PDF Seç", style: .default) { [weak self] _ in
                self?.pdfButtonTapped()
            })
            
        case .none:
            break
        }
        
        alert.addAction(UIAlertAction(title: "🔄 Sıfırla", style: .destructive) { [weak self] _ in
            self?.resetUI()
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showPDFDetails() {
        guard let pdf = selectedPDF else { return }
        
        let analysis = PDFService.shared.analyzePDF(pdf)
        let documentTitle = pdf.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String ?? "PDF Belgesi"
        let author = pdf.documentAttributes?[PDFDocumentAttribute.authorAttribute] as? String ?? "Bilinmeyen Yazar"
        let creationDate = pdf.documentAttributes?[PDFDocumentAttribute.creationDateAttribute] as? Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "tr_TR")
        
        let creationDateString = creationDate.map { dateFormatter.string(from: $0) } ?? "Bilinmiyor"
        
        let details = """
        📄 PDF Detayları
        
        📊 Temel Bilgiler:
        - Başlık: \(documentTitle)
        - Yazar: \(author)
        - Oluşturulma Tarihi: \(creationDateString)
        - Toplam Sayfa: \(analysis.pageCount)
        
        📝 Metin Analizi:
        - Toplam Metin Karakteri: \(analysis.totalTextLength)
        - Ortalama Sayfa Metin Uzunluğu: \(analysis.averageTextLength)
        - Metin İçeren Sayfa: \(analysis.pageTextLengths.filter { $0 > 0 }.count)
        
        🔍 Sayfa Detayları:
        \(generatePageDetails(analysis: analysis))
        """
        
        let alert = UIAlertController(title: "PDF Detayları", message: details, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func generatePageDetails(analysis: PDFAnalysisResult) -> String {
        var details = ""
        for (index, length) in analysis.pageTextLengths.enumerated() {
            let status = length > 0 ? "✅ Metin var" : "❌ Metin yok"
            details += "Sayfa \(index + 1): \(status) (\(length) karakter)\n"
        }
        return details
    }
    
    private func saveAnalysisResult(_ aiResult: String) {
        guard currentDataSource != .none else { return }
        
        let title: String
        let metadata: AnalysisMetadata
        
        switch currentDataSource {
        case .image:
            guard let image = selectedImage else { return }
            title = "Görsel Analizi - \(Date().formatted(date: .abbreviated, time: .shortened))"
            
            metadata = AnalysisMetadata(
                fileSize: image.jpegData(compressionQuality: 1.0)?.count,
                dimensions: "\(Int(image.size.width))×\(Int(image.size.height)) piksel",
                textLength: aiResult.count,
                processingTime: 1.5, // Placeholder
                aiModel: "TahlilAI v1.0"
            )
            
            let analysisResult = AnalysisResult.createImageAnalysis(
                title: title,
                image: image,
                analysisText: aiResult,
                metadata: metadata
            )
            
            AnalysisResultManager.shared.saveAnalysisResult(analysisResult)
            
        case .pdf:
            guard let pdf = selectedPDF else { return }
            title = "PDF Analizi - \(Date().formatted(date: .abbreviated, time: .shortened))"
            
            metadata = AnalysisMetadata(
                fileSize: pdf.dataRepresentation()?.count,
                pageCount: pdf.pageCount,
                textLength: aiResult.count,
                processingTime: 1.5, // Placeholder
                aiModel: "TahlilAI v1.0"
            )
            
            let analysisResult = AnalysisResult.createPDFAnalysis(
                title: title,
                pdf: pdf,
                analysisText: aiResult,
                metadata: metadata
            )
            
            AnalysisResultManager.shared.saveAnalysisResult(analysisResult)
            
        case .none:
            break
        }
        
        // Analiz sonucu kaydedildi
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Orijinal resmi al ve direkt kullan
        if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            imageView.image = originalImage
            updateUIForSelectedImage()
            // Resim seçildi
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate
extension ScanViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        // Start accessing the security-scoped resource
        guard url.startAccessingSecurityScopedResource() else {
            showAlert(message: "PDF dosyasına erişim sağlanamadı.")
            return
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        // Load PDF document
        if let pdfDocument = PDFDocument(url: url) {
            selectedPDF = pdfDocument
            updateUIForSelectedPDF(pdfDocument)
            // PDF seçildi
        } else {
            showAlert(message: "PDF dosyası yüklenemedi.")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}
