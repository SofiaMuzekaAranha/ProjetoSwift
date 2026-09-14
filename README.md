# ProjetoSwift

# Equipe: 2 alunos

# Proibido: comentários nos blocos de código e arquivos.

Criar um aplicativo mobile visual em Swift e SwiftUI onde o usuário possa explorar informações sobre um grande tema.
O aplicativo deverá buscar informações reais e atualizadas diretamente da internet, consumindo uma API (Application Programming Interface) pública e pronta.

A equipe tem liberdade para escolher o tema e a API que vai utilizar.
Algumas ideias de APIs públicas gratuitas: 
​
-- The Movie Database (TMDB): Para explorar filmes (Ex: Populares, Em Cartaz, Mais Votados).
​-- PokéAPI: Para explorar Pokémon (Ex: Tipo Fogo, Tipo Água, Tipo Planta).
​-- Rick and Morty API: Para explorar o universo da série (Ex: Personagens, Planetas, Episódios).
​-- NASA API: Para explorar fotos espaciais, rovers em Marte, etc.
​

# Requisitos do Aplicativo:

O aplicativo deve conter exatamente 3 camadas de navegação e lidar com o tráfego de dados da internet:

​-- Tela Inicial (Menu de Categorias):
​Deve apresentar um título chamativo.
​Deve conter um menu com pelo menos 3 opções (categorias) que determinem o que será buscado na API.
​Exemplo: Se usar a API do TMDB, as opções podem ser "Filmes de Ação", "Comédias" e "Ficção Científica".

​-- Tela de Carrossel (Galeria):
​Ao clicar em uma categoria no menu, o app abre esta tela e faz a requisição para a API.
​Enquanto os dados estiverem sendo baixados, a tela deve exibir um indicador de carregamento (um loading/spinner).
​Após o carregamento, deve exibir um carrossel horizontal/vertical com 5 cards gerados a partir do JSON da API.
​O usuário deve conseguir deslizar o dedo(mouse) para os lados ou acima e abaixo. Cada card deve ter a imagem remota e o título do item.
​
-- Tela de Detalhes:
​Ao tocar em um dos cards do carrossel, o app deve abrir uma nova tela.
​Esta tela deve receber os dados do item selecionado e exibir a imagem em destaque, o título e textos descritivos vindos da API (como sinopse, pontuação, habilidades, etc.).
​
# Critérios de Qualidade

-- Padrão MVVM

-- O aplicativo não pode travar (crash) se a internet cair; ele deve mostrar uma mensagem amigável de erro.

​-- As imagens devem ser carregadas de forma assíncrona (não podem congelar a tela enquanto baixam).

-- Criar uma estrutura de dados (Modelos) no código que reflita exatamente o JSON fornecido pela API.
​
# Requisitos Técnicos

​Para construir o projeto, obrigatoriamente, aplicar os seguintes conceitos:

​1. Consumo de API e Assincronismo (async/await)
A forma moderna de pedir dados para a internet sem travar o aplicativo enquanto espera a resposta.
​Aprendizado: Utilização do URLSession.shared.data(from:) em funções marcadas com async throws. Entendimento de tarefas assíncronas usando a estrutura Task {} dentro do SwiftUI (especialmente no modificador .task).

​2. Decodificação de Dados (Codable)
O processo de transformar o texto (JSON) que vem da internet em objetos do Swift que o aplicativo consiga ler.
​Aprendizado: Criação de structs que adotem o protocolo Codable (ou Decodable). Uso do JSONDecoder para mapear chaves do JSON para as propriedades do Swift, incluindo o uso de CodingKeys se os nomes variarem.

​3. Imagens Assíncronas (AsyncImage)
O componente nativo do SwiftUI para baixar e exibir fotos vindas de URLs (links).
​Aprendizado: Como implementar o AsyncImage gerenciando suas fases (AsyncImagePhase): mostrando um ProgressView() enquanto carrega, a imagem quando dá certo, e um ícone de erro (como um SF Symbol) se o link falhar.

​4. Navegação Orientada a Dados (NavigationStack)
O padrão atual da Apple para transitar entre telas de forma inteligente.
​Aprendizado: Como passar os dados decodificados da API da Tela de Carrossel para a Tela de Detalhes utilizando NavigationLink(value:) e interceptando esse valor com .navigationDestination(for:). A necessidade de fazer os modelos adotarem o protocolo Hashable.

​5. Layouts de Carrossel Modernos
​O que é: Construção da interface onde o usuário desliza os cards carregados da API.
​Aprendizado: O uso avançado do ScrollView(.horizontal) combinado com os modificadores modernos (iOS 17+) .scrollTargetBehavior(.viewAligned) e .scrollTargetLayout(), que criam o efeito de "paginação" nativo para os 5 cards de forma suave.

​6. Gestão de Estado Moderna (@Observable)
Como a interface reage às mudanças (ex: de "carregando" para "dados recebidos").
​Aprendizado: Criação de classes de serviço (ViewModels) usando a nova macro @Observable. Atualizar variáveis que automaticamente redesenham a tela para remover o spinner de loading e mostrar o carrossel quando os dados da API chegam.


# Critérios éticos: 

Um projeto ético, seguro e universalmente aceito, você deve seguir um conjunto de diretrizes de conformidade e integridade humana. Esses critérios garantem que o conteúdo não cause danos, ofensas ou processos jurídicos.

Abaixo estão os critérios canônicos divididos por categoria para orientar o seu projeto:


1. Dignidade Humana, Social e Institucional
Pessoas: Respeito absoluto aos direitos humanos. É proibido qualquer teor discriminatório (raça, gênero, orientação sexual, religião, nacionalidade ou deficiência), difamação, calúnia ou uso indevido de imagem e dados pessoais (LGPD).
Lugares: Preservação da integridade cultural e histórica. Evite estigmatizar bairros, cidades ou países, associando-os estritamente a estereótipos negativos (como crime, pobreza ou atraso tecnológico).
Empresas e Marcas: Respeito à propriedade intelectual e direito comercial. Não utilize nomes, logotipos ou identidades visuais registradas (colocar copyright). Evite a depreciação de marcas (difamação corporativa) ou concorrência desleal.


2. Proteção Ambiental e Consciência Ecológica
Animais e Seres Vivos: Proibição de qualquer representação ou apologia aos maus-tratos, exploração, crueldade ou degradação da fauna e flora. O projeto deve promover a sustentabilidade, o bem-estar animal e a preservação dos ecossistemas.


3. Substâncias de Uso Restrito e Controlado
Bebidas Alcoólicas: Não usar o consumo de álcool. 
Drogas: Proibição total de apologia, incentivo, facilitação de comércio ou normalização do uso de substâncias ilícitas. O tema não pode ser abordado.


4. Vestuário, Corporalidade e Modéstia Visual
Conteúdo Sexual e Sexualização: Eliminação de qualquer nudez, insinuação sexual explícita ou erotização de dinâmicas humanas.
Vestimentas: As roupas devem seguir critérios de neutralidade ou modéstia (dependendo do público-alvo), evitando fendas excessivas, transparências, decotes profundos ou peças que reduzam o corpo humano a um objeto de desejo visual (objetificação).

5. Política
Conteúdos Políticos: Proibição de manifestações partidárias, propaganda eleitoral, defesa de ideologias específicas ou apoio a candidatos e governos. O projeto deve manter total neutralidade político-institucional.
Guerras Geopolíticas: Vetada a representação, apologia, tomada de lado ou exploração comercial de conflitos armados ativos, disputas de fronteiras, sanções internacionais ou tensões diplomáticas reais. O foco deve ser a promoção da paz e da cooperação global.

6. Substâncias de Uso Restrito e Controlado
Proibição de Substâncias e Medicamentos: Os cards estão estritamente proibidos de exibir imagens de qualquer tipo de medicamento de tarja preta, pílulas de emagrecimento, shakes fitoterápicos ou suplementos inibidores de apetite.

7. Saúde Mental e Psiquiatria: O texto descritivo não pode citar, recomendar ou fazer análises sobre remédios controlados para saúde mental (como ansiolíticos, antidepressivos, estabilizadores de humor ou estimulantes). O app não deve fornecer diagnósticos ou sugerir automedicação.

8. Emagrecimento e Promessas Médicas: É proibida qualquer menção a fármacos emagrecedores (como fórmulas manipuladas, diuréticos ou análogos de GLP-1/canetas de emagrecimento) e dietas restritivas extremas. O texto não deve associar o valor ou a dignidade de uma pessoa ao seu peso ou formato corporal.
