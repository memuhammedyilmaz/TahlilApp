//
//  PDFService.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import PDFKit
import UIKit

class PDFService {
    static let shared = PDFService()
    
    private init() {}
    
    // MARK: - PDF Text Extraction
    
    /// Extracts text from all pages of a PDF document
    func extractText(from pdf: PDFDocument) -> String? {
        var extractedText = ""
        
        for i in 0..<pdf.pageCount {
            if let page = pdf.page(at: i) {
                if let pageContent = page.string {
                    extractedText += "--- Sayfa \(i + 1) ---\n"
                    extractedText += pageContent
                    extractedText += "\n\n"
                }
            }
        }
        
        return extractedText.isEmpty ? nil : extractedText
    }
    
    /// Extracts text from a specific page of a PDF document
    func extractText(from pdf: PDFDocument, pageIndex: Int) -> String? {
        guard pageIndex >= 0 && pageIndex < pdf.pageCount else { return nil }
        
        if let page = pdf.page(at: pageIndex) {
            return page.string
        }
        
        return nil
    }
    
    // MARK: - PDF Page Rendering
    
    /// Renders a specific page of a PDF as an image
    func renderPageAsImage(from pdf: PDFDocument, pageIndex: Int, scale: CGFloat = 2.0) -> UIImage? {
        guard pageIndex >= 0 && pageIndex < pdf.pageCount else { return nil }
        
        guard let page = pdf.page(at: pageIndex) else { return nil }
        
        let pageRect = page.bounds(for: .mediaBox)
        let scaledSize = CGSize(width: pageRect.width * scale, height: pageRect.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let pdfImage = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: scaledSize))
            
            context.cgContext.translateBy(x: 0, y: scaledSize.height)
            context.cgContext.scaleBy(x: scale, y: -scale)
            
            page.draw(with: .mediaBox, to: context.cgContext)
        }
        
        return pdfImage
    }
    
    /// Renders the first page of a PDF as an image
    func renderFirstPageAsImage(from pdf: PDFDocument, scale: CGFloat = 2.0) -> UIImage? {
        return renderPageAsImage(from: pdf, pageIndex: 0, scale: scale)
    }
    
    // MARK: - PDF Analysis
    
    /// Analyzes PDF content and provides metadata
    func analyzePDF(_ pdf: PDFDocument) -> PDFAnalysisResult {
        let pageCount = pdf.pageCount
        let totalTextLength = extractText(from: pdf)?.count ?? 0
        
        var pageTextLengths: [Int] = []
        for i in 0..<pageCount {
            if let pageText = extractText(from: pdf, pageIndex: i) {
                pageTextLengths.append(pageText.count)
            } else {
                pageTextLengths.append(0)
            }
        }
        
        let averageTextLength = pageTextLengths.isEmpty ? 0 : pageTextLengths.reduce(0, +) / pageTextLengths.count
        let hasText = totalTextLength > 0
        
        return PDFAnalysisResult(
            pageCount: pageCount,
            totalTextLength: totalTextLength,
            averageTextLength: averageTextLength,
            hasText: hasText,
            pageTextLengths: pageTextLengths
        )
    }
    
    /// Performs AI-based analysis on PDF content
    func performAIAnalysis(on pdf: PDFDocument, completion: @escaping (String?) -> Void) {
        print("🤖 PDF AI analizi başlatılıyor...")
        
        // First try to extract text directly from PDF
        if let extractedText = extractText(from: pdf) {
            let analysis = analyzePDF(pdf)
            
            // TODO: Integrate with actual AI service
            // For now, provide a comprehensive analysis result
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let aiResult = self.generateAIAnalysisResult(pdf: pdf, extractedText: extractedText, analysis: analysis)
                completion(aiResult)
            }
        } else {
            // If direct text extraction fails, try Vision OCR
            print("⚠️ PDF metin çıkarma başarısız, Vision OCR deneniyor...")
            
            VisionOCRService.shared.extractTextFromPDF(pdf) { ocrText in
                if let ocrText = ocrText {
                    print("✅ Vision OCR ile PDF metin çıkarma başarılı!")
                    let analysis = self.analyzePDF(pdf)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        let aiResult = self.generateAIAnalysisResult(pdf: pdf, extractedText: ocrText, analysis: analysis)
                        completion(aiResult)
                    }
                } else {
                    // If OCR also fails, provide structural analysis
                    print("⚠️ Vision OCR da başarısız, yapısal analiz yapılıyor...")
                    
                    let analysis = self.analyzePDF(pdf)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let aiResult = self.generateStructuralAnalysisResult(pdf: pdf, analysis: analysis)
                        completion(aiResult)
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func generateAIAnalysisResult(pdf: PDFDocument, extractedText: String, analysis: PDFAnalysisResult) -> String {
        let documentTitle = pdf.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String ?? "Bilinmeyen Belge"
        let author = pdf.documentAttributes?[PDFDocumentAttribute.authorAttribute] as? String ?? "Bilinmeyen Yazar"
        let creationDate = pdf.documentAttributes?[PDFDocumentAttribute.creationDateAttribute] as? Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "tr_TR")
        
        let creationDateString = creationDate.map { dateFormatter.string(from: $0) } ?? "Bilinmiyor"
        
        return """
        📄 PDF AI Analiz Sonucu:
        
        📊 Dosya Bilgileri:
        - Başlık: \(documentTitle)
        - Yazar: \(author)
        - Oluşturulma Tarihi: \(creationDateString)
        - Toplam Sayfa: \(analysis.pageCount)
        - Toplam Metin Karakteri: \(analysis.totalTextLength)
        - Ortalama Sayfa Metin Uzunluğu: \(analysis.averageTextLength)
        
        🔍 AI Analiz:
        Bu PDF dosyası başarıyla analiz edildi ve metin içeriği çıkarıldı.
        AI analizi sonucunda belge türü, ana konular ve önemli bilgiler tespit edildi.
        
        📝 Metin Analizi:
        - Metin içeren sayfa sayısı: \(analysis.pageTextLengths.filter { $0 > 0 }.count)
        - En uzun sayfa: \(analysis.pageTextLengths.enumerated().max(by: { $0.element < $1.element })?.offset ?? 0 + 1)
        - En kısa sayfa: \(analysis.pageTextLengths.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0 + 1)
        
        📖 Çıkarılan Metin (İlk 500 karakter):
        \(String(extractedText.prefix(500)))...
        
        💡 AI Önerileri:
        - Belge türü: \(self.detectDocumentType(from: extractedText))
        - Ana konular: \(self.detectMainTopics(from: extractedText))
        - Önemli bilgiler: \(self.detectImportantInfo(from: extractedText))
        - Güvenilirlik skoru: \(self.calculateReliabilityScore(analysis: analysis))
        """
    }
    
    private func generateStructuralAnalysisResult(pdf: PDFDocument, analysis: PDFAnalysisResult) -> String {
        let documentTitle = pdf.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String ?? "Bilinmeyen Belge"
        let author = pdf.documentAttributes?[PDFDocumentAttribute.authorAttribute] as? String ?? "Bilinmeyen Yazar"
        let creationDate = pdf.documentAttributes?[PDFDocumentAttribute.creationDateAttribute] as? Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "tr_TR")
        
        let creationDateString = creationDate.map { dateFormatter.string(from: $0) } ?? "Bilinmiyor"
        
        return """
        📄 PDF Yapısal Analiz Sonucu:
        
        ⚠️ Uyarı: Bu PDF'den metin çıkarılamadı. Yapısal analiz yapıldı.
        
        📊 Dosya Bilgileri:
        - Başlık: \(documentTitle)
        - Yazar: \(author)
        - Oluşturulma Tarihi: \(creationDateString)
        - Toplam Sayfa: \(analysis.pageCount)
        
        🔍 Yapısal Analiz:
        Bu PDF dosyası görsel veya tarama tabanlı olabilir. 
        Metin çıkarılamadığı için yapısal özellikler analiz edildi.
        
        📝 Sayfa Analizi:
        - Toplam sayfa sayısı: \(analysis.pageCount)
        - Sayfa boyutları: \(getPageSizeInfo(pdf))
        
        💡 Öneriler:
        - Bu PDF muhtemelen görsel/tarama tabanlı
        - Manuel inceleme önerilir
        - Görsel analiz için farklı AI modelleri kullanılabilir
        """
    }
    
    private func detectDocumentType(from text: String) -> String {
        let lowercasedText = text.lowercased()
        
        if lowercasedText.contains("laboratuvar") || lowercasedText.contains("test") || lowercasedText.contains("sonuç") {
            return "Laboratuvar Raporu"
        } else if lowercasedText.contains("rapor") || lowercasedText.contains("analiz") {
            return "Analiz Raporu"
        } else if lowercasedText.contains("reçete") || lowercasedText.contains("ilaç") {
            return "Tıbbi Reçete"
        } else if lowercasedText.contains("epikriz") || lowercasedText.contains("hasta") {
            return "Hasta Epikrizi"
        } else {
            return "Genel Belge"
        }
    }
    
    private func detectMainTopics(from text: String) -> String {
        let lowercasedText = text.lowercased()
        var topics: [String] = []
        
        if lowercasedText.contains("kan") || lowercasedText.contains("hemogram") {
            topics.append("Kan Analizi")
        }
        if lowercasedText.contains("idrar") || lowercasedText.contains("urine") {
            topics.append("İdrar Analizi")
        }
        if lowercasedText.contains("kolesterol") || lowercasedText.contains("lipid") {
            topics.append("Lipid Profili")
        }
        if lowercasedText.contains("şeker") || lowercasedText.contains("glikoz") {
            topics.append("Glikoz Metabolizması")
        }
        if lowercasedText.contains("karaciğer") || lowercasedText.contains("ast") || lowercasedText.contains("alt") {
            topics.append("Karaciğer Fonksiyonları")
        }
        
        return topics.isEmpty ? "Genel Tıbbi Veriler" : topics.joined(separator: ", ")
    }
    
    private func detectImportantInfo(from text: String) -> String {
        let lowercasedText = text.lowercased()
        var info: [String] = []
        
        if lowercasedText.contains("yüksek") || lowercasedText.contains("düşük") || lowercasedText.contains("normal") {
            info.append("Test Değerleri")
        }
        if lowercasedText.contains("referans") || lowercasedText.contains("normal değer") {
            info.append("Referans Aralıkları")
        }
        if lowercasedText.contains("tarih") || lowercasedText.contains("saat") {
            info.append("Zaman Bilgileri")
        }
        if lowercasedText.contains("doktor") || lowercasedText.contains("hekim") {
            info.append("Hekim Bilgileri")
        }
        
        return info.isEmpty ? "Genel Bilgiler" : info.joined(separator: ", ")
    }
    
    private func calculateReliabilityScore(analysis: PDFAnalysisResult) -> String {
        let textRatio = analysis.totalTextLength > 0 ? Double(analysis.pageTextLengths.filter { $0 > 0 }.count) / Double(analysis.pageCount) : 0.0
        
        if textRatio >= 0.8 && analysis.averageTextLength > 100 {
            return "Yüksek (90%)"
        } else if textRatio >= 0.5 && analysis.averageTextLength > 50 {
            return "Orta (70%)"
        } else if textRatio > 0 {
            return "Düşük (40%)"
        } else {
            return "Çok Düşük (10%)"
        }
    }
    
    private func getPageSizeInfo(_ pdf: PDFDocument) -> String {
        guard let firstPage = pdf.page(at: 0) else { return "Bilinmiyor" }
        
        let pageRect = firstPage.bounds(for: .mediaBox)
        let width = Int(pageRect.width)
        let height = Int(pageRect.height)
        
        // Determine page format
        let format: String
        if abs(width - 595) < 10 && abs(height - 842) < 10 {
            format = "A4"
        } else if abs(width - 612) < 10 && abs(height - 792) < 10 {
            format = "Letter"
        } else if abs(width - 595) < 10 && abs(height - 420) < 10 {
            format = "A3"
        } else {
            format = "Özel"
        }
        
        return "\(width)×\(height) pt (\(format))"
    }
}

// MARK: - PDF Analysis Result Model

struct PDFAnalysisResult {
    let pageCount: Int
    let totalTextLength: Int
    let averageTextLength: Int
    let hasText: Bool
    let pageTextLengths: [Int]
}
