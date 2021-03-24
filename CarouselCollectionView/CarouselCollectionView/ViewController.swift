//
//  ViewController.swift
//  CarouselCollectionView
//
//  Created by Sue Cho on 2021/03/24.
//

import UIKit

class CarouselViewController: UIViewController {
    
    // MARK:- Views
    private lazy var carouselView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var carouselProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .white
        return progressView
    }()
    
    // MARK:- Properties
    let colors: [UIColor] = [.red, .orange, .yellow, .brown, .purple]
    var progress: Progress?
    var timer: Timer?

    // MARK:- Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(carouselView)
        view.addSubview(carouselProgressView)
        
        carouselView.register(CarouselCollectionViewCell.self,
                              forCellWithReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier)
        carouselView.dataSource = self
        carouselView.delegate = self

        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: view.topAnchor),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 300),
            carouselProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            carouselProgressView.bottomAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: -20),
            carouselProgressView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8)
        ])
        
        configureProgressView()
        activateTimer()
    }
    
    override func viewDidLayoutSubviews() {
        let segmentSize = colors.count
        carouselView.scrollToItem(at: IndexPath(item: segmentSize, section: 0),
                                  at: .centeredHorizontally,
                                  animated: false)
    }
    
    private func configureProgressView() {
        carouselProgressView.progress = 0.0
        progress = Progress(totalUnitCount: Int64(colors.count))
        progress?.completedUnitCount = 1
        carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
    }
    
    private func visibleCellIndexPath() -> IndexPath {
        return carouselView.indexPathsForVisibleItems[0]
    }
    
    private func invalidateTimer() {
       timer?.invalidate()
    }
    private func activateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2,
                                     target: self,
                                     selector: #selector(timerCallBack),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func timerCallBack() {
        var item = visibleCellIndexPath().item
        if item == colors.count * 3 - 1 {
            carouselView.scrollToItem(at: IndexPath(item: colors.count * 2 - 1, section: 0),
                                    at: .centeredHorizontally,
                                    animated: false)
            item = colors.count * 2 - 1
        }
        
        item += 1
        carouselView.scrollToItem(at: IndexPath(item: item, section: 0),
                                  at: .centeredHorizontally,
                                  animated: true)
        let unitCount: Int = item % colors.count + 1
        progress?.completedUnitCount = Int64(unitCount)
        carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
    }

}

extension CarouselViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = colors[indexPath.item % colors.count]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? CarouselCollectionViewCell {
            
            cell.backgroundColor = color
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension CarouselViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        invalidateTimer()
        activateTimer()
        
        var item = visibleCellIndexPath().item
        if item == colors.count * 3 - 2 {
            item = colors.count * 2
        } else if item == 1 {
            item = colors.count + 1
        }
        carouselView.scrollToItem(at: IndexPath(item: item, section: 0),
                                  at: .centeredHorizontally,
                                  animated: false)
        
        let unitCount: Int = item % colors.count + 1
        progress?.completedUnitCount = Int64(unitCount)
        carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
    }
    
}

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 300)
    }
}

final class CarouselCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: CarouselCollectionViewCell.self)
    
}

