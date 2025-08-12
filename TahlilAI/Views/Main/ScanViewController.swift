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
    

    
    // MARK: - Properties
    private let viewModel = ScanViewModel()
    private var selectedImage: UIImage?
    
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
        
        viewModel.onAnalysisComplete = { [weak self] _ in
            self?.showAnalysisResult()
        }
        
        viewModel.onAnalysisError = { [weak self] errorMessage in
            self?.showAlert(message: "Analiz hatası: \(errorMessage)")
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
        present(imagePicker, animated: true)
    }
    
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
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
        // TODO: Implement AI analysis result handling
        let alert = UIAlertController(
            title: "⚠️ Analiz Sonucu",
            message: "AI analiz özelliği henüz geliştirilmedi.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel))
        present(alert, animated: true)
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
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
            updateUIForSelectedImage()
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}






