//
//  KVKKViewController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit
import SnapKit

class KVKKViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kişisel Verilerin Korunması"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Kullanıcı olarak sisteme yüklediğiniz tahlil sonuçları, boy, kilo, yaş ve diğer sağlık bilgileriniz, yalnızca tarafınıza genel bilgilendirme ve öneri sunmak amacıyla işlenmektedir. 6698 sayılı Kişisel Verilerin Korunması Kanunu (\"KVKK\") kapsamında \"özel nitelikli kişisel veri\" olarak kabul edilen sağlık verileriniz, açık rızanız alınmaksızın işlenmemektedir."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    

    
    private let dataCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Toplanan Veriler:"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let dataCollectionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "• Tahlil sonuçları ve raporları\n• Boy, kilo, yaş bilgileri\n• Ad, soyad, e-posta adresi\n• Uygulama kullanım verileri\n• Teknik veriler (IP adresi, cihaz bilgileri)\n• Sağlık verileri (özel nitelikli kişisel veri)"
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let purposeLabel: UILabel = {
        let label = UILabel()
        label.text = "Veri İşleme Amacı:"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let purposeTextView: UITextView = {
        let textView = UITextView()
        textView.text = "• Tahlil sonuçlarınızı analiz etmek ve size genel sağlık önerileri sunmak\n• Boy, kilo, yaş bilgilerinizle birlikte tahlil değerlerinizi değerlendirmek\n• Sistemin işleyişini ve güvenliğini sağlamak\n• Yurt dışı yapay zeka servisleriyle paylaşım (Google Cloud, Microsoft Azure, OpenAI vb.)"
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let dataTransferLabel: UILabel = {
        let label = UILabel()
        label.text = "Yurt Dışı Veri Aktarımı:"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let dataTransferTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Verileriniz, sistemin çalışması için kullanılan yurt dışı tabanlı yapay zeka servisleriyle (ör. Google Cloud, Microsoft Azure, OpenAI vb.) paylaşılabilir. Bu durumda verileriniz yurt dışına aktarılacaktır."
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let consentLabel: UILabel = {
        let label = UILabel()
        label.text = "Açık Rıza Onay Metni:"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let consentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Aşağıda yer alan metni okuyup onaylamadan uygulamayı kullanamazsınız.\n\n**Açık Rıza Beyanı:**\nKişisel sağlık verilerimin (tahlil sonuçları, boy, kilo, yaş vb.) tarafıma bilgilendirme ve öneri sunulması amacıyla işlenmesine ve yurt dışındaki yapay zeka hizmet sağlayıcılarıyla paylaşılmasına **açık rıza veriyorum**.\n\nVerileriniz, yalnızca yukarıda belirtilen amaçlarla ve gerekli güvenlik önlemleri alınarak işlenecek, hiçbir şekilde üçüncü kişilerle paylaşılmayacaktır. Dilediğiniz zaman verilerinizin silinmesini talep edebilirsiniz."
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Okudum, anladım ve kabul ediyorum", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private let declineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kabul Etmiyorum", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    // MARK: - Properties
    var onConsentGiven: (() -> Void)?
    var onConsentDeclined: (() -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    

    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "KVKK İzni"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, descriptionLabel, dataCollectionLabel, dataCollectionTextView, 
         purposeLabel, purposeTextView, dataTransferLabel, dataTransferTextView,
         consentLabel, consentTextView, acceptButton, declineButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dataCollectionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dataCollectionTextView.snp.makeConstraints { make in
            make.top.equalTo(dataCollectionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        purposeLabel.snp.makeConstraints { make in
            make.top.equalTo(dataCollectionTextView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        purposeTextView.snp.makeConstraints { make in
            make.top.equalTo(purposeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        dataTransferLabel.snp.makeConstraints { make in
            make.top.equalTo(purposeTextView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dataTransferTextView.snp.makeConstraints { make in
            make.top.equalTo(dataTransferLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        consentLabel.snp.makeConstraints { make in
            make.top.equalTo(dataTransferTextView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        consentTextView.snp.makeConstraints { make in
            make.top.equalTo(consentLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(consentTextView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        declineButton.snp.makeConstraints { make in
            make.top.equalTo(acceptButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupActions() {
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func acceptButtonTapped() {
        // Save consent to UserDefaults
        UserDefaults.standard.set(true, forKey: "KVKKConsent")
        UserDefaults.standard.set(Date(), forKey: "KVKKConsentDate")
        
        // Show success message
        let alert = UIAlertController(title: "Teşekkürler", message: "KVKK açık rızanız kaydedildi. Uygulamayı kullanmaya başlayabilirsiniz.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { _ in
            self.onConsentGiven?()
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    @objc private func declineButtonTapped() {
        let alert = UIAlertController(title: "Uyarı", message: "KVKK izni olmadan uygulamayı kullanamazsınız. Uygulamadan çıkış yapılacak.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Çıkış Yap", style: .destructive) { _ in
            self.onConsentDeclined?()
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    

}
