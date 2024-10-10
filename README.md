# Skeleton Rails Docker

## Instruções

#### Copie um exemplo de arquivo .env porque o arquivo real é ignorado pelo Git:

```sh
cp .env.example .env
```

#### Configurando o projeto:

```sh
./run setup

# Em outro terminal
./run rake db:setup db:seed
```

#### Verificando no navegador:

Acesse <http://localhost:3000>

#### Parando tudo:

```sh
# Para os contêiners e remove alguns recursos relacionados ao Docker associados a este projeto.
docker compose down
```

Você pode iniciar tudo novamente com docker `docker compose up`.

---

##### Extensão para o script de formatar o código

Baixe RunOnSave [clicando aqui](https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave).

##### Alias para rodar todos com `run` comando sem precisar do `./run`

```sh
# Edite o terminal que estiver usando (exemplo usando zshrc)
sudo nano ~/.zshrc

# Adicione a linha
alias run="./run"

# Para funcionar sem precisar fechar e abrir o terminal
source ~/.zshrc
```

#### Criar formulários para o painel admin:

```sh
# Gera a modelo globalmente e exclusivamente no namespace admin cria as controllers, views e rotas.
./run g_admin_model ModelName attr_a:string attr_b:string
```

#### Erro comum com o gerador do painel admin:

```sh
# Caso aconteça erros com os caminhos dos arquivos verificar o nome da modelo e controllers se não forma alterados pela pluralização do rails, caso aconteça aterar o arquivo de inflecção como no exemplo.

# config/initializers/inflections.rb
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'type_entity', 'type_entitys'
end

#ler mais sobre inflections
Acesse <https://api.rubyonrails.org/v7.1.3.4/classes/ActiveSupport/Inflector/Inflections.html>
```

#### Executar Rubocop:

```sh
# Executa a gem rubocop para executar algumas correções automáticas no código.
./run rubocop
```
