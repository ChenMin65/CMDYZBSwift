//
//  CMPageTitleView.swift
//  DY Copy
//
//  Created by 陈敏 on 2018/3/1.
//  Copyright © 2018年 ChenMin. All rights reserved.
//

import UIKit
private let kScrollLineH : CGFloat = 2
class CMPageTitleView: UIView {
    //mark:- 自定义属性
    private var titles : [String]
    
    private lazy var titleLables : [UILabel] = [UILabel]()
    
    private lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView;
    }()
    
    private lazy var scrollLine : UIView = {
        
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    //mark:- 自定义构造函数
     init(frame: CGRect, titles : [String]) {
    
        self.titles = titles;
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CMPageTitleView{
    
    private func setupUI(){
        //1.添加uiscrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2.添加title对应的lables
        setupTitleLabels()
        
        //3.设置底线和滚动的滑块
        setBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels(){
        
        //确定lable的一些frame值
        
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let lableH : CGFloat = frame.height - kScrollLineH
        let lableY : CGFloat = 0
        
        for (index,title) in titles.enumerated() {
            //1.创建UILable
            let lable = UILabel()

            //2设置Lable的属性
            lable.text = title
            lable.tag = index
            lable.font = UIFont.systemFont(ofSize: 16.0)
            lable.textColor = UIColor.darkGray
            lable.textAlignment = .center

            //3.设置lable的frame 没有必要每次遍历都确定位置 所以放在上面
//            let labelW : CGFloat = frame.width / CGFloat(titles.count)
//            let lableH : CGFloat = frame.height - scrollLineH
            let lableX : CGFloat = labelW * CGFloat(index)
//            let lableY : CGFloat = 0
            lable.frame = CGRect(x: lableX, y: lableY, width: labelW, height: lableH)

            //4.将lable添加到scrollView中
            scrollView.addSubview(lable)
            titleLables.append(lable)
        }
    }

    private func setBottomLineAndScrollLine(){
        
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH :CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        //2.添加scrollView;
        //2.1获取第一个Lable
       guard let fistLable = titleLables.first else {return}
        fistLable.textColor = UIColor.orange
        //2.2设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: fistLable.frame.origin.x, y: frame.height - kScrollLineH, width: fistLable.frame.width, height: kScrollLineH)
        
    }
}
