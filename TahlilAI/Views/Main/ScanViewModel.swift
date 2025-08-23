//
//  ScanViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import UIKit

class ScanViewModel: NSObject {
    
    var onAnalysisComplete: ((String) -> Void)?
    var onAnalysisError: ((String) -> Void)?
    var onAIProgress: ((String) -> Void)?
    
    func processImage(_ image: UIImage) {
        print("🤖 AI tabanlı metin tanıma başlatılıyor...")
        onAIProgress?("Görsel AI ile analiz ediliyor...")
        
        // Perform AI-based text recognition
        ImageCaptureService.shared.performAITextRecognition(on: image) { [weak self] extractedText in
            guard let self = self else { return }
            
            if let text = extractedText {
                print("✅ AI Metin Tanıma Başarılı!")
                
                DispatchQueue.main.async {
                    self.onAnalysisComplete?(text)
                }
            } else {
                // AI recognition failed
                print("❌ AI Metin Tanıma Başarısız: Görselden metin çıkarılamadı")
                DispatchQueue.main.async {
                    self.onAnalysisError?("AI metin tanıma başarısız")
                }
            }
        }
    }
    
    func performAITextRecognition(on image: UIImage, completion: @escaping (String?) -> Void) {
        ImageCaptureService.shared.performAITextRecognition(on: image, completion: completion)
    }
    
    func performAITextRecognitionWithCustomSettings(on image: UIImage, 
                                                   model: String = "default",
                                                   confidence: Float = 0.8,
                                                   completion: @escaping (String?) -> Void) {
        ImageCaptureService.shared.performAITextRecognition(on: image, 
                                                          model: model,
                                                          confidence: confidence,
                                                          completion: completion)
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestCameraPermission(completion: completion)
    }
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestPhotoLibraryPermission(completion: completion)
    }
}
