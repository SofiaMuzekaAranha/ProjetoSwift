import SwiftUI

// Compartilha a imagem enviada como fundo das três telas.
enum EstiloVisual {
    static var fundo: some View {
        FundoOceano()
    }
}

// Recorta a imagem ao tamanho da tela, sem distorcer suas proporções.
struct FundoOceano: View {
    var body: some View {
        GeometryReader { geometria in
            Image("FundoOceano")
                .resizable()
                .scaledToFill()
                .frame(width: geometria.size.width, height: geometria.size.height)
                .clipped()
        }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }
}

extension View {
    // Preenche a área da legenda com o material Liquid Glass nativo do iPhone.
    @ViewBuilder
    func fundoVidro(arredondamento: CGFloat = 0) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.clear, in: RoundedRectangle(cornerRadius: arredondamento))
        } else {
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: arredondamento))
        }
    }

    // Estende somente o topo do vidro até atrás do cabeçalho, sem mover a foto.
    @ViewBuilder
    func fundoVidroFoto() -> some View {
        self.background(alignment: .top) {
            GeometryReader { geometria in
                let extensaoSuperior: CGFloat = 130
                let extensaoLateral: CGFloat = 32
                let transicaoInferior: CGFloat = 40
                Group {
                    if #available(iOS 26.0, *) {
                        Rectangle().fill(.clear).glassEffect(.clear, in: Rectangle())
                    } else {
                        Rectangle().fill(.ultraThinMaterial)
                    }
                }
                .frame(
                    width: geometria.size.width + extensaoLateral * 2,
                    height: geometria.size.height + extensaoSuperior + transicaoInferior
                )
                // Faz o vidro desaparecer aos poucos abaixo da foto, sem uma borda reta.
                .mask(alignment: .top) {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(.white)
                            .frame(height: geometria.size.height + extensaoSuperior)

                        LinearGradient(
                            colors: [.white, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: transicaoInferior)
                    }
                }
                .offset(x: -extensaoLateral, y: -extensaoSuperior)
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    // Coloca o Liquid Glass atrás do conteúdo de um painel completo.
    @ViewBuilder
    func painelVidro(arredondamento: CGFloat = 20) -> some View {
        self.background {
            let forma = RoundedRectangle(cornerRadius: arredondamento)
            if #available(iOS 26.0, *) {
                forma.fill(.clear).glassEffect(.regular, in: forma)
                    .overlay(forma.stroke(.white.opacity(0.52), lineWidth: 0.75))
            } else {
                forma.fill(.ultraThinMaterial)
                    .overlay(forma.stroke(.white.opacity(0.52), lineWidth: 0.75))
            }
        }
    }
}

// O preenchimento de vidro deixa os botões circulares com aparência de bolhas.
extension View {
    @ViewBuilder
    func fundoBolha() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.clear.interactive(), in: Circle())
                .shadow(color: .blue.opacity(0.15), radius: 8, y: 4)
        } else {
            self.background(.ultraThinMaterial, in: Circle())
                .shadow(color: .blue.opacity(0.15), radius: 8, y: 4)
        }
    }
}

// Compartilha o mesmo título branco, centralizado e com vidro transparente.
struct TituloVidro: View {
    let texto: String

    var body: some View {
        Text(texto)
            .font(.title2)
            .bold()
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: 48)
            .fundoVidro(arredondamento: 16)
            .padding(.horizontal, 20)
    }
}
