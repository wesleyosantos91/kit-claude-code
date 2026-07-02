# Regra: Organização de pacotes (Java)

Padrão de pacotes sob `src/main/java/<base-package>/`:

```text
Application.java
web/            # adapter de entrada (HTTP/gRPC/GraphQL)
  api/{v1,controller,request,response,mapper,exception}
  grpc/  graphql/
message/        # adapter assíncrono (entrada/saída)
  kafka/  sqs/  sns/
application/    # casos de uso
  service/  command/  query/  dto/
domain/         # núcleo de negócio, sem tecnologia
  model/  service/  repository/  event/  exception/
infrastructure/ # detalhes técnicos
  persistence/  client/  storage/  messaging/  config/
  security/  resilience/  logging/  metrics/  openapi/
core/           # transversal (sem regra de negócio)
  annotation/  validation/  mapper/  util/
```

## Regras

- `domain/repository` = interfaces; implementação em `infrastructure/persistence`.
- DTO de API vive em `web/api/{request,response}`, **não** no domínio.
- Mapeamento DTO↔domínio em `web/api/mapper` ou `core/mapper`.
- Entity JPA fica em `infrastructure/persistence`, **não** é Aggregate.
- `core` não acumula classes soltas; cada item tem subpacote claro.
- SOLID é obrigatório como critério de design.

## Não fazer

- Não reestruturar pacotes existentes **sem aprovação explícita do usuário**.
- Ao criar pacote novo, seguir exatamente esta convenção.

Validação automática: regras ArchUnit (ver `archunit/architecture-rules.md`) —
as dependências entre camadas devem ser verificadas por teste, não por revisão manual.
