//
//  ViewController.swift
//  vid and ui
//
//  Created by Eric Dolecki on 6/25/19.
//  Copyright © 2019 Eric Dolecki. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    // Think of video frame as the viewport for the movie. Movie will playback in aspect ratio within.
    var videoFrame: UIView!
    var player: AVPlayer!
    @IBOutlet weak var mySlider: UISlider!
    var blocks:[UIView] = [UIView]()
    var container: UIView!
    var pianoContainer: UIView!
    var pianoKeys:[UIView] = [UIView]()
    
    // Create an empty array typed to PianoKey - which we will fill up.
    var testPianoKeys:[PianoKey] = [PianoKey]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        videoFrame = UIView(frame: CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 150))
        self.view.addSubview(videoFrame)
        
        playVideo()
        
        // Create blocks.
        container = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        var posX: CGFloat = 0.0
        var blockHeight: CGFloat = 30.0
        
        for index in 0...9 {
            let block = UIView(frame: CGRect(x: posX, y: 100 - blockHeight, width: 20, height: blockHeight))
            block.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            block.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
            block.layer.borderWidth = 1.0
            block.layer.shadowColor = UIColor.black.cgColor
            block.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            block.layer.shadowOpacity = 0.2
            block.layer.shadowRadius = 5.0
            block.layer.cornerRadius = 4.0
            block.tag = index
            blocks.append(block)
            container.addSubview(block)
            posX = posX + 28
            blockHeight = blockHeight + 10
        }
        // This grows the container view so that it contains all it's subviews - so it can e centered properly.
        container.sizeToFitCustom()
        container.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - 50)
        self.view.addSubview(container)
        
        // Initial UI evaluation slider value is 0, so 1st block will be lit up.
        sliderChanged(mySlider)
        
        createPianoKeys()
        
        // TESTING ONLY.
        
        let testContainer = UIView(frame: CGRect(x: 20, y: 430, width: 10, height: 10))
        testContainer.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        var positionX:CGFloat = 0.0
        for _ in 0...6 {
            let foo = PianoKey(isAMainKey: true)
            foo.frame.origin.x = positionX
            foo.frame.origin.y = 0
            testContainer.addSubview(foo)
            testPianoKeys.append(foo)
            positionX += foo.frame.width - foo.layer.borderWidth
        }
        // Create sub keys.
        var centerX: CGFloat = 28
        for index in 0...4 {
            let foo = PianoKey(isAMainKey: false)
            foo.center.x = centerX
            foo.frame.origin.y = 0
            testContainer.addSubview(foo)
            centerX += 26
            if index == 1 {
                centerX += 26
            }
        }
        testContainer.sizeToFitCustom()
        testContainer.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        testContainer.frame.origin.x = 5
        testContainer.frame.origin.y = pianoContainer.frame.origin.y
        self.view.addSubview(testContainer)
    }

    
    
    
    
    
    
    
    func createPianoKeys()
    {
        pianoContainer = UIView(frame: CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 150))
        var posX: CGFloat = 0.0
        for index in 0...6 {
            let thisKey = UIView(frame: CGRect(x: posX, y: 0, width: 30, height: 150))
            thisKey.tag = index
            thisKey.backgroundColor = UIColor.white
            thisKey.layer.borderColor = UIColor.lightGray.cgColor
            thisKey.layer.borderWidth = 4.0
            pianoContainer.addSubview(thisKey)
            pianoKeys.append(thisKey)
            posX = posX + 24 //30 - border / 2
        }
        
        // We don't need to store these in array, we don't affect them.
        var posX2: CGFloat = 19.5
        for index in 7...11 {
            let thisKey = UIView(frame: CGRect(x: posX2, y: 0, width: 14, height: 100))
            thisKey.backgroundColor = UIColor.lightGray
            posX2 = posX2 + 24
            
            // Skip to the right if needed.
            if index == 8 {
                posX2 = posX2 + 24
            }
            pianoContainer.addSubview(thisKey)
        }
        
        pianoContainer.sizeToFitCustom()
        pianoContainer.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + container.frame.height / 2 + 60)
        self.view.addSubview(pianoContainer)
    }
    
    
    
    
    
    
    
    
    
    func playVideo()
    {
        guard let path = Bundle.main.path(forResource: "jellyfish", ofType:"m4v") else {
            debugPrint("jellyfish.m4v not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoFrame.bounds
        videoFrame.layer.addSublayer(playerLayer)
        player.play()
        
        // Loop the video.
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    // Only accept Int values, so it snaps into place.
    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(.down), animated: true)
        
        // Reset all the blocks.
        for block in blocks {
            block.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        // Highlight the ones we need.
        for (index, block) in blocks.enumerated() {
            if index <= Int(sender.value) {
                block.backgroundColor = UIColor.darkGray
            }
        }
    }
}

extension UIView {
    final func sizeToFitCustom() {
        var w: CGFloat = 0
        var h: CGFloat = 0
        for view in subviews {
            if view.frame.origin.x + view.frame.width > w { w = view.frame.origin.x + view.frame.width }
            if view.frame.origin.y + view.frame.height > h { h = view.frame.origin.y + view.frame.height }
        }
        frame.size = CGSize(width: w, height: h)
    }
}
