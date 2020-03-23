//
//  PageContentView.swift
//  KMLive
//
//  Created by momo on 2020/3/19.
//  Copyright © 2020 kimReboot. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView:PageContentView, progress:CGFloat, fromIndex:Int, toIndex: Int)
}

private let kContentCellID = "kContentCellID"

class PageContentView: UIView {

    private var childVcs : [UIViewController]
    private weak var parentVc : UIViewController?
//    private var progress : CGFloat
//    private var fromIndex : Int
//    private var toIndex : Int
    private var startOffsetX : CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    private var isForbiddenScrollDelegate = false
    
    private lazy var colletionView : UICollectionView = {[weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
   
        return collectionView
    }()
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC:UIViewController?) {
        self.childVcs = childVCs;
        self.parentVc = parentVC;
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// 对外接口
extension PageContentView {
    func contentViewScroll(to index:Int) {
        
        isForbiddenScrollDelegate = true
        
        let offsetX = CGFloat(index) * colletionView.frame.width
        colletionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

extension PageContentView {
    
    private func setupUI() {
        
        for childVC in childVcs {
            parentVc?.addChild(childVC)
        }
        
        self.addSubview(colletionView)
        colletionView.frame = bounds
    }
}

extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVC = childVcs[indexPath.row]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

extension PageContentView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbiddenScrollDelegate {
            return
        }
        
        var progress : CGFloat
        var fromIndex : Int
        var toIndex : Int
        
        let offsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        let rate = offsetX / scrollViewW
        
        if offsetX > startOffsetX {  // 左滑
            
            fromIndex = Int(floor(rate))
            toIndex = fromIndex + 1
            if toIndex >= childVcs.count {
                toIndex = childVcs.count - 1
            }
            
            progress = rate - CGFloat(fromIndex)
            
            if offsetX - startOffsetX == scrollViewW  {
                progress = 1
                toIndex = fromIndex
            }
            
        } else {  // 右滑
            
            toIndex = Int(floor(rate))
            fromIndex = toIndex + 1
            if fromIndex >= childVcs.count {
                 fromIndex = childVcs.count - 1
            }
            
            progress = 1.0 - (rate - CGFloat(toIndex))
        }
        
        delegate?.pageContentView(contentView: self, progress: progress, fromIndex: fromIndex, toIndex: toIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbiddenScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
}
