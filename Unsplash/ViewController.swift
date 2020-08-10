//
//  ViewController.swift
//  Unsplash
//
//  Created by mmxsound on 2020/08/10.
//  Copyright © 2020 mmxsound. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    var list: [Unsplash] = []
    let disposeBag = DisposeBag()
    let viewModel = ViewModel()
    let maxPage = 10
    var currentPage = 1
    var isReachingEnd = false
    var orderBy: OrderBy = .latest
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomCell")
        
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.requestData()
        self.bindView()
        
        self.button.rx.tap.subscribe(onNext: { [weak self] in
            self?.setupActionSheet()
        }).disposed(by: disposeBag)
    }
}


private extension ViewController {
    
    func setupActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "latest", style: .default, handler: {
             [weak self] (alert: UIAlertAction!) -> Void in
            self?.orderBy = .latest
            self?.requestData()
        })
        
        let saveAction = UIAlertAction(title: "oldest", style: .default, handler: {
            [weak self] (alert: UIAlertAction!) -> Void in
            self?.orderBy = .oldest
            self?.requestData()
        })

        let cancelAction = UIAlertAction(title: "popular", style: .default, handler: {
            [weak self] (alert: UIAlertAction!) -> Void in
            self?.orderBy = .popular
            self?.requestData()
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func bindView() {
        
        self.viewModel.relay.subscribe(onNext: { value in
            self.list = value
        }).disposed(by: disposeBag)
        
        self.viewModel.relay.bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, element: Unsplash) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell else { return UITableViewCell() }
            cell.configureCell(imgUrl: element.urls?.thumb)
            return cell
        }.disposed(by: disposeBag)
    }
    
    func requestData() {
        HTTPBinDefaultAPI.sharedAPI.get(page: currentPage, perPage: maxPage, orderby: orderBy).subscribe(onNext: { [weak self] value in
            if self?.currentPage == 1 {
                self?.viewModel.relay.accept(value)
            } else {
                var currentList = self?.viewModel.relay.value ?? []
                currentList.append(contentsOf: value)
                self?.viewModel.relay.accept(currentList)
            }
            
        }).disposed(by: self.disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.list.count == 0 { return 0 }
        let item = self.list[indexPath.row]
        let width = tableView.frame.width
        let height = CGFloat(item.height ?? 0) * width / CGFloat(item.width ?? 0)
        return height
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if isReachingEnd {
            if self.currentPage <= self.maxPage {
                self.currentPage += 1
                self.requestData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        self.isReachingEnd = isReachingEnd
    }
}
