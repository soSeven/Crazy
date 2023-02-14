//
//  NewsViewController.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/6.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import Swinject

class NewsViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let news = WebViewController()
        news.url = URL(string: "http://news.shxinger.com/#/")
        navigationController?.pushViewController(news, animated: true)
    }

}
