/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class SearchResultsViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  var searchResults: FlickrSearchResults?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let resultsCount = searchResults?.searchResults.count ?? 0
    title = "\(searchResults?.searchTerm ?? "") (\(resultsCount))"
  }
}

// MARK: - UICollectionViewDataSource
extension SearchResultsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchResults?.searchResults.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)

    guard let resultsCell = cell as? SearchResultsCollectionViewCell else {
      return UICollectionViewCell()
    }

    if let flickrPhoto = searchResults?.searchResults[indexPath.item] {
      resultsCell.flickrPhoto = flickrPhoto
      resultsCell.heartToggleHandler = { [weak self] _ in
        self?.collectionView.reloadItems(at: [indexPath])
      }

      ImageCache.shared.loadThumbnail(for: flickrPhoto) { result in
        switch result {
        case .success(let image):
          if resultsCell.flickrPhoto == flickrPhoto {
            if flickrPhoto.isFavorite {
              resultsCell.imageView.image = image
            } else {
              // 1
              if let cachedImage = ImageCache.shared.image(forKey: "\(flickrPhoto.id)-filtered") {
                resultsCell.imageView.image = cachedImage
              } else {
                // 2
                DispatchQueue.global().async {
                  if let filteredImage = image.withTonalFilter {
                    ImageCache.shared.set(filteredImage, forKey: "\(flickrPhoto.id)-filtered")

                    DispatchQueue.main.async {
                      resultsCell.imageView.image = filteredImage
                    }
                  }
                }
              }
            }
          }
        case .failure(let error):
          print("Error: \(error)")
        }
      }
    }
    return resultsCell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // 3 images across
    let width = view.bounds.width / 3
    // each image has a ratio of 4:3
    let height = (width / 4) * 3
    return CGSize(width: width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
