import Foundation

// Getters are located in ObjectDetails+Relations
public enum RelationKey: String {
    case id
    case name
    case snippet
    case iconEmoji
    case iconImage
    case coverId
    case coverType
    case isFavorite
    case description
    case layout
    case layoutAlign
    case done
    case type
    case lastOpenedDate
    case lastModifiedDate
    case featuredRelations
    case relationFormat
    
    case isDeleted
    case isArchived
    case isHidden
    case isReadonly
    case isDraft
    case isHighlighted
    
    case workspaceId
    case fileExt
    case fileMimeType
}