//
//  CMPageContentView.swift
//  DY Copy
//
//  Created by 陈敏 on 2018/3/2.
//  Copyright © 2018年 ChenMin. All rights reserved.
//

import UIKit

protocol CMPageContentViewDelegate : class{
    
    func pageContenView(contentView : CMPageContentView, progress : CGFloat, sourceindex : Int, targetIndex : Int)
}

private let ContenCellID = "ContenCellID"

class CMPageContentView: UIView {

    // MARK:- 定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : CMPageContentViewDelegate?
    
   // MARK:- 懒加载collectionView
    private lazy var collectionView : UICollectionView = {[weak self] in
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //水平方向的指示器
        collectionView.showsVerticalScrollIndicator = false
        //是否进行分页显示
        collectionView.isPagingEnabled = true
        //范围大小
        collectionView.bounces = false
        //collecitonView的数据源 遵守协议
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContenCellID)
//        collectionView.re
        return collectionView
    }()
    // MARK:- 自定义构造函数
    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController?) {
        
        self.childVcs = childVcs;
        self.parentViewController = parentViewController
       
        super.init(frame: frame)
        
        // MARK:- 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension CMPageContentView{
    
    private func setupUI(){
        //1.将所有的子控件添加到父控制器中
        for childVc in childVcs{
            
            parentViewController?.addChildViewController(childVc)
            
        }
        //2.添加UICollectionView，用在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK:- 遵守UICollectionViewDelegate
extension CMPageContentView :UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContenCellID, for: indexPath)
        
        //2.给cell设置内容
        //先移除一下View 在重新添加
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
  
}

// MARK:- 遵守UICollectionViewDelegate
extension CMPageContentView :UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        //偏移量
       startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0.判断是否是点击事件
        if isForbidScrollDelegate{ return }
        
        //1.获取需要的数据
        var progress : CGFloat = 0
        var sourceindex : Int = 0
        var targetIndex : Int = 0
        
        //2.判断是左滑还是右滑
        let currenOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currenOffsetX > startOffsetX {   // 左滑
         
            //1.计算progress
            progress = currenOffsetX / scrollViewW - floor(currenOffsetX / scrollViewW)

            //2.计算sourceindex
            sourceindex = Int(currenOffsetX / scrollViewW)
            
            //3.targetIndex
            targetIndex = sourceindex + 1
            if targetIndex >= childVcs.count{
                
                targetIndex = childVcs.count - 1
            }
            //4.如果完全滑过去了
            if currenOffsetX - startOffsetX  == scrollViewW{
                progress = 1
                targetIndex = sourceindex
            }
        }else{    //右滑
         
            //1.计算progress
            progress = 1 - (currenOffsetX / scrollViewW - floor(currenOffsetX / scrollViewW))
            
            //2.计算targetIndex
            targetIndex =  Int(currenOffsetX / scrollViewW)

            //3.计算sourceindex
            sourceindex = targetIndex + 1
            if sourceindex >= childVcs.count{
                
                sourceindex = childVcs.count - 1
            }
        }
        //3.将progress、targetIndex、sourceindex传递给titleView
        print("progress:\(progress) sourceindex:\(sourceindex) targetIndex:\(targetIndex)")
        
        delegate?.pageContenView(contentView: self, progress: progress, sourceindex: sourceindex, targetIndex: targetIndex)
    }
}

// MARK:- 对外暴露的方法
extension CMPageContentView {
    
    func setCurrentIndex(currentIndex : Int){
        
        //1.记录需要禁止执行的代理方法
        isForbidScrollDelegate = true
        
        //2.滚到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x:offsetX, y:0), animated: false)
        
    }
}

