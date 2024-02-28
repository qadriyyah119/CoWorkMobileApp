//
//  WorkspaceReviewPopOverViewController.swift
//  CoWorkMobileApp
//

import UIKit
import Cartography
import RealmSwift

class WorkspaceReviewPopoverViewController: UIViewController {
    
    var workspaceReview: WorkspaceReview? {
        didSet {
            if let workspaceReview = workspaceReview {
                if let user = workspaceReview.user {
                    userProfileNameLabel.text = user.name
                    if let userImageUrl = user.imageUrl {
                        WorkspaceManager.shared.fetchImage(from: userImageUrl) { result in
                            switch result {
                            case .failure(let error):
                                print("Photo Failure: \(error)")
                            case .success(let image):
                                DispatchQueue.main.async {
                                    self.userProfileImage.image = image
                                }
                            }
                        }
                    }
                }
//                ratingText = "\(workspaceReview.rating ?? 0.0)"
                reviewLabel.text = workspaceReview.text
                if let reviewDateString = workspaceReview.timeCreated {
                    reviewDateLabel.text = format(time: reviewDateString)
                }
            }
        }
    }

    private lazy var userProfileImage: CircularImageView = {
       return CircularImageView(radius: 50)
    }()
    
    private lazy var userProfileNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyBoldFont, size: 14)
        label.textColor = .label
        return label
    }()
    
    private lazy var reviewDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 14)
        label.textColor = .label
        return label
    }()
    
    private lazy var nameDateVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userProfileNameLabel,
            reviewDateLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 14)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var userProfileHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userProfileImage,
            nameDateVerticalStackView
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var reviewVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userProfileHorizontalStackView,
            reviewLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .fill
//        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    var reviewId: String
    
    init(reviewId: String) {
        self.reviewId = reviewId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupSubView()
        self.fill(withReviewId: reviewId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.preferredContentSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    private func format(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromStr = dateFormatter.date(from: time)!

        dateFormatter.dateFormat = "MMM d, yyyy"
        let timeFromDate = dateFormatter.string(from: dateFromStr)
        return timeFromDate
    }
    
    func fill(withReviewId id: String) {
        let realm = try? Realm()
        self.workspaceReview = realm?.object(ofType: WorkspaceReview.self, forPrimaryKey: id)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 30
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 300),
            view.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupSubView() {
        self.view.addSubview(reviewVerticalStackView)
        
        constrain(reviewVerticalStackView) { reviewVerticalStackView in
            reviewVerticalStackView.top == reviewVerticalStackView.superview!.top + 12
            reviewVerticalStackView.leading == reviewVerticalStackView.superview!.leading + 16
            reviewVerticalStackView.trailing == reviewVerticalStackView.superview!.trailing - 16
//            reviewVerticalStackView.bottom == reviewVerticalStackView.superview!.bottom - 12
        }
    }
}
