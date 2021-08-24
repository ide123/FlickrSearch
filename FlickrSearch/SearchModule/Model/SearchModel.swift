//
//  SearchModel.swift
//  Returns Observable of Results
//  FlickrSearch
//
//  Created by jonathan ide on 21/8/21.
//

import Foundation
import RxSwift

/// 
class SearchModel {

    var dataSource: DataSourceProtocol!
    var loadingStatus = PublishSubject<LOADINGSTATUS>()

    /// Inject Flickr specific DataSource
    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
    }
    /// Return Observable of Results
    func search(for term: String?) -> Observable<[ImageSearchResult]> {

        return Observable<[ImageSearchResult]>.create { [weak self] observer in
            self?.dataSource.search(for: term) { imageResults in
                /// Notify Observer with results
                observer.onNext(imageResults)
                /// Publish an update to stop the Spinner 
                self?.loadingStatus.onNext(.LOADINGCOMPLETE)
            }
            return Disposables.create()
        }

    }
}
