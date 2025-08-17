//
//  SettingsViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import SnapKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    // MARK: - UI Components
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    

    
    // MARK: - Properties
    private let userService = UserService()
    private let firebaseAuthService = FirebaseAuthService()
    private var currentUser: User?
    
    private let settingsSections = [
        SettingsSection(title: "Hesap", items: [
            SettingsItem(title: "Profil Bilgileri", icon: "person.circle", type: .navigation),
            SettingsItem(title: "Şifre Değiştir", icon: "lock.circle", type: .navigation),
            SettingsItem(title: "Çıkış Yap", icon: "rectangle.portrait.and.arrow.right", type: .action)
        ]),
        SettingsSection(title: "Uygulama", items: [
            SettingsItem(title: "Tema", icon: "paintbrush", type: .navigation),
            SettingsItem(title: "Bildirimler", icon: "bell", type: .navigation),
            SettingsItem(title: "Gizlilik", icon: "hand.raised", type: .navigation),
            SettingsItem(title: "KVKK İzni", icon: "doc.text", type: .navigation)
        ]),
        SettingsSection(title: "Hakkında", items: [
            SettingsItem(title: "Sürüm", icon: "info.circle", type: .info, detail: "1.0.0"),
            SettingsItem(title: "Lisans", icon: "doc.text", type: .navigation),
            SettingsItem(title: "İletişim", icon: "envelope", type: .navigation)
        ])
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Ayarlar"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Helper Methods
    private func loadUserData() {
        currentUser = userService.getCurrentUser() as? User
        tableView.reloadData()
    }
    
    private func handleSettingsItem(_ item: SettingsItem) {
        switch item.title {
        case "Çıkış Yap":
            logout()
        case "Profil Bilgileri":
            // Navigate to profile
            break
        case "Şifre Değiştir":
            // Navigate to password change
            break
        case "Tema":
            // Navigate to theme settings
            break
        case "Bildirimler":
            // Navigate to notifications
            break
        case "Gizlilik":
            // Navigate to privacy
            break
        case "KVKK İzni":
            showKVKKSettings()
            break
        case "Lisans":
            // Navigate to license
            break
        case "İletişim":
            // Navigate to contact
            break
        default:
            break
        }
    }
    
    private func logout() {
        let alert = UIAlertController(title: "Çıkış Yap", message: "Hesabınızdan çıkış yapmak istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Çıkış Yap", style: .destructive) { _ in
            // Firebase sign out
            let success = self.firebaseAuthService.signOut()
            
            // Clear local data
            self.userService.deleteUser()
            
            if success {
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            } else {
                self.showAlert(message: "Çıkış yapılırken bir hata oluştu")
            }
        })
        
        present(alert, animated: true)
    }
    
    private func showKVKKSettings() {
        let alert = UIAlertController(title: "KVKK İzni", message: "KVKK izinleri bu sürümde henüz aktif değil", preferredStyle: .actionSheet)
        
        // Add actions
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        
        present(alert, animated: true)
    }
    
    private func revokeKVKKConsent() {
        let alert = UIAlertController(title: "KVKK İzni Geri Al", message: "KVKK izinleri bu sürümde henüz aktif değil", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        
        present(alert, animated: true)
    }
    
    private func deleteUserData() {
        let alert = UIAlertController(title: "Veri Silme", message: "Veri silme özelliği bu sürümde henüz aktif değil", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsSections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        let item = settingsSections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = settingsSections[indexPath.section].items[indexPath.row]
        handleSettingsItem(item)
    }
}

// MARK: - Settings Models
struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

struct SettingsItem {
    let title: String
    let icon: String
    let type: SettingsItemType
    let detail: String?
    
    init(title: String, icon: String, type: SettingsItemType, detail: String? = nil) {
        self.title = title
        self.icon = icon
        self.type = type
        self.detail = detail
    }
}

enum SettingsItemType {
    case navigation
    case action
    case info
}

// MARK: - Settings Table View Cell
class SettingsTableViewCell: UITableViewCell {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let accessoryImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(accessoryImageView)
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemPurple
        
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .label
        
        detailLabel.font = .systemFont(ofSize: 16)
        detailLabel.textColor = .secondaryLabel
        
        accessoryImageView.image = UIImage(systemName: "chevron.right")
        accessoryImageView.tintColor = .systemGray3
        accessoryImageView.contentMode = .scaleAspectFit
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.trailing.equalTo(accessoryImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        accessoryImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
    }
    
    func configure(with item: SettingsItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        detailLabel.text = item.detail
        
        switch item.type {
        case .navigation:
            accessoryImageView.isHidden = false
            accessoryType = .none
        case .action:
            accessoryImageView.isHidden = true
            accessoryType = .none
        case .info:
            accessoryImageView.isHidden = true
            accessoryType = .none
        }
    }
} 
