import Foundation

// Cada categoria usa um grupo do iNaturalist para buscar cinco espécies.
enum Categoria: String, CaseIterable, Identifiable, Hashable {
    case aguasVivas
    case baleias
    case tubaroes
    case esponjas
    case corais

    // Identifica cada opção no menu e na navegação.
    var id: String { rawValue }

    // Os nomes e as instruções da interface ficam em inglês.
    var titulo: String {
        switch self {
        case .aguasVivas: return "Jellyfish"
        case .baleias: return "Whales"
        case .tubaroes: return "Sharks"
        case .esponjas: return "Sponges"
        case .corais: return "Corals"
        }
    }

    var descricao: String {
        switch self {
        case .aguasVivas: return "Explore five jellyfish species."
        case .baleias: return "Explore five whale species."
        case .tubaroes: return "Explore five shark species."
        case .esponjas: return "Explore five marine sponge species."
        case .corais: return "Explore five coral species."
        }
    }

    // Os símbolos nativos mantêm o menu simples, sem imagens extras.
    var simbolo: String {
        switch self {
        case .aguasVivas: return "drop"
        case .baleias: return "water.waves"
        case .tubaroes: return "fish"
        case .esponjas: return "circle.grid.3x3.fill"
        case .corais: return "leaf"
        }
    }

    // Identificadores conferidos na API: Scyphozoa, Mysticeti, Selachii,
    // Porifera e Scleractinia. Esses grupos filtram as categorias na URL.
    var identificadorTaxon: Int {
        switch self {
        case .aguasVivas: return 48332
        case .baleias: return 424321
        case .tubaroes: return 551307
        case .esponjas: return 48824
        case .corais: return 47532
        }
    }

    // Exclui Spongillida, o grupo das esponjas de água doce.
    var identificadorExcluido: Int? {
        self == .esponjas ? 517637 : nil
    }
}
