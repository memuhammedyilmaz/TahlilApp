//
//  ScanViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import UIKit
import PDFKit

class ScanViewModel: NSObject {
    
    var onAnalysisComplete: ((String) -> Void)?
    var onAnalysisError: ((String) -> Void)?
    var onAIProgress: ((String) -> Void)?
    
    func processImage(_ image: UIImage) {
        print("🤖 Vision OCR ile görsel analizi başlatılıyor...")
        onAIProgress?("📷 Görsel OCR ile analiz ediliyor...")
        
        // Perform Vision OCR text recognition
        ImageCaptureService.shared.performAITextRecognition(on: image) { [weak self] extractedText in
            guard let self = self else { return }
            
            if let text = extractedText {
                print("✅ Vision OCR Başarılı!")
                onAIProgress?("🤖 OCR sonucu AI ile analiz ediliyor...")
                
                // TODO: Here you would send the extracted text to your AI service
                // For now, we'll use the OCR result directly
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let aiResult = """
                    📷 Görsel OCR Analiz Sonucu:
                    
                    🔍 Çıkarılan Metin:
                    \(text)
                    
                    💡 AI Analizi:
                    Bu görsel başarıyla OCR ile analiz edildi. 
                    Çıkarılan metin içeriği yukarıda görüntülenmektedir.
                    
                    📊 Metin İstatistikleri:
                    - Toplam Karakter: \(text.count)
                    - Satır Sayısı: \(text.components(separatedBy: .newlines).count)
                    - Kelime Sayısı: \(text.components(separatedBy: .whitespaces).count)
                    
                    🎯 Öneriler:
                    - Metin kalitesi: \(text.count > 100 ? "Yüksek" : "Orta")
                    - Görsel netliği: \(text.count > 200 ? "Mükemmel" : "İyi")
                    - Sonuç güvenilirliği: \(text.count > 50 ? "Yüksek" : "Orta")
                    """
                    
                    self.onAnalysisComplete?(aiResult)
                }
            } else {
                // OCR recognition failed
                print("❌ Vision OCR Başarısız: Görselden metin çıkarılamadı")
                DispatchQueue.main.async {
                    self.onAnalysisError?("Vision OCR başarısız: Görselden metin çıkarılamadı")
                }
            }
        }
    }
    
    func processPDF(_ pdf: PDFDocument) {
        print("🤖 Vision OCR ile PDF analizi başlatılıyor...")
        onAIProgress?("📄 PDF OCR ile analiz ediliyor...")
        
        // Process PDF with Vision OCR
        ImageCaptureService.shared.performAIPDFAnalysis(on: pdf) { [weak self] extractedText in
            guard let self = self else { return }
            
            if let text = extractedText {
                print("✅ PDF Vision OCR Analizi Başarılı!")
                
                DispatchQueue.main.async {
                    self.onAnalysisComplete?(text)
                }
            } else {
                // OCR recognition failed
                print("❌ PDF Vision OCR Analizi Başarısız: PDF'den metin çıkarılamadı")
                DispatchQueue.main.async {
                    self.onAnalysisError?("PDF Vision OCR analizi başarısız")
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
