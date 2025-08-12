//
//  ScanViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import UIKit

class ScanViewModel: BaseViewModel {
    
    var onAnalysisComplete: ((String) -> Void)?
    var onAnalysisError: ((String) -> Void)?
    
    func processImage(_ image: UIImage) {
        // TODO: Implement AI/ML image analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.onAnalysisError?("AI analiz özelliği henüz geliştirilmedi.")
        }
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestCameraPermission(completion: completion)
    }
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestPhotoLibraryPermission(completion: completion)
    }
}
