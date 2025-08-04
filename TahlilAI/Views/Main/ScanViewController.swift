//
//  ScanViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import PhotosUI

class ScanViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "📷 Tahlil Sonucu Tara"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Laboratuvar tahlil sonucunuzun fotoğrafını çekin veya galeriden seçin. AI teknolojimiz sonuçları otomatik olarak analiz edecektir."
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .textSecondary
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .cardBackground
        imageView.roundCorners(20)
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.primaryGradientStart.withAlphaComponent(0.3).cgColor
        imageView.addShadow(color: .primaryGradientStart, opacity: 0.2, radius: 15)
        return imageView
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
    
    private let resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TestResultCell.self, forCellReuseIdentifier: "TestResultCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isHidden = true
        return tableView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("💾 Sonuçları Kaydet", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .accentGreen
        button.setTitleColor(.white, for: .normal)
        button.roundCorners(16)
        button.addShadow()
        button.isHidden = true
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private let imagePicker = UIImagePickerController()
    private var selectedImage: UIImage?
    private var analyzedTests: [LabTest] = []
    private let userService = UserService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupImagePicker()
        setupTableView()
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
    }
    
    private func setupUI() {
        // Modern gradient background
        view.addGradientBackground(
            startColor: .backgroundPrimary,
            endColor: .backgroundSecondary,
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerLabel, descriptionLabel, imageView, cameraButton, galleryButton, 
         analyzeButton, creditsLabel, resultsTableView, saveButton, loadingIndicator].forEach {
            contentView.addSubview($0)
        }
        
        analyzeButton.addSubview(loadingIndicator)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        analyzeButton.translatesAutoresizingMaskIntoConstraints = false
        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // HeaderLabel
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // DescriptionLabel
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // ImageView
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            // CameraButton
            cameraButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            cameraButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cameraButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            cameraButton.heightAnchor.constraint(equalToConstant: 50),
            
            // GalleryButton
            galleryButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            galleryButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            galleryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            galleryButton.heightAnchor.constraint(equalToConstant: 50),
            
            // AnalyzeButton
            analyzeButton.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 20),
            analyzeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            analyzeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            analyzeButton.heightAnchor.constraint(equalToConstant: 50),
            
            // CreditsLabel
            creditsLabel.topAnchor.constraint(equalTo: analyzeButton.bottomAnchor, constant: 12),
            creditsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            creditsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // ResultsTableView
            resultsTableView.topAnchor.constraint(equalTo: creditsLabel.bottomAnchor, constant: 20),
            resultsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resultsTableView.heightAnchor.constraint(equalToConstant: 300),
            
            // SaveButton
            saveButton.topAnchor.constraint(equalTo: resultsTableView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // LoadingIndicator
            loadingIndicator.centerXAnchor.constraint(equalTo: analyzeButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: analyzeButton.centerYAnchor)
        ])
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func setupTableView() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }
    
    private func setupActions() {
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        analyzeButton.addTarget(self, action: #selector(analyzeButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func cameraButtonTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true)
        } else {
            showError("Kamera kullanılamıyor")
        }
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
        updateLoadingState(true)
        
        // Mock analysis - in real app, this would call the AI service
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.updateLoadingState(false)
            self.analyzedTests = self.getMockTestData()
            self.showResults()
            self.userService.useCredits(1)
            self.updateCreditsLabel()
        }
    }
    
    private func getMockTestData() -> [LabTest] {
        return [
            LabTest(name: "Hemoglobin", value: 14.2, unit: "g/dL", normalRange: 12.0...16.0, category: .blood),
            LabTest(name: "White Blood Cells", value: 7.5, unit: "K/μL", normalRange: 4.5...11.0, category: .blood),
            LabTest(name: "Platelets", value: 250, unit: "K/μL", normalRange: 150...450, category: .blood),
            LabTest(name: "Glucose", value: 95, unit: "mg/dL", normalRange: 70...100, category: .biochemistry),
            LabTest(name: "Creatinine", value: 0.9, unit: "mg/dL", normalRange: 0.6...1.2, category: .biochemistry)
        ]
    }
    
    private func showResults() {
        resultsTableView.isHidden = false
        saveButton.isHidden = false
        resultsTableView.reloadData()
    }
    
    private func saveTestResults() {
        let testResult = LabTestResult(
            date: Date(),
            tests: analyzedTests,
            imageURL: nil,
            notes: "Fotoğraf analizi"
        )
        
        let labTestService = LabTestService()
        labTestService.saveTestResult(testResult)
        
        showSuccess("Test sonuçları başarıyla kaydedildi")
        resetUI()
    }
    
    private func resetUI() {
        selectedImage = nil
        imageView.image = nil
        analyzedTests = []
        resultsTableView.isHidden = true
        saveButton.isHidden = true
        analyzeButton.isEnabled = false
        analyzeButton.alpha = 0.6
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        analyzeButton.isEnabled = !isLoading
        analyzeButton.alpha = isLoading ? 0.7 : 1.0
        
        if isLoading {
            loadingIndicator.startAnimating()
            analyzeButton.setTitle("", for: .normal)
        } else {
            loadingIndicator.stopAnimating()
            analyzeButton.setTitle("🔍 Analiz Et", for: .normal)
        }
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
            analyzeButton.isEnabled = true
            analyzeButton.alpha = 1.0
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ScanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analyzedTests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestResultCell", for: indexPath) as! TestResultCell
        let test = analyzedTests[indexPath.row]
        cell.configure(with: test)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Test Result Cell
class TestResultCell: UITableViewCell {
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    private let unitLabel = UILabel()
    private let statusView = UIView()
    private let statusLabel = UILabel()
    
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
        [nameLabel, valueLabel, unitLabel, statusView, statusLabel].forEach {
            containerView.addSubview($0)
        }
        
        containerView.backgroundColor = .cardBackground
        containerView.roundCorners(12)
        containerView.addShadow()
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = .primaryBlue
        unitLabel.font = .systemFont(ofSize: 14)
        unitLabel.textColor = .secondaryLabel
        statusLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        statusView.roundCorners(4)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: -12),
            
            valueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 4),
            unitLabel.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor),
            
            statusView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            statusView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusView.widthAnchor.constraint(equalToConstant: 8),
            statusView.heightAnchor.constraint(equalToConstant: 8),
            
            statusLabel.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 4),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with test: LabTest) {
        nameLabel.text = test.name
        valueLabel.text = test.value.formattedString()
        unitLabel.text = test.unit
        statusLabel.text = test.isAbnormal ? "Anormal" : "Normal"
        statusLabel.textColor = test.isAbnormal ? .accentRed : .accentGreen
        statusView.backgroundColor = test.isAbnormal ? .accentRed : .accentGreen
    }
} 