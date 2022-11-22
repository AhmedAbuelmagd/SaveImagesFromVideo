//
//  HomeVC.swift
//  SaveImagesFromVideo
//
//  Created by Ahmed Abuelmagd on 22/11/2022.
//

import UIKit
import AVFoundation

class HomeVC: UIViewController {

    @IBOutlet weak var imagesCV: UICollectionView!
    @IBOutlet weak var selectVideoBtn: UIButton!
    
    var imagesList: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    @IBAction func selectVideoBtnClicked(_ sender: UIButton) {
        actionSheet()
    }
}

extension HomeVC{
    func initUI(){

        for item in [selectVideoBtn, imagesCV]{
            item?.addBorder(borderColor: Colors.C0DACE4, borderWidth: 1)
            item?.addRadius(radius: 10)
        }
        initCV(cv: imagesCV)
    }
    
    func actionSheet(){
        let alert = UIAlertController(title: "Upload File", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default , handler:{ (UIAlertAction)in
            self.upload(isCamera: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Open Gallery", style: .default , handler:{ (UIAlertAction)in
            self.upload()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    func upload(isCamera:Bool = false){
        
        
        
        if isCamera{ AttachmentHandler.shared.openVideoCamera(vc: self)
        }else{ AttachmentHandler.shared.openVideoGallery(vc: self) }
        AttachmentHandler.shared.videoPickedBlock = { [weak self] (videoPath) in
            guard let self = self else { return }
            self.saveImagesFromVdeo(path:videoPath)
        }
    }
    func initCV(cv: UICollectionView){
        cv.delegate = self
        cv.dataSource = self
        cv.registerCVNib(cell: ImagesCVCell.self)
    }
    func saveImagesFromVdeo(path:NSURL){
        let asset = AVURLAsset(url: (path as URL), options: nil)
        let videoDuration = asset.duration
        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceAfter = CMTime.zero
        generator.requestedTimeToleranceBefore = CMTime.zero
        var frameForTimes = [NSValue]()
        let sampleCounts: Int = (Int(videoDuration.seconds) < 30) ? 1 : Int(round(videoDuration.seconds / 30))
        let totalTimeLength = Int(videoDuration.seconds * Double(videoDuration.timescale))
        let step = totalTimeLength / sampleCounts
        
        for i in 0 ..< sampleCounts {
            let cmTime = CMTimeMake(value: Int64(i * step), timescale: Int32(videoDuration.timescale))
            frameForTimes.append(NSValue(time: cmTime))
        }
        
        generator.generateCGImagesAsynchronously(forTimes: frameForTimes, completionHandler: {requestedTime, image, actualTime, result, error in
            DispatchQueue.main.async {
                if let image = image {
                    print(requestedTime.value, requestedTime.seconds, actualTime.value)
                    guard let bluredImage = UIImage(cgImage: image).blurImage(radius: 3) else { return}
                    
                    UIImageWriteToSavedPhotosAlbum(bluredImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    self.imagesList.append(bluredImage)
                    
                    self.imagesCV.reloadData()
                }
            }
        })
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCV(index: indexPath) as ImagesCVCell
        cell.initCell(cellData: imagesList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cVHeight = collectionView.bounds.height
        return CGSize(width: cVHeight, height: cVHeight)
    }
}
