//
//  TestMovementsPresenter.swift
//  MovementAuth
//
//  Created by Fran on 04/03/21.
//

import Foundation

class TestMovementsPresenter: BasePresenter, TestMovementsPresenterDelegate {

    var mView: TestMovementsViewDelegate
    
    init(v: TestMovementsViewDelegate) {
        self.mView = v
        super.init()
    }
    
}
