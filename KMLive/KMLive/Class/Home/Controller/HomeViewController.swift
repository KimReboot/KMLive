//
//  HomeViewController.swift
//  KMLive
//
//  Created by momo on 2020/3/17.
//  Copyright © 2020 kimReboot. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 50
class HomeViewController: UIViewController {

    private lazy var pageTitleView : PageTitleView = { [weak self] in
//        let viewFrame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: kTitleViewH)
        let viewFrame = CGRect(x: 0, y: 88, width: UIScreen.main.bounds.size.width, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: viewFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView : PageContentView = { [weak self] in
        
        var list = [UIViewController]()
        for _ in 0...3 {
          let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)), a: 1.0)
          list.append(vc)
        }
        
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        let pageView = PageContentView(frame:contentFrame, childVCs: list, parentVC: self)
        pageView.delegate = self
        return pageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension HomeViewController {
    private func setupUI() {
        
        setupNaviBar()
        
        self.view.addSubview(pageTitleView)
        self.view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.orange
    }
    
    private func setupNaviBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
    
    @objc private func clickHistoryButton() {
        NSLog("clickHistoryButton")
    }
    
    @objc private func clickSearchButton() {
        NSLog("clickSearchButton")
    }
    
    @objc private func clickQRCodeButton() {
        NSLog("clickQRCodeButton")
    }
    
    private func createBarButton(imageName:String, highlightImage:String, size:CGSize) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: highlightImage), for: .highlighted)
        button.frame = CGRect(origin: CGPoint(), size: size)
        
        let barButton = UIBarButtonItem(customView: button)
        
        return barButton
    }
}

extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, fromIndex: Int, toIndex: Int) {
        pageTitleView.setTitleViewWithProgress(progress: progress, fromIndex: fromIndex, toIndex: toIndex)
    }
}


extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.contentViewScroll(to: index)
    }
}
