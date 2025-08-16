//
//  ScanViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import UIKit
import Vision

class ScanViewModel: NSObject {
    
    var onAnalysisComplete: ((OCRResult) -> Void)?
    var onAnalysisError: ((String) -> Void)?
    var onOCRProgress: ((String) -> Void)?
    
    func processImage(_ image: UIImage) {
        print("🔍 OCR işlemi başlatılıyor...")
        onOCRProgress?("Görsel analiz ediliyor...")
        
        // Perform OCR with detailed line-by-line results
        ImageCaptureService.shared.performOCRWithDetails(on: image) { [weak self] ocrResult in
            guard let self = self else { return }
            
            if let result = ocrResult {
                // OCR successful - process the line-by-line results
                print("✅ OCR Başarılı!")
                print("📊 OCR Sonuçları:")
                print("==================================================")
                print("📝 Toplam Satır: \(result.totalLines)")
                print("🎯 Ortalama Güven: %\(result.averageConfidencePercentage)")
                print("🔍 Yüksek Güvenli Satırlar: \(result.highConfidenceLines.count)")
                print("⚠️ Düşük Güvenli Satırlar: \(result.lowConfidenceLines.count)")
                print("==================================================")
                print("📋 Satır Satır Sonuçlar:")
                
                for (index, line) in result.lines.enumerated() {
                    let confidenceIcon = line.isHighConfidence ? "✅" : "⚠️"
                    print("\(index + 1). [%\(line.confidencePercentage)] \(confidenceIcon) \(line.text)")
                }
                print("==================================================")
                
                DispatchQueue.main.async {
                    self.onAnalysisComplete?(result)
                }
            } else {
                // OCR failed
                print("❌ OCR Başarısız: Görselden metin çıkarılamadı")
                self.onAnalysisError?("Görselden metin çıkarılamadı. Lütfen daha net bir fotoğraf deneyin.")
            }
        }
    }
    
    func performOCR(on image: UIImage, completion: @escaping (String?) -> Void) {
        ImageCaptureService.shared.performOCR(on: image, completion: completion)
    }
    
    func performOCRWithDetails(on image: UIImage, completion: @escaping (OCRResult?) -> Void) {
        ImageCaptureService.shared.performOCRWithDetails(on: image, completion: completion)
    }
    
    func performOCRWithCustomSettings(on image: UIImage, 
                                    recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
                                    languages: [String] = ["tr-TR"],
                                    completion: @escaping (String?) -> Void) {
        ImageCaptureService.shared.performOCR(on: image, 
                                            recognitionLevel: recognitionLevel,
                                            languages: languages,
                                            completion: completion)
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestCameraPermission(completion: completion)
    }
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        ImageCaptureService.shared.requestPhotoLibraryPermission(completion: completion)
    }
}
