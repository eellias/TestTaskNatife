//
//  Posts.swift
//  TestTaskNatife
//
//  Created by Ilya Tovstokory on 05.09.2023.
//

import Foundation

struct PostsFeed: Codable {
    let posts: [Post]
}

struct PostDetails: Codable {
    let post: PostById
}

struct Post: Codable {
    let postId: Int
    let timeshamp: Date
    let title: String
    let preview_text: String
    let likes_count: Int
}

struct PostById: Codable {
    let postId: Int
    let timeshamp: Date
    let title: String
    let text: String
    let postImage: String
    let likes_count: Int
}
