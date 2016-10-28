//
//  ViewController.swift
//  PlayAudioFIle
//
//  Created by michal on 27/10/16.
//  Copyright © 2016 Michal Bojanowicz. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var displayAudioView: DisplayAudioFile!
    
    let audioData = AudioData()
    let audioPlayer = AudioPlayer()
    var path = Bundle.main.url(forResource: "test", withExtension: "mp3") // crashes if the file is not found
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startBtnAction() {
        do {try audioPlayer.play(audioUrl: path!)} catch {print("catched")}
        displayWaveform ()
    }
    
    @IBAction func stopBtnAction() {
        audioPlayer.stop()
    }
    
    func displayWaveform () {
        do {
            
            // read audio buffer from file right now will crash if file not found
            let audioBuffer = try audioData.readFileIntoBuffer(audioUrl: path!)
            
            // converts audio buffer into array of tuples (L: Float, R: Float) corresponding to audio samples
            let audioValues = audioData.getDataFromBuffer(audioBuffer: audioBuffer)
            
            // don't need both channels to display waveform
            let leftChannelData = audioValues.L
            
            // we don't need do draw every sample, draw only averages, numberOfChunks = into how many chunks we split the file
            let averagesLeft = audioData.getAverageValues(array: leftChannelData, numberOfChunks: 500)
            
            displayAudioView.lines = averagesLeft
            displayAudioView.setNeedsDisplay()
        } catch {print("can't read file into buffer")}
        
    }
}

