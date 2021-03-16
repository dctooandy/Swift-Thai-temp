//
//  DummyViewController.swift
//  PreBetLead
//
//  Created by vanness wu on 2019/5/16.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import RxCocoa
import RxSwift

class DummyViewController:BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoView()
        setupIndicator()
        view.backgroundColor = .white
    }
    private var avPlayer:AVPlayer?
    private let indicator = UIActivityIndicatorView(style: .whiteLarge)
    private func setupVideoView(){
        if let url = URL(string: "https://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4")  {
            avPlayer = AVPlayer(url:url)
            let avPlayerLayer = AVPlayerLayer(player:avPlayer)
            avPlayerLayer.frame = self.view.bounds
            avPlayerLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(avPlayerLayer)
            avPlayer?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
            avPlayer?.play()
            NotificationCenter.default.addObserver(forName:NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object:nil,
                                                   queue:nil) { [weak self] notification in
                                                    self?.avPlayer?.seek(to:CMTime.zero)
                                                    self?.avPlayer?.play()
            }
        }
    }
    private func setupIndicator(){
        indicator.color = .darkGray
        view.addSubview(indicator)
        indicator.snp.makeConstraints { (maker) in
        maker.center.equalToSuperview()
        }
        indicator.startAnimating()
    }
    deinit {
//        removeObserver(self, forKeyPath: "status")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" , let avPlayer = avPlayer{
            switch avPlayer.status {
            case .readyToPlay:
                indicator.stopAnimating()
            default:
                break
            }
        }
    }
}
