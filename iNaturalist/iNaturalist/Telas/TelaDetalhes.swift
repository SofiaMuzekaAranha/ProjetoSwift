import SwiftUI

// Terceira tela: recebe a espécie selecionada e mostra os dados já carregados.
struct TelaDetalhes: View {
    let especie: Especie
    @Environment(\.dismiss) private var fecharTela

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // O cabeçalho de vidro e a foto ocupam a faixa superior da tela.
                VStack(spacing: 12) {
                    HStack {
                        Button {
                            fecharTela()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.7), radius: 18, x: 0, y: 0)
                                .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.4), radius: 30, x: 0, y: 0)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Back")

                        Spacer(minLength: 0)

                        Text("Species details")
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.white)
                            .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.7), radius: 18, x: 0, y: 0)
                            .shadow(color: Color(red: 0.01, green: 0.05, blue: 0.16).opacity(0.4), radius: 30, x: 0, y: 0)

                        Spacer(minLength: 0)

                        // Equilibra o espaço da seta para centralizar o título.
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    ImagemRemota(
                        endereco: especie.urlImagem,
                        descricaoAcessibilidade: "Photo of \(especie.titulo)"
                    )
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .accessibilityIdentifier("detail-photo")
                }
                .frame(maxWidth: .infinity)
                .fundoVidroFoto()

                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Common name")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))

                        Text(especie.nomePopular ?? "Not available")
                            .font(.title2)
                            .bold()
                            .accessibilityIdentifier("detail-common-name")
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Scientific name")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))

                        Text(especie.nomeCientifico)
                            .font(.title3)
                            .italic()
                            .accessibilityIdentifier("detail-scientific-name")
                    }

                    // O resumo da espécie é recebido junto com os dados da API.
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)

                        Text(especie.descricao ?? "No description available.")
                            .accessibilityIdentifier("detail-description")
                    }

                    // Links para os dados e créditos nas fontes originais.
                    VStack(alignment: .leading, spacing: 8) {
                        if let urlPerfil = especie.urlPerfil {
                            Link("Species data: iNaturalist", destination: urlPerfil)
                        }

                        if let urlWikipedia = especie.urlWikipedia {
                            Link("Description source", destination: urlWikipedia)
                        }

                        if let creditos = especie.foto?.creditos {
                            Text(creditos)
                                .foregroundStyle(.white.opacity(0.8))
                        }

                        if let urlCreditosImagem = especie.urlCreditosImagem {
                            Link("Photo credits", destination: urlCreditosImagem)
                        }
                    }
                    .font(.caption)
                }
                .frame(maxWidth: 600, alignment: .leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
                // O conteúdo abaixo da foto fica sem painel de vidro e com margens amplas.
            }
            // Sobe o conteúdo rolável até o local do antigo botão, mantendo o header no ScrollView.
            .padding(.top, -66)
        }
        // Deixa o fundo estendido desenhar atrás da barra, sem deslocar a foto.
        .scrollClipDisabled()
        .foregroundStyle(.white)
        .background(EstiloVisual.fundo.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
