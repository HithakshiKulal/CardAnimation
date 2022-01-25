//
//  ViewController.swift
//  CardAnimation
//
//  Created by Hithakshi on 25/01/22.
//

import UIKit

struct Card {
    var type: AccountType
}

class ViewController: UIViewController {
    @IBOutlet weak var card1Width: NSLayoutConstraint!
    @IBOutlet weak var card2Width: NSLayoutConstraint!
    @IBOutlet weak var card3Width: NSLayoutConstraint!

    @IBOutlet weak var card1: CardView!
    @IBOutlet weak var card2: CardView!
    @IBOutlet weak var card3: CardView!
    
    lazy var previousSelectedCard: CardView = card1
    lazy var previousWidth: NSLayoutConstraint = card1Width
    lazy var cards: [Card] = AccountType.allCases.map { Card(type: $0) }

    var cardColors: [UIColor] = [#colorLiteral(red: 0.1184628382, green: 0.5210333467, blue: 0.914528966, alpha: 1), #colorLiteral(red: 0.9990434051, green: 0.3179908097, blue: 0.5322634578, alpha: 1), #colorLiteral(red: 0.2290330529, green: 0.8233567476, blue: 0.7957426906, alpha: 1)]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        [card1, card2, card3].enumerated().forEach {
            guard let card = $0.element else { return }
            let index = $0.offset % cardColors.count
            card.color = cardColors[index]
            if index == 0 {
                card.state = .expanded
                card1Width.constant = 200
            } else {
                card2Width.constant = 60
                card3Width.constant = 60
            }
            card.delegate = self
            card.updateView(type: cards[index].type)
        }
    }

}

extension ViewController: CardViewDelegate {
    func didSelect(cardView: CardView) {
        cardView.expand()
        previousSelectedCard.collapse()
        previousSelectedCard = cardView
            self.previousWidth.constant = 60
            switch cardView {
            case self.card1:
                self.card1Width.constant = 200
                self.previousWidth = self.card1Width
            case self.card2:
                self.card2Width.constant = 200
                self.previousWidth = self.card2Width
            case self.card3:
                self.card3Width.constant = 200
                self.previousWidth = self.card3Width
            default: break
            }
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    }
                       
}
