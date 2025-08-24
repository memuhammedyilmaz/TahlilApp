//
//  AnalysisResult.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation
import UIKit
import PDFKit

// MARK: - Analysis Result Model
struct AnalysisResult: Codable {
    let id: String
    let title: String
    let analysisType: AnalysisType
    let analysisDate: Date
    let analysisText: String
    let thumbnailData: Data?
    let originalData: Data?
    let metadata: AnalysisMetadata
    
    init(title: String, analysisType: AnalysisType, analysisText: String, thumbnailData: Data? = nil, originalData: Data? = nil, metadata: AnalysisMetadata) {
        self.id = UUID().uuidString
        self.title = title
        self.analysisType = analysisType
        self.analysisDate = Date()
        self.analysisText = analysisText
        self.thumbnailData = thumbnailData
        self.originalData = originalData
        self.metadata = metadata
    }
}

// MARK: - Analysis Type Enum
enum AnalysisType: String, Codable, CaseIterable {
    case image = "image"
    case pdf = "pdf"
    
    var displayName: String {
        switch self {
        case .image:
            return "Görsel Analizi"
        case .pdf:
            return "PDF Analizi"
        }
    }
    
    var icon: String {
        switch self {
        case .image:
            return "📷"
        case .pdf:
            return "📄"
        }
    }
}

// MARK: - Analysis Metadata
struct AnalysisMetadata: Codable {
    let fileSize: Int?
    let dimensions: String?
    let pageCount: Int?
    let textLength: Int?
    let confidence: Double?
    let processingTime: TimeInterval?
    let aiModel: String?
    
    init(fileSize: Int? = nil, dimensions: String? = nil, pageCount: Int? = nil, textLength: Int? = nil, confidence: Double? = nil, processingTime: TimeInterval? = nil, aiModel: String? = nil) {
        self.fileSize = fileSize
        self.dimensions = dimensions
        self.pageCount = pageCount
        self.textLength = textLength
        self.confidence = confidence
        self.processingTime = processingTime
        self.aiModel = aiModel
    }
}

// MARK: - Analysis Result Extensions
extension AnalysisResult {
    
    /// Creates an AnalysisResult from an image analysis
    static func createImageAnalysis(title: String, image: UIImage, analysisText: String, metadata: AnalysisMetadata) -> AnalysisResult {
        let thumbnailData = createThumbnail(from: image)
        let originalData = image.jpegData(compressionQuality: 0.8)
        
        return AnalysisResult(
            title: title,
            analysisType: .image,
            analysisText: analysisText,
            thumbnailData: thumbnailData,
            originalData: originalData,
            metadata: metadata
        )
    }
    
    /// Creates an AnalysisResult from a PDF analysis
    static func createPDFAnalysis(title: String, pdf: PDFDocument, analysisText: String, metadata: AnalysisMetadata) -> AnalysisResult {
        let thumbnailData = createPDFThumbnail(from: pdf)
        let originalData = pdf.dataRepresentation()
        
        return AnalysisResult(
            title: title,
            analysisType: .pdf,
            analysisText: analysisText,
            thumbnailData: thumbnailData,
            originalData: originalData,
            metadata: metadata
        )
    }
    
    /// Creates a thumbnail from UIImage
    private static func createThumbnail(from image: UIImage) -> Data? {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        let thumbnail = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return thumbnail.jpegData(compressionQuality: 0.7)
    }
    
    /// Creates a thumbnail from PDFDocument
    private static func createPDFThumbnail(from pdf: PDFDocument) -> Data? {
        guard let firstPage = pdf.page(at: 0) else { return nil }
        
        let pageRect = firstPage.bounds(for: .mediaBox)
        let scale: CGFloat = 200 / max(pageRect.width, pageRect.height)
        let thumbnailSize = CGSize(width: pageRect.width * scale, height: pageRect.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: thumbnailSize)
        let thumbnail = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: thumbnailSize))
            
            context.cgContext.translateBy(x: 0, y: thumbnailSize.height)
            context.cgContext.scaleBy(x: scale, y: -scale)
            
            firstPage.draw(with: .mediaBox, to: context.cgContext)
        }
        
        return thumbnail.jpegData(compressionQuality: 0.7)
    }
    
    /// Gets the original image if available
    var originalImage: UIImage? {
        guard analysisType == .image, let data = originalData else { return nil }
        return UIImage(data: data)
    }
    
    /// Gets the original PDF if available
    var originalPDF: PDFDocument? {
        guard analysisType == .pdf, let data = originalData else { return nil }
        return PDFDocument(data: data)
    }
    
    /// Gets the thumbnail image
    var thumbnailImage: UIImage? {
        guard let data = thumbnailData else { return nil }
        return UIImage(data: data)
    }
    
    /// Formats the analysis date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: analysisDate)
    }
    
    /// Gets a summary of the analysis
    var summary: String {
        let textPreview = String(analysisText.prefix(100))
        return textPreview + (analysisText.count > 100 ? "..." : "")
    }
}
