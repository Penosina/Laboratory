import Foundation
import CoreData

extension ArticleDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleDataModel> {
        return NSFetchRequest<ArticleDataModel>(entityName: "ArticleDataModel")
    }

    @NSManaged public var publishedAt: String?
    @NSManaged public var title: String?
    @NSManaged public var myDescription: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var url: String?
    @NSManaged public var viewCount: Int16
    @NSManaged public var imageData: Data?

}

extension ArticleDataModel : Identifiable {

}
