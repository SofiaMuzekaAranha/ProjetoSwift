import Foundation

// Representa o objeto taxon recebido do iNaturalist.
// Decodable lê o JSON; Hashable permite passar a espécie pela navegação.
struct Especie: Decodable, Identifiable, Hashable {
    let id: Int
    let nomeCientifico: String
    let nomePopular: String?
    let foto: FotoEspecie?
    let urlWikipedia: URL?
    var descricao: String?

    // Relaciona os nomes em português às chaves originais do JSON.
    enum CodingKeys: String, CodingKey {
        case id
        case nomeCientifico = "name"
        case nomePopular = "preferred_common_name"
        case foto = "default_photo"
        case urlWikipedia = "wikipedia_url"
        case descricao = "wikipedia_summary"
    }

    // Usa o nome científico quando a API não fornece um nome popular em inglês.
    var titulo: String {
        nomePopular ?? nomeCientifico
    }

    // A tela baixa este endereço com AsyncImage, sem bloquear a interface.
    var urlImagem: URL? { foto?.enderecoMedio }

    // Permite consultar o perfil e os créditos no próprio iNaturalist.
    var urlPerfil: URL? { URL(string: "https://www.inaturalist.org/taxa/\(id)") }

    var urlCreditosImagem: URL? {
        guard let foto else { return nil }
        return URL(string: "https://www.inaturalist.org/photos/\(foto.id)")
    }
}

// Guarda somente o endereço da foto e os créditos recebidos na resposta.
struct FotoEspecie: Decodable, Hashable {
    let id: Int
    let enderecoMedio: URL?
    let creditos: String?

    enum CodingKeys: String, CodingKey {
        case id
        case enderecoMedio = "medium_url"
        case creditos = "attribution"
    }
}
