//
//  CMHomeViewController.swift
//  DY Copy
//
//  Created by 陈敏 on 2018/3/1.
//  Copyright © 2018年 ChenMin. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class CMHomeViewController: UIViewController {
    
    //懒加载属性
    private lazy var pageTitleView : CMPageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatuBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleVeiw = CMPageTitleView(frame: titleFrame, titles: titles)

        return titleVeiw
    }()
    
    private lazy var pageContentView : CMPageContentView = {
        
        //1.确定内容的Frame
        let contentH = kScreenH - kStatuBarH - kNavigationBarH - kTitleViewH
        let contentFrame = CGRect(x: 0, y: kStatuBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        //2.确定所有的自控制器
        var childVcs = [UIViewController]()
        
        for _ in 0..<4{
            let vc = UIViewController()

            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let contentView = CMPageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI界面
        setupUI()
    }

}

// mark:设置UI界面
extension CMHomeViewController{
    
    private func setupUI(){
        // 不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        //1 设置导航栏
        setupNavigationBar()
        
        //2添加TitleView
        view.addSubview(pageTitleView)
        
        //3.添加ContenView
        view.addSubview(pageContentView)
//        pageContentView.backgroundColor = UIColor.orange
        
    }
    
    private func setupNavigationBar(){
        //设置左侧的item
//        let btn = UIButton()
//        btn.setImage(UIImage (named: "logo"), for: .normal)
//        btn.sizeToFit()
        //用构造方法（实例方法）
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //
        let size = CGSize(width: 40, height: 40)
//        let historyBtn = UIButton()
//        historyBtn.setImage(UIImage(named: "image_my_history"), for: .normal)
//        historyBtn.setImage(UIImage(named: "Image_my_history_click"), for: .highlighted)
//        historyBtn.frame = CGRect(origin: point, size: size)
//        let historyItem = UIBarButtonItem(customView: historyBtn)
        
        //在扩展文件里创建一个类方法 --> UIBarButtonItem-Extension
        //类方法调用
//        let historyItem = UIBarButtonItem.creatItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        
        //实例方法的调用
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        
        
//        let searchBtn = UIButton()
//        searchBtn.setImage(UIImage(named: "btn_search"), for: .normal)
//        searchBtn.setImage(UIImage(named: "btn_search_clicked"), for: .highlighted)
//        searchBtn.frame = CGRect(origin: point, size: size)
        //类方法调用
//        let searchItem = UIBarButtonItem.creatItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        
        //实例方法的调用
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        
//        let qrcodeBtn = UIButton()
//        qrcodeBtn.setImage(UIImage(named: "Image_scan"), for: .normal)
//        qrcodeBtn.setImage(UIImage(named: "Image_scan_click"), for: .highlighted)
//        qrcodeBtn.frame = CGRect(origin: point, size: size)
        //类方法调用
//        let qrcodeItem = UIBarButtonItem.creatItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        //实例方法的调用
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)

        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
    
}
