//
//  SearchViewController.swift
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class SearchViewController: UIViewController {
    
    /// Views managed by VC
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var collectionView : UICollectionView!
    
    /// Required for Protocol Conformance
    var viewModel  : ViewModelProtocol?
    var coordinator: CoordinatorProtocol?
    
    /// Dispose of Subscriptions
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Fire a search request when user hits search button
        let searchEventObs = searchBar.rx.searchButtonClicked.asObservable()
        let searchTermObs  = searchBar.rx.text.asObservable()
        _ = searchEventObs.withLatestFrom(searchTermObs).subscribe { [weak self] evt in
            if let term = evt.element {
                /// Search with the Term
                (self?.viewModel as? SearchableProtocol)?.search(for: term!).subscribe({ evts in
                    if let searchResults = evts.element {
                        print("VC: \(searchResults)")
                    }
                })
                /// Hide the Keyboard
                self?.searchBar.resignFirstResponder()
            }
        }.disposed(by: disposeBag)

    }

}
