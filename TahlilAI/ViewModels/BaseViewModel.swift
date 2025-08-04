//
//  BaseViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation

// MARK: - Base ViewModel Protocol
protocol BaseViewModelProtocol {
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
    var onDataUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onLoadingChanged: ((Bool) -> Void)? { get set }
}

// MARK: - Base ViewModel Implementation
class BaseViewModel: BaseViewModelProtocol {
    var isLoading: Bool = false {
        didSet {
            onLoadingChanged?(isLoading)
        }
    }
    
    var errorMessage: String? {
        didSet {
            if let error = errorMessage {
                onError?(error)
            }
        }
    }
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
} 