import SwiftUI

// Primeira tela: mostra um cabeçalho simples e o menu de categorias.
struct TelaInicial: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // O fundo do cabeçalho também cobre a área acima, até o topo da tela.
                VStack(alignment: .leading, spacing: 12) {
                    Text("iNaturalist")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(Color(red: 0.42, green: 0.78, blue: 1.0))
                        // Um brilho branco difuso separa o título do fundo sem criar contorno duro.
                        .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.7), radius: 18, x: 0, y: 0)
                        .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.4), radius: 30, x: 0, y: 0)

                    Text("Explore marine life")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.white)
                        .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.7), radius: 18, x: 0, y: 0)
                        .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.4), radius: 30, x: 0, y: 0)

                    Text("Choose a category to discover five marine species.")
                        .foregroundStyle(.white.opacity(0.85))
                        .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.7), radius: 18, x: 0, y: 0)
                        .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.4), radius: 30, x: 0, y: 0)
                }
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity, alignment: .leading)

                TituloVidro(texto: "Species")

                MenuBolhas()

            }
            .background(EstiloVisual.fundo.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            // Os valores abrem a galeria e os detalhes na mesma pilha.
            .navigationDestination(for: Categoria.self) { categoria in
                TelaGaleria(categoria: categoria)
                    .toolbar(.visible, for: .navigationBar)
            }
            .navigationDestination(for: Especie.self) { especie in
                TelaDetalhes(especie: especie)
                    .toolbar(.visible, for: .navigationBar)
            }
        }
    }
}

// Visualiza o menu sem fazer requisições à internet.
#Preview {
    TelaInicial()
}

// Mantém o posicionamento circular separado do cabeçalho da tela.
private struct MenuBolhas: View {
    var body: some View {
        // Distribui cinco bolhas igualmente ao redor de um centro.
        GeometryReader { geometria in
            let lado = min(geometria.size.width - 32, geometria.size.height - 24, 360)
            let raio = lado * 0.34
            let tamanhoBolha = lado * 0.25
            let centro = CGPoint(x: geometria.size.width / 2, y: geometria.size.height / 2)

            ZStack {
                ForEach(Array(Categoria.allCases.enumerated()), id: \.element.id) { indice, categoria in
                    let angulo = Double(indice) * 2 * Double.pi / Double(Categoria.allCases.count) - Double.pi / 2

                    NavigationLink(value: categoria) {
                        VStack(spacing: 6) {
                            // Usa os ícones enviados, mantendo a transparência original.
                            Image(categoria.id)
                                .resizable()
                                .scaledToFit()
                                .padding(tamanhoBolha * 0.16)
                                .frame(width: tamanhoBolha, height: tamanhoBolha)
                                .fundoBolha()

                            Text(categoria.titulo)
                                .font(.caption)
                                .bold()
                                .foregroundStyle(.white)
                                .shadow(color: .black.opacity(0.25), radius: 2, y: 1)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(categoria.titulo)
                    .accessibilityIdentifier("category-\(categoria.id)")
                    .position(
                        x: centro.x + raio * CGFloat(cos(angulo)),
                        y: centro.y + raio * CGFloat(sin(angulo))
                    )
                }
            }
            .frame(width: geometria.size.width, height: geometria.size.height)
        }
    }
}
