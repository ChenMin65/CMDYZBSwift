//
//  CMRecommendViewController.swift
//  DY Copy
//
//  Created by 陈敏 on 2018/3/3.
//  Copyright © 2018年 ChenMin. All rights reserved.
//

import UIKit
private let kItmeMargin : CGFloat = 10
private let kItmeW = (kScreenW - 3 * kItmeMargin) / 2
private let KNormalItmeH = kItmeW * 3 / 4
private let kPrettyItmeH = kItmeW * 4 / 3
private let kHearderViewH : CGFloat = 50
private let kNomalCellID = "kNomalCellID"
private let kPretyCellID = "kPrettyCellID"

private let kHearderViewID = "kHearderViewID"
class CMRecommendViewController: UIViewController {

    //MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = { [unowned self] in
        //1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItmeW, height: KNormalItmeH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItmeMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHearderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItmeMargin, bottom: 0, right: kItmeMargin)
       
        //2.创建CollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        //随着父控件的拉伸而拉伸 解决CollectionView下方显示不全的方法 还有HomeViewController里设置原始View的大小的时候 减去下方TabBar的44高度
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        print(self.view.bounds)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //布局UICollectionViewCell样式
        collectionView.register(UINib(nibName: "CMCollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier: kNomalCellID)
        
        //不同的cell样式
        collectionView.register(UINib(nibName: "CMCollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPretyCellID)
        
        //创建CollectionView的组头
        collectionView.register(UINib(nibName: "CMCollectionHearderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHearderViewID)
     
        return collectionView
    }()
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //设置UI界面
        setupUI()
        
    }
}

//MARK:- 设置UI界面
extension CMRecommendViewController{
    
    private func setupUI(){
        view.addSubview(collectionView)
        
    }
}

//MARK:- 遵守UICollectionView的数据协议
extension CMRecommendViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    //分组cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            
            return 8
        }
        return 4
    }
    
    //CollectionViewCell方法
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //定义Cell
        let cell : UICollectionViewCell!
       
        //判断颜值那组cell
        if indexPath.section == 1 {
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPretyCellID, for: indexPath)
            
        }else{
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNomalCellID, for: indexPath)
        }
        return cell
    }
    
    //CollectionView组头的方法
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1.取出section的hearderView
        let hearderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHearderViewID, for: indexPath)
        
        return hearderView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if indexPath.section == 1{
            
            return CGSize(width: kItmeW, height: kPrettyItmeH)
        }else{
            
            return CGSize(width: kItmeW, height: KNormalItmeH)
        }
    }
    
}







