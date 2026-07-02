# Template: achado de agente

Formato padrão para reportar achados de qualquer subagente/skill.

```markdown
- **Agente:** <nome>
- **Severidade:** CRÍTICO | ALTO | MÉDIO | BAIXO (ver review-severity-matrix.md)

## Achado
<Descrição objetiva.>

## Evidência
- `arquivo:linha` — <trecho/observação>
- Comando/saída: <quando aplicável>

## Recomendação
<Ação acionável e proporcional ao risco.>

## Validação sugerida
<Como confirmar a correção (teste/comando).>
```

Sem evidência verificável → rebaixar severidade ou marcar "a investigar"
(ver `evidence-rules.md`).
