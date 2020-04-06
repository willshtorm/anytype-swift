// DO NOT EDIT.
//
// Generated by the AnytypeSwiftCodegen.
//
// For information on using the generated types, please see the documentation:
//   https://github.com/anytypeio/anytype-swift-codegen

import Combine
import Foundation
import Lib
import SwiftProtobuf

extension Anytype_Rpc.Account.Create.Request {
  init(name: String, avatar: Anytype_Rpc.Account.Create.Request.OneOf_Avatar?) {
    self.name = name
    self.avatar = avatar
  }
}

extension Anytype_Rpc.Account.Create.Response {
  init(error: Anytype_Rpc.Account.Create.Response.Error, account: Anytype_Model_Account) {
    self.error = error
    self.account = account
  }
}

extension Anytype_Rpc.Account.Create.Response.Error {
  init(code: Anytype_Rpc.Account.Create.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Account.Recover.Response {
  init(error: Anytype_Rpc.Account.Recover.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Account.Recover.Response.Error {
  init(code: Anytype_Rpc.Account.Recover.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Account.Select.Request {
  init(id: String, rootPath: String) {
    self.id = id
    self.rootPath = rootPath
  }
}

extension Anytype_Rpc.Account.Select.Response {
  init(error: Anytype_Rpc.Account.Select.Response.Error, account: Anytype_Model_Account) {
    self.error = error
    self.account = account
  }
}

extension Anytype_Rpc.Account.Select.Response.Error {
  init(code: Anytype_Rpc.Account.Select.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Account.Stop.Request {
  init(removeData: Bool) {
    self.removeData = removeData
  }
}

extension Anytype_Rpc.Account.Stop.Response {
  init(error: Anytype_Rpc.Account.Stop.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Account.Stop.Response.Error {
  init(code: Anytype_Rpc.Account.Stop.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Bookmark.Fetch.Request {
  init(contextID: String, blockID: String, url: String) {
    self.contextID = contextID
    self.blockID = blockID
    self.url = url
  }
}

extension Anytype_Rpc.Block.Bookmark.Fetch.Response {
  init(error: Anytype_Rpc.Block.Bookmark.Fetch.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Bookmark.Fetch.Response.Error {
  init(code: Anytype_Rpc.Block.Bookmark.Fetch.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Close.Request {
  init(contextID: String, blockID: String) {
    self.contextID = contextID
    self.blockID = blockID
  }
}

extension Anytype_Rpc.Block.Close.Response {
  init(error: Anytype_Rpc.Block.Close.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Close.Response.Error {
  init(code: Anytype_Rpc.Block.Close.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Copy.Request {
  init(contextID: String, blocks: [Anytype_Model_Block]) {
    self.contextID = contextID
    self.blocks = blocks
  }
}

extension Anytype_Rpc.Block.Copy.Response {
  init(error: Anytype_Rpc.Block.Copy.Response.Error, html: String) {
    self.error = error
    self.html = html
  }
}

extension Anytype_Rpc.Block.Copy.Response.Error {
  init(code: Anytype_Rpc.Block.Copy.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Create.Request {
  init(contextID: String, targetID: String, block: Anytype_Model_Block, position: Anytype_Model_Block.Position) {
    self.contextID = contextID
    self.targetID = targetID
    self.block = block
    self.position = position
  }
}

extension Anytype_Rpc.Block.Create.Response {
  init(error: Anytype_Rpc.Block.Create.Response.Error, blockID: String) {
    self.error = error
    self.blockID = blockID
  }
}

extension Anytype_Rpc.Block.Create.Response.Error {
  init(code: Anytype_Rpc.Block.Create.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.CreatePage.Request {
  init(contextID: String, targetID: String, details: SwiftProtobuf.Google_Protobuf_Struct, position: Anytype_Model_Block.Position) {
    self.contextID = contextID
    self.targetID = targetID
    self.details = details
    self.position = position
  }
}

extension Anytype_Rpc.Block.CreatePage.Response {
  init(error: Anytype_Rpc.Block.CreatePage.Response.Error, blockID: String, targetID: String) {
    self.error = error
    self.blockID = blockID
    self.targetID = targetID
  }
}

extension Anytype_Rpc.Block.CreatePage.Response.Error {
  init(code: Anytype_Rpc.Block.CreatePage.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Cut.Request {
  init(contextID: String, blocks: [Anytype_Model_Block]) {
    self.contextID = contextID
    self.blocks = blocks
  }
}

extension Anytype_Rpc.Block.Cut.Response {
  init(error: Anytype_Rpc.Block.Cut.Response.Error, textSlot: String, htmlSlot: String, anySlot: [Anytype_Model_Block]) {
    self.error = error
    self.textSlot = textSlot
    self.htmlSlot = htmlSlot
    self.anySlot = anySlot
  }
}

extension Anytype_Rpc.Block.Cut.Response.Error {
  init(code: Anytype_Rpc.Block.Cut.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.CutBreadcrumbs.Request {
  init(breadcrumbsID: String, index: Int32) {
    self.breadcrumbsID = breadcrumbsID
    self.index = index
  }
}

extension Anytype_Rpc.Block.CutBreadcrumbs.Response {
  init(error: Anytype_Rpc.Block.CutBreadcrumbs.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.CutBreadcrumbs.Response.Error {
  init(code: Anytype_Rpc.Block.CutBreadcrumbs.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Download.Request {
  init(contextID: String, blockID: String) {
    self.contextID = contextID
    self.blockID = blockID
  }
}

extension Anytype_Rpc.Block.Download.Response {
  init(error: Anytype_Rpc.Block.Download.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Download.Response.Error {
  init(code: Anytype_Rpc.Block.Download.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Export.Request {
  init(contextID: String, blocks: [Anytype_Model_Block]) {
    self.contextID = contextID
    self.blocks = blocks
  }
}

extension Anytype_Rpc.Block.Export.Response {
  init(error: Anytype_Rpc.Block.Export.Response.Error, path: String) {
    self.error = error
    self.path = path
  }
}

extension Anytype_Rpc.Block.Export.Response.Error {
  init(code: Anytype_Rpc.Block.Export.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Get.Marks.Request {
  init(contextID: String, blockID: String, range: Anytype_Model_Range) {
    self.contextID = contextID
    self.blockID = blockID
    self.range = range
  }
}

extension Anytype_Rpc.Block.Get.Marks.Response {
  init(error: Anytype_Rpc.Block.Get.Marks.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Get.Marks.Response.Error {
  init(code: Anytype_Rpc.Block.Get.Marks.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Merge.Request {
  init(contextID: String, firstBlockID: String, secondBlockID: String) {
    self.contextID = contextID
    self.firstBlockID = firstBlockID
    self.secondBlockID = secondBlockID
  }
}

extension Anytype_Rpc.Block.Merge.Response {
  init(error: Anytype_Rpc.Block.Merge.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Merge.Response.Error {
  init(code: Anytype_Rpc.Block.Merge.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Open.Request {
  init(contextID: String, blockID: String, breadcrumbsIds: [String]) {
    self.contextID = contextID
    self.blockID = blockID
    self.breadcrumbsIds = breadcrumbsIds
  }
}

extension Anytype_Rpc.Block.Open.Response {
  init(error: Anytype_Rpc.Block.Open.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Open.Response.Error {
  init(code: Anytype_Rpc.Block.Open.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.OpenBreadcrumbs.Request {
  init(contextID: String) {
    self.contextID = contextID
  }
}

extension Anytype_Rpc.Block.OpenBreadcrumbs.Response {
  init(error: Anytype_Rpc.Block.OpenBreadcrumbs.Response.Error, blockID: String) {
    self.error = error
    self.blockID = blockID
  }
}

extension Anytype_Rpc.Block.OpenBreadcrumbs.Response.Error {
  init(code: Anytype_Rpc.Block.OpenBreadcrumbs.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Paste.Request {
  init(contextID: String, focusedBlockID: String, selectedTextRange: Anytype_Model_Range, selectedBlockIds: [String], textSlot: String, htmlSlot: String, anySlot: [Anytype_Model_Block]) {
    self.contextID = contextID
    self.focusedBlockID = focusedBlockID
    self.selectedTextRange = selectedTextRange
    self.selectedBlockIds = selectedBlockIds
    self.textSlot = textSlot
    self.htmlSlot = htmlSlot
    self.anySlot = anySlot
  }
}

extension Anytype_Rpc.Block.Paste.Response {
  init(error: Anytype_Rpc.Block.Paste.Response.Error, blockIds: [String]) {
    self.error = error
    self.blockIds = blockIds
  }
}

extension Anytype_Rpc.Block.Paste.Response.Error {
  init(code: Anytype_Rpc.Block.Paste.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Redo.Request {
  init(contextID: String) {
    self.contextID = contextID
  }
}

extension Anytype_Rpc.Block.Redo.Response {
  init(error: Anytype_Rpc.Block.Redo.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Redo.Response.Error {
  init(code: Anytype_Rpc.Block.Redo.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Replace.Request {
  init(contextID: String, blockID: String, block: Anytype_Model_Block) {
    self.contextID = contextID
    self.blockID = blockID
    self.block = block
  }
}

extension Anytype_Rpc.Block.Replace.Response {
  init(error: Anytype_Rpc.Block.Replace.Response.Error, blockID: String) {
    self.error = error
    self.blockID = blockID
  }
}

extension Anytype_Rpc.Block.Replace.Response.Error {
  init(code: Anytype_Rpc.Block.Replace.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Details.Detail {
  init(key: String, value: SwiftProtobuf.Google_Protobuf_Value) {
    self.key = key
    self.value = value
  }
}

extension Anytype_Rpc.Block.Set.Details.Request {
  init(contextID: String, details: [Anytype_Rpc.Block.Set.Details.Detail]) {
    self.contextID = contextID
    self.details = details
  }
}

extension Anytype_Rpc.Block.Set.Details.Response {
  init(error: Anytype_Rpc.Block.Set.Details.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Details.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Details.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Fields.Request {
  init(contextID: String, blockID: String, fields: SwiftProtobuf.Google_Protobuf_Struct) {
    self.contextID = contextID
    self.blockID = blockID
    self.fields = fields
  }
}

extension Anytype_Rpc.Block.Set.Fields.Response {
  init(error: Anytype_Rpc.Block.Set.Fields.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Fields.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Fields.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.File.Name.Request {
  init(contextID: String, blockID: String, name: String) {
    self.contextID = contextID
    self.blockID = blockID
    self.name = name
  }
}

extension Anytype_Rpc.Block.Set.File.Name.Response {
  init(error: Anytype_Rpc.Block.Set.File.Name.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.File.Name.Response.Error {
  init(code: Anytype_Rpc.Block.Set.File.Name.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Image.Name.Request {
  init(contextID: String, blockID: String, name: String) {
    self.contextID = contextID
    self.blockID = blockID
    self.name = name
  }
}

extension Anytype_Rpc.Block.Set.Image.Name.Response {
  init(error: Anytype_Rpc.Block.Set.Image.Name.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Image.Name.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Image.Name.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Image.Width.Request {
  init(contextID: String, blockID: String, width: Int32) {
    self.contextID = contextID
    self.blockID = blockID
    self.width = width
  }
}

extension Anytype_Rpc.Block.Set.Image.Width.Response {
  init(error: Anytype_Rpc.Block.Set.Image.Width.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Image.Width.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Image.Width.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Link.TargetBlockId.Request {
  init(contextID: String, blockID: String, targetBlockID: String) {
    self.contextID = contextID
    self.blockID = blockID
    self.targetBlockID = targetBlockID
  }
}

extension Anytype_Rpc.Block.Set.Link.TargetBlockId.Response {
  init(error: Anytype_Rpc.Block.Set.Link.TargetBlockId.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Link.TargetBlockId.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Link.TargetBlockId.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Page.IsArchived.Request {
  init(contextID: String, blockID: String, isArchived: Bool) {
    self.contextID = contextID
    self.blockID = blockID
    self.isArchived = isArchived
  }
}

extension Anytype_Rpc.Block.Set.Page.IsArchived.Response {
  init(error: Anytype_Rpc.Block.Set.Page.IsArchived.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Page.IsArchived.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Page.IsArchived.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Restrictions.Request {
  init(contextID: String, blockID: String, restrictions: Anytype_Model_Block.Restrictions) {
    self.contextID = contextID
    self.blockID = blockID
    self.restrictions = restrictions
  }
}

extension Anytype_Rpc.Block.Set.Restrictions.Response {
  init(error: Anytype_Rpc.Block.Set.Restrictions.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Restrictions.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Restrictions.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Text.Checked.Request {
  init(contextID: String, blockID: String, checked: Bool) {
    self.contextID = contextID
    self.blockID = blockID
    self.checked = checked
  }
}

extension Anytype_Rpc.Block.Set.Text.Checked.Response {
  init(error: Anytype_Rpc.Block.Set.Text.Checked.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Text.Checked.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Text.Checked.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Text.Color.Request {
  init(contextID: String, blockID: String, color: String) {
    self.contextID = contextID
    self.blockID = blockID
    self.color = color
  }
}

extension Anytype_Rpc.Block.Set.Text.Color.Response {
  init(error: Anytype_Rpc.Block.Set.Text.Color.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Text.Color.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Text.Color.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Text.Style.Request {
  init(contextID: String, blockID: String, style: Anytype_Model_Block.Content.Text.Style) {
    self.contextID = contextID
    self.blockID = blockID
    self.style = style
  }
}

extension Anytype_Rpc.Block.Set.Text.Style.Response {
  init(error: Anytype_Rpc.Block.Set.Text.Style.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Text.Style.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Text.Style.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Text.Text.Request {
  init(contextID: String, blockID: String, text: String, marks: Anytype_Model_Block.Content.Text.Marks) {
    self.contextID = contextID
    self.blockID = blockID
    self.text = text
    self.marks = marks
  }
}

extension Anytype_Rpc.Block.Set.Text.Text.Response {
  init(error: Anytype_Rpc.Block.Set.Text.Text.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Text.Text.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Text.Text.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Video.Name.Request {
  init(contextID: String, blockID: String, name: String) {
    self.contextID = contextID
    self.blockID = blockID
    self.name = name
  }
}

extension Anytype_Rpc.Block.Set.Video.Name.Response {
  init(error: Anytype_Rpc.Block.Set.Video.Name.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Video.Name.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Video.Name.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Set.Video.Width.Request {
  init(contextID: String, blockID: String, width: Int32) {
    self.contextID = contextID
    self.blockID = blockID
    self.width = width
  }
}

extension Anytype_Rpc.Block.Set.Video.Width.Response {
  init(error: Anytype_Rpc.Block.Set.Video.Width.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Set.Video.Width.Response.Error {
  init(code: Anytype_Rpc.Block.Set.Video.Width.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Split.Request {
  init(contextID: String, blockID: String, cursorPosition: Int32, style: Anytype_Model_Block.Content.Text.Style) {
    self.contextID = contextID
    self.blockID = blockID
    self.cursorPosition = cursorPosition
    self.style = style
  }
}

extension Anytype_Rpc.Block.Split.Response {
  init(error: Anytype_Rpc.Block.Split.Response.Error, blockID: String) {
    self.error = error
    self.blockID = blockID
  }
}

extension Anytype_Rpc.Block.Split.Response.Error {
  init(code: Anytype_Rpc.Block.Split.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Undo.Request {
  init(contextID: String) {
    self.contextID = contextID
  }
}

extension Anytype_Rpc.Block.Undo.Response {
  init(error: Anytype_Rpc.Block.Undo.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Undo.Response.Error {
  init(code: Anytype_Rpc.Block.Undo.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Unlink.Request {
  init(contextID: String, blockIds: [String]) {
    self.contextID = contextID
    self.blockIds = blockIds
  }
}

extension Anytype_Rpc.Block.Unlink.Response {
  init(error: Anytype_Rpc.Block.Unlink.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Unlink.Response.Error {
  init(code: Anytype_Rpc.Block.Unlink.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Block.Upload.Request {
  init(contextID: String, blockID: String, filePath: String, url: String) {
    self.contextID = contextID
    self.blockID = blockID
    self.filePath = filePath
    self.url = url
  }
}

extension Anytype_Rpc.Block.Upload.Response {
  init(error: Anytype_Rpc.Block.Upload.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Block.Upload.Response.Error {
  init(code: Anytype_Rpc.Block.Upload.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.BlockList.Duplicate.Request {
  init(contextID: String, targetID: String, blockIds: [String], position: Anytype_Model_Block.Position) {
    self.contextID = contextID
    self.targetID = targetID
    self.blockIds = blockIds
    self.position = position
  }
}

extension Anytype_Rpc.BlockList.Duplicate.Response {
  init(error: Anytype_Rpc.BlockList.Duplicate.Response.Error, blockIds: [String]) {
    self.error = error
    self.blockIds = blockIds
  }
}

extension Anytype_Rpc.BlockList.Duplicate.Response.Error {
  init(code: Anytype_Rpc.BlockList.Duplicate.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.BlockList.Move.Request {
  init(contextID: String, blockIds: [String], targetContextID: String, dropTargetID: String, position: Anytype_Model_Block.Position) {
    self.contextID = contextID
    self.blockIds = blockIds
    self.targetContextID = targetContextID
    self.dropTargetID = dropTargetID
    self.position = position
  }
}

extension Anytype_Rpc.BlockList.Move.Response {
  init(error: Anytype_Rpc.BlockList.Move.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.BlockList.Move.Response.Error {
  init(code: Anytype_Rpc.BlockList.Move.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.BlockList.MoveToNewPage.Request {
  init(contextID: String, blockIds: [String], block: Anytype_Model_Block, dropTargetID: String, position: Anytype_Model_Block.Position) {
    self.contextID = contextID
    self.blockIds = blockIds
    self.block = block
    self.dropTargetID = dropTargetID
    self.position = position
  }
}

extension Anytype_Rpc.BlockList.MoveToNewPage.Response {
  init(error: Anytype_Rpc.BlockList.MoveToNewPage.Response.Error, linkID: String) {
    self.error = error
    self.linkID = linkID
  }
}

extension Anytype_Rpc.BlockList.MoveToNewPage.Response.Error {
  init(code: Anytype_Rpc.BlockList.MoveToNewPage.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.BlockList.Set.Align.Request {
  init(contextID: String, blockIds: [String], align: Anytype_Model_Block.Align) {
    self.contextID = contextID
    self.blockIds = blockIds
    self.align = align
  }
}

extension Anytype_Rpc.BlockList.Set.Align.Response {
  init(error: Anytype_Rpc.BlockList.Set.Align.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.BlockList.Set.Align.Response.Error {
  init(code: Anytype_Rpc.BlockList.Set.Align.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.BlockList.Set.BackgroundColor.Request {
  init(contextID: String, blockIds: [String], color: String) {
    self.contextID = contextID
    self.blockIds = blockIds
    self.color = color
  }
}

extension Anytype_Rpc.BlockList.Set.BackgroundColor.Response {
  init(error: Anytype_Rpc.BlockList.Set.BackgroundColor.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.BlockList.Set.BackgroundColor.Response.Error {
  init(code: Anytype_Rpc.BlockList.Set.BackgroundColor.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.BlockList.Set.Fields.Request {
  init(contextID: String, blockFields: [Anytype_Rpc.BlockList.Set.Fields.Request.BlockField]) {
    self.contextID = contextID
    self.blockFields = blockFields
  }
}

extension Anytype_Rpc.BlockList.Set.Fields.Request.BlockField {
  init(blockID: String, fields: SwiftProtobuf.Google_Protobuf_Struct) {
    self.blockID = blockID
    self.fields = fields
  }
}

extension Anytype_Rpc.BlockList.Set.Fields.Response {
  init(error: Anytype_Rpc.BlockList.Set.Fields.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.BlockList.Set.Fields.Response.Error {
  init(code: Anytype_Rpc.BlockList.Set.Fields.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.BlockList.Set.Text.Color.Request {
  init(contextID: String, blockIds: [String], color: String) {
    self.contextID = contextID
    self.blockIds = blockIds
    self.color = color
  }
}

extension Anytype_Rpc.BlockList.Set.Text.Color.Response {
  init(error: Anytype_Rpc.BlockList.Set.Text.Color.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.BlockList.Set.Text.Color.Response.Error {
  init(code: Anytype_Rpc.BlockList.Set.Text.Color.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.BlockList.Set.Text.Style.Request {
  init(contextID: String, blockIds: [String], style: Anytype_Model_Block.Content.Text.Style) {
    self.contextID = contextID
    self.blockIds = blockIds
    self.style = style
  }
}

extension Anytype_Rpc.BlockList.Set.Text.Style.Response {
  init(error: Anytype_Rpc.BlockList.Set.Text.Style.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.BlockList.Set.Text.Style.Response.Error {
  init(code: Anytype_Rpc.BlockList.Set.Text.Style.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Config.Get.Response {
  init(error: Anytype_Rpc.Config.Get.Response.Error, homeBlockID: String, archiveBlockID: String, gatewayURL: String) {
    self.error = error
    self.homeBlockID = homeBlockID
    self.archiveBlockID = archiveBlockID
    self.gatewayURL = gatewayURL
  }
}

extension Anytype_Rpc.Config.Get.Response.Error {
  init(code: Anytype_Rpc.Config.Get.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.ExternalDrop.Content.Request {
  init(contextID: String, focusedBlockID: String, content: Data) {
    self.contextID = contextID
    self.focusedBlockID = focusedBlockID
    self.content = content
  }
}

extension Anytype_Rpc.ExternalDrop.Content.Response {
  init(error: Anytype_Rpc.ExternalDrop.Content.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.ExternalDrop.Content.Response.Error {
  init(code: Anytype_Rpc.ExternalDrop.Content.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.ExternalDrop.Files.Request {
  init(contextID: String, dropTargetID: String, position: Anytype_Model_Block.Position, localFilePaths: [String]) {
    self.contextID = contextID
    self.dropTargetID = dropTargetID
    self.position = position
    self.localFilePaths = localFilePaths
  }
}

extension Anytype_Rpc.ExternalDrop.Files.Response {
  init(error: Anytype_Rpc.ExternalDrop.Files.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.ExternalDrop.Files.Response.Error {
  init(code: Anytype_Rpc.ExternalDrop.Files.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Ipfs.File.Get.Request {
  init(id: String) {
    self.id = id
  }
}

extension Anytype_Rpc.Ipfs.File.Get.Response {
  init(error: Anytype_Rpc.Ipfs.File.Get.Response.Error, data: Data, media: String, name: String) {
    self.error = error
    self.data = data
    self.media = media
    self.name = name
  }
}

extension Anytype_Rpc.Ipfs.File.Get.Response.Error {
  init(code: Anytype_Rpc.Ipfs.File.Get.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Ipfs.Image.Get.Blob.Request {
  init(hash: String, wantWidth: Int32) {
    self.hash = hash
    self.wantWidth = wantWidth
  }
}

extension Anytype_Rpc.Ipfs.Image.Get.Blob.Response {
  init(error: Anytype_Rpc.Ipfs.Image.Get.Blob.Response.Error, blob: Data) {
    self.error = error
    self.blob = blob
  }
}

extension Anytype_Rpc.Ipfs.Image.Get.Blob.Response.Error {
  init(code: Anytype_Rpc.Ipfs.Image.Get.Blob.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Ipfs.Image.Get.File.Request {
  init(hash: String, wantWidth: Int32) {
    self.hash = hash
    self.wantWidth = wantWidth
  }
}

extension Anytype_Rpc.Ipfs.Image.Get.File.Response {
  init(error: Anytype_Rpc.Ipfs.Image.Get.File.Response.Error, localPath: String) {
    self.error = error
    self.localPath = localPath
  }
}

extension Anytype_Rpc.Ipfs.Image.Get.File.Response.Error {
  init(code: Anytype_Rpc.Ipfs.Image.Get.File.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.LinkPreview.Request {
  init(url: String) {
    self.url = url
  }
}

extension Anytype_Rpc.LinkPreview.Response {
  init(error: Anytype_Rpc.LinkPreview.Response.Error, linkPreview: Anytype_Model_LinkPreview) {
    self.error = error
    self.linkPreview = linkPreview
  }
}

extension Anytype_Rpc.LinkPreview.Response.Error {
  init(code: Anytype_Rpc.LinkPreview.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Log.Send.Request {
  init(message: String, level: Anytype_Rpc.Log.Send.Request.Level) {
    self.message = message
    self.level = level
  }
}

extension Anytype_Rpc.Log.Send.Response {
  init(error: Anytype_Rpc.Log.Send.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Log.Send.Response.Error {
  init(code: Anytype_Rpc.Log.Send.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Ping.Request {
  init(index: Int32, numberOfEventsToSend: Int32) {
    self.index = index
    self.numberOfEventsToSend = numberOfEventsToSend
  }
}

extension Anytype_Rpc.Ping.Response {
  init(error: Anytype_Rpc.Ping.Response.Error, index: Int32) {
    self.error = error
    self.index = index
  }
}

extension Anytype_Rpc.Ping.Response.Error {
  init(code: Anytype_Rpc.Ping.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Process.Cancel.Request {
  init(id: String) {
    self.id = id
  }
}

extension Anytype_Rpc.Process.Cancel.Response {
  init(error: Anytype_Rpc.Process.Cancel.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Process.Cancel.Response.Error {
  init(code: Anytype_Rpc.Process.Cancel.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.UploadFile.Request {
  init(url: String, localPath: String, type: Anytype_Model_Block.Content.File.TypeEnum) {
    self.url = url
    self.localPath = localPath
    self.type = type
  }
}

extension Anytype_Rpc.UploadFile.Response {
  init(error: Anytype_Rpc.UploadFile.Response.Error, hash: String) {
    self.error = error
    self.hash = hash
  }
}

extension Anytype_Rpc.UploadFile.Response.Error {
  init(code: Anytype_Rpc.UploadFile.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Version.Get.Response {
  init(error: Anytype_Rpc.Version.Get.Response.Error, version: String, details: String) {
    self.error = error
    self.version = version
    self.details = details
  }
}

extension Anytype_Rpc.Version.Get.Response.Error {
  init(code: Anytype_Rpc.Version.Get.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Wallet.Create.Request {
  init(rootPath: String) {
    self.rootPath = rootPath
  }
}

extension Anytype_Rpc.Wallet.Create.Response {
  init(error: Anytype_Rpc.Wallet.Create.Response.Error, mnemonic: String) {
    self.error = error
    self.mnemonic = mnemonic
  }
}

extension Anytype_Rpc.Wallet.Create.Response.Error {
  init(code: Anytype_Rpc.Wallet.Create.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}

extension Anytype_Rpc.Wallet.Recover.Request {
  init(rootPath: String, mnemonic: String) {
    self.rootPath = rootPath
    self.mnemonic = mnemonic
  }
}

extension Anytype_Rpc.Wallet.Recover.Response {
  init(error: Anytype_Rpc.Wallet.Recover.Response.Error) {
    self.error = error
  }
}

extension Anytype_Rpc.Wallet.Recover.Response.Error {
  init(code: Anytype_Rpc.Wallet.Recover.Response.Error.Code, description_p: String) {
    self.code = code
    self.description_p = description_p
  }
}
