//
//  SearchViewController.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController, ViewModelContainerProtocol, CoordinatedProtocol {
    
    var viewModel  : ViewModelProtocol?
    var coordinator: CoordinatorProtocol?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
