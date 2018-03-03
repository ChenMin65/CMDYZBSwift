//
//  CMPageContentView.swift
//  DY Copy
//
//  Created by 陈敏 on 2018/3/2.
//  Copyright © 2018年 ChenMin. All rights reserved.
//

import UIKit

private let ContenCellID = "ContenCellID"

class CMPageContentView: UIView {

    //mark: -定义属性
    private var childVcs : [UIViewController]
    private var parentViewController : UIViewController
    
    //mark: -懒加载collectionView
    private lazy var collectionView : UICollectionView = {
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
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

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContenCellID)
//        collectionView.re
        return collectionView
    }()
    //mark: -自定义构造函数
    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController) {
        
        self.childVcs = childVcs;
        self.parentViewController = parentViewController
       
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// mark:-设置UI界面
extension CMPageContentView{
    
    private func setupUI(){
        //1.将所有的子控件添加到父控制器中
        for childVc in childVcs{
            
            parentViewController.addChildViewController(childVc)
            
        }
        //2.添加UICollectionView，用在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//mark: -遵守CollectionViewDataSource
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

