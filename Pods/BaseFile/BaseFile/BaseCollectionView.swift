
import UIKit
open class BaseCollectionView : UICollectionView {
    open var dataArray = NSMutableArray()
    open var urlString = ""
    var curPage = 0
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(frame: CGRect) {
        let lay = UICollectionViewFlowLayout()
        lay.itemSize = CGSize(width: 100, height: 100)
        lay.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        lay.minimumInteritemSpacing = 10
        lay.minimumLineSpacing = 10
        lay.scrollDirection = .vertical
        self.init(frame: frame, collectionViewLayout: lay)
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        alwaysBounceVertical = true
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    deinit {
    }
}


