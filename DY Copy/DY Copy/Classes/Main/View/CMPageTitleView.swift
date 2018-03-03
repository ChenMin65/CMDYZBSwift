//
//  CMPageTitleView.swift
//  DY Copy
//
//  Created by 陈敏 on 2018/3/1.
//  Copyright © 2018年 ChenMin. All rights reserved.
//

import UIKit
// MARK:-定义协议
protocol CMPageTitleViewDelegate : class {
    
    func pageTitleView(titleView : CMPageTitleView, selectedIndex index : Int)
    
}

// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)

// MARK:- 定义CMPageTitleView类
class CMPageTitleView: UIView {
    // MARK:-- 自定义属性
    private var currentIndex : Int = 0
    private var titles : [String]
    
    // MARK:-定义代理属性
    weak var delegate : CMPageTitleViewDelegate?
    
    // MARK:-懒加载属性
    private lazy var titleLables : [UILabel] = [UILabel]()
    private lazy var scrollView : UIScrollView = {
        
        //创建scrollView
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
    // MARK:-自定义构造函数
     init(frame: CGRect, titles : [String]) {
    
        self.titles = titles;
        
        super.init(frame: frame)
        // MARK:- 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 设置UI界面
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
            lable.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
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
            
            //5.给lable添加手势
            lable.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLableClick(tapGes:)))
            lable.addGestureRecognizer(tapGes)
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
        fistLable.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        //2.2设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: fistLable.frame.origin.x, y: frame.height - kScrollLineH, width: fistLable.frame.width, height: kScrollLineH)
        
    }
}
// MARK:- 监听Lable的点击
extension CMPageTitleView{
    
    @objc private func titleLableClick(tapGes : UITapGestureRecognizer){
        //1.获取当前Label的下标值
        guard let currentLable = tapGes.view as? UILabel else {
           
            return
        }
        
        //2.获取之前的Lable
        let oldLable = titleLables[currentIndex]
        
        //3.切换文字颜色
        currentLable.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLable.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        //4.保存最新的Lable的下标值
        currentIndex = currentLable.tag
        
        //5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentLable.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15, animations: {
            
            self.scrollLine.frame.origin.x = scrollLineX
        })
        
        //6.通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//MARK:- 对外暴露的方法
extension CMPageTitleView{
    func setTitleViewProgress(progress : CGFloat, sourceindex : Int, targetIndex : Int){
        //1.取出sourceLable/targetLable
        let sourceLable = titleLables[sourceindex]
        let targetLable = titleLables[targetIndex]
        
        //2.处理滑块的逻辑
        let moveTotalX = targetLable.frame.origin.x - sourceLable.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLable.frame.origin.x + moveX
        
        //3颜色的渐变（复杂）
        //3.1 取出变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        //3.2变化sourceLable
        sourceLable.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        //3.3变化targetLable
        targetLable.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        //4记录最新的index 
        currentIndex = targetIndex
    }
}




