# ARANHA-ZabbixAgentUpdate

[![Microsoft PowerShell](https://img.shields.io/badge/Windows-017AD7?style=for-the-badge&logo=windows&logoColor=white)](https://github.com/ferspider3/ARANHA-ZabbixAuditoriaFile)

## Informações Importantes

Script para geração de relatório de auditoria em arquivos. Como o exemplo prático de ler os eventos do 'Eventlog' sobre o evento 5145, retornar todo o contexto e informações não utéis; resolvi desenvolver esse script para filtragem de dados e melhor leitura para log de auditoria de arquivos.

## Passo a passo

1. Criar o item a ser capturado no seu zabbix_agentd.conf do host:
   `UserParameter=auditoria,type C:\zabbix\auditoria.txt`
2. Para leitura do arquivo, deverá ser criado um item no seu Host no Zabbix para ler os dados que serão capturados do paramêtro definido pelo agente:
  Nome: `Auditoria - Log de Arquivos`
  Tipo: `Agente Zabbix (Ativo)`
  Chave: `auditoria`
3. Finalizado!
