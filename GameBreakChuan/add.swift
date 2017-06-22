//
//  add.swift
//  GameBreakChuan
//
//  Created by Minh Tuan on 6/19/17.
//  Copyright © 2017 Minh Tuan. All rights reserved.
//

import UIKit
import AVFoundation

class add: UIView {
    
    var ball = UIImageView()
    var ballRadians = CGFloat()
    var bricks = [UIImageView]()
    var bricksOut = UIImageView()
    var _margin: CGFloat = 10
    var pan : UIImageView!
    var mainViewSize = CGSize()
    var bien1: CGFloat = 10
    var heart: UILabel!
    var pan1 = UIImageView()
    var value = [Int]()
    var colors = [UIColor.red, UIColor.white, UIColor.blue]
    var audio = AVAudioPlayer()
// tạo một .... 
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBall()
        addPanDanh()
        hardPanDrawing()
        tinhMang()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // vẽ pan người chơi
    func addPanDanh(){
        pan = UIImageView(frame:CGRect(x: mainViewSize.width / 2 - 50, y: mainViewSize.height - 60, width: 100, height: 50 ))
        pan.backgroundColor = UIColor.blue
        self.addSubview(pan)
    }
    // vẽ bóng
    func addBall(){
        mainViewSize = self.bounds.size
        
        
        
        
        ball = UIImageView(frame: CGRect(x: ballRadians,y: mainViewSize.height / 2, width: 50, height: 50))
        ball.image = UIImage(named: "ball.png")
        ballRadians = 25.0
        ball.center = CGPoint(x: ballRadians, y: mainViewSize.height / 2)
        self.addSubview(ball)
    }
    // Vẽ các pan cố định
    
    func hardPanDrawing(){
        for hang in 0..<3{
            for cot in 0..<7{
                pan1 = UIImageView(frame: CGRect(x: _margin + CGFloat(cot) * chieuRong(), y: 30 + bien1 * CGFloat(hang + 1) + CGFloat(20) * CGFloat(hang), width: 50, height: 20))
                bricks.append(pan1)
                value.append(3)
                pan1.backgroundColor = UIColor.red
                self.addSubview(pan1)
            }
        }
        bricksOut = UIImageView(frame: CGRect(x: self.bounds.size.width + 300, y: 100, width: 20, height: 20))
        self.addSubview(bricksOut)
    }
    func chieuRong() -> CGFloat {
        let chieuRong = (self.bounds.size.width - (2 * (_margin)) - 50) / 6
        return chieuRong
    }
    // ve lable
    func tinhMang(){
        heart = UILabel(frame: CGRect(x: mainViewSize.width / 2 - 25, y: mainViewSize.height / 2 - 25, width: 50, height: 50))
        heart.backgroundColor = UIColor.white
        heart.textAlignment = .center
        self.addSubview(heart)
    }
    // tao tieng chim hot
    func tiengCham(){
        let file = Bundle.main.path(forResource: "ping", ofType: ".mp3")!
        let url = URL(fileURLWithPath: file)
        audio = try!AVAudioPlayer(contentsOf: url)
        audio.prepareToPlay()
        audio.play()
    }
    
}
