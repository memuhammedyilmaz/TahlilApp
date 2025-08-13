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
import Vision

class ScanViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    

    
    private let instructionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .cardBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.primaryGradientStart.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "📷 Fotoğraf çekin veya galeriden görsel ekleyin\nTahlil sonuçlarınızı Al ile analiz edelim"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = .textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.primaryGradientStart.withAlphaComponent(0.3).cgColor
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
        label.text = "📷 Fotoğraf eklemek için dokunun"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📷 Kamera ile Çek", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .primaryGradientStart
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addShadow(color: .primaryGradientStart, opacity: 0.2, radius: 6)
        return button
    }()
    
    private let galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🖼️ Galeriden Seç", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .statusSuccess
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addShadow(color: .statusSuccess, opacity: 0.2, radius: 6)
        return button
    }()
    
    private let analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🔍 Analiz Et", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .secondaryGradientStart
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.alpha = 0.6
        button.addShadow(color: .secondaryGradientStart, opacity: 0.3, radius: 8)
        return button
    }()
    
    private let creditLabel: UILabel = {
        let label = UILabel()
        label.text = "💎 Kalan Kredi: 100"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = .primaryGradientStart
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Görsel analiz ediliyor..."
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let resultsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .cardBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.primaryGradientStart.withAlphaComponent(0.3).cgColor
        view.isHidden = true
        return view
    }()
    
    private let resultsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "📊 OCR Sonuçları"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .textPrimary
        return label
    }()
    
    private let resultsSummaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    private let resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.register(OCRResultCell.self, forCellReuseIdentifier: "OCRResultCell")
        return tableView
    }()
    
    private let actionButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.isHidden = true
        return stackView
    }()
    
    private let copyAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📋 Tümünü Kopyala", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let exportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📤 Dışa Aktar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let confidenceFilterContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.isHidden = true
        return view
    }()
    
    private let confidenceFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "🎯 Güven Filtresi: %80"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let confidenceSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.8
        slider.minimumTrackTintColor = .systemBlue
        slider.maximumTrackTintColor = .systemGray4
        return slider
    }()

    
    // MARK: - Properties
    private let viewModel = ScanViewModel()
    private var selectedImage: UIImage?
    private var ocrResults: OCRResult?
    
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
        title = "Tahlil Tara"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.textPrimary,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }
    
    private func setupUI() {
        // Gradient background
        view.addGradientBackground(
            startColor: .backgroundPrimary,
            endColor: .backgroundSecondary,
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
        
        view.addSubview(instructionContainer)
        instructionContainer.addSubview(instructionLabel)
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        imageContainerView.addSubview(placeholderLabel)
        view.addSubview(cameraButton)
        view.addSubview(galleryButton)
        view.addSubview(analyzeButton)
        view.addSubview(creditLabel)
        view.addSubview(progressLabel)
        view.addSubview(resultsContainer)
        
        resultsContainer.addSubview(resultsTitleLabel)
        resultsContainer.addSubview(resultsSummaryLabel)
        resultsContainer.addSubview(resultsTableView)
        resultsContainer.addSubview(confidenceFilterContainer)
        resultsContainer.addSubview(actionButtonsStackView)
        
        confidenceFilterContainer.addSubview(confidenceFilterLabel)
        confidenceFilterContainer.addSubview(confidenceSlider)
        
        actionButtonsStackView.addArrangedSubview(copyAllButton)
        actionButtonsStackView.addArrangedSubview(exportButton)
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
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
        
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.centerX).offset(-8)
            make.height.equalTo(50)
        }
        
        galleryButton.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.centerX).offset(8)
            make.trailing.equalToSuperview().offset(-20)
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
        
        resultsContainer.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        resultsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        resultsSummaryLabel.snp.makeConstraints { make in
            make.top.equalTo(resultsTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        resultsTableView.snp.makeConstraints { make in
            make.top.equalTo(resultsSummaryLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(confidenceFilterContainer.snp.top).offset(-16)
        }
        
        confidenceFilterContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(actionButtonsStackView.snp.top).offset(-16)
            make.height.equalTo(50)
        }
        
        confidenceFilterLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        confidenceSlider.snp.makeConstraints { make in
            make.leading.equalTo(confidenceFilterLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
        actionButtonsStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }


    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageContainerTapped))
        imageContainerView.addGestureRecognizer(tapGesture)
        
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        analyzeButton.addTarget(self, action: #selector(analyzeButtonTapped), for: .touchUpInside)
        copyAllButton.addTarget(self, action: #selector(copyAllButtonTapped), for: .touchUpInside)
        exportButton.addTarget(self, action: #selector(exportButtonTapped), for: .touchUpInside)
        confidenceSlider.addTarget(self, action: #selector(confidenceSliderChanged), for: .valueChanged)
        

        

    }
    
    // MARK: - Actions
    @objc private func imageContainerTapped() {
        showImageSourceAlert()
    }
    
    @objc private func cameraButtonTapped() {
        checkCameraPermission { granted in
            if granted {
                self.openCamera()
            } else {
                self.showPermissionAlert(for: "kamera")
            }
        }
    }
    
    @objc private func galleryButtonTapped() {
        checkPhotoLibraryPermission { granted in
            if granted {
                self.openPhotoLibrary()
            } else {
                self.showPermissionAlert(for: "galeri")
            }
        }
    }
    
    @objc private func analyzeButtonTapped() {
        guard let image = selectedImage else { return }
        
        // Show progress
        progressLabel.isHidden = false
        analyzeButton.isEnabled = false
        analyzeButton.alpha = 0.6
        
        viewModel.onAnalysisComplete = { [weak self] ocrResult in
            self?.handleAnalysisComplete(ocrResult)
        }
        
        viewModel.onAnalysisError = { [weak self] errorMessage in
            self?.handleAnalysisError(errorMessage)
        }
        
        viewModel.onOCRProgress = { [weak self] progressMessage in
            self?.progressLabel.text = progressMessage
        }
        
        viewModel.processImage(image)
    }
    

    

    

    
    @objc private func freeCropTapped() {
        // TODO: Implement free-form cropping with custom crop view
        showAlert(message: "Serbest kırpma özelliği yakında eklenecek!")
    }
    
    // MARK: - Helper Methods
    private func showImageSourceAlert() {
        let alert = UIAlertController(title: "Fotoğraf Seç", message: "Fotoğraf kaynağını seçin", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Kamera", style: .default) { [weak self] _ in
            self?.cameraButtonTapped()
        })
        
        alert.addAction(UIAlertAction(title: "Galeri", style: .default) { [weak self] _ in
            self?.galleryButtonTapped()
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
        imagePicker.allowsEditing = true // Kırpma özelliğini etkinleştir
        present(imagePicker, animated: true)
    }
    
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true // Kırpma özelliğini etkinleştir
        present(imagePicker, animated: true)
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
    
    private func showAnalysisResult() {
        // This method is no longer needed as we handle results in handleAnalysisComplete
    }
    
    private func handleAnalysisComplete(_ ocrResult: OCRResult) {
        self.ocrResults = ocrResult
        
        // Update UI
        progressLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        
        // Console'a sonuçları yazdır
        print("🔍 OCR Analiz Sonucu:")
        print("📝 Toplam Satır: \(ocrResult.totalLines)")
        print("🎯 Ortalama Güven: %\(ocrResult.averageConfidencePercentage)")
        print("✅ Yüksek Güvenli: \(ocrResult.highConfidenceLines.count)")
        print("⚠️ Düşük Güvenli: \(ocrResult.lowConfidenceLines.count)")
        print("\n📋 Satır Detayları:")
        
        for (index, line) in ocrResult.lines.enumerated() {
            let confidenceIcon = line.isHighConfidence ? "✅" : "⚠️"
            print("\(index + 1). \(confidenceIcon) %\(line.confidencePercentage) - \(line.text)")
        }
        
        // UI'ı gizle - sadece konsola yazdır
        resultsContainer.isHidden = true
        confidenceFilterContainer.isHidden = true
        actionButtonsStackView.isHidden = true
        
        // Kullanıcıya bilgi ver
        showAlert(message: "OCR analizi tamamlandı! Sonuçlar konsola yazdırıldı.")
    }
    
    private func handleAnalysisError(_ errorMessage: String) {
        progressLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        
        showAlert(message: errorMessage)
    }
    
    private func scrollToResults() {
        let resultsFrame = resultsContainer.frame
        let scrollPoint = CGPoint(x: 0, y: resultsFrame.origin.y - 100)
        
        // Use scroll view if available, otherwise animate the view
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            scrollView.setContentOffset(scrollPoint, animated: true)
        } else {
            UIView.animate(withDuration: 0.5) {
                self.view.frame.origin.y = -scrollPoint.y
            }
        }
    }
    
    @objc private func copyAllButtonTapped() {
        guard let ocrResults = ocrResults else { return }
        
        let allText = ocrResults.lines.map { line in
            "[%\(line.confidencePercentage)] \(line.text)"
        }.joined(separator: "\n")
        
        UIPasteboard.general.string = allText
        
        // Show success feedback
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        
        showAlert(message: "Tüm OCR sonuçları panoya kopyalandı!")
    }
    
    @objc private func exportButtonTapped() {
        guard let ocrResults = ocrResults else { return }
        
        // Create CSV format
        var csvContent = "Satır,Güven,Metin\n"
        
        for (index, line) in ocrResults.lines.enumerated() {
            let escapedText = line.text.replacingOccurrences(of: "\"", with: "\"\"")
            csvContent += "\(index + 1),%\(line.confidencePercentage),\"\(escapedText)\"\n"
        }
        
        // Create temporary file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("OCR_Results.csv")
        
        do {
            try csvContent.write(to: tempURL, atomically: true, encoding: .utf8)
            
            // Share the file
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            
            // For iPad
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = exportButton
                popover.sourceRect = exportButton.bounds
            }
            
            present(activityVC, animated: true)
            
        } catch {
            showAlert(message: "Dışa aktarma hatası: \(error.localizedDescription)")
        }
    }
    
    @objc private func confidenceSliderChanged() {
        let confidence = Int(confidenceSlider.value * 100)
        confidenceFilterLabel.text = "🎯 Güven Filtresi: %\(confidence)"
        
        // Re-filter results if available
        if let ocrResults = ocrResults {
            let filteredLines = ocrResults.lines.filter { $0.confidence >= confidenceSlider.value }
            let filteredResult = OCRResult(
                lines: filteredLines,
                fullText: filteredLines.map { $0.text }.joined(separator: "\n"),
                totalLines: filteredLines.count,
                averageConfidence: Double(filteredLines.map { $0.confidence }.reduce(0, +)) / Double(max(filteredLines.count, 1))
            )
            
            // Update summary
            let summaryText = """
            📝 Toplam Satır: \(filteredResult.totalLines)
            🎯 Ortalama Güven: %\(filteredResult.averageConfidencePercentage)
            ✅ Yüksek Güvenli: \(filteredResult.highConfidenceLines.count)
            ⚠️ Düşük Güvenli: \(filteredResult.lowConfidenceLines.count)
            """
            resultsSummaryLabel.text = summaryText
            
            // Reload table view
            resultsTableView.reloadData()
        }
    }

    
    private func navigateToHistory() {
        let historyVC = HistoryViewController()
        let navController = UINavigationController(rootViewController: historyVC)
        present(navController, animated: true)
    }
    
    private func updateUIForSelectedImage() {
        placeholderLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        
        // Reset previous results
        resultsContainer.isHidden = true
        confidenceFilterContainer.isHidden = true
        actionButtonsStackView.isHidden = true
        ocrResults = nil
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Kırpılmış resmi al, yoksa orijinal resmi kullan
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            imageView.image = editedImage
            print("✅ Kırpılmış resim seçildi")
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            imageView.image = originalImage
            print("📷 Orijinal resim seçildi (kırpılmadı)")
        }
        
        updateUIForSelectedImage()
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ScanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ocrResults?.lines.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OCRResultCell", for: indexPath) as! OCRResultCell
        if let line = ocrResults?.lines[indexPath.row] {
            cell.configure(with: line)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // Adjust as needed
    }
}

// MARK: - OCRResultCell
class OCRResultCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let lineNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    private let contentTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let confidenceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    private let confidenceIconLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(lineNumberLabel)
        containerView.addSubview(contentTextLabel)
        containerView.addSubview(confidenceLabel)
        containerView.addSubview(confidenceIconLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        lineNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        confidenceIconLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        confidenceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(confidenceIconLabel.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        contentTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(lineNumberLabel.snp.trailing).offset(12)
            make.trailing.equalTo(confidenceLabel.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with line: OCRLine) {
        lineNumberLabel.text = "\(line.confidencePercentage)"
        contentTextLabel.text = line.text
        
        // Configure confidence display
        confidenceLabel.text = "%\(line.confidencePercentage)"
        
        if line.isHighConfidence {
            confidenceLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            confidenceLabel.textColor = .systemGreen
            confidenceIconLabel.text = "✅"
        } else {
            confidenceLabel.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
            confidenceLabel.textColor = .systemOrange
            confidenceIconLabel.text = "⚠️"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentTextLabel.text = nil
        lineNumberLabel.text = nil
        confidenceLabel.text = nil
        confidenceIconLabel.text = nil
    }
}






