//
//  PageTitleView.swift
//  KMLive
//
//  Created by momo on 2020/3/18.
//  Copyright © 2020 kimReboot. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView:PageTitleView, selectedIndex index: Int)
}

private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectedColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {

    private var titles : [String]
    private var currentIndex : Int = 0
    weak var delegate : PageTitleViewDelegate?
    
    private lazy var scrollerView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var scrollLine : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.orange
        return lineView
    }()
    
    private lazy var titleLabels : [UILabel] = [UILabel]()
    init(frame: CGRect, titles: [String]) {
        
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageTitleView {
    
    private func setupUI() {
        self.addSubview(scrollerView)
        scrollerView.frame = bounds
        
        setupTitleLabels()
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels() {
        
        let w : CGFloat = frame.width/CGFloat(titles.count)
        let h : CGFloat = frame.height - kScrollLineH
        let y : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2, a: 1.0)
            label.textAlignment = .center
            
            let x : CGFloat = w * CGFloat(index)
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            self.addSubview(label)
            
            titleLabels.append(label)
            
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action:#selector(self.doTap(guesture:)))
            label.addGestureRecognizer(tap)
            
        }
    }
    
    @objc func doTap(guesture: UITapGestureRecognizer) {
        
        guard let currentLabel = guesture.view as? UILabel else { return }
        let preLabel = titleLabels[currentIndex]
        
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2, a: 1.0)
        preLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2, a: 1.0)
        
        currentIndex = currentLabel.tag;
        
        let startX = scrollLine.frame.origin.x
        let endX = startX + CGFloat(currentLabel.tag - preLabel.tag) * currentLabel.bounds.width

        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = endX
        }
        
        self.delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
    
    private func setupBottomLineAndScrollLine() {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomView.frame = CGRect(x: 0, y: frame.height-lineH, width: frame.width, height: lineH)
        scrollerView.addSubview(bottomView)
        
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor.orange
        
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        scrollerView.addSubview(scrollLine)
    }
}

extension PageTitleView {
    func setTitleViewWithProgress(progress:CGFloat, fromIndex:Int, toIndex:Int) -> Void {
        NSLog("progress :\(progress), from:\(fromIndex), to: \(toIndex)")
        
        let startX = titleLabels[fromIndex].frame.origin.x
        let endX = titleLabels[toIndex].frame.origin.x
        let totalMoveX = endX - startX
        scrollLine.frame.origin.x = startX + totalMoveX * progress
        
        let colorDelta = (kSelectedColor.0 - kNormalColor.0, kSelectedColor.1 - kNormalColor.1, kSelectedColor.2 - kNormalColor.2)
        titleLabels[fromIndex].textColor = UIColor(r: kSelectedColor.0 - colorDelta.0*progress, g: kSelectedColor.1 - colorDelta.1*progress, b: kSelectedColor.2 - colorDelta.2*progress, a: 1.0)
        titleLabels[toIndex].textColor = UIColor(r: kNormalColor.0+colorDelta.0*progress, g: kNormalColor.1+colorDelta.1*progress, b: kNormalColor.2+colorDelta.2*progress, a: 1.0)
        
        currentIndex = toIndex
    }
}
