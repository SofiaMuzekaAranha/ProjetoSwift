import Foundation
import Observation

// Cuida dos dados e do estado da galeria, separado do código da interface.
// MainActor mantém as atualizações da tela no fluxo principal do aplicativo.
@Observable
@MainActor
final class ModeloGaleria {
    var especies: [Especie] = []
    var carregando = true
    var mensagemErro: String?

    // Começa no bloco central de cards para permitir deslizar nas duas direções.
    var posicaoCarrossel: Int? = 500

    private let servico = ServicoEspecies()

    // A tela chama esta função na abertura e também ao tentar carregar novamente.
    func carregar(categoria: Categoria) async {
        // Voltar dos detalhes não precisa baixar novamente os mesmos dados.
        guard especies.isEmpty else {
            return
        }

        carregando = true
        mensagemErro = nil

        // Sempre esconde o indicador ao terminar, mesmo quando ocorre um erro.
        defer {
            carregando = false
        }

        do {
            let especiesRecebidas = try await servico.buscarEspecies(categoria: categoria)
            try Task.checkCancellation()
            especies = especiesRecebidas
            posicaoCarrossel = especies.count * 100
        } catch is CancellationError {
            // Sair da tela cancela o carregamento e não representa uma falha.
        } catch let erro as URLError {
            switch erro.code {
            case .cancelled:
                break
            case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                mensagemErro = "Check your internet connection and try again."
            default:
                mensagemErro = "We couldn't connect to iNaturalist. Please try again."
            }
        } catch let erro as ErroServico {
            mensagemErro = erro.localizedDescription
        } catch {
            mensagemErro = "We couldn't load the species. Please try again."
        }
    }
}
