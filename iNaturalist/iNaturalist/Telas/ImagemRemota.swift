import SwiftUI

// Reutiliza o carregamento assíncrono de fotos na galeria e nos detalhes.
struct ImagemRemota: View {
    let endereco: URL?
    let descricaoAcessibilidade: String

    var body: some View {
        // Usa o tamanho reservado pela tela para recortar a foto sem sobras.
        GeometryReader { geometria in
            Group {
                if let endereco = endereco {
                    AsyncImage(url: endereco) { fase in
                        switch fase {
                        case .empty:
                            ProgressView("Loading photo…")

                        case .success(let imagem):
                            imagem
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometria.size.width, height: geometria.size.height)
                                .accessibilityLabel(descricaoAcessibilidade)

                        case .failure:
                            imagemIndisponivel

                        @unknown default:
                            imagemIndisponivel
                        }
                    }
                } else {
                    imagemIndisponivel
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondarySystemBackground))
            .clipped()
        }
    }

    // Um endereço ausente ou uma falha no download não interrompe o aplicativo.
    private var imagemIndisponivel: some View {
        VStack(spacing: 8) {
            Image(systemName: "photo")
                .font(.largeTitle)

            Text("Photo unavailable")
                .font(.caption)
        }
        .foregroundStyle(.secondary)
    }
}
