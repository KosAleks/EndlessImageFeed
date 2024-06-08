import UIKit
import ProgressHUD
import Kingfisher

final class SingleImageViewController: UIViewController {
    private (set) var photos = [Photo]()
    private let imagesListService = ImagesListService()
    private let photo = Photo()
    private let placeholder = UIImage(named: "placeholder")
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var sharingButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage? {
        UIBlockingProgressHUD.show()
        if let url = URL(string: photo.largeImageURL ?? "") {
            imageView.kf.setImage(with: url) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self = self else {return}
                switch result {
                case .success(let imageResult):
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                case .failure:
                    self.showError()
                }
            }
        }
        UIBlockingProgressHUD.dismiss()
        return image
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Something went wrong. Let's try again?",
            message: "",
            preferredStyle: .actionSheet)
        let okActionButton = UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("allert OK button tapped")
            alert.dismiss(animated: true)
            self.dismiss(animated: true)
            if let url = URL(string: self.photo.largeImageURL ?? "") {
                self.imageView.kf.setImage(with: url) { [weak self] result in guard let self = self else {return}
                    switch result {
                    case .success(let imageResult):
                        self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                    case .failure:
                        self.showError()
                    }
                }
            }
        })
            
        let cancelActionButton = UIAlertAction(title: "No, thanks.", style: .default, handler: { _ in
            print("alert NO button tapped")
            alert.dismiss(animated: true)
            self.dismiss(animated: true)
        })
        alert.addAction(okActionButton)
        alert.addAction(cancelActionButton)
            self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = image
        guard let image else {return}
        rescaleAndCenterImageInScrollView(image: image)
        view.backgroundColor = UIColor(named: "YP Black")
    }
  
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSharingButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
