//
//  MainTabBarController.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .cardBackground
        tabBar.tintColor = .primaryGradientStart
        tabBar.unselectedItemTintColor = .textLight
        
        // Add modern shadow to tab bar
        tabBar.addShadow(color: .primaryGradientStart, opacity: 0.15, radius: 12, offset: CGSize(width: 0, height: -3))
    }
    
        private func setupViewControllers() {
        let scanVC = UINavigationController(rootViewController: ScanViewController())
        let analyticsVC = UINavigationController(rootViewController: AnalyticsViewController())
        let premiumVC = UINavigationController(rootViewController: PremiumViewController())
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())

        scanVC.tabBarItem = UITabBarItem(
            title: "Tara",
            image: UIImage(systemName: "camera.fill"),
            selectedImage: UIImage(systemName: "camera.fill")
        )

        analyticsVC.tabBarItem = UITabBarItem(
            title: "Analiz",
            image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis")
        )

        premiumVC.tabBarItem = UITabBarItem(
            title: "Premium",
            image: UIImage(systemName: "crown.fill"),
            selectedImage: UIImage(systemName: "crown.fill")
        )

        settingsVC.tabBarItem = UITabBarItem(
            title: "Ayarlar",
            image: UIImage(systemName: "gearshape.fill"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )

        viewControllers = [scanVC, analyticsVC, premiumVC, settingsVC]
    }
} 