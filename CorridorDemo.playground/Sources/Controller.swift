import Foundation
import UIKit

open class LabelController: UIViewController {

  public lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = true
    label.backgroundColor = .clear
    label.textColor = .white
    label.numberOfLines = 16
    label.frame = CGRect(x: 20, y: 0, width: 380, height: 700)
    label.textAlignment = .left
    label.text = "Test"
    return label
  }()

  public lazy var headline: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = true
    label.backgroundColor = .clear
    label.textColor = .white
    label.numberOfLines = 1
    label.font = UIFont.boldSystemFont(ofSize: 40)
    label.frame = CGRect(x: 20, y: 0, width: 380, height: 100)
    label.textAlignment = .left
    label.text = "Corridor"
    label.alpha = 0.3
    return label
  }()

  open override func viewDidLoad(){
    view.backgroundColor = .black
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = [UIColor.brown.cgColor, UIColor.blue.cgColor]
    view.layer.insertSublayer(gradient, at: 0)
    self.view.addSubview(label)
    self.view.addSubview(headline)
  }
}


