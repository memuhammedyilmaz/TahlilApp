//
//  ImageCaptureService.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import UIKit
import Photos
import AVFoundation
import PDFKit
import Vision

class ImageCaptureService {
    static let shared = ImageCaptureService()
    
    private init() {}
    
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }
    
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        default:
            completion(false)
        }
    }
    
    // MARK: - AI Text Recognition Functions
    
    /// Performs AI-based text recognition on the given image
    func performAITextRecognition(on image: UIImage, completion: @escaping (String?) -> Void) {
        print("🤖 Vision OCR ile metin tanıma başlatılıyor...")
        
        // Use Vision OCR for text extraction
        VisionOCRService.shared.extractTextFromImage(image) { extractedText in
            if let text = extractedText {
                print("✅ Vision OCR Başarılı!")
                completion(text)
            } else {
                print("❌ Vision OCR Başarısız: Görselden metin çıkarılamadı")
                completion(nil)
            }
        }
    }
    
    /// Performs AI-based text recognition with custom settings
    func performAITextRecognition(on image: UIImage, 
                                 model: String = "default",
                                 confidence: Float = 0.8,
                                 completion: @escaping (String?) -> Void) {
        print("🤖 Vision OCR ile metin tanıma (özel ayarlar) başlatılıyor...")
        
        // Use Vision OCR with custom settings
        let recognitionLevel: VNRequestTextRecognitionLevel = confidence > 0.7 ? .accurate : .fast
        let usesLanguageCorrection = confidence > 0.5
        
        VisionOCRService.shared.extractTextFromImage(image, 
                                                   recognitionLevel: recognitionLevel,
                                                   usesLanguageCorrection: usesLanguageCorrection) { extractedText in
            if let text = extractedText {
                print("✅ Vision OCR (özel ayarlar) Başarılı!")
                completion(text)
            } else {
                print("❌ Vision OCR (özel ayarlar) Başarısız")
                completion(nil)
            }
        }
    }
    
    // MARK: - AI PDF Analysis Functions
    
    /// Performs AI-based analysis on the given PDF document
    func performAIPDFAnalysis(on pdf: PDFDocument, completion: @escaping (String?) -> Void) {
        print("🤖 PDF AI analizi başlatılıyor...")
        
        // Use the dedicated PDFService for better PDF handling
        PDFService.shared.performAIAnalysis(on: pdf) { aiResult in
            if let result = aiResult {
                print("✅ PDF AI Analizi Başarılı!")
                completion(result)
            } else {
                print("❌ PDF AI Analizi Başarısız")
                completion(nil)
            }
        }
    }
    
    /// Performs AI-based analysis on PDF with custom settings
    func performAIPDFAnalysis(on pdf: PDFDocument, 
                             model: String = "default",
                             confidence: Float = 0.8,
                             completion: @escaping (String?) -> Void) {
        print("🤖 PDF AI analizi (özel ayarlar) başlatılıyor...")
        
        // For now, use the default implementation
        performAIPDFAnalysis(on: pdf, completion: completion)
    }
}
