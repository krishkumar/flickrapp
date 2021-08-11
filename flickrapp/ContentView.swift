//
//  ContentView.swift
//  flickrapp
//
//  Created by Krishna Kumar on 7/10/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        TabView(selection: $appState.selectedTab,
                content:  {
                    SearchTabView(interactor: FlickrSearchInteractor(appState: appState)) .tabItem {
                        
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Flickr")
                        }
                    }.tag(Tab.home)
                })
    }
}

struct SearchTabView: View {
    @EnvironmentObject var appState: AppState
    @State var searchInput: String = ""
    var interactor: SearchInteractor
    init(interactor: SearchInteractor) {
        self.interactor = interactor
    }
    var body: some View {
        VStack {
            Text("Flickr App - Search Tab")
            if let photos = self.appState.searchViewModel.photos.photos.photo {
                List {
                    ForEach(photos) { photo in
                        ImageView(withFlickrPhoto: photo)
                    }
                }
            }
            HStack {
                TextField("Type here to search", text: $searchInput).padding()
                Button(action: {
                    interactor.load(search: searchInput, mocked: false)
                }, label: {
                    Text("Search").bold()
                }).padding()
                    .disabled(searchInput == "")
                
            }
        }
    }
}

extension SearchTabView {
    class ViewModel: ObservableObject {
        @Published var photos: Photos = Photos(photos: PhotosClass(page: 0, pages: 0, perpage: 0, total: 0, photo: []), stat: "")
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var selectedTab: ContentView.Tab = .home
    }
}

extension ContentView {
    enum Tab: Hashable {
        case home
        case detail
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
