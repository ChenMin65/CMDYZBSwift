//
//  UIBarButtonItem-Extension.swift
//  DY Copy
//
//  Created by 陈敏 on 2018/3/1.
//  Copyright © 2018年 ChenMin. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
   /*
    //类方法的创建
    class func creatItem(imageName : String, highImageName : String, size : CGSize) -> UIBarButtonItem  {
        
        let btn = UIButton()
        let point = CGPoint()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        btn.frame = CGRect(origin: point, size: size)
        return UIBarButtonItem(customView: btn)
    }
    */
    
    //遍利构造函数：条件1>convenience开头 2>在构造函数中必须明确调用一个设计的构造函数（self）
    convenience init(imageName : String, highImageName : String = "", size : CGSize = CGSize()){
//        创建UIButton
        let btn = UIButton()
        let point = CGPoint()
        //设置btn的图片
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highImageName != "" {
            
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        
        //设置btn的尺寸
        if size == CGSize(){
        
            btn.sizeToFit()
        
        }else{
           
            btn.frame = CGRect(origin: point, size: size)

        }
        
        //设置Item
        self.init(customView : btn)
    }
    
}
