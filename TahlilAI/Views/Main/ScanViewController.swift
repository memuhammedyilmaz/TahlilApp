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
        label.text = "📷 Fotoğraf çekin veya galeriden görsel ekleyin\nTahlil sonuçlarınızı Al ile analiz edelim"
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
        label.text = "📷 Fotoğraf eklemek için dokunun"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📷 Kamera ile Çek", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        // Add shadow manually
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.masksToBounds = false
        return button
    }()
    
    private let galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🖼️ Galeriden Seç", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        // Add shadow manually
        button.layer.shadowColor = UIColor.systemGreen.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.masksToBounds = false
        return button
    }()
    
    private let analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🔍 Analiz Et", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.alpha = 0.6
        // Add shadow manually
        button.layer.shadowColor = UIColor.systemPurple.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.masksToBounds = false
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
        label.text = "Görsel analiz ediliyor..."
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
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
        view.addSubview(analyzeButton)
        view.addSubview(creditLabel)
        view.addSubview(progressLabel)
        
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
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageContainerTapped))
        imageContainerView.addGestureRecognizer(tapGesture)
        
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        analyzeButton.addTarget(self, action: #selector(analyzeButtonTapped), for: .touchUpInside)
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
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
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
    
    private func handleAnalysisComplete(_ ocrResult: OCRResult) {
        self.ocrResults = ocrResult
        
        // Update UI
        progressLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        
        // OCR sonuçlarını dizi formatında print et
        printOCRResultsAsArray(ocrResult)
        
        // Kullanıcıya bilgi ver
        showAlert(message: "OCR analizi tamamlandı! Sonuçlar konsola yazdırıldı.")
    }
    
    /// OCR sonuçlarını tablo formatında print eder
    private func printOCRResultsAsArray(_ ocrResult: OCRResult) {
        print("🔍 OCR Analiz Sonucu - Tablo Formatında:")
        print(String(repeating: "=", count: 100))
        
        // Tablo başlığı
        print("📋 LABORATUVAR TEST SONUÇLARI")
        print(String(repeating: "-", count: 100))
        
        // Tablo sütun başlıkları
        print("No  Test Adı                    Sonuç          Birim         Referans Değeri")
        print(String(repeating: "-", count: 100))
        
        // Her satır için tablo formatında
        for (index, line) in ocrResult.lines.enumerated() {
            let lineNumber = String(format: "%-4d", index + 1)
            let testName = String(line.text.prefix(25)).padding(toLength: 25, withPad: " ", startingAt: 0)
            let result = String(line.text.prefix(15)).padding(toLength: 15, withPad: " ", startingAt: 0)
            let unit = String(line.text.prefix(12)).padding(toLength: 12, withPad: " ", startingAt: 0)
            let reference = String(line.text.prefix(40)).padding(toLength: 40, withPad: " ", startingAt: 0)
            
            print("\(lineNumber) \(testName) \(result) \(unit) \(reference)")
        }
        
        print(String(repeating: "-", count: 100))
        
        // Özet bilgileri
        print("📊 TABLO ÖZETİ:")
        print("📝 Toplam Test: \(ocrResult.totalLines)")
        print("🎯 Ortalama Güven: %\(ocrResult.averageConfidencePercentage)")
        print("✅ Yüksek Güvenli: \(ocrResult.highConfidenceLines.count)")
        print("⚠️ Düşük Güvenli: \(ocrResult.lowConfidenceLines.count)")
        print(String(repeating: "=", count: 100))
    }
    
    private func handleAnalysisError(_ errorMessage: String) {
        progressLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        
        showAlert(message: errorMessage)
    }
    
    private func updateUIForSelectedImage() {
        placeholderLabel.isHidden = true
        analyzeButton.isEnabled = true
        analyzeButton.alpha = 1.0
        
        // Reset previous results
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



#Preview {
    ScanViewController()
}






