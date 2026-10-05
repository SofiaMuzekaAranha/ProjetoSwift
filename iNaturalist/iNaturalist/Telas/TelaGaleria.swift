import SwiftUI

// Segunda tela: observa o carregamento e apresenta os cinco cards da categoria.
struct TelaGaleria: View {
    let categoria: Categoria

    // O State mantém a mesma instância do modelo enquanto esta tela existir.
    @State private var modelo = ModeloGaleria()
    @Environment(\.dismiss) private var fecharTela

    var body: some View {
        // O Bindable liga a posição da rolagem ao modelo observável.
        @Bindable var modelo = modelo

        VStack(spacing: 0) {
            // O botão e o título ficam juntos no mesmo painel de vidro.
            HStack {
                Button {
                    fecharTela()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")

                Spacer(minLength: 0)

                Text(categoria.titulo)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Spacer(minLength: 0)

                // Mantém o nome exatamente centralizado na faixa.
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 56)
            .fundoVidro(arredondamento: 16)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)

            Group {
                if modelo.carregando {
                    ProgressView("Loading species…")
                        .accessibilityIdentifier("gallery-loading")
                } else if let mensagemErro = modelo.mensagemErro {
                    // A falha de internet aparece na tela e permite uma nova tentativa.
                    ContentUnavailableView {
                        Label("Couldn't load species", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text(mensagemErro)
                    } actions: {
                        Button("Retry") {
                            Task {
                                await modelo.carregar(categoria: categoria)
                            }
                        }
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("retry-gallery")
                    }
                } else {
                    // A rolagem externa mantém o conteúdo acessível em telas pequenas.
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Swipe to explore five species. Tap a photo to learn more.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.85))
                                .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.7), radius: 18, x: 0, y: 0)
                                .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.4), radius: 30, x: 0, y: 0)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 24)

                            GeometryReader { geometria in
                                let larguraCard = min(geometria.size.width * 0.76, 360)

                                ScrollView(.horizontal) {
                                    LazyHStack(alignment: .center, spacing: 16) {
                                        // Cria repetições sob demanda para continuar deslizando sem voltar ao primeiro card.
                                        ForEach(0..<(modelo.especies.count * 201), id: \.self) { indice in
                                            let especie = modelo.especies[indice % modelo.especies.count]

                                            NavigationLink(value: especie) {
                                                VStack(alignment: .leading, spacing: 0) {
                                                    ImagemRemota(
                                                        endereco: especie.urlImagem,
                                                        descricaoAcessibilidade: "Photo of \(especie.titulo)"
                                                    )
                                                    .frame(height: 240)

                                                    Text(especie.titulo)
                                                        .font(.headline)
                                                        .foregroundStyle(.white)
                                                        .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
                                                        // Reserva espaço para nomes longos sem cortar a legenda.
                                                        .multilineTextAlignment(.center)
                                                        .lineLimit(3)
                                                        .minimumScaleFactor(0.75)
                                                        .padding(.horizontal, 16)
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 96)
                                                        // O material translúcido mantém o fundo visível sem criar linhas nas laterais.
                                                        .background(.ultraThinMaterial.opacity(0.16))
                                                }
                                                // Recorta foto e legenda juntas para formar um único card.
                                                .frame(width: larguraCard, height: 336, alignment: .top)
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                                .shadow(color: Color(red: 0.30, green: 0.43, blue: 0.57).opacity(0.25), radius: 12, x: 0, y: 6)
                                            }
                                            .id(indice)
                                            .buttonStyle(.plain)
                                            .accessibilityIdentifier("species-\(especie.id)")
                                            .accessibilityHint("Open species details")
                                        }
                                    }
                                    // Cada card se torna um ponto de parada da rolagem.
                                    .scrollTargetLayout()
                                }
                                .contentMargins(.horizontal, (geometria.size.width - larguraCard) / 2, for: .scrollContent)
                                .scrollTargetBehavior(.viewAligned)
                                .scrollPosition(id: $modelo.posicaoCarrossel, anchor: .center)
                                .onChange(of: modelo.posicaoCarrossel) { _, novaPosicao in
                                    let quantidade = modelo.especies.count
                                    guard let novaPosicao, quantidade > 0 else { return }

                                    // Apenas no limite distante, mantém o mesmo card e seus vizinhos no centro.
                                    if novaPosicao < quantidade || novaPosicao >= quantidade * 200 {
                                        var transacao = Transaction()
                                        transacao.disablesAnimations = true
                                        withTransaction(transacao) {
                                            modelo.posicaoCarrossel = quantidade * 100 + novaPosicao % quantidade
                                        }
                                    }
                                }
                                // Mantém os reflexos e a sombra visíveis ao redor dos cards.
                                .scrollClipDisabled()
                                .scrollIndicators(.hidden)
                                .accessibilityIdentifier("gallery-carousel")
                            }
                            .frame(height: 356)
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(EstiloVisual.fundo.ignoresSafeArea())
        // Reserva a mesma altura superior, ocultando o botão nativo duplicado.
        .navigationBarBackButtonHidden()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        // Mantém a barra transparente atrás do cabeçalho de vidro.
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        // A tarefa é cancelada pelo SwiftUI se a tela sair da navegação.
        .task {
            if modelo.especies.isEmpty {
                await modelo.carregar(categoria: categoria)
            }
        }
    }
}
