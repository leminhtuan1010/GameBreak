# Game Break
## Giới thiệu
Trong bài sẽ mô tả từng bước cụ thể để tạo nên pan người chơi và các break
## Khởi tạo vẽ pan cho người chơi
***    
func addPanDanh(){
        pan = UIImageView(frame:CGRect(x: mainViewSize.width / 2 - 50, y: mainViewSize.height - 60, width: 100, height: 50 ))
        pan.backgroundColor = UIColor.blue
        self.addSubview(pan)
    }
***
    * Về mặt logic thì chúng ta đang vẽ và cũng cấp toạ độ cho chiếc pan và truyền kích thước cho nó.
    * Sau khi khởi tạo được hình dạng cho chiếc pan thì chúng ta sẽ gán màu cho nó bắng cách UIColor.(Màu chúng ta muốn) 
    * Cuối cùng là đưa cpan lên màn hình hiển thị
## Kiểm tra vị trí của Pan sau khi được di chuyển
Kiểm tra toạ độ di chuyển của người chơi.
```sh
    func onPan(panGesture: UIPanGestureRecognizer){
        if (panGesture.state == .began || panGesture.state == .changed){
            let poin = panGesture.location(in: self.view)
            self.pan.center = CGPoint(x: poin.x, y: pan.center.y)
        }
    }
```
    * Về mặt logic thì chúng ta sẽ so sánh vị trí ban đầu và vị tri sau khi di chuyển với .began và .changed.
    * Chúng ta phải xác định vị trí của pan bằng một điểm cố định và dựa vào nó để xác định vị trí của pan đang đứng.
## Vẽ các break
Vẽ các beark trên màn hình
```sh
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
```
    * về mặt logic chúng ta sẽ vẽ một pan cố định trước và cho khoảng cách để máy tự vẽ các break còn lại.
    * Ở đây chúng ta sẽ vẽ 3 hàng và 7 cột => sẽ có 21 ô khoảng cách đều nhau nằm trong khoảng chúng ta giới hạn.
    * Đầu tiên sẽ vẽ 1 pan cố định với toạ độ và kích thước được chúng ta quy định trước.
    * Sau đó truyền màu vào cho chúng.
    * Cuối cùng là in chúng ra màn hình
## Kiểm tra va chạm của quả bóng và break 
Kiểm tra va chạm của quả bóng và các break vừa được vẽ.
```sh
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
``` 
    * Về logic thì sẽ xét va chạm của qủa bóng ở các mặt của break với khoảng và kích thước của quả bóng và break
    * Tính điều kiện va chạm giữa bóng và break
    * Với mỗi lần bóng va chạm vào break thì sẽ được truyền về và giảm cấp độ của breal xuống một cấp đến khi nào cấp độ của break trở về 0 thì sẽ xoá break ra khỏi màn hình.
