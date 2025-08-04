//
//  SettingsViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "⚙️ Ayarlar"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesap bilgilerinizi düzenleyin ve uygulama ayarlarını yapılandırın"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // Profile Section
    private let profileSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "👤 Profil Bilgileri"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ad Soyad"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .backgroundGray
        textField.roundCorners(12)
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-posta"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .backgroundGray
        textField.roundCorners(12)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Telefon"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .backgroundGray
        textField.roundCorners(12)
        textField.keyboardType = .phonePad
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let ageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Yaş"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .backgroundGray
        textField.roundCorners(12)
        textField.keyboardType = .numberPad
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Boy (cm)"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .backgroundGray
        textField.roundCorners(12)
        textField.keyboardType = .decimalPad
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Kilo (kg)"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .backgroundGray
        textField.roundCorners(12)
        textField.keyboardType = .decimalPad
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    // Credits Section
    private let creditsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "💎 Kredi Sistemi"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let creditsLabel: UILabel = {
        let label = UILabel()
        label.text = "Mevcut Kredi: 0"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .primaryBlue
        return label
    }()
    
    private let creditsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 120, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CreditPackageCell.self, forCellWithReuseIdentifier: "CreditPackageCell")
        return collectionView
    }()
    
    // Theme Section
    private let themeSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "🎨 Tema"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let themeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.selectedSegmentIndex = 2 // System default
        control.backgroundColor = .backgroundGray
        control.selectedSegmentTintColor = .primaryBlue
        control.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return control
    }()
    
    // Premium Section
    private let premiumSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "⭐ Premium"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let premiumStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Ücretsiz Plan"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let upgradeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Premium'a Yükselt", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .accentOrange
        button.setTitleColor(.white, for: .normal)
        button.roundCorners(12)
        button.addShadow()
        return button
    }()
    
    private let saveProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("💾 Profili Kaydet", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .primaryBlue
        button.setTitleColor(.white, for: .normal)
        button.roundCorners(16)
        button.addShadow()
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🚪 Çıkış Yap", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.accentRed, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Properties
    private let userService = UserService()
    private let creditPackages = [
        CreditPackage(credits: 10, price: "₺9.99", popular: false),
        CreditPackage(credits: 25, price: "₺19.99", popular: true),
        CreditPackage(credits: 50, price: "₺34.99", popular: false),
        CreditPackage(credits: 100, price: "₺59.99", popular: false)
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupThemeControl()
        setupCollectionView()
        setupActions()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCreditsLabel()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Ayarlar"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerLabel, descriptionLabel, profileSectionLabel, nameTextField, emailTextField,
         phoneTextField, ageTextField, heightTextField, weightTextField, creditsSectionLabel,
         creditsLabel, creditsCollectionView, themeSectionLabel, themeSegmentedControl,
         premiumSectionLabel, premiumStatusLabel, upgradeButton, saveProfileButton, logoutButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        profileSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        heightTextField.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        creditsSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
        creditsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        themeSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        themeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        premiumSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        premiumStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        upgradeButton.translatesAutoresizingMaskIntoConstraints = false
        saveProfileButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            // ProfileSectionLabel
            profileSectionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            profileSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // NameTextField
            nameTextField.topAnchor.constraint(equalTo: profileSectionLabel.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // EmailTextField
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // PhoneTextField
            phoneTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            phoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // AgeTextField
            ageTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12),
            ageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ageTextField.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            ageTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // HeightTextField
            heightTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12),
            heightTextField.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            heightTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            heightTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // WeightTextField
            weightTextField.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 12),
            weightTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            weightTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // CreditsSectionLabel
            creditsSectionLabel.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 30),
            creditsSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            creditsSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // CreditsLabel
            creditsLabel.topAnchor.constraint(equalTo: creditsSectionLabel.bottomAnchor, constant: 12),
            creditsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            creditsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // CreditsCollectionView
            creditsCollectionView.topAnchor.constraint(equalTo: creditsLabel.bottomAnchor, constant: 12),
            creditsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            creditsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            creditsCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            // ThemeSectionLabel
            themeSectionLabel.topAnchor.constraint(equalTo: creditsCollectionView.bottomAnchor, constant: 30),
            themeSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            themeSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // ThemeSegmentedControl
            themeSegmentedControl.topAnchor.constraint(equalTo: themeSectionLabel.bottomAnchor, constant: 12),
            themeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            themeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            themeSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // PremiumSectionLabel
            premiumSectionLabel.topAnchor.constraint(equalTo: themeSegmentedControl.bottomAnchor, constant: 30),
            premiumSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            premiumSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // PremiumStatusLabel
            premiumStatusLabel.topAnchor.constraint(equalTo: premiumSectionLabel.bottomAnchor, constant: 12),
            premiumStatusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            premiumStatusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // UpgradeButton
            upgradeButton.topAnchor.constraint(equalTo: premiumStatusLabel.bottomAnchor, constant: 12),
            upgradeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            upgradeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            upgradeButton.heightAnchor.constraint(equalToConstant: 50),
            
            // SaveProfileButton
            saveProfileButton.topAnchor.constraint(equalTo: upgradeButton.bottomAnchor, constant: 30),
            saveProfileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveProfileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
            // LogoutButton
            logoutButton.topAnchor.constraint(equalTo: saveProfileButton.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupThemeControl() {
        let themes = AppTheme.allCases
        themeSegmentedControl.removeAllSegments()
        
        for (index, theme) in themes.enumerated() {
            themeSegmentedControl.insertSegment(withTitle: theme.displayName, at: index, animated: false)
        }
        
        themeSegmentedControl.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        creditsCollectionView.delegate = self
        creditsCollectionView.dataSource = self
    }
    
    private func setupActions() {
        saveProfileButton.addTarget(self, action: #selector(saveProfileButtonTapped), for: .touchUpInside)
        upgradeButton.addTarget(self, action: #selector(upgradeButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func themeChanged() {
        let themes = AppTheme.allCases
        if themeSegmentedControl.selectedSegmentIndex < themes.count {
            let selectedTheme = themes[themeSegmentedControl.selectedSegmentIndex]
            updateUserTheme(selectedTheme)
        }
    }
    
    @objc private func saveProfileButtonTapped() {
        saveUserProfile()
    }
    
    @objc private func upgradeButtonTapped() {
        showPremiumUpgrade()
    }
    
    @objc private func logoutButtonTapped() {
        showLogoutConfirmation()
    }
    
    // MARK: - Helper Methods
    private func loadUserData() {
        if let user = userService.getCurrentUser() {
            nameTextField.text = user.name
            emailTextField.text = user.email
            phoneTextField.text = user.phone
            ageTextField.text = user.age > 0 ? "\(user.age)" : ""
            heightTextField.text = user.height > 0 ? "\(user.height)" : ""
            weightTextField.text = user.weight > 0 ? "\(user.weight)" : ""
            
            // Set theme
            let themes = AppTheme.allCases
            if let themeIndex = themes.firstIndex(of: user.theme) {
                themeSegmentedControl.selectedSegmentIndex = themeIndex
            }
            
            // Update premium status
            premiumStatusLabel.text = user.isPremium ? "Premium Üye" : "Ücretsiz Plan"
            upgradeButton.setTitle(user.isPremium ? "Premium Aktif" : "Premium'a Yükselt", for: .normal)
            upgradeButton.isEnabled = !user.isPremium
        }
        
        updateCreditsLabel()
    }
    
    private func saveUserProfile() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            showError("Ad ve e-posta alanları zorunludur")
            return
        }
        
        let age = Int(ageTextField.text ?? "") ?? 0
        let height = Double(heightTextField.text ?? "") ?? 0.0
        let weight = Double(weightTextField.text ?? "") ?? 0.0
        
        let updatedUser = User(
            name: name,
            email: email,
            phone: phoneTextField.text ?? "",
            height: height,
            weight: weight,
            age: age,
            credits: userService.getAvailableCredits(),
            isPremium: userService.getCurrentUser()?.isPremium ?? false,
            theme: userService.getCurrentUser()?.theme ?? .system
        )
        
        userService.updateUser(updatedUser)
        showSuccess("Profil başarıyla güncellendi")
    }
    
    private func updateUserTheme(_ theme: AppTheme) {
        if var user = userService.getCurrentUser() as? User {
            let updatedUser = User(
                id: user.id,
                name: user.name,
                email: user.email,
                phone: user.phone,
                height: user.height,
                weight: user.weight,
                age: user.age,
                credits: user.credits,
                isPremium: user.isPremium,
                theme: theme
            )
            userService.updateUser(updatedUser)
        }
    }
    
    private func updateCreditsLabel() {
        let credits = userService.getAvailableCredits()
        creditsLabel.text = "Mevcut Kredi: \(credits)"
    }
    
    private func showPremiumUpgrade() {
        let alert = UIAlertController(title: "Premium'a Yükselt", message: "Premium özellikler:\n• Sınırsız kredi\n• Gelişmiş analizler\n• Öncelikli destek\n• Reklamsız deneyim", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "₺29.99/ay", style: .default) { _ in
            self.purchasePremium()
        })
        
        alert.addAction(UIAlertAction(title: "₺299.99/yıl", style: .default) { _ in
            self.purchasePremium()
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func purchasePremium() {
        // Mock premium purchase
        if var user = userService.getCurrentUser() as? User {
            let updatedUser = User(
                id: user.id,
                name: user.name,
                email: user.email,
                phone: user.phone,
                height: user.height,
                weight: user.weight,
                age: user.age,
                credits: user.credits,
                isPremium: true,
                theme: user.theme
            )
            userService.updateUser(updatedUser)
            loadUserData()
            showSuccess("Premium üyeliğiniz aktif edildi!")
        }
    }
    
    private func showLogoutConfirmation() {
        let alert = UIAlertController(title: "Çıkış Yap", message: "Hesabınızdan çıkış yapmak istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Çıkış Yap", style: .destructive) { _ in
            self.logout()
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func logout() {
        userService.deleteUser()
        
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creditPackages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreditPackageCell", for: indexPath) as! CreditPackageCell
        let package = creditPackages[indexPath.item]
        cell.configure(with: package)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let package = creditPackages[indexPath.item]
        purchaseCredits(package)
    }
    
    private func purchaseCredits(_ package: CreditPackage) {
        let alert = UIAlertController(title: "Kredi Satın Al", message: "\(package.credits) kredi satın almak istiyor musunuz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: package.price, style: .default) { _ in
            self.userService.addCredits(package.credits)
            self.updateCreditsLabel()
            self.showSuccess("\(package.credits) kredi başarıyla eklendi!")
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - Credit Package Cell
class CreditPackageCell: UICollectionViewCell {
    private let containerView = UIView()
    private let creditsLabel = UILabel()
    private let priceLabel = UILabel()
    private let popularLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        [creditsLabel, priceLabel, popularLabel].forEach {
            containerView.addSubview($0)
        }
        
        containerView.backgroundColor = .cardBackground
        containerView.roundCorners(12)
        containerView.addShadow()
        
        creditsLabel.font = .systemFont(ofSize: 16, weight: .bold)
        creditsLabel.textColor = .primaryBlue
        creditsLabel.textAlignment = .center
        
        priceLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        priceLabel.textColor = .label
        priceLabel.textAlignment = .center
        
        popularLabel.font = .systemFont(ofSize: 10, weight: .bold)
        popularLabel.textColor = .white
        popularLabel.backgroundColor = .accentOrange
        popularLabel.textAlignment = .center
        popularLabel.roundCorners(8)
        popularLabel.text = "POPÜLER"
        popularLabel.isHidden = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        popularLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            creditsLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            creditsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            creditsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: creditsLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            popularLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            popularLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            popularLabel.widthAnchor.constraint(equalToConstant: 50),
            popularLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(with package: CreditPackage) {
        creditsLabel.text = "\(package.credits) Kredi"
        priceLabel.text = package.price
        popularLabel.isHidden = !package.popular
    }
}

// MARK: - Credit Package Model
struct CreditPackage {
    let credits: Int
    let price: String
    let popular: Bool
} 