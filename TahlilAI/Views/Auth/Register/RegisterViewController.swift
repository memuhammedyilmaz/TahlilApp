//
//  RegisterViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import SnapKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backgroundGradientView: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.badge.plus")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesap Oluştur"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "TahlilAI'ya katılın ve laboratuvar sonuçlarınızı analiz edin"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 20
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Kişisel Bilgileriniz"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    private let nameIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ad Soyad"
        textField.font = .systemFont(ofSize: 16)
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let emailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    private let emailIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "envelope")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-posta adresiniz"
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let passwordContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    private let passwordIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifreniz"
        textField.font = .systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let showPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let confirmPasswordContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    private let confirmPasswordIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.shield")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifrenizi tekrar girin"
        textField.font = .systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let showConfirmPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hesap Oluştur", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.systemPurple.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
        return button
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Zaten hesabın var mı? Giriş yap", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemPurple, for: .normal)
        return button
    }()
    
    // MARK: - Properties
    private let userService = UserService()
    private let firebaseAuthService = FirebaseAuthService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupGradient()
        setupKeyboardHandling()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(backgroundGradientView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [logoImageView, titleLabel, subtitleLabel, cardView].forEach {
            contentView.addSubview($0)
        }
        
        [welcomeLabel, nameContainerView, emailContainerView, passwordContainerView, 
         confirmPasswordContainerView, registerButton, dividerView, loginButton].forEach {
            cardView.addSubview($0)
        }
        
        [nameIconImageView, nameTextField].forEach {
            nameContainerView.addSubview($0)
        }
        
        [emailIconImageView, emailTextField].forEach {
            emailContainerView.addSubview($0)
        }
        
        [passwordIconImageView, passwordTextField, showPasswordButton].forEach {
            passwordContainerView.addSubview($0)
        }
        
        [confirmPasswordIconImageView, confirmPasswordTextField, showConfirmPasswordButton].forEach {
            confirmPasswordContainerView.addSubview($0)
        }
    }
    
    private func setupGradient() {
        if let gradientLayer = backgroundGradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = backgroundGradientView.bounds
        }
    }
    
    private func setupKeyboardHandling() {
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Set text field delegates
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // Always scroll to show the card view properly when keyboard appears
        let cardViewFrame = cardView.convert(cardView.bounds, to: scrollView)
        let scrollPoint = CGPoint(x: 0, y: max(0, cardViewFrame.origin.y - 50))
        scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func getActiveTextField() -> UITextField? {
        if nameTextField.isFirstResponder {
            return nameTextField
        } else if emailTextField.isFirstResponder {
            return emailTextField
        } else if passwordTextField.isFirstResponder {
            return passwordTextField
        } else if confirmPasswordTextField.isFirstResponder {
            return confirmPasswordTextField
        }
        return nil
    }
    
    private func setupConstraints() {
        backgroundGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        nameContainerView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        nameIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.leading.equalTo(nameIconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        emailContainerView.snp.makeConstraints { make in
            make.top.equalTo(nameContainerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        emailIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(emailIconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        passwordContainerView.snp.makeConstraints { make in
            make.top.equalTo(emailContainerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        passwordIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(passwordIconImageView.snp.trailing).offset(12)
            make.trailing.equalTo(showPasswordButton.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
        
        showPasswordButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        confirmPasswordContainerView.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        confirmPasswordIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.leading.equalTo(confirmPasswordIconImageView.snp.trailing).offset(12)
            make.trailing.equalTo(showConfirmPasswordButton.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
        
        showConfirmPasswordButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordContainerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        showConfirmPasswordButton.addTarget(self, action: #selector(showConfirmPasswordButtonTapped), for: .touchUpInside)
        
        // Add button press animations
        [registerButton, loginButton, showPasswordButton, showConfirmPasswordButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
    }
    
    // MARK: - Actions
    @objc private func registerButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Lütfen tüm alanları doldurun")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Şifreler eşleşmiyor")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(message: "Şifre en az 6 karakter olmalıdır")
            return
        }
        
        // Add loading state
        registerButton.setTitle("Hesap oluşturuluyor...", for: .normal)
        registerButton.isEnabled = false
        
        // Firebase Authentication
        firebaseAuthService.signUp(email: email, password: password, name: name) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    // Save user to local storage
                    self?.userService.saveUser(user)
                    
                    // Navigate to main app
                    let mainTabBarController = MainTabBarController()
                    mainTabBarController.modalPresentationStyle = .fullScreen
                    self?.present(mainTabBarController, animated: true)
                    
                case .failure(let error):
                    self?.handleAuthError(error)
                    self?.registerButton.setTitle("Hesap Oluştur", for: .normal)
                    self?.registerButton.isEnabled = true
                }
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func showPasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func showConfirmPasswordButtonTapped() {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        let imageName = confirmPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showConfirmPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func buttonTouchDown(_ button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp(_ button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Helper Methods
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func handleAuthError(_ error: Error) {
        let errorMessage: String
        
        // Convert to NSError to get the error code
        let nsError = error as NSError
        
        // Firebase Auth error codes
        switch nsError.code {
        case 17008: // Invalid email
            errorMessage = "Geçersiz e-posta adresi"
        case 17026: // Weak password
            errorMessage = "Şifre çok zayıf. En az 6 karakter kullanın"
        case 17007: // Email already in use
            errorMessage = "Bu e-posta adresi zaten kullanımda"
        case 17010: // Too many requests
            errorMessage = "Çok fazla deneme yaptınız. Lütfen daha sonra tekrar deneyin"
        case 17020: // Network error
            errorMessage = "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin"
        case 17006: // Operation not allowed
            errorMessage = "E-posta/şifre ile kayıt etkin değil"
        default:
            
            // Try to match based on error description as fallback
            let errorDescription = error.localizedDescription.lowercased()
            if errorDescription.contains("email") || errorDescription.contains("e-posta") || errorDescription.contains("invalid") {
                errorMessage = "Geçersiz e-posta adresi"
            } else if errorDescription.contains("password") || errorDescription.contains("şifre") || errorDescription.contains("weak") {
                errorMessage = "Şifre çok zayıf. En az 6 karakter kullanın"
            } else if errorDescription.contains("already") || errorDescription.contains("zaten") || errorDescription.contains("in use") {
                errorMessage = "Bu e-posta adresi zaten kullanımda"
            } else if errorDescription.contains("network") || errorDescription.contains("ağ") || errorDescription.contains("connection") {
                errorMessage = "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin"
            } else {
                errorMessage = "Hesap oluşturulurken bir hata oluştu. Lütfen bilgilerinizi kontrol edin."
            }
        }
        
        showAlert(message: errorMessage)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
            registerButtonTapped()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Add visual feedback for active text field
        if let containerView = textField.superview {
            containerView.layer.borderColor = UIColor.systemPurple.cgColor
            containerView.layer.borderWidth = 2
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Remove visual feedback
        if let containerView = textField.superview {
            containerView.layer.borderColor = UIColor.systemGray4.cgColor
            containerView.layer.borderWidth = 1
        }
    }
} 
