//
//  UserProfileSettingsFileManager.swift
//  Imyarek_SwiftUI
//
//  Created by maftuna murtazaeva on 18.05.2025.
//

import UIKit

extension FileManager {
    func saveImageData(_ data: Data, withName name: String) throws {
        let url = try imageURL(for: name)
        try data.write(to: url)
    }

    func loadImage(named name: String) -> UIImage? {
        guard let url = try? imageURL(for: name),
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func imageURL(for name: String) throws -> URL {
        let dir = urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent(name)
    }
}

