//
//  PostsTableViewCell.swift
//  TestTaskNatife
//
//  Created by Ilya Tovstokory on 05.09.2023.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    static let identifier = "PostsTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .darkGray
        button.setTitle("Expand", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(expandButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
    
    public func configure(with model: Post) {
        titleLabel.text = model.title
        descriptionLabel.text = model.preview_text
        likesLabel.text = "❤️\(model.likes_count)"
        dateLabel.text = String(format: "%d days ago", Calendar.current.dateComponents([.day], from: model.timeshamp, to: Date()).day!)
    }
    
    private func applyConstraints() {
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10),
            titleLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
            descriptionLabel.bottomAnchor.constraint(equalTo: likesLabel.topAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10)
        ]
        
        let likesLabelConstraints = [
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            likesLabel.bottomAnchor.constraint(equalTo: expandButton.topAnchor, constant: -10)
        ]
        
        let dateLabelConstraints = [
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: expandButton.topAnchor, constant: -10)
        ]
        
        let expandButtonConstraints = [
            expandButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            expandButton.heightAnchor.constraint(equalToConstant: 50),
            expandButton.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 10),
            expandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            expandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(likesLabelConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
        NSLayoutConstraint.activate(expandButtonConstraints)
    }
}
