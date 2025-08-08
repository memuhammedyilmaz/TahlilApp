//
//  ScanViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import UIKit

class ScanViewModel: BaseViewModel {
    
    func processImage(_ image: UIImage) {
        // TODO: Implement image processing
        print("Image processing started")
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestCameraPermission(completion: completion)
    }
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestPhotoLibraryPermission(completion: completion)
    }
}
