//
//  MyTableViewCell.swift
//  SFHW-24.3.3
//
//  Created by Mykhailo Romanovskyi on 31.03.2021.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    let myLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupElements() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElements() {
        addSubview(myLabel)
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        ])
    }
    
}
