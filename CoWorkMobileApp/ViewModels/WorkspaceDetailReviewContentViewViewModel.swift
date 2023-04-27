//
//  WorkspaceDetailReviewContentViewViewModel.swift
//  CoWorkMobileApp
//


import UIKit
import RealmSwift

class WorkspaceDetailReviewContentViewViewModel {
    
    var workspaceReview: WorkspaceReview? {
        didSet {
            if let workspaceReview = workspaceReview {
                if let user = workspaceReview.user {
                    userNameText = user.name
                    if let userImageUrl = user.imageUrl {
                        WorkspaceManager.shared.fetchImage(from: userImageUrl) { result in
                            switch result {
                            case .failure(let error):
                                print("Photo Failure: \(error)")
                            case .success(let image):
                                DispatchQueue.main.async {
                                    self.userImageCompletion?(image)
                                }
                            }
                        }
                    }
                }
                ratingText = "\(workspaceReview.rating ?? 0.0)"
                reviewText = workspaceReview.text
                if let reviewDateString = workspaceReview.timeCreated {
                   reviewDateText = format(time: reviewDateString)
                }
            }
        }
    }
    
    var userNameText: String?
    var ratingText: String?
    var reviewText: String?
    var userImageUrl: UIImage?
    var reviewDateText: String?
    var userImageCompletion: ((UIImage?) -> Void)?
    let viewMoreText = NSAttributedString (
        string: "Show More",
        attributes: [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
    
    private func format(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromStr = dateFormatter.date(from: time)!

        dateFormatter.dateFormat = "MMM d, yyyy"
        let timeFromDate = dateFormatter.string(from: dateFromStr)
        return timeFromDate
    }
    
    func fill(withReviewId id: String, completion: (() -> Void)? ) {
        let realm = try? Realm()
        self.workspaceReview = realm?.object(ofType: WorkspaceReview.self, forPrimaryKey: id)
        completion?()
    }
}
