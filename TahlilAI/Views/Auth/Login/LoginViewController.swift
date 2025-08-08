//
//  LoginViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backgroundGradientView: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "testtube.2")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TahlilAI"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Laboratuvar sonuçlarınızı yapay zeka ile analiz edin"
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
        label.text = "Hoş Geldiniz"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.systemBlue.cgColor
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
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hesap oluştur", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
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
        
        [welcomeLabel, emailContainerView, passwordContainerView, loginButton, dividerView, registerButton].forEach {
            cardView.addSubview($0)
        }
        
        [emailIconImageView, emailTextField].forEach {
            emailContainerView.addSubview($0)
        }
        
        [passwordIconImageView, passwordTextField, showPasswordButton].forEach {
            passwordContainerView.addSubview($0)
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
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        if emailTextField.isFirstResponder {
            return emailTextField
        } else if passwordTextField.isFirstResponder {
            return passwordTextField
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
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
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
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailContainerView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(24)
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
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        
        // Add button press animations
        [loginButton, registerButton, showPasswordButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Lütfen tüm alanları doldurun")
            return
        }
        
        // Add loading state
        loginButton.setTitle("Giriş yapılıyor...", for: .normal)
        loginButton.isEnabled = false
        
        // Firebase Authentication
        firebaseAuthService.signIn(email: email, password: password) { [weak self] result in
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
                    self?.loginButton.setTitle("Giriş Yap", for: .normal)
                    self?.loginButton.isEnabled = true
                }
            }
        }
    }
    
    @objc private func registerButtonTapped() {
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
    }
    
    @objc private func showPasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
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
        
        // Firebase Auth error codes (trying different code ranges)
        switch nsError.code {
        case 17009, 17999: // Wrong password (different Firebase versions)
            errorMessage = "Yanlış şifre"
        case 17008, 17998: // Invalid email
            errorMessage = "Geçersiz e-posta adresi"
        case 17011, 17997: // User not found
            errorMessage = "Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı"
        case 17010, 17996: // Too many requests
            errorMessage = "Çok fazla deneme yaptınız. Lütfen daha sonra tekrar deneyin"
        case 17020, 17995: // Network error
            errorMessage = "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin"
        case 17005, 17994: // User disabled
            errorMessage = "Hesabınız devre dışı bırakılmış"
        case 17006, 17993: // Operation not allowed
            errorMessage = "E-posta/şifre ile giriş etkin değil"
        default:
            // Debug: Print the actual error for troubleshooting
            print("Firebase Auth Error - Code: \(nsError.code), Description: \(error.localizedDescription)")
            
            // Try to match based on error description as fallback
            let errorDescription = error.localizedDescription.lowercased()
            if errorDescription.contains("password") || errorDescription.contains("şifre") || errorDescription.contains("wrong") {
                errorMessage = "Yanlış şifre"
            } else if errorDescription.contains("email") || errorDescription.contains("e-posta") || errorDescription.contains("invalid") {
                errorMessage = "Geçersiz e-posta adresi"
            } else if errorDescription.contains("user") || errorDescription.contains("kullanıcı") || errorDescription.contains("not found") {
                errorMessage = "Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı"
            } else if errorDescription.contains("network") || errorDescription.contains("ağ") || errorDescription.contains("connection") {
                errorMessage = "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin"
            } else {
                errorMessage = "Giriş yapılırken bir hata oluştu. Lütfen bilgilerinizi kontrol edin."
            }
        }
        
        showAlert(message: errorMessage)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Add visual feedback for active text field
        if let containerView = textField.superview {
            containerView.layer.borderColor = UIColor.systemBlue.cgColor
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