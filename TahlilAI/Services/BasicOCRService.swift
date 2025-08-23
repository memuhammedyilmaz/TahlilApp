//
//  BasicOCRService.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import UIKit
import Vision

// MARK: - Basic OCR Service
class BasicOCRService {
    static let shared = BasicOCRService()
    
    private init() {}
    
    // MARK: - Simple OCR Function
    func performBasicOCR(on image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("OCR Hatası: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            // Basit metin çıkarma - sadece metinleri birleştir
            let extractedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: " ")
            
            DispatchQueue.main.async {
                completion(extractedText)
            }
        }
        
        // Basit ayarlar
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["tr-TR", "en-US"]
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("OCR Request Hatası: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    // MARK: - Fast OCR (Hızlı mod)
    func performFastOCR(on image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            let extractedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: " ")
            
            DispatchQueue.main.async {
                completion(extractedText)
            }
        }
        
        // Hızlı mod ayarları
        request.recognitionLevel = .fast
        request.recognitionLanguages = ["tr-TR"]
        request.usesLanguageCorrection = false
        
        do {
            try requestHandler.perform([request])
        } catch {
            completion(nil)
        }
    }
    
    // MARK: - Line by Line OCR (Satır satır)
    func performLineByLineOCR(on image: UIImage, completion: @escaping ([String]?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            // Satırları Y pozisyonuna göre sırala (yukarıdan aşağıya)
            let sortedObservations = observations.sorted { obs1, obs2 in
                let y1 = obs1.boundingBox.origin.y
                let y2 = obs2.boundingBox.origin.y
                return y1 > y2
            }
            
            let lines = sortedObservations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            DispatchQueue.main.async {
                completion(lines)
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["tr-TR", "en-US"]
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            completion(nil)
        }
    }
}
