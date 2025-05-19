//===============================================================
//  UserProfileScene/UserProfileView.swift
//===============================================================

import SwiftUI

struct UserProfileView: View {
    @StateObject var viewModel: UserProfileViewModel

    var body: some View {
        Group {
            if let profile = viewModel.profile {
                content(for: profile)
            } else {
                ProgressView()
            }
        }
    }

    // MARK: – UI (остался прежним)
    private func content(for profile: UserProfile) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: profile.photoName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding(.top)

                Text("\(profile.name), \(profile.age)")
                    .font(.title)
                    .bold()

                Text(profile.bio)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    infoRow("Пол", profile.gender.rawValue)
                    infoRow("Интересы",
                            profile.interests.map(\.title).joined(separator: ", "))
                }
                .padding(.horizontal)

                Divider()

                HStack {
                    ForEach(profile.socialLinks) { link in
                        linkButton(link)
                            .padding(.horizontal, 10)
                        if link.id != profile.socialLinks.last?.id { Divider() }
                    }
                }
            }
        }
    }

    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(title):").bold()
            Text(value)
        }
    }

    private func linkButton(_ link: SocialLink) -> some View {
        Button { viewModel.tapped(platform: link.platform.rawValue) } label: {
            Image(link.platform.rawValue)            // telegram / instagram / vk
                .resizable()
                .frame(width: 60, height: 60)
                .padding()
                .background(.white)
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 30)
                         .stroke(Color(.label).opacity(0.7), lineWidth: 2))
        }
    }
}

enum UserProfileModule {
    @MainActor static func build() -> some View {
        let presenter  = UserProfileRouter()
        let interactor = UserProfileLogic(presenter: presenter)
        let viewModel  = UserProfileViewModel(interactor: interactor)

        presenter.viewModel = viewModel     // слабая ссылка
        return UserProfileView(viewModel: viewModel)
    }
}


#Preview {
    UserProfileModule.build()
}
