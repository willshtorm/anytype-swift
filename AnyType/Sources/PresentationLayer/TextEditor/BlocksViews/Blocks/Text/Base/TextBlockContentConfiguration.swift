//
//  TextBlockContentConfiguration.swift
//  AnyType
//
//  Created by Kovalev Alexander on 10.03.2021.
//  Copyright © 2021 AnyType. All rights reserved.
//

import BlocksModels
import UIKit
import Combine


/// Content configuration for text blocks
struct TextBlockContentConfiguration {
    private(set) var marksPaneActionSubject: PassthroughSubject<MarksPane.Main.Action, Never>
    private(set) var toolbarActionSubject: PassthroughSubject<BaseBlockViewModel.ActionsPayload.Toolbar.Action, Never>
    private(set) weak var textViewDelegate: TextViewDelegate?
    private(set) var viewModel: TextBlockViewModel
    private(set) var information: BlockInformation.InformationModel

    /// text block view model

    /// Block information
    
    init(
         textViewDelegate: TextViewDelegate?,
         viewModel: TextBlockViewModel,
         marksPaneActionSubject: PassthroughSubject<MarksPane.Main.Action, Never>,
         toolbarActionSubject: PassthroughSubject<BaseBlockViewModel.ActionsPayload.Toolbar.Action, Never>
    ) {
        self.marksPaneActionSubject = marksPaneActionSubject
        self.toolbarActionSubject = toolbarActionSubject
        self.textViewDelegate = textViewDelegate
        self.information = viewModel.information
        self.viewModel = viewModel
    }
}

extension TextBlockContentConfiguration: UIContentConfiguration {
    
    func makeContentView() -> UIView & UIContentView {
        let view: TextBlockContentView = .init(configuration: self)
        self.viewModel.addContextMenuIfNeeded(view)
        return view
    }
    
    func updated(for state: UIConfigurationState) -> TextBlockContentConfiguration {
        return self
    }
}

extension TextBlockContentConfiguration: Hashable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.information == rhs.information
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.information)
    }
}
