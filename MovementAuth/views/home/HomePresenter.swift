//
//  HomePresenter.swift
//  MovementAuth
//
//  Created by Fran on 02/03/21.
//

import Foundation


class HomePresenter: BasePresenter, HomePresenterDelegate {

    var mView: HomeViewDelegate
    
    init(v: HomeViewDelegate) {
        self.mView = v
        super.init()
    }
    
}
