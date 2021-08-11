//
//  SearchInteractor.swift
//  flickrapp
//
//  Created by Krishna Kumar on 7/11/21.
//

import Foundation
import Combine

// MARK: - Search Interactor Protocol
protocol SearchInteractor {
    func load(search: String, mocked: Bool)
}

// MARK: - Implementation
struct FlickrSearchInteractor: SearchInteractor {
    func load(search: String, mocked: Bool = false) {
        if (mocked) {
            MockFlickrAPI().search(tag: "test") { result in
                switch result {
                case .success(let photos):
                    DispatchQueue.main.async {
                        let m = SearchTabView.ViewModel()
                        m.photos = photos
                        appState.searchViewModel = m
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            FlickrAPI().search(tag: search) { result in
                switch result {
                case .success(let photos):
                    DispatchQueue.main.async {
                        let m = SearchTabView.ViewModel()
                        m.photos = photos
                        appState.searchViewModel = m
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    let appState: AppState
}
