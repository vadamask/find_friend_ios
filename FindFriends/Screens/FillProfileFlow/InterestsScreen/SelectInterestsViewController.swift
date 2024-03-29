//
//  SelectInterestsView.swift
//  FindFriends
//
//  Created by Vitaly on 01.03.2024.
//

import UIKit

class SelectInterestsViewController: UIViewController {
    private(set) var selectInterestsView = SelectInterestsView()
    
    override func loadView() {
        self.view = selectInterestsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectInterestsView.loadData()
    }
}
