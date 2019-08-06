//
//  SearchResultTableViewCell.swift
//  Pilvi
//
//  Created by 이재은 on 05/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Method
    
    func setProperties(_ word: String, part: String) {
        let attributedStr = NSMutableAttributedString(string: word)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor,
                                   value: UIColor.orange,
                                   range: (word as NSString).range(of: part))
        resultLabel.attributedText = attributedStr
    }

}

