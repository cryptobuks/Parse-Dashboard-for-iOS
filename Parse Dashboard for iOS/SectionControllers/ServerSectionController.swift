//
//  ServerSectionController.swift
//  Parse Dashboard for iOS
//
//  Copyright © 2018 Nathan Tannar.
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
//  Created by Nathan Tannar on 4/29/18.
//

import UIKit
import IGListKit

final class ServerSectionController: ListSectionController {
    
    weak var server: ParseServerConfig?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    override func didUpdate(to object: Any) {
        server = object as? ParseServerConfig
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { return .zero }
        return CGSize(width: width - inset.left - inset.right, height: 80)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ServerCell.self, for: self, at: index) as? ServerCell else {
            fatalError()
        }
        cell.bindViewModel(server as Any)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        guard let config = server else { return }
        ParseLite.shared.initialize(with: config)
        let schemasViewController = SchemaViewController()
        viewController?.navigationController?.pushViewController(schemasViewController, animated: true)
    }
    
    override func didHighlightItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) else { return }
        UIView.animate(withDuration: 1) {
            cell.contentView.backgroundColor = UIColor.logoTint
        }
    }
    
    override func didUnhighlightItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) else { return }
        UIView.animate(withDuration: 0.3) {
            cell.contentView.backgroundColor = .darkBlueAccent
        }
    }
    
}
