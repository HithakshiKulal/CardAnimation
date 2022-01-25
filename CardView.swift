//
//  CardView.swift
//  CardAnimation
//
//  Created by Hithakshi on 25/01/22.
//

import UIKit

enum AccountType: String, CaseIterable {
    case savings = "Savings Account"
    case credit = "Credit Account"
    case crypto = "Crypto Account"
    
    var title: String { rawValue }
}

class CardView: UIView {
    enum State {
        case expanded
        case collapsed
    }
    
    @IBOutlet weak var animatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!

    
    var color: UIColor = .clear
    var state: State = .collapsed {
        didSet {
            animateUIBasedOnState()
        }
    }
    weak var delegate: CardViewDelegate?
    
    let nibName = "CardView"
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        addGesture()
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelect))
        self.addGestureRecognizer(tapGesture)
    }
    
    func updateView(type: AccountType) {
        titleLabel.text = type.rawValue
        animatorView.backgroundColor = color
        animatorView.layer.cornerRadius = 20
        updateUIBasedOnState()
        button1.layer.cornerRadius = button1.frame.width / 2
        button2.layer.cornerRadius = button2.frame.width / 2

    }
    
    @objc
    func didSelect() {
        guard state == .collapsed else { return }
        delegate?.didSelect(cardView: self)
    }
    
    func expand() {
        guard state == .collapsed else { return }
        state = .expanded
        
    }
    
    func collapse() {
        guard state == .expanded else { return }
        state = .collapsed

    }
    
    func updateUIBasedOnState() {
        switch state {
        case .expanded:
            self.titleLabel.transform = .identity
            self.button1.alpha = 1
            self.button2.alpha = 1
        case .collapsed:
            self.titleLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            self.cardNumberLabel.alpha = 0
            self.button1.alpha = 0
            self.button2.alpha = 0
        }
    }
    
    func animateUIBasedOnState() {
//        titleLabel.layer.anchorPoint = .init(x: 0, y: 0)
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.layer.anchorPoint = .zero
            switch self.state {
            case .expanded:
                self.titleLabel.transform = .identity
                self.cardNumberLabel.alpha = 1
                self.button2.alpha = 1
                self.button1.alpha = 1
            case .collapsed:
                self.titleLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                self.cardNumberLabel.alpha = 0
                self.button1.alpha = 0
                self.button2.alpha = 0
            }
        })
    }
    
}


protocol CardViewDelegate: AnyObject {
    func didSelect(cardView: CardView)
}
