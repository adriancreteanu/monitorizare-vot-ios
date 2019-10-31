//
//  AttachNoteViewController.swift
//  MonitorizareVot
//
//  Created by Cristi Habliuc on 31/10/2019.
//  Copyright © 2019 Code4Ro. All rights reserved.
//

import UIKit

/// This class is used to allow the user to add a new note and it's part of the `NoteViewController` as
/// it backs that screen's history table view's header
class AttachNoteViewController: UIViewController {
    
    let model: AttachNoteViewModel
    
    @IBOutlet weak var outerContainer: UIView!
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewPlaceHolder: UILabel!
    @IBOutlet weak var attachButton: AttachButton!
    @IBOutlet weak var submitButton: ActionButton!
    
    // MARK: - Object
    
    init(withModel model: AttachNoteViewModel) {
        self.model = model
        super.init(nibName: "AttachNoteViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateAppearance()
    }
    
    fileprivate func updateAppearance() {
        cardContainer.layer.masksToBounds = true
        cardContainer.layer.cornerRadius = Configuration.buttonCornerRadius
        outerContainer.layer.shadowColor = UIColor.cardDarkerShadow.cgColor
        outerContainer.layer.shadowOffset = .zero
        outerContainer.layer.shadowRadius = Configuration.shadowRadius
        outerContainer.layer.shadowOpacity = Configuration.shadowOpacity
        titleLabel.textColor = .defaultText
        textViewContainer.layer.borderWidth = 1
        textViewContainer.layer.borderColor = UIColor.textViewContainerBorder.cgColor
        textViewContainer.layer.cornerRadius = Configuration.buttonCornerRadius
        textView.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        textView.contentOffset = .zero
        textView.textColor = .defaultText
    }
    
    fileprivate func localize() {
        titleLabel.text = "Label_AddNote".localized
        attachButton.setTitle("Button_AddPhotoVideo".localized, for: .normal)
        submitButton.setTitle("Button_Submit".localized, for: .normal)
        textViewPlaceHolder.text = "Label_TypeNote".localized
    }

}
