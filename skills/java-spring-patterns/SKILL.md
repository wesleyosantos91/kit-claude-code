---
name: java-spring-patterns
description: Padrões e idiomas Spring Boot para produção - beans, resiliência (Resilience4j), segurança, messaging (Kafka/SQS), caching, scheduling, observabilidade. Use ao implementar features em Spring Boot ou resolver problemas Spring.
---

# Skill: Java Spring Patterns

## Objetivo

Aplicar padrões de produção ao implementar código Spring Boot, evitando os
anti-patterns conhecidos.

## Quando usar

Ao implementar features ou resolver problemas em projetos Spring Boot.

## Quando NÃO usar

Para validar qualidade/gates (use `java-quality-gate`) ou organização de
pacotes (ver `java-quality-gate/config/package-organization.md`).

## Inputs esperados

- A feature/problema em questão e o módulo alvo.

## Workflow

1. Identifique a categoria do problema (config, resiliência, messaging, cache...).
2. Aplique o padrão correspondente abaixo, adaptando nomes ao domínio.
3. Confira a lista de anti-patterns antes de concluir.

## Padrões

### Configuration properties (type-safe)

```java
@ConfigurationProperties(prefix = "app.payment")
public record PaymentProperties(String apiUrl, Duration timeout, int maxRetries) {}
// Ativar: @EnableConfigurationProperties(PaymentProperties.class)
```

### Resiliência (Resilience4j)

```java
@CircuitBreaker(name = "paymentService", fallbackMethod = "paymentFallback")
public PaymentResult processPayment(PaymentRequest request) {
    return paymentClient.charge(request);
}
```

```yaml
resilience4j:
  circuitbreaker:
    instances:
      paymentService:
        sliding-window-size: 10
        failure-rate-threshold: 50
        wait-duration-in-open-state: 30s
  retry:
    instances:
      paymentService:
        max-attempts: 3
        wait-duration: 500ms
        exponential-backoff-multiplier: 2
```

### Security (JWT resource server)

```java
@Bean
SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    return http
        .csrf(AbstractHttpConfigurer::disable)
        .sessionManagement(s -> s.sessionCreationPolicy(STATELESS))
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/actuator/health/**").permitAll()
            .requestMatchers("/api/v1/admin/**").hasRole("ADMIN")
            .anyRequest().authenticated())
        .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
        .build();
}
```

### Messaging (Kafka / SQS)

```java
@KafkaListener(topics = "${app.kafka.topics.orders}", groupId = "${spring.application.name}")
public void consume(@Payload OrderEvent event) { orderService.process(event); }

@SqsListener("${app.sqs.queues.orders}")
public void consume(@Payload OrderEvent event) { orderService.process(event); }
```

### Caching

```java
@Cacheable(value = "products", key = "#productId", unless = "#result == null")
public Product findProduct(String productId) { ... }

@CacheEvict(value = "products", key = "#product.id")
public Product updateProduct(Product product) { ... }
```

### Scheduling com lock distribuído

```java
@Scheduled(fixedDelayString = "${app.cleanup.interval:PT1H}")
@SchedulerLock(name = "cleanupExpiredOrders", lockAtLeastFor = "PT5M")
public void cleanupExpiredOrders() { ... }
```

### Observabilidade (Micrometer)

```java
@Bean
MeterBinder orderMetrics(OrderRepository repository) {
    return registry -> Gauge.builder("orders.pending.count", repository::countPending)
        .register(registry);
}
```

## Anti-patterns a evitar

- `@Autowired` em campo — preferir constructor injection.
- `@Transactional` em classe inteira — ser explícito por método.
- Service chamando controller — violação de camadas.
- `spring.jpa.open-in-view: true` — N+1 silencioso.
- Catch genérico em `@Service` — deixar propagar para o handler global.
- `@Async` sem executor configurado — usa pool default (perigoso).

## Saída esperada

Código seguindo os padrões acima, com justificativa de 1 linha quando um
padrão for deliberadamente não aplicado.

## Segurança

- Nunca hardcode secrets em properties/código — use variáveis de ambiente
  ou secret manager.
