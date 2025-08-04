//
//  Extensions.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit

// MARK: - UIView Extensions
extension UIView {
    func addShadow(color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 10, offset: CGSize = CGSize(width: 0, height: 4)) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
    
    func roundCorners(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func addGradientBackground(startColor: UIColor, endColor: UIColor, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGlassEffect(blurStyle: UIBlurEffect.Style = .systemMaterial) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurView, at: 0)
    }
    
    func addPulseAnimation() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: "pulse")
    }
    
    func addShimmerEffect() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: -1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 2, y: 0.5)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
        
        layer.addSublayer(gradientLayer)
    }
}

// MARK: - UIColor Extensions
extension UIColor {
    // Modern Gradient Colors
    static let primaryGradientStart = UIColor(red: 0.4, green: 0.2, blue: 0.9, alpha: 1.0) // Purple
    static let primaryGradientEnd = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0) // Blue
    
    // Secondary Gradient Colors
    static let secondaryGradientStart = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0) // Coral
    static let secondaryGradientEnd = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0) // Orange
    
    // Success Gradient Colors
    static let successGradientStart = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) // Green
    static let successGradientEnd = UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0) // Dark Green
    
    // Background Colors
    static let backgroundPrimary = UIColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0) // Light Blue Gray
    static let backgroundSecondary = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0) // Very Light Blue
    static let cardBackground = UIColor.white
    
    // Text Colors
    static let textPrimary = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0) // Dark Blue Gray
    static let textSecondary = UIColor(red: 0.4, green: 0.4, blue: 0.6, alpha: 1.0) // Medium Gray
    static let textLight = UIColor(red: 0.6, green: 0.6, blue: 0.8, alpha: 1.0) // Light Gray
    
    // Status Colors
    static let statusSuccess = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) // Green
    static let statusWarning = UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 1.0) // Orange
    static let statusError = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0) // Red
    static let statusInfo = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0) // Blue
    
    // Accent Colors
    static let accentPurple = UIColor(red: 0.6, green: 0.2, blue: 0.9, alpha: 1.0)
    static let accentPink = UIColor(red: 1.0, green: 0.2, blue: 0.6, alpha: 1.0)
    static let accentTeal = UIColor(red: 0.2, green: 0.8, blue: 0.8, alpha: 1.0)
    static let accentYellow = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
    
    // Legacy colors for backward compatibility
    static let primaryBlue = primaryGradientEnd
    static let secondaryBlue = primaryGradientStart
    static let accentGreen = statusSuccess
    static let accentOrange = statusWarning
    static let accentRed = statusError
    static let backgroundGray = backgroundPrimary
}

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
}

// MARK: - Date Extensions
extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
}

// MARK: - Double Extensions
extension Double {
    func formattedString() -> String {
        return String(format: "%.1f", self)
    }
}

// MARK: - Array Extensions
extension Array where Element == LabTest {
    var abnormalTests: [LabTest] {
        return self.filter { $0.isAbnormal }
    }
    
    var normalTests: [LabTest] {
        return self.filter { !$0.isAbnormal }
    }
    
    func groupedByCategory() -> [TestCategory: [LabTest]] {
        return Dictionary(grouping: self) { $0.category }
    }
} 