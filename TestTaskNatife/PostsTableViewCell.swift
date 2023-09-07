//
//  PostsTableViewCell.swift
//  TestTaskNatife
//
//  Created by Ilya Tovstokory on 05.09.2023.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    static let identifier = "PostsTableViewCell"
    
    private var isExpanded = false
    
    private var isExpandable = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    public let descriptionLabel: UILabel = {
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
    
    public let expandButton: UIButton = {
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
        
        configureContentView()
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func updateDescriptionLabelConstraints() {
        if isExpanded {
            descriptionLabel.numberOfLines = 0
        } else {
            descriptionLabel.numberOfLines = 2
        }
    }
    
    public func configure(with model: Post) {
        titleLabel.text = model.title
        descriptionLabel.text = model.preview_text
        likesLabel.text = "❤️\(model.likes_count)"
        dateLabel.text = String(format: "%d days ago", Calendar.current.dateComponents([.day], from: model.timeshamp, to: Date()).day!)
        
        descriptionLabel.layoutIfNeeded()
        
        if descriptionLabel.countLines() <= 3 {
            expandButton.isHidden = true
        }
        
        isExpanded = descriptionLabel.numberOfLines == 0
        updateDescriptionLabelConstraints()
        
        
    }
    
    @objc private func expandButtonTapped() {
        isExpanded.toggle()
        updateDescriptionLabelConstraints()
        
        if isExpanded {
            expandButton.setTitle("Collapse", for: .normal)
        } else {
            expandButton.setTitle("Expand", for: .normal)
        }
        
        // Пересчитываем высоту ячейки
        if let tableView = superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    private func configureContentView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(expandButton)
        
        expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: likesLabel.topAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            likesLabel.bottomAnchor.constraint(equalTo: expandButton.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: expandButton.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            expandButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            expandButton.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 10),
            expandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            expandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }
}

extension UILabel {
  func countLines() -> Int {
    guard let myText = self.text as NSString? else {
      return 0
    }
    self.layoutIfNeeded()
    let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
    return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
  }
}
