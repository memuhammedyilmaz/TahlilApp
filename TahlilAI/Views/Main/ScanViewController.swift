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

class ScanViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "📷 Fotoğraf çekin veya galeriden görsel ekleyin\nTahlil sonuçlarınızı AI ile analiz edelim"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .textSecondary
        label.lineBreakMode = .byWordWrapping
        label.roundCorners(12)
        label.addShadow(color: .primaryGradientStart, opacity: 0.2, radius: 8)
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.primaryGradientStart.withAlphaComponent(0.3).cgColor
        return label
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardBackground
        view.roundCorners(20)
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.primaryGradientStart.withAlphaComponent(0.3).cgColor
        view.addShadow(color: .primaryGradientStart, opacity: 0.2, radius: 15)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.roundCorners(20)
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
        label.tag = 100
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📷 Kamera ile Çek", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .primaryGradientStart
        button.setTitleColor(.white, for: .normal)
        button.roundCorners(20)
        button.addShadow(color: .primaryGradientStart, opacity: 0.3, radius: 12)
        return button
    }()
    
    private let galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🖼️ Galeriden Seç", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .successGradientStart
        button.setTitleColor(.white, for: .normal)
        button.roundCorners(20)
        button.addShadow(color: .successGradientStart, opacity: 0.3, radius: 12)
        return button
    }()
    
    private let analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🔍 Analiz Et", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .secondaryGradientStart
        button.setTitleColor(.white, for: .normal)
        button.roundCorners(25)
        button.addShadow(color: .secondaryGradientStart, opacity: 0.3, radius: 15)
        button.isEnabled = false
        button.alpha = 0.6
        return button
    }()
    
    private let creditsLabel: UILabel = {
        let label = UILabel()
        label.text = "💎 Kalan Kredi: 0"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .primaryGradientStart
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    private let imagePicker = UIImagePickerController()
    private var selectedImage: UIImage?
    private let userService = UserService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupImagePicker()
        setupActions()
        updateCreditsLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCreditsLabel()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Tahlil Tara"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.textPrimary,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }
    
    private func setupUI() {
        // Modern gradient background
        view.addGradientBackground(
            startColor: .backgroundPrimary,
            endColor: .backgroundSecondary,
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
        
        // Add subviews using SnapKit style
        view.addSubview(descriptionLabel)
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        imageContainerView.addSubview(placeholderLabel)
        view.addSubview(cameraButton)
        view.addSubview(galleryButton)
        view.addSubview(analyzeButton)
        view.addSubview(creditsLabel)
    }
    
    private func setupConstraints() {
        // DescriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(80)
        }
        
        // ImageContainerView
        imageContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(280)
        }
        
        // ImageView
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // PlaceholderLabel
        placeholderLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // CameraButton
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.centerX).offset(-8)
            make.height.equalTo(50)
        }
        
        // GalleryButton
        galleryButton.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.centerX).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        // AnalyzeButton
        analyzeButton.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        // CreditsLabel
        creditsLabel.snp.makeConstraints { make in
            make.top.equalTo(analyzeButton.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20)
        }
        

        
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    

    
    private func setupActions() {
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        analyzeButton.addTarget(self, action: #selector(analyzeButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageContainerView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func cameraButtonTapped() {
        // Check camera availability
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showError("Bu cihazda kamera bulunmuyor")
            return
        }
        
        // Check camera permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.openCamera()
                    } else {
                        self?.showError("Kamera izni reddedildi")
                    }
                }
            }
        case .denied, .restricted:
            showCameraPermissionAlert()
        @unknown default:
            showError("Kamera erişimi sağlanamadı")
        }
    }
    
    private func openCamera() {
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        present(imagePicker, animated: true)
    }
    
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(
            title: "Kamera İzni Gerekli",
            message: "Kamera kullanabilmek için Ayarlar > Gizlilik ve Güvenlik > Kamera bölümünden izin vermeniz gerekiyor.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ayarlara Git", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func galleryButtonTapped() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func analyzeButtonTapped() {
        guard let image = selectedImage else { return }
        
        // Check credits
        if userService.getAvailableCredits() < 1 {
            showError("Yetersiz kredi. Lütfen kredi satın alın.")
            return
        }
        
        startAnalysis(image: image)
    }
    
    @objc private func saveButtonTapped() {
        saveTestResults()
    }
    
    @objc private func imageViewTapped() {
        let alert = UIAlertController(title: "Fotoğraf Seç", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Kamera", style: .default) { _ in
            self.cameraButtonTapped()
        })
        
        alert.addAction(UIAlertAction(title: "Galeri", style: .default) { _ in
            self.galleryButtonTapped()
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    private func startAnalysis(image: UIImage) {
        // Mock analysis - in real app, this would call the AI service
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showResults()
            self.userService.useCredits(1)
            self.updateCreditsLabel()
        }
    }
    
    private func getMockTestData() -> [LabTest] {
        return [
            LabTest(name: "Hemoglobin", value: 14.2, unit: "g/dL", normalRange: "12.0-16.0", category: TestCategory.blood.rawValue),
            LabTest(name: "White Blood Cells", value: 7.5, unit: "K/μL", normalRange: "4.5-11.0", category: TestCategory.blood.rawValue),
            LabTest(name: "Platelets", value: 250, unit: "K/μL", normalRange: "150-450", category: TestCategory.blood.rawValue),
            LabTest(name: "Glucose", value: 95, unit: "mg/dL", normalRange: "70-100", category: TestCategory.biochemistry.rawValue),
            LabTest(name: "Creatinine", value: 0.9, unit: "mg/dL", normalRange: "0.6-1.2", category: TestCategory.biochemistry.rawValue),
            LabTest(name: "Cholesterol", value: 180, unit: "mg/dL", normalRange: "0-200", category: TestCategory.biochemistry.rawValue),
            LabTest(name: "Triglycerides", value: 150, unit: "mg/dL", normalRange: "0-150", category: TestCategory.biochemistry.rawValue)
        ]
    }
    

    
    private func showResults() {
        // Save test results first
        let mockTests = getMockTestData()
        let testResult = LabTestResult(
            date: Date(),
            tests: mockTests,
            notes: "Fotoğraf analizi"
        )
        
        let labTestService = LabTestService()
        labTestService.saveTestResult(testResult)
        
        // Open HistoryViewController directly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.openHistoryViewController()
        }
    }
    
    private func saveTestResults() {
        // This method is now handled in showResults()
        showSuccess("Test sonuçları başarıyla kaydedildi")
        resetUI()
    }
    
    private func resetUI() {
        selectedImage = nil
        imageView.image = nil
        
        // Show placeholder again
        placeholderLabel.isHidden = false
        
        analyzeButton.isEnabled = false
        analyzeButton.alpha = 0.6
    }
   
    
    private func openHistoryViewController() {
        let historyVC = HistoryViewController()
        let navController = UINavigationController(rootViewController: historyVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    private func updateCreditsLabel() {
        let credits = userService.getAvailableCredits()
        creditsLabel.text = "💎 Kalan Kredi: \(credits)"
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Başarılı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            selectedImage = image
            imageView.image = image
            
            // Hide placeholder
            placeholderLabel.isHidden = true
            
            analyzeButton.isEnabled = true
            analyzeButton.alpha = 1.0
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}



 
