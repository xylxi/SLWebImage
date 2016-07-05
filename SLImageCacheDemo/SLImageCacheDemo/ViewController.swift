//
//  ViewController.swift
//  SLImageCache
//
//  Created by DMW_W on 16/7/4.
//  Copyright © 2016年 XYLXI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        let yepAvatarURLStrings = [
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/84c9a0a9-c6eb-4495-9b50-0d551749956a",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/7cf09c38-355b-4daa-b733-5fede0181e5f",
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-2.jpg",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/0e47196b-1656-4b79-8953-457afaca6f7b",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/e2b84ebe-533d-4845-a842-774de98c8504",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/e24117db-d360-4c0b-8159-c908bf216e38",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/0738b75f-b223-4e34-a61c-add693f99f74",
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-8.jpg",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/134f80a5-d273-4e7c-b490-f0de862c4ac4",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/d0c29846-e064-4b4c-b4aa-bd0bd2d8d435",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/d124dcfe-07ec-4ac6-aaf3-5ba6afd131ad",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/70f6f156-7707-471d-8c98-fcb7d2a6edb1",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/24795538-fc57-428b-843e-211e6b89a00c",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/70a3d702-7769-4616-8410-0a7f5d39d883",
            "https://yep-avatars.s3.cn-north-1.amazonaws.com.cn/db49a8c6-dd2f-464d-8d06-03e7268c7fb4",
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg",
            ]
        for str in yepAvatarURLStrings {
            self.datas.append(NSURL(string: str)!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var datas = [NSURL]()
    
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("SLTableViewCell", forIndexPath: indexPath) as! SLTableViewCell
        cell.model = self.datas[indexPath.row];
        if indexPath.row == 0 {
            print(cell.imgView.sl_url)
        }
        return cell;
    }
}

class SLTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    var model: NSURL! {
        didSet {
            self.imgView.sl_setImageWithURL(model);
        }
    }
}

