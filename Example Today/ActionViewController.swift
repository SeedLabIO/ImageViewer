//
//  ActionViewController.swift
//  Example Today
//
//  Created by Alen Liang on 18/01/2018.
//  Copyright © 2018 MailOnline. All rights reserved.
//

import UIKit
import ImageViewer

extension UIImageView: DisplaceableView {}

struct DataItem {
    
    let imageView: UIImageView
    let galleryItem: GalleryItem
}

class ActionViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    
    var items: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageViews = [image1, image2, image3, image4, image5, image6, image7]
        
        for (index, imageView) in imageViews.enumerated() {
            
            guard let imageView = imageView else { continue }
            var galleryItem: GalleryItem!
            
            switch index {
                
            case 2:
                
                galleryItem = GalleryItem.video(fetchPreviewImageBlock: { $0(UIImage(named: "2")!) }, videoURL: URL (string: "http://video.dailymail.co.uk/video/mol/test/2016/09/21/5739239377694275356/1024x576_MP4_5739239377694275356.mp4")!)
                
            case 4:
                
                let myFetchImageBlock: FetchImageBlock = { $0(imageView.image!) }
                
                let itemViewControllerBlock: ItemViewControllerBlock = { index, itemCount, fetchImageBlock, configuration, isInitialController in
                    
                    return AnimatedViewController(index: index, itemCount: itemCount, fetchImageBlock: myFetchImageBlock, configuration: configuration, isInitialController: isInitialController)
                }
                
                galleryItem = GalleryItem.custom(fetchImageBlock: myFetchImageBlock, itemViewControllerBlock: itemViewControllerBlock)
                
            default:
                
                let image = imageView.image ?? UIImage(named: "0")!
                galleryItem = GalleryItem.image { $0(image) }
            }
            
            items.append(DataItem(imageView: imageView, galleryItem: galleryItem))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func done() {
        extensionContext?.completeRequest(returningItems: extensionContext?.inputItems, completionHandler: nil)
    }
    
    @IBAction func showGalleryImageViewer(_ sender: UITapGestureRecognizer) {
        
        guard let displacedView = sender.view as? UIImageView else { return }
        
        guard let displacedViewIndex = items.index(where: { $0.imageView == displacedView }) else { return }
        
        let galleryViewController = GalleryViewController(startIndex: displacedViewIndex, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())
        
        galleryViewController.launchedCompletion = { print("LAUNCHED") }
        galleryViewController.closedCompletion = { print("CLOSED") }
        galleryViewController.swipedToDismissCompletion = { print("SWIPE-DISMISSED") }

        self.presentImageGallery(galleryViewController)
    }
    
    func galleryConfiguration() -> GalleryConfiguration {
        
        return [
            
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            
            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),
            
            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            GalleryConfigurationItem.activityViewByLongPress(false),
            
            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffectStyle.light),
            
            GalleryConfigurationItem.videoControlsColor(.white),
            
            GalleryConfigurationItem.maximumZoomScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),
            
            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),
            
            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),
            
            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),
            
            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),
            
            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),
            
            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50)
        ]
    }
}

extension ActionViewController: GalleryDisplacedViewsDataSource {
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        
        return index < items.count ? items[index].imageView : nil
    }
}

extension ActionViewController: GalleryItemsDataSource {
    
    func itemCount() -> Int {
        
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        
        return items[index].galleryItem
    }
}

extension ActionViewController: GalleryItemsDelegate {
    
    func removeGalleryItem(at index: Int) {
        
        print("remove item at \(index)")
        
        let imageView = items[index].imageView
        imageView.removeFromSuperview()
        items.remove(at: index)
    }
}

// Some external custom UIImageView we want to show in the gallery
class FLSomeAnimatedImage: UIImageView {
}

// Extend ImageBaseController so we get all the functionality for free
class AnimatedViewController: ItemBaseController<FLSomeAnimatedImage> {
}
