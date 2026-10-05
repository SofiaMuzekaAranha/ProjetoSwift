import Foundation

// A busca retorna uma lista de resultados; cada resultado contém uma espécie.
struct RespostaEspeciesAPI: Decodable {
    let resultados: [ResultadoEspecieAPI]

    enum CodingKeys: String, CodingKey {
        case resultados = "results"
    }
}

// Lê somente taxon, sem guardar contagens e outros dados desnecessários.
struct ResultadoEspecieAPI: Decodable {
    let especie: Especie

    enum CodingKeys: String, CodingKey {
        case especie = "taxon"
    }
}

// O perfil JSON do iNaturalist fornece o resumo da Wikipédia já armazenado.
struct RespostaDescricaoAPI: Decodable {
    let descricao: String?

    enum CodingKeys: String, CodingKey {
        case descricao = "wikipedia_summary"
    }
}
