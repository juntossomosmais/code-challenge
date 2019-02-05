
# Code Challenge Juntos Somos+

O objetivo desse code challenge é, mais do que seu currículo, formação e certificações, avaliarmos como você lida com esse desafio, quais ferramentas escolhe, a qualidade do seu código e a maneira de pensar nele.

A solução desse desafio é extremamente importante para entendermos os seus requisitos de qualidade, organização do seu código, performance, portabilidade, etc.

Sinta-se à vontade para escolher a tecnologia e ferramentas que achar necessário. Queremos ser surpreendidos pela sua abordagem no desafio!

Temos apenas dois pré-requisitos: código testado e pronto para produção.

Topa?

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


## FRONT-END/APPS: Interface

Em [função do nosso layout base](layout-desktop.jpg), **fique a vontade para reformulá-lo** a fim de casar com os seguintes **requisitos obrigatórios**:
  
  - Uma tela de detalhe deve ser apresentada quando se clicar em um cliente.
  - Navegação entre as fotos dos clientes.
  - Filtros pela região e/ou classificação do cliente.
  - A interface **deve** ser responsiva (front-end)
  - A interface **deve** ser adaptável para telas diferentes (apps)
  - Não deve existir alguém externo, isto é, todo a lógica tem que ser trabalhada em memória, dentro do seu projeto. O carregamento dos dados de input deve ser por meio de request HTTP.

Desenvolva da maneira que você achar melhor como mostrar os dados do usuário.

Use como input os links abaixo (~200 registros cada):

- https://storage.googleapis.com/juntossomosmais-code-challenge/input-frontend-apps.csv
- https://storage.googleapis.com/juntossomosmais-code-challenge/input-frontend-apps.json

## BACK-END: API

Pense em uma API que dada a **região do usuário** e seu **tipo de classificação**, responda a **listagem dos elegíveis**. Não existe routing definido para a aplicação, fica a seu gosto.

É **obrigatório** trabalhar com toda manipulação dos dados **em memória**. O carregamento dos dados de input deve ser por meio de request HTTP.

Além da lista dos usuários elegíveis, para permitir navegação entre os registros, **deve ser implementado** os seguintes metadados de paginação:

```
  {
    pageNumber: X,
    pageSize: P,
    totalCount: T,
    users: [
      ...
    ]
  }
```

Imagine que essa API seja possa ser acessada por consumidores específicos, então coloque o que mais achar necessário.

Use como input os links abaixo (~1000 registros cada):

- https://storage.googleapis.com/juntossomosmais-code-challenge/input-backend.csv
- https://storage.googleapis.com/juntossomosmais-code-challenge/input-backend.json

# Como entregar

Você deve disponibilizar seu código em algum serviço de hospedagem como Bitbucket, Gitlab ou Github e manter o repositório como privado.

É obrigatório ter um **README** com todas as instruções sobre o seu desafio.

Assim que finalizar, nos avise para enviarmos os usuários que devem ter acesso para avaliação.
