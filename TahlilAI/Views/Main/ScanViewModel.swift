//
//  ScanViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import UIKit
import Vision

class ScanViewModel: BaseViewModel {
    
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
                
                // Process the extracted data for lab test analysis
                let processedData = self.processLabTestData(from: result)
                
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
    
    /// Processes OCR results to extract lab test data
    /// - Parameter ocrResult: The OCR result containing line-by-line data
    /// - Returns: Processed lab test data
    private func processLabTestData(from ocrResult: OCRResult) -> [String: Any] {
        var labData: [String: Any] = [:]
        
        // Extract test names and values
        for line in ocrResult.lines {
            let text = line.text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Look for common lab test patterns
            if let testData = extractTestData(from: text) {
                labData[testData.name] = testData.value
            }
        }
        
        return labData
    }
    
    /// Extracts test name and value from a line of text
    /// - Parameter text: The text line to analyze
    /// - Returns: TestData if found, nil otherwise
    private func extractTestData(from text: String) -> TestData? {
        // Common lab test patterns
        let patterns = [
            // Pattern: "Test Name: Value Unit"
            #"^([^:]+):\s*([0-9.]+)\s*([a-zA-Z%]+)$"#,
            // Pattern: "Test Name Value Unit"
            #"^([a-zA-Z\s]+)\s+([0-9.]+)\s*([a-zA-Z%]+)$"#,
            // Pattern: "Test Name = Value"
            #"^([^=]+)=\s*([0-9.]+)"#
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let range = NSRange(text.startIndex..<text.endIndex, in: text)
                if let match = regex.firstMatch(in: text, options: [], range: range) {
                    let nameRange = Range(match.range(at: 1), in: text)!
                    let valueRange = Range(match.range(at: 2), in: text)!
                    
                    let name = String(text[nameRange]).trimmingCharacters(in: .whitespaces)
                    let value = String(text[valueRange]).trimmingCharacters(in: .whitespaces)
                    
                    var unit = ""
                    if match.numberOfRanges > 3 {
                        let unitRange = Range(match.range(at: 3), in: text)!
                        unit = String(text[unitRange]).trimmingCharacters(in: .whitespaces)
                    }
                    
                    return TestData(name: name, value: value, unit: unit)
                }
            }
        }
        
        return nil
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

// MARK: - Data Structures

/// Represents extracted test data from OCR
struct TestData {
    let name: String
    let value: String
    let unit: String
    
    var fullValue: String {
        return unit.isEmpty ? value : "\(value) \(unit)"
    }
}
