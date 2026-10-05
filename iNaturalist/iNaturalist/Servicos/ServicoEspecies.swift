import Foundation

// Busca as espécies e suas descrições somente nos serviços do iNaturalist.
final class ServicoEspecies {
    func buscarEspecies(categoria: Categoria) async throws -> [Especie] {
        guard var componentes = URLComponents(string: "https://api.inaturalist.org/v1/observations/species_counts") else {
            throw ErroServico.enderecoInvalido
        }

        // O grupo filtra a categoria. species_counts evita espécies repetidas.
        componentes.queryItems = [
            URLQueryItem(name: "taxon_id", value: String(categoria.identificadorTaxon)),
            URLQueryItem(name: "per_page", value: "5"),
            URLQueryItem(name: "photos", value: "true"),
            URLQueryItem(name: "quality_grade", value: "research"),
            URLQueryItem(name: "captive", value: "false"),
            URLQueryItem(name: "rank", value: "species"),
            URLQueryItem(name: "locale", value: "en")
        ]

        // Esponjas de água doce ficam fora da busca de animais marinhos.
        if let identificadorExcluido = categoria.identificadorExcluido {
            componentes.queryItems?.append(URLQueryItem(name: "without_taxon_id", value: String(identificadorExcluido)))
        }
        guard let endereco = componentes.url else {
            throw ErroServico.enderecoInvalido
        }

        // Espera a internet de forma assíncrona, sem travar a tela.
        let (dados, resposta) = try await URLSession.shared.data(from: endereco)
        try validar(resposta: resposta)
        let resultado = try JSONDecoder().decode(RespostaEspeciesAPI.self, from: dados)
        var especies = resultado.resultados.map(\.especie)

        // Entrega cinco espécies diferentes com foto ou mostra um erro amigável.
        guard especies.count == 5,
              Set(especies.map(\.id)).count == 5,
              especies.allSatisfy({ $0.urlImagem != nil }) else {
            throw ErroServico.dadosIncompletos
        }

        // A busca resumida não contém a descrição; pede os cinco perfis selecionados.
        for indice in especies.indices {
            try Task.checkCancellation()
            especies[indice].descricao = try await buscarDescricao(id: especies[indice].id)
        }
        return especies
    }

    // Este endpoint JSON do iNaturalist contém o campo wikipedia_summary.
    private func buscarDescricao(id: Int) async throws -> String? {
        guard let endereco = URL(string: "https://www.inaturalist.org/taxa/\(id).json?locale=en") else {
            throw ErroServico.enderecoInvalido
        }
        let (dados, resposta) = try await URLSession.shared.data(from: endereco)
        try validar(resposta: resposta)
        let resultado = try JSONDecoder().decode(RespostaDescricaoAPI.self, from: dados)
        return limparTexto(resultado.descricao)
    }

    // Respostas HTTP de erro são tratadas pelo modelo de tela.
    private func validar(resposta: URLResponse) throws {
        guard let respostaHTTP = resposta as? HTTPURLResponse,
              (200...299).contains(respostaHTTP.statusCode) else {
            throw ErroServico.falhaServidor
        }
    }

    // Remove o HTML do resumo para mostrar apenas texto na interface.
    private func limparTexto(_ texto: String?) -> String? {
        guard let texto else { return nil }
        let textoLimpo = texto
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        // Alguns perfis retornam apenas reticências quando não possuem resumo.
        return textoLimpo.isEmpty || textoLimpo == "..." || textoLimpo == "…" ? nil : textoLimpo
    }
}

// Centraliza as mensagens dos problemas esperados do serviço.
enum ErroServico: LocalizedError {
    case enderecoInvalido
    case falhaServidor
    case dadosIncompletos

    var errorDescription: String? {
        switch self {
        case .enderecoInvalido:
            return "We couldn't open the species service. Please try again."
        case .falhaServidor:
            return "iNaturalist is unavailable right now. Please try again later."
        case .dadosIncompletos:
            return "We couldn't load five species with photos. Please try again."
        }
    }
}
