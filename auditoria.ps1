# Definindo a codificação do console para UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Valor desejado para comparação
$desiredDomain = "MEUDOMINIO"
$excludedUsers = "NOMEHOST$", "0"

# Obtendo a data/hora atual e subtraindo 5 minutos para definir o intervalo de tempo
$FiveMinutesAgo = (Get-Date).AddMinutes(-5)

# Obtendo eventos do log de segurança com EventID 5145 dos últimos 5 minutos
$LatestEvents5145 = Get-EventLog -LogName Security | 
                    Where-Object {$_.EventID -eq 5145 -and $_.TimeGenerated -ge $FiveMinutesAgo -and $_.ReplacementStrings[2] -eq $desiredDomain -and $excludedUsers -notcontains $_.ReplacementStrings[1]}

# Caminho do arquivo de saída
$outputFilePath = "C:\zabbix\auditoria.txt"

# Inicializando o arquivo de saída
Set-Content -Path $outputFilePath -Value ""

# Mapeamento de códigos com "%%" para descrições
$mapaCodigos = @{
    "%%4416" = "Ler dados ou listar diretorio";
    "%%4417" = "Gravar dados ou adicionar arquivo";
    "%%4418" = "Anexar dados ou adicionar subdiretorio";
    "%%4419" = "Ler atributos de arquivo estendido";
    "%%4420" = "Gravar atributos de arquivo estendidos";
    "%%4421" = "Executar";
    "%%4422" = "Excluir Diretório";
    "%%4423" = "Ler atributos de arquivo estendido";
    "%%4424" = "Gravar atributos de arquivo";
    "%%1537" = "Exclusao";
    "%%1538" = "Leitura";
    "%%1541" = "Sincronizar";
}

# Verificando se algum evento foi encontrado
if ($LatestEvents5145) {
    foreach ($event in $LatestEvents5145) {
        # Separa os códigos e remove espaços extras e quebras de linha
        $codigosArray = @($event.ReplacementStrings[11] -split "[\s\n]+" | Where-Object { $_ -match "%%\d+" })

        # Captura o último código
        $ultimoCodigo = $codigosArray[-1]

        # Obtém a descrição da ação com base no último código
        $acao = $mapaCodigos[$ultimoCodigo]
        if (-not $acao) {
            $acao = "Código de evento desconhecido: $ultimoCodigo"
        }

        # Incluindo data e hora do evento
        $dataHoraEvento = $event.TimeGenerated.ToString("dd/MM/yyyy HH:mm:ss")

        $eventDetails = "$dataHoraEvento - O usuario $($event.ReplacementStrings[1]), no dominio $($event.ReplacementStrings[2]), executou a acao $acao, no caminho $($event.ReplacementStrings[9])`r`n"
        Add-Content -Path $outputFilePath -Value $eventDetails
    }
} else {
    Set-Content -Path $outputFilePath -Value "Nenhum evento recente EventID 5145 encontrado no dominio '$desiredDomain' ou eventos relacionados a arquivos no ultimo minuto."
}
