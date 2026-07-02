---
name: terraform-module
description: Cria ou revisa módulos Terraform seguindo boas práticas (variáveis documentadas, naming, state remoto, IAM de menor privilégio). Use quando pedirem para criar infra, módulo Terraform ou revisar IaC.
---

# Skill: Terraform Module

## Objetivo

Criar/revisar módulos Terraform padronizados, seguros e componíveis.

## Quando usar

Ao criar infraestrutura, módulos Terraform ou revisar IaC.

## Quando NÃO usar

Para aplicar infraestrutura — `terraform apply`/`destroy` está na deny list
(`permissions/settings.json`) e exige execução humana.

## Inputs esperados

- O recurso/módulo desejado e o ambiente alvo.

## Workflow

1. Estruture o módulo no layout padrão.
2. Aplique as regras mandatórias (variáveis, naming, state, segurança).
3. Rode `terraform fmt` e `terraform validate`.
4. Percorra o checklist antes de concluir.

## Estrutura de módulo

```
modules/<nome>/
├── main.tf           # Recursos principais
├── variables.tf      # Variáveis de entrada (todas documentadas)
├── outputs.tf        # Outputs (todos documentados)
├── versions.tf       # Required providers e terraform version
├── locals.tf         # Valores computados (opcional)
└── README.md         # Documentação do módulo
```

## Regras mandatórias

- **Variáveis:** toda variável tem `description` e `type`; sensíveis com
  `sensitive = true`; restrições com `validation` block.
- **Outputs:** essenciais para composição (ARN, ID, endpoint), todos com `description`.
- **Naming:** `<service>-<component>-<environment>`; tags obrigatórias
  `Environment`, `Service`, `ManagedBy=terraform` via `locals.common_tags`.
- **State:** remoto em S3 com encryption + lock; nunca commitar `.tfstate`;
  state separado por ambiente.

```hcl
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

locals {
  name_prefix = "${var.service}-${var.environment}"
  common_tags = {
    Environment = var.environment
    Service     = var.service
    ManagedBy   = "terraform"
  }
}
```

## Saída esperada

Módulo completo passando no checklist:

- [ ] `terraform fmt` e `terraform validate` passaram
- [ ] Todas as variáveis documentadas; outputs relevantes expostos
- [ ] Tags obrigatórias presentes
- [ ] Sem segredos hardcoded (use Secrets Manager/variáveis)
- [ ] IAM de menor privilégio — nunca `"*"` em actions
- [ ] Security groups deny-by-default; encryption at rest habilitado
- [ ] Remote state configurado

## Segurança

- Nunca executar `terraform apply`/`destroy` — apenas `fmt`, `validate` e `plan`.
- Nunca hardcode credenciais/segredos em `.tf` ou `.tfvars` versionados.
