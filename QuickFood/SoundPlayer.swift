//
//  SoundPlayer.swift
//  QuickFood
//
//  Created by Daniel Marin on 6/9/20.
//  Copyright © 2020 Daniel Marin. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?
// This function was inspired by Paul Hudson's tutorial at
// https://www.hackingwithswift.com/example-code/media/how-to-play-sounds-using-avaudioplayer
func playSound(soundFile: String, type: String) {
    if let path = Bundle.main.path(forResource: soundFile, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not find pr play audio file \(soundFile).\(type)")
        }
    } else {
        print("Could not find sound. soundFile: \(soundFile), type: \(type)")
    }
}
