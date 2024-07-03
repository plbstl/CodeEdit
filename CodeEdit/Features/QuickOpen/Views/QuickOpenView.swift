//
//  QuickOpenView.swift
//  CodeEditModules/QuickOpen
//
//  Created by Pavel Kasila on 20.03.22.
//

import SwiftUI

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}

struct QuickOpenView: View {
    @EnvironmentObject private var workspace: WorkspaceDocument

    private let onClose: () -> Void
    private let openFile: (CEWorkspaceFile) -> Void

    @ObservedObject private var quickOpenViewModel: QuickOpenViewModel

    @State private var selectedItem: CEWorkspaceFile?

    init(
        state: QuickOpenViewModel,
        onClose: @escaping () -> Void,
        openFile: @escaping (CEWorkspaceFile) -> Void
    ) {
        self.quickOpenViewModel = state
        self.onClose = onClose
        self.openFile = openFile
    }

    var body: some View {
        SearchPanelView(
            title: "Open Quickly",
            image: Image(systemName: "magnifyingglass"),
            options: $quickOpenViewModel.openQuicklySearchResults,
            text: $quickOpenViewModel.openQuicklyQuery,
            optionRowHeight: 40
        ) { searchResult in
            QuickOpenItem(
                baseDirectory: quickOpenViewModel.fileURL,
                searchResult: searchResult
            )
        } preview: { searchResult in
            QuickOpenPreviewView(item: CEWorkspaceFile(url: searchResult.fileURL))
        } onRowClick: { searchResult in
            guard let file = workspace.workspaceFileManager?.getFile(
                searchResult.fileURL.relativePath,
                createIfNotFound: true
            ) else {
                return
            }
            openFile(file)
            quickOpenViewModel.openQuicklyQuery = ""
            onClose()
        } onClose: {
            onClose()
        }
        .onReceive(quickOpenViewModel.$openQuicklyQuery.debounce(for: 0.2, scheduler: DispatchQueue.main)) { _ in
            quickOpenViewModel.fetchOpenQuickly()
        }
    }
}
