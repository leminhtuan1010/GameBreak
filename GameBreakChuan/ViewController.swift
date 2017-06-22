//
//  ViewController.swift
//  GameBreakChuan
//
//  Created by Minh Tuan on 6/19/17.
//  Copyright © 2017 Minh Tuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deltaAnge:CGFloat = 0.1
    var radians = CGFloat()
    var bien: Bool = true
    var ballDenta: CGFloat = 5
    var D:CGFloat = 50
    var pan1 : add!
    var time = Timer()
    var ball = UIImageView()
    var pan : UIImageView!
    var count = 0
    var mang = 5
    var lbl: UILabel!
    var value = Int()
    var vaCham = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pan1 = add(frame: CGRect(x: 0, y: 0,width:view.bounds.size.width, height: view.bounds.size.height))
        self.view.addSubview(pan1)
        ball = pan1.ball                // kế thừa từ clas add
        pan = pan1.pan
        lbl = pan1.heart
        time = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(runBall), userInfo: nil, repeats: true)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(panGesture:)))
        pan.isUserInteractionEnabled = true
        pan.addGestureRecognizer(panGesture)
    }
    
    func moveBrick(b1: UIImageView,b2: UIImageView){
        b1.center = b2.center
    }
    
    // bóng chạy theo chiều dương
    func runDow(){
        deltaAnge = 0.1
        radians = radians + deltaAnge
        ball.transform = CGAffineTransform(rotationAngle: radians)
        ball.center = CGPoint(x: ball.center.x + pan1.ballRadians * deltaAnge, y:ball.center.y + pan1.ballRadians * deltaAnge * ballDenta)
        if (ball.center.x > pan1.mainViewSize.width - pan1.ballRadians){
            deltaAnge = -0.1
            bien = false
        }
    }
    // bóng chạy theo chiều âm
    func backFlow(){
        deltaAnge = -0.1
        radians = radians + deltaAnge
        ball.transform = CGAffineTransform(rotationAngle: radians)
        ball.center = CGPoint(x: ball.center.x + pan1.ballRadians * deltaAnge, y: ball.center.y - pan1.ballRadians * deltaAnge * ballDenta)
        if (ball.center.x < pan1.ballRadians){
            deltaAnge = 0.1
            bien = true
        }
    }
    func runBall(){
        if (bien == true){
            runDow()
            chiaGoc()
        }else{
            backFlow()
            chiaGoc()
        }
    }
    func randomGoc(min:CGFloat, max: CGFloat) -> CGFloat{
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    // Kiểm soát biên trên biên dưới và góc bật của quả bóng
    func chiaGoc(){
        let goc = randomGoc(min: 0.5, max: 1.0)
        if((pan.center.x - ball.center.x) * (pan.center.x - ball.center.x) + (pan.center.y - ball.center.y) * (pan.center.y - ball.center.y) <= D * D){
            ballDenta = -4 * goc
            //        }else if (ball.center.y < ballRadians){
            //            ballDenta = 4 * goc
        }
        if(ball.center.y < CGFloat(pan1.ballRadians + 120)){
            for i in 0..<21{ // điều kiện va chạm của bóng vào break
                if (ball.center.y <= pan1.bricks[i].center.y + CGFloat(25 + 10) && ball.center.x >= (pan1.bricks[i].center.x - (view.bounds.size.width - 80) / 14 - CGFloat(pan1.ballRadians)) && ball.center.x <= (pan1.bricks[i].center.x + (view.bounds.size.width - 80) / 14 + CGFloat(pan1.ballRadians))){
                    pan1.tiengCham()
                    pan1.value[i] -= 1
                    count += 1
                    if (pan1.value[i] == 0){                            // điều kiện đổi màu break và xoá break
                        moveBrick(b1: pan1.bricks[i], b2: pan1.bricksOut)
                        ballDenta = -ballDenta
                        return
                    }
                    // gán màu cho từng cấp độ
                    pan1.bricks[i].layer.backgroundColor = pan1.colors[pan1.value[i]].cgColor
                    ballDenta = -ballDenta
                    return
                }
                thang()
            }
            
        }
        if (ball.center.y < pan1.ballRadians){
            ballDenta = -ballDenta
        }
        
        reset()
    }

    // Kiểm tra vị trí của pan (di chuyển pan)
    func onPan(panGesture: UIPanGestureRecognizer){
        if (panGesture.state == .began || panGesture.state == .changed){
            let poin = panGesture.location(in: self.view)
            self.pan.center = CGPoint(x: poin.x, y: pan.center.y)
        }
    }
    // khởi tạo lại bóng khi người chơi chết
    func reset(){
        lbl.text = "\(mang)"
        if(ball.center.y > pan1.mainViewSize.height){
            ball.center = CGPoint(x: pan1.mainViewSize.width / 2, y: pan1.mainViewSize.height / 2)
            mang -= 1
        }
        if (mang == 0){
            hetMang()
            
            }
    }
    //kiểm tra số break còn lại trên màn hình
    func thang(){
        if (count == 63){
            print("dunglai")
            thongBaoThang()
            
        }
    }

    // reset lại chương trình
    func resetBoard(){
        self.pan.removeFromSuperview()
        self.pan1.removeFromSuperview()
        self.pan1 =  add(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        self.view.addSubview(pan1)
        ball = pan1.ball
        pan = pan1.pan
        lbl = pan1.heart
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(panGesture:)))
        pan.isUserInteractionEnabled = true
        pan.addGestureRecognizer(panGesture)
    }
    // thông báo alert sau khi đã hết break
    func thongBaoThang(){
        let alertController = UIAlertController(title: "Thông Báo",message: "Bạn đã thắng", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Chơi lại", style: .default, handler: { (action) -> Void in
            self.resetBoard()
            self.count = 0
            self.runBall()
            self.resetHeart()
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler:{ (action) -> Void in exit(1) })
        alertController.addAction(ok)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    // thông báo hết mạng
    func hetMang(){
        let alertController = UIAlertController(title: "Thông Báo",message: "Lose", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Chơi lại", style: .default, handler: { (action) -> Void in
            self.resetBoard()
            self.runBall()
            self.resetHeart()
            self.count = 0
    
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler:{ (action) -> Void in exit(1) })
        alertController.addAction(ok)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)

    }
    func resetHeart(){
        
        mang = 5
        lbl.text = "\(mang)"
    }
}

