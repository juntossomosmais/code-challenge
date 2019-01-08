
# Code Challenge Juntos Somos+

Para o desenvolvimento desse problema você pode utilizar alguma linguagem open-source, framework ou lib em que se sinta confortável. De preferência uma das nossas principais linguagens: Python, Kotlin, Node.js ou Java. Iremos avaliar a sua solução pela:

- Organização
- Manutenibilidade
- Rastreabilidade
- Testabilidade
- Performance
- Portabilidade

Esperamos que ele seja **PRODUCTION READY**, então coloque todas as boas práticas que você estiver acostumado.

# O desafio

Recebemos insumos de clientes via arquivo CSV das empresas participantes todo mês, contudo, recebemos de alguns no formato JSON.

Exemplo do CSV:

```
gender,name.title,name.first,name.last,location.street,location.city,location.state,location.postcode,location.coordinates.latitude,location.coordinates.longitude,location.timezone.offset,location.timezone.description,email,dob.date,dob.age,registered.date,registered.age,phone,cell,picture.large,picture.medium,picture.thumbnail
male,mr,joselino,alves,2095 rua espirito santo ,são josé de ribamar,paraná,96895,-35.8687,-131.8801,-10:00,Hawaii,joselino.alves@example.com,1996-01-09T02:53:34Z,22,2014-02-09T19:19:32Z,4,(97) 0412-1519,(94) 6270-3362,https://randomuser.me/api/portraits/men/75.jpg,https://randomuser.me/api/portraits/med/men/75.jpg,https://randomuser.me/api/portraits/thumb/men/75.jpg
```
Exemplo do JSON:

```
{"gender":"male","name":{"title":"mr","first":"antonelo","last":"da conceição"},"location":{"street":"8986 rua rui barbosa ","city":"santo andré","state":"alagoas","postcode":40751,"coordinates":{"latitude":"-69.8704","longitude":"-165.9545"},"timezone":{"offset":"+1:00","description":"Brussels, Copenhagen, Madrid, Paris"}},"email":"antonelo.daconceição@example.com","dob":{"date":"1956-02-12T10:38:37Z","age":62},"registered":{"date":"2005-12-05T15:22:53Z","age":13},"phone":"(85) 8747-8125","cell":"(87) 2414-0993","picture":{"large":"https://randomuser.me/api/portraits/men/8.jpg","medium":"https://randomuser.me/api/portraits/med/men/8.jpg","thumbnail":"https://randomuser.me/api/portraits/thumb/men/8.jpg"}}
```

Precisamos aplicar nossa regra de negócio a fim de casar com necessidades internas da Juntos Somos+.

## Regras de negócio que você precisa implementar

Costumamos trabalhar com os **clientes pelas 5 regiões do país**: 

- Norte
- Nordeste
- Centro-Oeste
- Sudeste
- Sul

Como a concentração de consultores nossos é mais forte em alguns pontos, dependendo da localidade do cliente pode ficar mais fácil nosso time atendê-lo. Considere os pontos abaixo **(bounding box) para classificá-lo de acordo com os rótulos**:

- **ESPECIAL**

```
minlon: -2.196998
minlat -46.361899
maxlon: -15.411580
maxlat: -34.276938
```
```
minlon: -19.766959
minlat -52.997614
maxlon: -23.966413
maxlat: -44.428305
```

- **NORMAL**

```
minlon: -26.155681
minlat -54.777426
maxlon: -34.016466
maxlat: -46.603598
```

- **TRABALHOSO:** Qualquer outro usuário que não se encaixa nas regras acima.

Outro ponto é que temos intenção de expandir os serviços para outros países, então **quanto mais genérico o cadastro, melhor**. Infelizmente os registros CSVs e JSONs não estão 100% prontos. Para melhorá-los, precisamos:

1. Transformar os contatos telefônicos no formato [E.164](https://en.wikipedia.org/wiki/E.164). Exemplo: (86) 8370-9831 vira +558683709831.
2. Inserir a nacionalidade. Como todos os clientes ainda são do brasil, o valor padrão será BR.
3. Alterar o valor do campo `gender` para `F` ou `M` em vez de `female` ou `male`.
4. Retirar o campo `age` de `dob` e `registered`.
5. Alterar estrutura para simplificar leitura e usar arrays em campos específicos (ver exemplo abaixo)

Exemplo de contrato de OUTPUT:

```
{
  "type": "laborious"
  "gender": "m",
  "name": {
    "title": "mr",
    "first": "quirilo",
    "last": "nascimento"
  },
  "location": {
    "region": "sul"
    "street": "680 rua treze ",
    "city": "varginha",
    "state": "paraná",
    "postcode": 37260,
    "coordinates": {
      "latitude": "-46.9519",
      "longitude": "-57.4496"
    },
    "timezone": {
      "offset": "+8:00",
      "description": "Beijing, Perth, Singapore, Hong Kong"
    }
  },
  "email": "quirilo.nascimento@example.com",
  "birthday": "1979-01-22T03:35:31Z",
  "registered": "2005-07-01T13:52:48Z",
  "telephoneNumbers": [
    "+556629637520"
  ],
  "mobileNumbers": [
    "+553270684089"
  ],
  "picture": {
    "large": "https://randomuser.me/api/portraits/men/83.jpg",
    "medium": "https://randomuser.me/api/portraits/med/men/83.jpg",
    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/83.jpg"
  },
  "nationality": "BR"
}

```

**Os dados devem ser armazenados conforme o contrato de OUTPUT também.**


## FRONT-END ou APPS: Fazer uma interface de interação

Em [função do nosso layout base](layout-desktop.jpg), **fique a vontade para reformulá-lo** a fim de casar com os seguintes **comportamentos obrigatórios**:
   
- Quando se clicar em um cliente, deve apresentar uma tela de detalhe com as informações dele.
- Permitir a possibilidade do usuário navegar entre as fotos dos clientes na listagem e/ou detalhe.
- Filtros pela região e/ou classificação do cliente.
- Paginação por 30 elementos.
- Interface responsiva (front) / adaptável para telas diferentes (apps).
- A lógica nesse caso ficará toda no front/app, então você vai trabalhar com todos dados em memória. O input deve ser acessado via request http (CORS friendly).
   
Use sua criatividade e aproveite das informações do usuário para mostrar o card e o detalhe como você entende que seria a melhor forma e também a mais performática.

Você deverá usar como input os links abaixo (~200 registros cada):

- https://storage.googleapis.com/juntossomosmais-code-challenge/input-frontend-apps.csv
- https://storage.googleapis.com/juntossomosmais-code-challenge/input-frontend-apps.json

## BACK-END: Fazer uma API

Coloque essa lógica numa API backend, onde dada a **região do usuário** e seu **tipo de classificação** em uma request o seu response será a **listagem dos elegíveis**. O routing da aplicação fica a seu gosto.

Assim como no FRONT-END e APPS, é **obrigatório** trabalhar com toda manipulação dos dados **em memória** (não é permitido usar qualquer tipo de database), então você precisará carregar o source em algum momento e fazendo **uma requisição HTTP** para uma das urls logo abaixo para obter os dados.

O payload da response, além de conter a lista de usuários com o contrato de _output_, **deve conter** os seguintes metadados de paginação e totais, implementar esses metadados é **obrigatório**:

```
  {
    pageNumber: int32,
    pageSize: int32,
    totalCount: int32,
    listings: [
      ...
    ]
  }
```

Faça essa API pensando que ela pode ser consumida por vários tipos de clientes e com diferentes propósitos, portanto implemente o que mais achar relevante e que faça sentido.

Você deverá usar como source os links abaixo (~1000 registros cada):

- https://storage.googleapis.com/juntossomosmais-code-challenge/input-backend.csv
- https://storage.googleapis.com/juntossomosmais-code-challenge/input-backend.json

# Prazo e como entregar

Esse desafio não deve tomar muito do seu tempo, a ideia dele é ser prático. Porém, vamos dar o prazo de **7 dias**  a partir do momento que você o recebê-lo.

Para entregá-lo você deve usar um dos seguintes serviços de hospedagem de código: [Bitbucket](https://bitbucket.org/), [GitLab](https://gitlab.com/) ou [GitHub](https://github.com/). O repositório deve ser **PRIVADO**. Fique ligado, repositórios públicos **não serão aceitos!**

Pedimos que você faça um **README** com pelo menos instruções básicas. Exemplos:

- Como rodar localmente
- Como rodar os testes
- Como fazer o deploy

Prezamos muito por documentação em forma de README, então faça dele seu cartão de visita. Caso as regras não estejam claras, implemente da maneira que achar melhor, pois na entrevista você poderá defender seu entendimento.

Quando terminar o desafio, avisa pra gente que nós vamos te passar uma lista de usuários que devem ter acesso de leitura ao seu repo pra poder cloná-lo e fazer a correção.

Bom teste!
