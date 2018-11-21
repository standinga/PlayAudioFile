//
//  AudioData.swift
//  PlayAudioFIle
//
//  Created by michal on 27/10/16.
//  Copyright © 2016 Michal Bojanowicz. All rights reserved.
//

import AVFoundation

class AudioData {
    
    func readFileIntoBuffer(audioUrl: URL) throws -> AVAudioPCMBuffer {
        
        let audioFile = try AVAudioFile(forReading: audioUrl)
        let audioFileFormat = audioFile.processingFormat
        let audioFileSize = UInt32(audioFile.length)
        let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFileFormat, frameCapacity: audioFileSize)!
        try audioFile.read(into: audioBuffer)
        return audioBuffer
    }
    
    // get audio data from whole file
    func getAudioDataFromFile(audioUrl: URL) throws -> (L: [Float], R: [Float]) {
        
        let audioBuffer = try readFileIntoBuffer(audioUrl: audioUrl)
        let (L, R) = getDataFromBuffer(audioBuffer: audioBuffer)
        
        print("AudioData audio max R: \(String(describing: R.max()))")
        return (L, R)
    }
    
    func getAverageValues(array: [Float], numberOfChunks: Int = 100) -> [Float] {
        var averageValuesArray: [Float] = []
        let length = array.count
        let stride = Double(length) / Double(numberOfChunks)
        
        for i in 0..<numberOfChunks {
            let offset = Int(Double(i) * stride)
            let endOffset = offset + Int(stride) < length ? offset + Int(stride) : length
            let currentChunk = Array(array[offset..<endOffset])
            let currentChunkAbs = currentChunk.map { abs($0) }
            let currentChunkSum = currentChunkAbs.reduce(0.0, +)
            let currentAverage = currentChunkSum / Float(stride)
            averageValuesArray.append(currentAverage)
            
        }
        
        return averageValuesArray
    }
    
    // returns averages of frameSize
    fileprivate func getAverages(audioBuffer: AVAudioPCMBuffer, numberOfFrames: Int = 100) -> [(L: Float, R: Float)] {
        
        var audioAveragesArray: [(L: Float, R: Float)] = []
        
        let (L,R) = getDataFromBuffer(audioBuffer: audioBuffer)
        let audioBufferLength = audioBuffer.frameLength
        let stride = Double(audioBufferLength) / Double (numberOfFrames)
        let frameSize = Int(stride)
        
        for i in 0..<numberOfFrames {
            print (i)
            let startOffset = Int(Double(i) * stride)
            let endOffset = startOffset + frameSize < L.count ? startOffset + frameSize : L.count
            let currentLeftChunk = Array(L[startOffset..<endOffset])
            let currentRightChunk = Array(R[startOffset..<endOffset])
            let currentLeftAbs = currentLeftChunk.map { abs($0) }
            let currentRightAbs = currentRightChunk.map { abs($0) }
            let currentLeftSum = currentLeftAbs.reduce(0.0, +)
            let currentRightSum = currentRightAbs.reduce(0.0, +)
            let currentLeftAverage = currentLeftSum / Float(L.count)
            let currentRightAverage = currentRightSum / Float(L.count)
            
            audioAveragesArray.append((currentLeftAverage, currentRightAverage))
            
        }
        return audioAveragesArray
    }
    
    
    func getAudioValuesAtPositions(audioBuffer: AVAudioPCMBuffer, numberOfFrames: Int = 100) -> [(L: Float, R: Float)] {
        var audioValuesArray: [(L:Float, R: Float)] = []
        let (L, R) = getDataFromBuffer(audioBuffer: audioBuffer)
        let stride = Double(L.count) / Double(numberOfFrames)
        
        for i in 0..<numberOfFrames {
            let offset = Int(Double(i) * stride) < L.count ? Int(Double(i) * stride) : L.count - 1
            let currentValues = (L: L[offset], R: R[offset])
            audioValuesArray.append(currentValues)
            
        }
        
        return audioValuesArray
        
    }
    
    func getValuesWithStride(values: [Float], numberOfChunks: Int = 500)->[Float] {
        var valuesAtChunks: [Float] = []
        let stride  = Double(values.count) / Double(numberOfChunks)
        for i in 0..<numberOfChunks {
            let offset = Int(Double(i) * stride)
             valuesAtChunks.append(values[offset])
        }
        return valuesAtChunks
    }

    func getDataFromBuffer(audioBuffer: AVAudioPCMBuffer) -> (L: [Float],R: [Float]) {
        
        let audioBufferSize = Int(audioBuffer.frameLength)
        
        var Ldata:[Float]
        var Rdata:[Float]
        
        if let leftpointer = audioBuffer.floatChannelData?[0] {
            let LdataBuffer = UnsafeBufferPointer(start: leftpointer, count: audioBufferSize)
            Ldata = Array(LdataBuffer)
        } else {
            Ldata = [0.0]
        }
        
        if let rightPointer = audioBuffer.floatChannelData?[1] {
            let RdataBuffer = UnsafeBufferPointer(start: rightPointer, count: audioBufferSize)
            Rdata = Array(RdataBuffer)
        } else {
            Rdata = [0.0]
        }
        
        return (Ldata, Rdata)
        
    }
    
    func getAverageAudioChannels(audioBuffer: AVAudioPCMBuffer) -> [Float] {
    
        let (Ldata, Rdata) = getDataFromBuffer(audioBuffer: audioBuffer)
        
        return zip(Ldata, Rdata).map { $0 + $1 / 2.0 }
    
    }
    
    func getMaxSignal(audioBuffer: AVAudioPCMBuffer) -> Float {
        
        let (Ldata, Rdata) = getDataFromBuffer(audioBuffer: audioBuffer)
        
        let absoluteValues = zip(Ldata, Rdata).map { abs($0) > abs($1) ? abs($0) : abs($1) }
        
            return absoluteValues.max()!

        }

}
