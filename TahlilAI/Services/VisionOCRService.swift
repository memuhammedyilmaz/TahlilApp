//
//  VisionOCRService.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import UIKit
import Vision
import PDFKit

class VisionOCRService {
    static let shared = VisionOCRService()
    
    private init() {}
    
    // MARK: - Image OCR
    
    /// Extracts text from UIImage using Vision framework
    func extractTextFromImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("❌ Vision OCR Hatası: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            let extractedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            if extractedText.isEmpty {
                completion(nil)
            } else {
                print("✅ Vision OCR Başarılı - \(extractedText.count) karakter")
                print("OCR Metni: \(extractedText)")
                completion(extractedText)
            }
        }
        
        // OCR ayarları
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["tr-TR", "en-US"]
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("❌ Vision OCR İşlem Hatası: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    /// Extracts text from UIImage with custom settings
    func extractTextFromImage(_ image: UIImage, 
                             recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
                             usesLanguageCorrection: Bool = true,
                             languages: [String] = ["tr-TR", "en-US"],
                             completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("❌ Vision OCR Hatası: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            let extractedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            if extractedText.isEmpty {
                completion(nil)
            } else {
                print("✅ Vision OCR Başarılı - \(extractedText.count) karakter")
                print("OCR Metni: \(extractedText)")
                completion(extractedText)
            }
        }
        
        // Özel OCR ayarları
        request.recognitionLevel = recognitionLevel
        request.usesLanguageCorrection = usesLanguageCorrection
        request.recognitionLanguages = languages
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("❌ Vision OCR İşlem Hatası: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - PDF OCR
    
        /// Extracts text from PDF using Vision framework
    func extractTextFromPDF(_ pdf: PDFDocument, completion: @escaping (String?) -> Void) {
        var allText = ""
        let group = DispatchGroup()

        for pageIndex in 0..<pdf.pageCount {
            guard let page = pdf.page(at: pageIndex) else { continue }

            group.enter()

            // PDF sayfasını UIImage'e çevir
            if let pageImage = renderPDFPage(page) {
                extractTextFromImage(pageImage) { text in
                    if let text = text {
                        allText += "--- Sayfa \(pageIndex + 1) ---\n"
                        allText += text
                        allText += "\n\n"
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            if allText.isEmpty {
                completion(nil)
            } else {
                print("✅ PDF Vision OCR Başarılı - \(allText.count) karakter")
                print("PDF OCR Metni: \(allText)")
                completion(allText)
            }
        }
    }
    
    /// Extracts text from PDF with custom settings
    func extractTextFromPDF(_ pdf: PDFDocument, 
                           recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
                           usesLanguageCorrection: Bool = true,
                           languages: [String] = ["tr-TR", "en-US"],
                           completion: @escaping (String?) -> Void) {
        var allText = ""
        let group = DispatchGroup()
        
        for pageIndex in 0..<pdf.pageCount {
            guard let page = pdf.page(at: pageIndex) else { continue }
            
            group.enter()
            
            // PDF sayfasını UIImage'e çevir
            if let pageImage = renderPDFPage(page) {
                extractTextFromImage(pageImage, 
                                   recognitionLevel: recognitionLevel,
                                   usesLanguageCorrection: usesLanguageCorrection,
                                   languages: languages) { text in
                    if let text = text {
                        allText += "--- Sayfa \(pageIndex + 1) ---\n"
                        allText += text
                        allText += "\n\n"
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if allText.isEmpty {
                completion(nil)
            } else {
                print("✅ PDF Vision OCR Başarılı - \(allText.count) karakter")
                print("PDF OCR Metni: \(allText)")
                completion(allText)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Renders PDF page as UIImage
    private func renderPDFPage(_ page: PDFPage) -> UIImage? {
        let pageRect = page.bounds(for: .mediaBox)
        let scale: CGFloat = 2.0 // Yüksek kalite için
        let size = CGSize(width: pageRect.width * scale, height: pageRect.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            context.cgContext.translateBy(x: 0, y: size.height)
            context.cgContext.scaleBy(x: scale, y: -scale)
            
            page.draw(with: .mediaBox, to: context.cgContext)
        }
        
        return image
    }
    
    // MARK: - Batch Processing
    
    /// Processes multiple images in batch
    func extractTextFromImages(_ images: [UIImage], completion: @escaping ([String?]) -> Void) {
        let group = DispatchGroup()
        var results: [String?] = Array(repeating: nil, count: images.count)
        
        for (index, image) in images.enumerated() {
            group.enter()
            
            extractTextFromImage(image) { text in
                results[index] = text
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
    }
    
    /// Processes multiple PDFs in batch
    func extractTextFromPDFs(_ pdfs: [PDFDocument], completion: @escaping ([String?]) -> Void) {
        let group = DispatchGroup()
        var results: [String?] = Array(repeating: nil, count: pdfs.count)
        
        for (index, pdf) in pdfs.enumerated() {
            group.enter()
            
            extractTextFromPDF(pdf) { text in
                results[index] = text
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
    }
}

