//
//  SearchViewController.swift
//  FlickrSearch
//
//  A lightweight View Controller that manages its views and thats all.
//
//  Created by jonathan ide on 21/8/21.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class SearchViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    // UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
    /// Views managed by VC
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerActivityView: UIActivityIndicatorView!
    @IBOutlet weak var spinnerLabelView: UILabel!

    var images = [ImageSearchResult]()

    /// Required for Protocol Conformance
    var viewModel: SearchableProtocol?
    var coordinator: CoordinatorProtocol?

    /// Dispose of Subscriptions
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// TODO - bind in VM
        self.navigationController?.navigationBar.topItem?.title = "Flickr Search"
        
        /// Register a Collection View Cell
        self.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
        self.collectionView?.contentInsetAdjustmentBehavior = .never
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        // self.collectionView.delegate = self
        // self.collectionView.dataSource = self

        if let viewModel = self.viewModel {

            _ = viewModel.spinnerViewBS.bind(to: self.spinnerView.rx.isHidden)

            /// Fire a search request when user hits search button
            let searchEventObs = searchBar.rx.searchButtonClicked.asObservable()
            let searchTermObs  = searchBar.rx.text.asObservable()
            _ = searchEventObs.withLatestFrom(searchTermObs).subscribe { [weak self] evt in
                if let term = evt.element {

                    /// Check Term is "valid" i.e. has content
                    if !(viewModel.validate(term: term!)) {
                        return
                    }
                    /// Binding sets the datasource directly so we only want this done once per search
                    self?.collectionView.dataSource = nil

                    /// Show spinner - not very obvious - could change to enum & convert to bool
                    /// binds BS direct to isHidden propertty of the UIView displaying the spinner
                    viewModel.spinnerViewBS.onNext(false)
                    /// Concise way of binding UICollectionView to its DataSource (as an Observable)
                    /// which is returned by the Search. This may seem a bit obfuscated but it eliminates
                    /// boiler plate code
                    /**_ = viewModel.search(for: term!).bind(to:(self?.collectionView.rx.items(cellIdentifier: "imageCell"))!){ index, cellItem, cell in
                      
                        //print( "Index: \(index) CellItem: \(cellItem)  Cell: \(cell)")
                        let imgView = cellItem.image! as UIImageView
                        imgView.contentMode = .scaleAspectFit
                        cell.contentMode = .scaleAspectFit
                        cell.contentView.backgroundColor = .white
                        cell.contentView.addSubview(imgView)
                        //(cell as? ImageCell)?.imageView = imgView
                        imgView.translatesAutoresizingMaskIntoConstraints = false
                        //cell.contentView.translatesAutoresizingMaskIntoConstraints = false
                        imgView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 0).isActive = true
                        imgView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 0).isActive = true
                        imgView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0).isActive = true
                        imgView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0).isActive = true
                        
                        
                    }*/
                    
                    _ = viewModel.search(for: term!).bind(to: (self?.collectionView.rx.items)!) { _, index, element in
                        
                        guard let cell = (self?.collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: IndexPath(row: index, section: 0))) as? ImageCell else {
                            return UICollectionViewCell()
                        }
                        
                        guard let imgView = element.image else {
                            return UICollectionViewCell()
                        }
                        
                        imgView.contentMode = .scaleAspectFit
                        cell.contentView.addSubview(element.image!)
                        cell.prepareForReuse()
                        imgView.translatesAutoresizingMaskIntoConstraints = false
                        imgView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 0).isActive = true
                        imgView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 0).isActive = true
                        imgView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0).isActive = true
                        imgView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0).isActive = true
                        cell.backgroundColor = .red
                        print("Element: \(element)")
                        return cell
                        
                    }
                    
                    /// Hide the Keyboard
                    /**_ = viewModel.search(for: term!).subscribe({ allimages in
                        self?.images = allimages.element!
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
                    })*/

                    self?.searchBar.resignFirstResponder()
                }

            }.disposed(by: disposeBag)

        }

    }

    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    let itemsPerRow = CGFloat(3)

    /**func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell

        //cell.contentView.addSubview(images[indexPath.row].image!)
        cell?.imageView = images[indexPath.row].image!

        return cell!
    }*/

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        print("delegate called: \(widthPerItem) index: \(indexPath.row)")
        return CGSize(width: 90, height: 90 )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}
