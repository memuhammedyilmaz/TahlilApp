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
        print("🔍 Görüntü analizi başlatılıyor...")
        
        TesseractOCRService.shared.extractText(from: image) { [weak self] result in
            switch result {
            case .success(let extractedText):
                print("✅ Tesseract OCR Analiz Sonucu:")
                print("📄 Çıkarılan Metin:")
                print(extractedText)
                print(String(repeating: "=", count: 50))
                
                DispatchQueue.main.async {
                    self?.onAnalysisComplete?(extractedText)
                }
                
            case .failure(let error):
                print("❌ Tesseract OCR Hatası: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    self?.onAnalysisError?(error.localizedDescription)
                }
            }
        }
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestCameraPermission(completion: completion)
    }
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestPhotoLibraryPermission(completion: completion)
    }
}
