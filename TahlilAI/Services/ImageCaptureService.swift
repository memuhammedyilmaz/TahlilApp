//
//  ImageCaptureService.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import UIKit
import Photos
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
    
    // MARK: - Image Cropping Functions
    
    /// Crops an image to the specified rectangle
    /// - Parameters:
    ///   - image: The image to crop
    ///   - rect: The rectangle to crop to (in image coordinates)
    /// - Returns: Cropped image or nil if failed
    func cropImage(_ image: UIImage, to rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let scale = image.scale
        let scaledRect = CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.width * scale,
            height: rect.height * scale
        )
        
        guard let croppedCGImage = cgImage.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: image.imageOrientation)
    }
    
    /// Crops an image to a square aspect ratio, centered
    /// - Parameters:
    ///   - image: The image to crop
    ///   - size: The size of the square (defaults to the smaller dimension)
    /// - Returns: Cropped square image or nil if failed
    func cropImageToSquare(_ image: UIImage, size: CGFloat? = nil) -> UIImage? {
        let imageSize = image.size
        let minDimension = min(imageSize.width, imageSize.height)
        let targetSize = size ?? minDimension
        
        let x = (imageSize.width - targetSize) / 2
        let y = (imageSize.height - targetSize) / 2
        let rect = CGRect(x: x, y: y, width: targetSize, height: targetSize)
        
        return cropImage(image, to: rect)
    }
    
    /// Crops an image to a specific aspect ratio
    /// - Parameters:
    ///   - image: The image to crop
    ///   - aspectRatio: The desired aspect ratio (width/height)
    /// - Returns: Cropped image with the specified aspect ratio or nil if failed
    func cropImageToAspectRatio(_ image: UIImage, aspectRatio: CGFloat) -> UIImage? {
        let imageSize = image.size
        
        var targetWidth: CGFloat
        var targetHeight: CGFloat
        
        if imageSize.width / imageSize.height > aspectRatio {
            // Image is wider than desired ratio, crop width
            targetHeight = imageSize.height
            targetWidth = targetHeight * aspectRatio
        } else {
            // Image is taller than desired ratio, crop height
            targetWidth = imageSize.width
            targetHeight = targetWidth / aspectRatio
        }
        
        let x = (imageSize.width - targetWidth) / 2
        let y = (imageSize.height - targetHeight) / 2
        let rect = CGRect(x: x, y: y, width: targetWidth, height: targetHeight)
        
        return cropImage(image, to: rect)
    }
    

    
    // MARK: - OCR Functions
    
    /// Performs OCR on the given image using Vision framework
    /// - Parameters:
    ///   - image: The image to perform OCR on
    ///   - completion: Completion handler with extracted text or nil if failed
    func performOCR(on image: UIImage, completion: @escaping (String?) -> Void) {
        performOCRWithDetails(on: image) { result in
            completion(result?.fullText)
        }
    }
    
    /// Performs OCR with custom recognition level and languages
    /// - Parameters:
    ///   - image: The image to perform OCR on
    ///   - recognitionLevel: OCR recognition level (fast or accurate)
    ///   - languages: Array of language codes for recognition
    ///   - completion: Completion handler with OCRResult containing line-by-line data
    func performOCR(on image: UIImage, 
                   recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
                   languages: [String] = ["tr-TR"],
                   completion: @escaping (String?) -> Void) {
        performOCRWithDetails(on: image, recognitionLevel: recognitionLevel, languages: languages) { result in
            completion(result?.fullText)
        }
    }
    
    /// Performs OCR and returns detailed line-by-line results
    /// - Parameters:
    ///   - image: The image to perform OCR on
    ///   - recognitionLevel: OCR recognition level (fast or accurate)
    ///   - languages: Array of language codes for recognition
    ///   - completion: Completion handler with OCRResult containing line-by-line data
    func performOCRWithDetails(on image: UIImage, 
                             recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
                             languages: [String] = ["tr-TR", "en-US"],
                             completion: @escaping (OCRResult?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("OCR Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            // Process observations to get line-by-line results
            let ocrResult = self.processOCRObservations(observations, imageSize: image.size)
            
            DispatchQueue.main.async {
                completion(ocrResult)
            }
        }
        
        request.recognitionLevel = recognitionLevel
        request.recognitionLanguages = languages
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("OCR Request Error: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    /// Performs OCR with confidence filtering
    /// - Parameters:
    ///   - image: The image to perform OCR on
    ///   - minConfidence: Minimum confidence threshold (0.0 to 1.0)
    ///   - completion: Completion handler with filtered OCRResult
    func performOCRWithConfidenceFilter(on image: UIImage, 
                                      minConfidence: Float = 0.5,
                                      completion: @escaping (OCRResult?) -> Void) {
        performOCRWithDetails(on: image) { ocrResult in
            guard let result = ocrResult else {
                completion(nil)
                return
            }
            
            // Filter lines by confidence
            let filteredLines = result.lines.filter { $0.confidence >= minConfidence }
            
            let filteredResult = OCRResult(
                lines: filteredLines,
                fullText: filteredLines.map { $0.text }.joined(separator: "\n"),
                totalLines: filteredLines.count,
                averageConfidence: Double(filteredLines.map { $0.confidence }.reduce(0, +)) / Double(max(filteredLines.count, 1))
            )
            
            completion(filteredResult)
        }
    }
    
    /// Detects the primary language of the text in the image
    /// - Parameters:
    ///   - image: The image to analyze
    ///   - completion: Completion handler with detected language code
    func detectLanguage(in image: UIImage, completion: @escaping (String?) -> Void) {
        performOCRWithDetails(on: image) { ocrResult in
            guard let result = ocrResult, !result.lines.isEmpty else {
                completion(nil)
                return
            }
            
            // Simple language detection based on character sets
            let text = result.fullText.lowercased()
            
            // Check for Turkish characters
            let turkishChars = CharacterSet(charactersIn: "çğıöşü")
            if text.rangeOfCharacter(from: turkishChars) != nil {
                completion("tr-TR")
                return
            }
            
            // Check for English (basic)
            let englishPattern = "^[a-zA-Z0-9\\s.,!?;:'\"()-]+$"
            if text.range(of: englishPattern, options: .regularExpression) != nil {
                completion("en-US")
                return
            }
            
            // Default to Turkish for Turkish locale
            completion("tr-TR")
        }
    }
    
    /// Processes OCR observations to extract line-by-line data
    /// - Parameters:
    ///   - observations: Array of VNRecognizedTextObservation
    ///   - imageSize: Size of the original image
    /// - Returns: OCRResult with structured line-by-line data
    private func processOCRObservations(_ observations: [VNRecognizedTextObservation], imageSize: CGSize) -> OCRResult {
        var lines: [OCRLine] = []
        
        // Sort observations by Y position (top to bottom)
        let sortedObservations = observations.sorted { obs1, obs2 in
            let y1 = obs1.boundingBox.origin.y
            let y2 = obs2.boundingBox.origin.y
            return y1 > y2 // Top to bottom
        }
        
        for observation in sortedObservations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            
            let text = topCandidate.string
            let confidence = topCandidate.confidence
            
            // Convert normalized coordinates to image coordinates
            let boundingBox = observation.boundingBox
            let imageRect = CGRect(
                x: boundingBox.origin.x * imageSize.width,
                y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
                width: boundingBox.width * imageSize.width,
                height: boundingBox.height * imageSize.height
            )
            
            let line = OCRLine(
                text: text,
                confidence: confidence,
                boundingBox: imageRect,
                normalizedBoundingBox: boundingBox
            )
            
            lines.append(line)
        }
        
        // Group lines that are close to each other (same row)
        let groupedLines = groupLinesByRow(lines, tolerance: 10.0)
        
        return OCRResult(
            lines: groupedLines,
            fullText: groupedLines.map { $0.text }.joined(separator: "\n"),
            totalLines: groupedLines.count,
            averageConfidence: Double(groupedLines.map { $0.confidence }.reduce(0, +)) / Double(groupedLines.count)
        )
    }
    
    /// Groups lines that are approximately on the same row
    /// - Parameters:
    ///   - lines: Array of OCR lines
    ///   - tolerance: Y-coordinate tolerance for grouping (in points)
    /// - Returns: Array of grouped lines
    private func groupLinesByRow(_ lines: [OCRLine], tolerance: CGFloat) -> [OCRLine] {
        guard !lines.isEmpty else { return [] }
        
        var groupedLines: [OCRLine] = []
        var currentGroup: [OCRLine] = []
        var lastY: CGFloat = lines.first!.boundingBox.midY
        
        for line in lines {
            let currentY = line.boundingBox.midY
            
            if abs(currentY - lastY) <= tolerance {
                // Same row, add to current group
                currentGroup.append(line)
            } else {
                // New row, process current group and start new one
                if !currentGroup.isEmpty {
                    // Merge lines in the same group
                    let mergedLine = mergeLinesInGroup(currentGroup)
                    groupedLines.append(mergedLine)
                }
                currentGroup = [line]
                lastY = currentY
            }
        }
        
        // Don't forget the last group
        if !currentGroup.isEmpty {
            let mergedLine = mergeLinesInGroup(currentGroup)
            groupedLines.append(mergedLine)
        }
        
        return groupedLines
    }
    
    /// Merges multiple lines that are on the same row
    /// - Parameter group: Array of lines to merge
    /// - Returns: Single merged line
    private func mergeLinesInGroup(_ group: [OCRLine]) -> OCRLine {
        guard group.count > 1 else { return group.first! }
        
        // Sort by X position (left to right)
        let sortedGroup = group.sorted { $0.boundingBox.origin.x < $1.boundingBox.origin.x }
        
        let mergedText = sortedGroup.map { $0.text }.joined(separator: " ")
        let averageConfidence = Double(sortedGroup.map { $0.confidence }.reduce(0, +)) / Double(sortedGroup.count)
        
        // Calculate merged bounding box
        let minX = sortedGroup.map { $0.boundingBox.minX }.min() ?? 0
        let maxX = sortedGroup.map { $0.boundingBox.maxX }.max() ?? 0
        let minY = sortedGroup.map { $0.boundingBox.minY }.min() ?? 0
        let maxY = sortedGroup.map { $0.boundingBox.maxY }.max() ?? 0
        
        let mergedBoundingBox = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        
        return OCRLine(
            text: mergedText,
            confidence: Float(averageConfidence),
            boundingBox: mergedBoundingBox,
            normalizedBoundingBox: CGRect.zero // Not needed for merged lines
        )
    }
}

// MARK: - OCR Data Structures

/// Represents a single line of text extracted by OCR
struct OCRLine {
    let text: String
    let confidence: Float
    let boundingBox: CGRect
    let normalizedBoundingBox: CGRect
    
    var isHighConfidence: Bool {
        return confidence >= 0.8
    }
    
    var confidencePercentage: Int {
        return Int(confidence * 100)
    }
}

/// Represents the complete OCR result with line-by-line data
struct OCRResult {
    let lines: [OCRLine]
    let fullText: String
    let totalLines: Int
    let averageConfidence: Double
    
    var highConfidenceLines: [OCRLine] {
        return lines.filter { $0.isHighConfidence }
    }
    
    var lowConfidenceLines: [OCRLine] {
        return lines.filter { !$0.isHighConfidence }
    }
    
    var averageConfidencePercentage: Int {
        return Int(averageConfidence * 100)
    }
}
