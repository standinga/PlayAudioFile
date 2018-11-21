//
//  PlayAudio.swift
//  PlayAudioFIle
//
//  Created by michal on 27/10/16.
//  Copyright © 2016 Michal Bojanowicz. All rights reserved.
//

import AVFoundation

protocol AudioPlayerDelegate: class {
    func audioSignal(didReceiveBuffer buffer: AVAudioPCMBuffer,
                     timeStamp: AVAudioTime)
    
}

class AudioPlayer {
    
    weak var delegate: AudioPlayerDelegate?
    
    fileprivate var audioEngine: AVAudioEngine!
    fileprivate var audioPlayer: AVAudioPlayerNode!
    fileprivate let bus = 0
    let audioData = AudioData()
    
    
    // MARK: - Play Audio
    func play(audioUrl: URL) throws {
        
        let AVBufferSize = 1024
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.default)
        
        audioEngine = AVAudioEngine()
        audioPlayer = AVAudioPlayerNode()
        
        let audioFile = try AVAudioFile(forReading: audioUrl)
        
        audioEngine.attach(audioPlayer)
        audioEngine.connect(audioPlayer, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayer.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        // right now this one is not used, it could be used to draw signal level, send current position of playing
        audioEngine.outputNode.installTap(onBus: bus, bufferSize: AVAudioFrameCount(AVBufferSize), format: nil) {
            buffer, time in
            
            DispatchQueue.main.async {
                self.delegate?.audioSignal(didReceiveBuffer: buffer, timeStamp: time)
//                print(time)
                
            }
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        audioPlayer.play()
    }
    
    
    func stop() {
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer = nil
        }
        if audioEngine != nil {
            audioEngine.stop()
            audioEngine.reset()
            audioEngine = nil
        }
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
