//
//  ViewController.swift
//  SampleRefreshAnimation
//
//  Created by hajime ito on 2020/02/10.
//  Copyright © 2020 hajime_poi. All rights reserved.
//

import UIKit
import SwiftGifOrigin

typealias TableViewDD = UITableViewDelegate & UITableViewDataSource

class ViewController: UIViewController, TableViewDD {
    
    var myHeaderView: UIView!
    var lastContentOffset: CGFloat = 0
    @IBOutlet weak var myTableView: UITableView!
    
    fileprivate let refreshCtl = UIRefreshControl()
    
    var bilibili = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createHeaderView()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.contentInset.top = 30 //ヘッダーの高さ分下げる
        myTableView.refreshControl = refreshCtl
        refreshCtl.tintColor = .clear // ゲージを透明にする
        refreshCtl.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: .valueChanged)
        
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.addHeaderViewGif()
        if bilibili {
            bilibili = false
        } else {
            bilibili = true
        }
        myTableView.contentInset.top = 130 //ヘッダーの分下げる
        sender.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [],animations: {
                self.myTableView.contentInset.top = 30
            }, completion: nil)
            self.updateHeaderView()
            self.myTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEST",for: indexPath as IndexPath) as! tableViewCell
        if bilibili {
            if indexPath.section == 0 {
                cell.myImageView?.image = UIImage.gif(name: "bili")
                cell.myTextLabel.text = "(- o -)"
            } else {
                cell.myImageView?.image = nil
                cell.myTextLabel.text = "(o w o)"
            }
        } else {
            if indexPath.section == 0 {
                cell.myImageView?.image = nil
                cell.myTextLabel.text = "(- o -)"
            } else {
                cell.myImageView?.image = UIImage.gif(name: "bili2")
                cell.myTextLabel.text = "(o w o)"
            }
        }
        cell.myImageView?.clipsToBounds = true
        return cell
    }
    
}

extension ViewController {
    private func createHeaderView() {
        let displayWidth: CGFloat! = self.view.frame.width
        // 上に余裕を持たせている（後々アニメーションなど追加するため）
        myHeaderView = UIView(frame: CGRect(x: 0, y: -230, width: displayWidth, height: 230))
        myHeaderView.alpha = 1
        myHeaderView.backgroundColor = UIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1)
        myTableView.addSubview(myHeaderView)
        let myLabel = UILabel(frame: CGRect(x: 0, y: 200, width: displayWidth, height: 30))
        if bilibili {
            myLabel.text = "↑"
        } else {
            myLabel.text = "↑"
        }
        myLabel.textAlignment = .center
        myLabel.textColor = .white
        myLabel.alpha = 1
        myHeaderView.addSubview(myLabel)
        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
        if bilibili {
            image.image = UIImage(named: "bili2")
        } else {
            image.image = UIImage(named: "bili")
        }
        
        myHeaderView.addSubview(image)
    }
    
    private func updateHeaderView() {
        let displayWidth: CGFloat! = self.view.frame.width
        for sub in myHeaderView.subviews {
            sub.removeFromSuperview()
        }
        myHeaderView = UIView(frame: CGRect(x: 0, y: -230, width: displayWidth, height: 230))
        myHeaderView.alpha = 1
        myHeaderView.backgroundColor = UIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1)
        myTableView.addSubview(myHeaderView)
        let myLabel = UILabel(frame: CGRect(x: 0, y: 200, width: displayWidth, height: 30))
        if bilibili {
            myLabel.text = "↑"
        } else {
            myLabel.text = "↑"
        }
        myLabel.textAlignment = .center
        myLabel.textColor = .white
        myLabel.alpha = 1
        myHeaderView.addSubview(myLabel)
        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
        if bilibili {
            image.image = UIImage(named: "bili2")
        } else {
            image.image = UIImage(named: "bili")
        }
        
        myHeaderView.addSubview(image)
    }
    
    func addHeaderViewGif() {
        let displayWidth: CGFloat! = self.view.frame.width
        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
        if bilibili {
            image.loadGif(name: "bili2")
        } else {
            image.loadGif(name: "bili")
        }
        myHeaderView.addSubview(image)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.myHeaderView.subviews[1].removeFromSuperview()
        }
    }
}

class tableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextLabel: UILabel!
    @IBOutlet weak var syosaiButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
