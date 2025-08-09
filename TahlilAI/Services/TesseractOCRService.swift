//
//  TesseractOCRService.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import UIKit
import Vision

class TesseractOCRService {
    static let shared = TesseractOCRService()
    
    private init() {}
    
    func extractText(from image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        print("🔍 Tesseract OCR Analizi Başlatılıyor...")
        
        guard let cgImage = image.cgImage else {
            completion(.failure(OCRError.imageConversionFailed))
            return
        }
        
        // Vision framework kullanarak OCR
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("❌ OCR Hatası: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("❌ OCR sonuçları alınamadı")
                completion(.failure(OCRError.noResults))
                return
            }
            
            var extractedText = ""
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                extractedText += topCandidate.string + "\n"
            }
            
            print("✅ OCR Analiz Tamamlandı:")
            print("📄 Çıkarılan Metin:")
            print(extractedText)
            print(String(repeating: "=", count: 50))
            
            if extractedText.isEmpty {
                completion(.failure(OCRError.noTextFound))
            } else {
                completion(.success(extractedText))
            }
        }
        
        // Türkçe dil desteği
        request.recognitionLanguages = ["tr-TR", "en-US"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("❌ OCR İşlemi Hatası: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

enum OCRError: Error, LocalizedError {
    case imageConversionFailed
    case noResults
    case noTextFound
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed:
            return "Görüntü dönüştürme hatası"
        case .noResults:
            return "OCR sonuçları alınamadı"
        case .noTextFound:
            return "Görüntüde metin bulunamadı"
        }
    }
}
