import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rekorLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let yodaImageView = UIImageView()
    var count = 10
    var timer = Timer()
    var modeTimer = Timer()
    var height = 0
    var width = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rekoru UserDefaults'tan yükle ve label'a ata
        let rekor = UserDefaults.standard.integer(forKey: "rekor")
        self.rekorLabel.text = "\(rekor)"
        
        // Yoda ImageView ayarları
        yodaImageView.image = UIImage(named: "yoda.png")
        view.addSubview(yodaImageView)
        height = Int(view.frame.size.height)
        width = Int(view.frame.size.width)
        startTimers()
        yodaImageView.isUserInteractionEnabled = true
        yodaImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.yodaIsCatched)))
    }
    
    func startTimers() {
        modeTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
            let y = CGFloat(Int.random(in: 270...self.height-130))
            let x = CGFloat(Int.random(in: 0...self.width-90))
            self.yodaImageView.frame = CGRect(x: x, y: y, width: 100, height: 130)
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.count == 1 {
                self.timer.invalidate()
                self.modeTimer.invalidate()
                self.showGameOverAlert()
            } else {
                self.count -= 1
                self.timeLabel.text = String(self.count)
            }
        }
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Time's up!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            // Rekoru kontrol et ve gerekirse güncelle
            let currentScore = Int(self.scoreLabel.text!) ?? 0
            let rekor = UserDefaults.standard.integer(forKey: "rekor")
            
            if currentScore > rekor {
                UserDefaults.standard.set(currentScore, forKey: "rekor")
                self.rekorLabel.text = "\(currentScore)"
            }
            
            // Oyunu sıfırla
            self.count = 10
            self.scoreLabel.text = "0"
            self.timeLabel.text = "10"
            self.startTimers()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func yodaIsCatched() {
        count += 1
        self.timeLabel.text = String(self.count)
        
        let currentScore = Int(scoreLabel.text!) ?? 0
        scoreLabel.text = String(currentScore + 1)
        
        let y = CGFloat(Int.random(in: 270...height-130))
        let x = CGFloat(Int.random(in: 0...width-90))
        yodaImageView.frame = CGRect(x: x, y: y, width: 100, height: 130)
    }
}
