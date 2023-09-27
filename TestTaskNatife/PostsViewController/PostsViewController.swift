//
//  ViewController.swift
//  TestTaskNatife
//
//  Created by Ilya Tovstokory on 05.09.2023.
//

import UIKit

class PostsViewController: UIViewController {
    
    private var posts: [Post] = [Post]()
    
    // MARK: - Views
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(PostsTableViewCell.self, forCellReuseIdentifier: PostsTableViewCell.identifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 250
        return table
    }()
    
    private let sortSegmentedControl: UISegmentedControl = {
        
        let items = ["Feed", "By Date", "By Rating"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(sortSegmentedControl)
        sortSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        navigationItem.titleView = sortSegmentedControl
        
        setupActivityIndicator()
        
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Functions
    
    private func fetchPosts() {
        activityIndicator.startAnimating()
        
        APICaller.shared.getPostsFeed { [weak self] result in
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    self?.posts = posts
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.showPostsErrorAlert()
                }
            }
        }
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            posts.sort { $0.postId < $1.postId }
        case 1:
            posts.sort { $0.timeshamp > $1.timeshamp }
        case 2:
            posts.sort { $0.likes_count > $1.likes_count }
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    private func showPostsErrorAlert() {
        let alert = UIAlertController(title: "Loading error", message: "There was a problem loading the feed, please check your connection and try again.", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Try again", style: .default) { [weak self] (_) in
            self?.fetchPosts()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showPostByIdErrorAlert() {
        let alert = UIAlertController(title: "Loading error", message: "There was a problem loading the post, please check your connection and try again.", preferredStyle: .alert)
        
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        cell.configure(with: Post(postId: post.postId, timeshamp: post.timeshamp, title: post.title, preview_text: post.preview_text, likes_count: post.likes_count))
        
        if cell.descriptionLabel.countLines() <= 3 {
            cell.expandButton.isHidden = true
        } else {
            cell.expandButton.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        
        let postId = post.postId
        
        activityIndicator.startAnimating()
        
        APICaller.shared.getPostById(with: postId) { [weak self] result in
            switch result {
            case .success(let post):
                DispatchQueue.main.async {
                    let vc = DetailsViewController()
                    vc.configure(with: PostById(postId: postId, timeshamp: post.timeshamp, title: post.title, text: post.text, postImage: post.postImage, likes_count: post.likes_count))
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.showPostByIdErrorAlert()
                }
            }
        }
    }
}
