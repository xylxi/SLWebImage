//
//  SLWebImage.swift
//  SLImageCache
//
//  Created by DMW_W on 16/7/4.
//  Copyright © 2016年 XYLXI. All rights reserved.
//

import UIKit

struct Resource {
    let downloadURL: NSURL;
    let cachekey:    String;
    init(downloadURL: NSURL, cacheKey: String? = nil) {
        self.downloadURL = downloadURL
        self.cachekey = cacheKey ?? downloadURL.absoluteString
    }
}
// 图片获取途径
enum CacheType {
    case Memory
    case Web
}

class SLImageManager {
    // 单例
    static let shareInstance = SLImageManager()
    // 缓存
    let cache = NSCache()
    let session: NSURLSession
    private init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }
    // 通过串行队列保证，同一时间只用一个线程访问pool变量
    let ioQueue = dispatch_queue_create("com.xylxi.slimage.ioqueue", DISPATCH_QUEUE_SERIAL)
    // 通过全局队列，开启多线程处理工作
    let cacheQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
    
    // 请求池
    let pool = SLTaskPool()
    
    func downloadAndCacheWithSource(resource: Resource,completion: Completion) {
        
        if let image = self.cache.objectForKey(resource.cachekey) as? UIImage {
            // 首先cache
            completion(finished: true, image: image, cacheType: .Memory,ImageURL: resource.downloadURL)
        }else {
            // 开启多线程处理
            let request = Request(completion: completion, resource: resource)
            // 用串行队列保证pool的读写安全
            dispatch_async(self.ioQueue, {
                self.pool.addTask(request)
                // 如果已经有请求就算了
                if self.pool.tasks[resource.downloadURL]!.requests.count > 1 {
                    
                }else {
                    //
                    dispatch_async(self.cacheQueue, {
                        let task = self.session.dataTaskWithURL(resource.downloadURL, completionHandler: { (data, response, error) in
                            var image : UIImage
                            var finish: Bool
                            if let data = data {
                                image = UIImage(data: data) ?? UIImage()
                                finish = UIImage(data: data) == nil ? false : true
                            }else {
                                finish = false;
                                image = UIImage()
                            }
                            dispatch_async(self.ioQueue, {
                                // 缓存
                                self.cache.setObject(image, forKey: resource.cachekey)
                                // 安全访问
                                let requests = self.pool.requestsWithURL(resource.downloadURL)
                                // 遍历
                                dispatch_async(self.cacheQueue, {
                                    requests.forEach({ (request) in
                                        dispatch_async(dispatch_get_main_queue(), {
                                            request.completion(finished: finish, image: image, cacheType: .Web, ImageURL: resource.downloadURL)
                                        })
                                    })
                                })
                                self.pool.removeRequestsWithURL(resource.downloadURL)
                            })
                        })
                        task.resume()
                    })
                }
            })
        }
    }
    
}

extension SLImageManager {
    typealias Completion = (finished: Bool, image: UIImage, cacheType: CacheType, ImageURL: NSURL) -> Void
    // 请求数据
    struct Request {
        let completion: Completion
        let resource: Resource
    }
    // 每一个请求
    class SLTask {
        let URL: NSURL
        var requests = [Request]()
        init(URL: NSURL) {
            self.URL = URL;
        }
    }
    // 请求池
    class SLTaskPool {
        var tasks = [NSURL : SLTask]()
        // 添加任务
        func addTask(request: Request) {
            if let task = self.tasks[request.resource.downloadURL] {
                // 如果请求对应的URL存在
                task.requests.append(request)
            }else {
                let task = SLTask(URL: request.resource.downloadURL)
                task.requests.append(request);
                self.tasks[request.resource.downloadURL] = task;
            }
        }
        
        func requestsWithURL(URL: NSURL) -> [Request] {
            guard let task = tasks[URL] else {
                return []
            }
            return task.requests
        }
        func removeRequestsWithURL(URL: NSURL) {
            tasks.removeValueForKey(URL)
        }
        func removeAllRequests() {
            tasks.removeAll()
        }
    }
}





