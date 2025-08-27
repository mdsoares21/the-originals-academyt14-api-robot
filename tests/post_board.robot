*** Settings ***
Documentation    Criar Diretoria
Resource    ../resources/resource.robot
Resource    ../resources/resource_board.robot

*** Test Cases ***
CT01 - Criar Diretoria
    Post criar diretoria

CT_02 - Criar Diretoria Caracter Especial
    Post criar diretoria Caracter Especial

CT_03 - Criar Diretoria com 50 Caracteres
    Post criar diretoria com +50 Caracteres

CT-04 - Editar Diretoria
    Put Diretoria

CT-05 - Editar dados Diretoria ID
    #[Teardown]    Deletar Diretoria Criada 
    Criar Palavra Randomica
    Cadastrar nova Diretoria
    Criar Palavra Randomica
    ${resposta}    Editar dados Diretoria ID
    Validar Mensagem De Sucesso   ${resposta}    Cadastro atualizado com sucesso.



CT-06 - Editar dados Diretoria com & caracteres permitidos
    Criar Palavra Randomica    
    Cadastrar nova Diretoria
    Criar Palavra Randomica
    ${resposta}    Editar dados Diretoria com & caracteres permitidos
    Validar Mensagem De Sucesso   ${resposta}    Cadastro atualizado com sucesso.

CT-07 -Editar diretoria boardName ausente
    Criar Palavra Randomica
    Cadastrar nova Diretoria
    ${resposta}    Editar diretoria boardName ausente  
    Validar Mensagem De Erro   ${resposta}    O campo 'diretoria' é obrigatório.

CT-08 - Editar diretoria boardName com números
    Criar Palavra Randomica
    Cadastrar nova Diretoria
    ${resposta}    Editar diretoria boardName com números
    Validar Mensagem De Erro   ${resposta}    O campo 'diretoria' só pode conter letras e o caractere especial '&'.
    

CT-09 - Editar diretoria boardName com caracteres especiais
    Criar Palavra Randomica    
    Cadastrar nova Diretoria
    ${resposta}    Editar diretoria boardName com caracteres especiais
    Log    ${resposta}
    Validar Mensagem De Erro   ${resposta}    O campo 'diretoria' só pode conter letras e o caractere especial '&'.

CT-10 - Cadastrar Diretoria Duplicada  
    Cadastrar nova Diretoria Duplicada
    

