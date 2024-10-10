# frozen_string_literal: true

require 'faker'

# Create AOffice
office = Office.create({
                         name: 'Diretor'
                       })

# Create Admin
User.create({
              name: 'Suporte',
              email: 'suporte@agenciaw3.digital',
              avatar: Rails.root.join('db/assets/images/user-avatar.png').open,
              password: 'w3case2022',
              password_confirmation: 'w3case2022',
              office_id: office.id,
              cpf: '123.456.789-00',
              sex: 0,
              cep: '12345-678',
              uf: 'SP',
              city: 'São Paulo',
              street: 'Rua Exemplo',
              neighborhood: 'Bairro Exemplo',
              super_user: true
            })

puts '--> Admin criado'

# Create Type Entity
TypeEntity.create({
                    name: 'Prefeitura Municipal'
                  })
TypeEntity.create({
                    name: 'Câmara de vereadores'
                  })

# Create Entity

Entity.create(
  number_edition: Faker::Number.number(digits: 2),
  cnpj: '03.173.317/0001-18',
  phone: '(67) 3441-1250',
  type_entity_id: TypeEntity.all.sample.id,
  user_id: User.all.sample.id,
  name_entity: 'Prefeitura Municipal de Nova Andradina',
  uf: 'MS',
  city: 'Nova Andradina',
  cep: '79750000',
  street: 'Avenida Antonio Joaquim de Moura Andrade',
  number_address: '541',
  complement: 'Centro',
  law: "Lei #{Faker::Number.number(digits: 2)}",
  name_diary: 'Diário Oficial de Nova Andradina',
  logo: Rails.root.join('db/assets/images/novaandradina-logo.png').open,
  status: true
)

Entity.create(
  number_edition: Faker::Number.number(digits: 2),
  cnpj: '03.132.498/0001-62',
  phone: '(67) 3465-1280',
  type_entity_id: TypeEntity.all.sample.id,
  user_id: User.all.sample.id,
  name_entity: 'Prefeitura Municipal de Jateí',
  uf: 'MS',
  city: 'Jateí',
  cep: '79720000',
  street: 'Rua Miranda',
  number_address: '354',
  complement: 'Centro',
  law: "Lei #{Faker::Number.number(digits: 2)}",
  name_diary: 'Diário Oficial de Jateí',
  logo: Rails.root.join('db/assets/images/jatei-logo.png').open,
  status: true
)

Entity.create(
  number_edition: Faker::Number.number(digits: 2),
  cnpj: '03.123.456/0001-89', # CNPJ da Prefeitura de Batayporã
  phone: '(67) 3443-1280', # Telefone da Prefeitura de Batayporã
  type_entity_id: TypeEntity.all.sample.id,
  user_id: User.all.sample.id,
  name_entity: 'Prefeitura Municipal de Batayporã',
  uf: 'MS',
  city: 'Batayporã',
  cep: '79760000',
  street: 'Avenida Brasil',
  number_address: '402',
  complement: 'Centro',
  law: "Lei #{Faker::Number.number(digits: 2)}",
  name_diary: 'Diário Oficial de Batayporã',
  logo: Rails.root.join('db/assets/images/bataypora-logo.png').open,
  status: true
)

Entity.create(
  number_edition: Faker::Number.number(digits: 2),
  cnpj: '03.987.654/0001-32',
  phone: '(67) 3445-1122',
  type_entity_id: TypeEntity.all.sample.id,
  user_id: User.all.sample.id,
  name_entity: 'Prefeitura Municipal de Anaurilândia',
  uf: 'MS',
  city: 'Anaurilândia',
  cep: '79770000',
  street: 'Rua Mato Grosso',
  number_address: '160',
  complement: 'Centro',
  law: "Lei #{Faker::Number.number(digits: 2)}",
  name_diary: 'Diário Oficial de Anaurilândia',
  logo: Rails.root.join('db/assets/images/anaurilandia-logo.png').open,
  status: true
)

Entity.create(
  number_edition: Faker::Number.number(digits: 2),
  cnpj: '03.654.321/0001-45',
  phone: '(67) 3412-1234',
  type_entity_id: TypeEntity.all.sample.id,
  user_id: User.all.sample.id,
  name_entity: 'Prefeitura Municipal de Douradina',
  uf: 'MS',
  city: 'Douradina',
  cep: '79880000',
  street: 'Avenida Presidente Vargas',
  number_address: '255',
  complement: 'Centro',
  law: "Lei #{Faker::Number.number(digits: 2)}",
  name_diary: 'Diário Oficial de Douradina',
  logo: Rails.root.join('db/assets/images/douradina-logo.png').open,
  status: true
)

Entity.create(
  number_edition: Faker::Number.number(digits: 2),
  cnpj: '04.321.987/0001-67',
  phone: '(67) 3476-1422',
  type_entity_id: TypeEntity.all.sample.id,
  user_id: User.all.sample.id,
  name_entity: 'Prefeitura Municipal de Itaquiraí',
  uf: 'MS',
  city: 'Itaquiraí',
  cep: '79965000',
  street: 'Avenida Industrial',
  number_address: '123',
  complement: 'Centro',
  law: "Lei #{Faker::Number.number(digits: 2)}",
  name_diary: 'Diário Oficial de Itaquiraí',
  logo: Rails.root.join('db/assets/images/itaquirai-logo.png').open,
  status: true
)

Entity.create(
  number_edition: Faker::Number.number(digits: 2),
  cnpj: '05.876.543/0001-21',
  phone: '(67) 3541-1234',
  type_entity_id: TypeEntity.all.sample.id,
  user_id: User.all.sample.id,
  name_entity: 'Prefeitura Municipal de Santa Rita do Pardo',
  uf: 'MS',
  city: 'Santa Rita do Pardo',
  cep: '79690000',
  street: 'Rua Presidente Vargas',
  number_address: '455',
  complement: 'Centro',
  law: "Lei #{Faker::Number.number(digits: 2)}",
  name_diary: 'Diário Oficial de Santa Rita do Pardo',
  logo: Rails.root.join('db/assets/images/santaritadopardo-logo.png').open,
  status: true
)

# Create BranchGovernment
BranchGovernment.create(name: 'Poder Executivo')
BranchGovernment.create(name: 'Poder Legislativo')

# Seed file for populating the database with categories and subcategories

# Helper method to create categories and subcategories
def create_category_with_subcategories(category_name, subcategories = [])
  category = DiaryCategory.create(name: category_name)
  subcategories.each do |subcategory_name|
    DiarySubCategory.create(name: subcategory_name, diary_category: category)
  end
end

# List of categories with their respective subcategories (if any)
categories_with_subcategories = {
  'Atas' => %w[Deliberativa Convocatória Chamamento Regimental],
  'Aviso' => ['Licitação', 'Adjudicação', 'Convocação', 'Anulação', 'Dispensa', 'Homologação',
              'Impugnação de edital', 'Inexigibilidade', 'Notificação de penalidades', 'Permissão de uso',
              'Rescisão de contrato', 'Revogação', 'Habilitação de licitante', 'Abertura de concorrência',
              'Adiamento de licitação', 'Contrato', 'Recurso', 'Registro de preço', 'Termo de aditivo',
              'Cancelamento', 'Extrato de contrato', 'Julgamento', 'Parecer de deliberação da comissão julgadora'],
  'Contratos' => ['Aditivo', 'Serviços', 'Fornecimento', 'Extrato de Contrato Administrativo',
                  'Termo Aditivo ao Contrato Administrativo', 'Termo de Encerramento do Contrato Administrativo',
                  'Extrato do Termo Aditivo ao Contrato Administrativo'],
  'Decreto' => %w[Executivo Legislativo Revogação Nomeação],
  'Decisão' => %w[Judicial Administrativa Disciplinar],
  'Despacho' => %w[Administrativo Legislativo Comissão],
  'Edital' => ['Pregão Eletrônico', 'Chamada pública', 'Concurso/Seletivo Simplificado'],
  'Lei' => ['Lei Ordinária', 'Lei Complementar', 'Lei de Responsabilidade Fiscal', 'Decreto', 'Lei Orgânica',
            'Resolução'],
  'Licitação' => ['Concorrência', 'Pregão', 'Dispensa', 'Diálogo competitivo', 'ATA de Registro de Preços',
                  'Aviso de Pregão Eletrônico', 'Aviso de Pregão Presencial', 'Aviso de Dispensa',
                  'Adesão/Carona em Registro de Preços', 'Chamada Pública', 'Inexigibilidade',
                  'Licitação Dispensável', 'Resultado de Pregão Eletrônico', 'Resultado de Pregão Presencial',
                  'Resultado de Dispensa de Licitação', 'Resultado de Inexigibilidade de Licitação', 'Resultado de Chamada Pública'],
  'Ofícios' => %w[Comunicação Solicitação Informação],
  'Portaria' => %w[Nomeação Exoneração Lotação],
  'Requerimentos' => ['Solicitações', 'Documentos', 'Procedimentos diversos'],
  'Resolução' => ['Administrativa', 'Normativa', 'Específica/complementar'],
  'Projeto de lei' => ['Complementar', 'Emenda', 'Sancionado(a)'],
  'Resolução Legislativa' => %w[Deliberação Decisão Normativa],
  'Extrato de Contrato' => %w[Execução Aditamento Contratual],
  'Extrato' => ['Pagamento', 'Recebimento', 'Extrato diversos'],
  'Parecer' => ['Análise', 'Parecer Técnico', 'Juridico'],
  'Homologação' => ['Contratual', 'Adjudicação', 'Processo Licitatório'],
  'Rescisão' => ['Rescisão Unilateral', 'Amigável', 'De ofício'],
  'Exoneração' => %w[Desligamento Demissão Afastamento],
  'Demonstrativo' => %w[Financeiro Contábil Técnico],
  'Relatório Fiscal' => ['Fiscalização', 'Auditoria', 'Relatório complementar'],
  'Convocação' => ['Administrativa', 'Extraordinária', 'Chamamento público'],
  'Nomeação' => ['Concurso/Seletivo', 'Cargos de comissão', 'Cargo de Confiança'],
  'Termo de Retificação' => %w[Alteração Ajuste Correção],
  'Retificação' => %w[Retificação Correção Modificação],
  'Ratificação' => %w[Validação Confirmação Ratificação],
  'Adjudicação' => %w[Aprovação Homologação Decisão],
  'Chamada Pública' => ['Agricultura Familiar', 'Empresas', 'Processo Licitatório'],
  'Cancelamento' => %w[Revogação Cancelamento Anulação],
  'Atos de Pessoal' => ['Portaria de Férias', 'Portaria de Licença para Trato de Assunto Particular - TIP',
                        'Portaria de Licença Maternidade', 'Portaria de Licença para Tratamento de Saúde',
                        'Extrato de Contrato de Trabalho', 'Extrato de Aditivo ao Contrato de Trabalho',
                        'Exoneração', 'Alteração de Lotação', 'Outros Atos de Pessoal'],
  'Prestação de Contas' => ['RREO – Relatório Resumido', 'PPA', 'LDO', 'LOA', 'RGF'],
  'Outros' => ['Notificação Judicial', 'Extrajudicial', 'Aviso'],
  'Categoria Indefinida' => ['Genérico', 'Não especificado', 'Outros'],
  'PPA - Plano Plurianual' => [],
  'LDO - Lei de Diretrizes Orçamentárias' => [],
  'LOA - Lei Orçamentária Anual' => [],
  'RGF - Relatório de Gestão Fiscal' => [],
  'Termo Aditivo' => []
}

# Create categories and subcategories
categories_with_subcategories.each do |category_name, subcategories|
  create_category_with_subcategories(category_name, subcategories)
end

# Create OfficialDiary
# official_diary = OfficialDiary.create({
#                                         title: 'Diário Oficial 01',
#                                         slug: 'diario-oficial-01',
#                                         certificate: 'Certificado-001'

#                                       })

# # Create Section
# Section.create({
#                  description: 'Descrição da seção de exemplo',
#                  branch_government: branch_government_1,
#                  diary_category: diary_category_1,
#                  diary_sub_category: diary_sub_category_1,
#                  official_diary: official_diary
#                })

# puts '--> Section criada'
