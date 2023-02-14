//
//  YBPlayAudio.swift
//  CrazyMusic
//
//  Created by liQi on 2019/12/16.
//  Copyright © 2019 长沙奇热. All rights reserved.
//

import UIKit
import AVFoundation

class YBPlayAudio: NSObject {

    static let shared = YBPlayAudio(name: "award.mp3")

    var audio: AVAudioPlayer?
    var repeatPlay = false

    init(name: String, repeatPlay: Bool = false) {
        super.init()
        if let path = Bundle.main.path(forResource: name, ofType: nil) {
            let url = URL(fileURLWithPath: path)
            audio = try? AVAudioPlayer(contentsOf: url)
            audio?.prepareToPlay()
            audio?.delegate = self
        }
        self.repeatPlay = repeatPlay

    }

    func play() {
        audio?.currentTime = 0
        audio?.play()
    }

    func stop() {
        audio?.stop()
    }
    
    private static let clickAudio = YBPlayAudio(name: "通用按钮点击音效.mp3")
    static func click() {
        clickAudio.play()
    }
    
    private static let successAudio = YBPlayAudio(name: "猜对.mp3")
    static func success() {
        successAudio.play()
    }
    
    private static let failAudio = YBPlayAudio(name: "猜错.mp3")
    static func fail() {
        failAudio.play()
    }
    
    private static let awardAudio = YBPlayAudio(name: "得到红包.mp3")
    static func award() {
        awardAudio.play()
    }
    
    private static let awardClickAudio = YBPlayAudio(name: "点击开红包.mp3")
    static func awardClick() {
        awardClickAudio.play()
    }
    
    static let bgAudio = YBPlayAudio(name: "默认背景音乐.mp3", repeatPlay: true)
    
    private static let diamondAudio = YBPlayAudio(name: "钻石漂移至顶部.mp3")
    static func diamond() {
        diamondAudio.play()
    }

}

extension YBPlayAudio: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if repeatPlay {
            audio?.play()
        }
    }
}
