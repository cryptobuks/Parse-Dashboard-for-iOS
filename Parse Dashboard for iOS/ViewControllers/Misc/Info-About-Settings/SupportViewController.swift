//
//  SupportViewController.swift
//  Parse Dashboard for iOS
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 9/9/17.
//

import UIKit
import EggRating
import StoreKit

final class SupportViewController: UITableViewController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localizable.support.localized
        setupTableView()
        IAPHandler.shared.fetchAvailableProducts(delegate: self)
    }
    
    private func setupTableView() {
        
        tableView.backgroundColor = .groupTableViewBackground
        tableView.contentInset.bottom = 60
        tableView.contentInset.top = 20
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            if IAPHandler.shared.iapProducts.count > 0 {
                IAPHandler.shared.purchase(atIndex: indexPath.row - 1)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 1 {
//                let appId = "1212141622"
//                guard let url = URL(string : "itms-apps:itunes.apple.com/us/app/apple-store/id\(appId)?mt=8&action=write-review") else {
//                    return
//                }
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                EggRating.promptRateUs(in: self)
            } else {
                guard let url = URL(string: "https://github.com/nathantannar4/Parse-Dashboard-for-iOS") else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section >= 1 ) && indexPath.row == 0 {
            return 60
        }
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return IAPHandler.shared.iapProducts.count > 0 ? IAPHandler.shared.iapProducts.count + 1 : 2
        } else if section == 2 {
            return 3
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = .groupTableViewBackground
        cell.textLabel?.numberOfLines = 0
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = Localizable.supportInfo.localized
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            cell.textLabel?.textColor = .darkGray
            cell.selectionStyle = .none
        case 1:
            if indexPath.row == 0 {
                cell.textLabel?.text = Localizable.makeDonation.localized
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
                cell.selectionStyle = .none
                cell.imageView?.image = UIImage(named: "Money")?.scale(to: 30)
                let separatorView = UIView()
                separatorView.backgroundColor = .lightGray
                cell.contentView.addSubview(separatorView)
                separatorView.anchor(cell.textLabel?.bottomAnchor, left: cell.contentView.leftAnchor, right: cell.contentView.rightAnchor, heightConstant: 0.5)
            } else if IAPHandler.shared.iapProducts.count > 0 {
                switch indexPath.row {
                case 1:
                    cell.imageView?.image = UIImage(named: "Coffee")
                    cell.textLabel?.text = IAPHandler.shared.iapProducts[indexPath.row-1].localizedTitle
                    cell.detailTextLabel?.text = IAPHandler.shared.iapPrices[0]
                    cell.imageView?.tintColor = .logoTint
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
                    cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                    cell.accessoryType = .disclosureIndicator
                case 2:
                    cell.imageView?.image = UIImage(named: "Beer")
                    cell.textLabel?.text = IAPHandler.shared.iapProducts[indexPath.row-1].localizedTitle
                    cell.detailTextLabel?.text = IAPHandler.shared.iapPrices[1]
                    cell.imageView?.tintColor = .darkPurpleAccent
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
                    cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                    cell.accessoryType = .disclosureIndicator
                case 3:
                    cell.imageView?.image = UIImage(named: "Meal")
                    cell.textLabel?.text = IAPHandler.shared.iapProducts[indexPath.row-1].localizedTitle
                    cell.detailTextLabel?.text = IAPHandler.shared.iapPrices[2]
                    cell.imageView?.tintColor = .darkPurpleBackground
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
                    cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                    cell.accessoryType = .disclosureIndicator
                default:
                    break
                }
            } else {
                cell.textLabel?.text = "Fetching Donation Options..."
                cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 18)
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = Localizable.fanPrompt.localized
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
                cell.selectionStyle = .none
                cell.imageView?.image = UIImage(named: "Heart")?.scale(to: 30)
                let separatorView = UIView()
                separatorView.backgroundColor = .lightGray
                cell.contentView.addSubview(separatorView)
                separatorView.anchor(cell.textLabel?.bottomAnchor, left: cell.contentView.leftAnchor, right: cell.contentView.rightAnchor, heightConstant: 0.5)
            case 1:
                cell.textLabel?.text = Localizable.ratePrompt.localized
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                cell.imageView?.image = UIImage(named: "Rating")
                cell.accessoryType = .disclosureIndicator
            case 2:
                cell.textLabel?.text = Localizable.starRepoPrompt.localized
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                cell.imageView?.image = UIImage(named: "Star")
                cell.accessoryType = .disclosureIndicator
            default:
                break
            }
        default:
            break
        }
        return cell
    }
}

extension SupportViewController: SKProductsRequestDelegate {

    // MARK: - SKProductsRequestDelegate
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        IAPHandler.shared.iapProducts.removeAll()
        IAPHandler.shared.iapPrices.removeAll()
        
        let products = response.products.sorted { (a, b) -> Bool in
            return a.price.decimalValue < b.price.decimalValue
        }
        
        for product in products {
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = product.priceLocale
            if let price1Str = numberFormatter.string(from: product.price) {
                IAPHandler.shared.iapProducts.append(product)
                IAPHandler.shared.iapPrices.append(price1Str)
                print(product.localizedDescription + "\nfor just \(price1Str)")
            }
        }
        tableView.reloadSections([1], with: .none)
    }
}
