*** Settings ***
Resource    ../resources/resource.robot
Resource    ../resources/users.robot

*** Test Cases ***
CT-1 Criar Usuário
    Post criar usuário

CT-2 Validar Login 
    Pegar token
CT-3 Listagem de Users
    Listar users
    
CT-4 Contar Usuários
    Count Users

CT-5 Consultar Usuários ID
    Get users
    
CT-6 Alterar Status usuário para false
    Put status false

CT-7 Alterar Status usuário para true
    Put status true

CT-8 Deletar usuário
    Delete User
