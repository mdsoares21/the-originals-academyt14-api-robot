*** Settings ***
Documentation    Keywords para o PATH /Users 
Resource    ../resources/resource.robot


*** Keywords **
Criar sessao
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
Realizar Login
    ${body}    Create Dictionary    
    ...    mail=sysadmin@qacoders.com    
    ...    password=1234@Test
    #Log    ${body}
Pegar boardToken    
    Criar sessao
    ${body}    Create Dictionary    
    ...    mail=sysadmin@qacoders.com    
    ...    password=1234@Test
    ${resposta}    POST On Session    alias=develop    url=login    json=${body}    expected_status=200
    #Log To Console    ${resposta.json()}
    # Log To Console    ${resposta.json()["token"]}
    Status should be     200    ${resposta}
     RETURN    ${resposta.json()["token"]}

# Listagem Board
    
    # Criar sessao
    # ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json
    # Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    
    # Pegar boardToken
    # ${boardToken}    Pegar boardToken
    # GET On Session    alias=develop    url=board/?token=${boardToken}   
Listar Diretorias
    ${boardToken}=    Pegar boardToken
    ${headers}=       Create Dictionary    accept=application/json    Content-Type=application/json    Authorization=${boardToken}
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}=      GET On Session    alias=develop    url=board/?token=${boardToken}
    # Log To Console    ${resposta.status_code}
    #Log To Console    ${resposta.json()}
    RETURN          ${resposta}


# Count Board
#     Pegar boardToken
#     ${boardToken}    Pegar boardToken
#     GET On Session    alias=develop    url=board/count/?token=${boardToken}
Contar Diretorias
    ${boardToken}=    Pegar boardToken
    ${headers}=       Create Dictionary    accept=application/json    Content-Type=application/json    Authorization=${boardToken}
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}=      GET On Session    alias=develop    url=board/count/?token=${boardToken}
    # Log To Console    Status: ${resposta.status_code}
    #Log To Console    ${resposta.json()}
    RETURN          ${resposta}

    
Criar Palavra Randomica
    Criar sessao
    ${token}                Pegar boardToken
    ${palavra_randomica}    Generate Random String    8    [LETTERS]
    ${palavra_randomica}    Convert To Lower Case    ${palavra_randomica}
    Set Global Variable     ${DIRETORIA}    ${palavra_randomica}
    # Log                     ${DIRETORIA}

Cadastrar nova Diretoria 
    ${body}    Create Dictionary    boardName=${DIRETORIA}
    # Log    ${body}    
    Criar sessao
    ${boardToken}    Pegar boardToken   
    ${headers}       Create Dictionary    Authorization=${boardToken} 
    ${resposta}      POST On Session    alias=develop    url=board/    headers=${headers}    json=${body}
    ${json}=         Set Variable    ${resposta.json()}
    ${id}=           Get From Dictionary    ${json['newBoard']}    _id
    Set Global Variable    ${Id_Board}    ${id}
    # Log To Console         ${id}
    # Log                    ${Id_Board}
    #${body}=       To Json    ${resposta.content}
    #Log To Console    ${resposta.json().newBoard._id}    
    # ${id}=         Get From Dictionary    ${body['newBoard']}    _id
    # Set Global Variable    ${Id_Board}
    # Status should be     201    ${resposta}

Cadastrar nova Diretoria Duplicada
    ${body}    Create Dictionary    boardName=TesteMichaeel
    # Log    ${body}    
    Criar sessao
    ${boardToken}    Pegar boardToken   
    ${headers}       Create Dictionary    Authorization=${boardToken} 
    ${resposta}      POST On Session    alias=develop    url=board/    headers=${headers}    json=${body}    expected_status=any
    RETURN    ${resposta}   
    # ${resposta}    Cadastrar nova Diretoria Duplicada
    Validar Mensagem De Erro   ${resposta}    Não é possível salvar esse registro. Diretoria já cadastrada no sistema.

    # ${json}=         Set Variable    ${resposta.json()}
    # ${id}=           Get From Dictionary    ${json['newBoard']}    _id
    # Set Global Variable    ${Id_Board}    ${id}
    # Log To Console         ${id}
    # Log                    ${Id_Board}
    
Mostrar Diretoria ID       
    ${boardToken}    Pegar boardToken
    GET On Session    alias=develop    url=board/${Id_Board}/?token=${boardToken} 
    Log   ID da diretoria: ${Id_Board}
  

Editar dados Diretoria ID
    ${body}    Create Dictionary    boardName=${DIRETORIA} 
    # Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}       Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    # Log    ${Id_Board}
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=200 
    RETURN    ${resposta}
    # ${resposta}      GET On Session    alias=develop    url=board/${Id_Board}
    # Should Be Equal As Strings    ${resposta.json()["board"]["boardName"]}    ${DIRETORIA}
    # Log To Console    ==== PUT realizado com sucesso ====
    # Log    ${resposta.json()}

Editar dados Diretoria com & caracteres permitidos
    ${body}    Create Dictionary    boardName=${DIRETORIA}&${DIRETORIA}
    # Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}       Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    # Log    ${Id_Board}
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=200
    RETURN    ${resposta}

Editar diretoria boardName ausente
    ${body}    Create Dictionary    
    # Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=400
    RETURN    ${resposta}


Editar diretoria boardName com números
    ${body}    Create Dictionary    boardName=1234  
    # Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=400
    RETURN    ${resposta}    
    
Editar diretoria boardName com caracteres especiais
    ${body}    Create Dictionary    boardName=Clis@#$%  
    # Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=400
    RETURN    ${resposta} 


Post criar diretoria
    #Gerar dados dinâmicos
    ${random_board}    Generate Random String    8    [LETTERS]
    ${body}    Create Dictionary    boardName=${random_board}
    Criar Sessão
    ${token}    Pegar token
    ${resposta}    Post On Session    alias=develop    url=${url_4}/board?token=${Token}   json=${body}    expected_status=201
    # Log To Console    ${resposta.json()}
    ${id_board}    Set Variable    ${resposta.json()['newBoard']['_id']}
    Log To Console    ${resposta.json()['newBoard']['_id']}
    Set Global Variable    ${id_board}
    Log    ${id_board}
    RETURN    ${resposta}

Post criar diretoria Caracter Especial
    ${body}    Create Dictionary    boardName=&%%$&¨%$@!
    Criar Sessão
    ${token}    Pegar token
    ${resposta}    POST On Session    alias=develop    url=${url_4}/board?token=${token}    json={body}    expected_status=400
    # Log    ${resposta}
    RETURN    ${resposta}
    ${resposta}    Post criar diretoria Caracter Especial
    Validar Mensagem De Erro   ${resposta}    O campo 'diretoria' só pode conter letras e o caractere especial '&'.

Post criar diretoria com +50 Caracteres
    ${body}    Create Dictionary    boardName=qwertyuiopasdfghjklçmnbvcxzqwertyuiopasdfghjklçmnbvcxz
    Criar Sessão
    ${token}    Pegar token
    ${resposta}    POST On Session    alias=develop    url=${url_4}/board?token=${token}    json={body}    expected_status=400
    # Log    ${resposta}
    RETURN    ${resposta}
    ${resposta}    Post criar diretoria com +50 Caracteres
    Validar Mensagem De Erro   ${resposta}    O campo 'diretoria' deve possuir no máximo 50 caracteres.
    

Put Diretoria
    Post criar diretoria
    Criar Palavra Randomica
    ${body}    Create Dictionary    boardName=${DIRETORIA}
    ${token}    Pegar Token
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json    Authorization=${token} 
    ${resposta}    Create Session    alias=develop    url=${url_4}    headers=${headers}    verify=true
    PUT On Session    alias=develop    url=${url_4}board/${id_Board}    json=${body}    expected_status=200
    RETURN    ${resposta}

Validar Mensagem De Erro
    [Arguments]    ${resposta}    ${mensagem_erro}
    Should Be Equal As Strings    ${resposta.status_code}    400
    Should Be Equal As Strings    ${resposta.json()["error"][0]}    ${mensagem_erro}   

 
Validar Mensagem De Erro sem token
    [Arguments]    ${resposta}    ${mensagem_erro}
    Should Be Equal As Strings    ${resposta.status_code}    403
    Should Be Equal As Strings    ${resposta.json()["errors"][0]}    ${mensagem_erro}    

Validar Mensagem De Sucesso
    [Arguments]    ${resposta}    ${mensagem}
    Should Be Equal As Strings    ${resposta.status_code}    200
    Should Be Equal As Strings    ${resposta.json()["msg"]}    ${mensagem}        
 
Validar Mensagem De Sucesso Criação
    [Arguments]    ${resposta}    ${mensagem}
    Should Be Equal As Strings    ${resposta.status_code}    201
    Should Be Equal As Strings    ${resposta.json()["msg"]}    ${mensagem}      



Deletar Diretoria Criada
    ${boardToken}    Pegar boardToken
    ${headers}       Create Dictionary    accept=application/json    Content-Type=application/json    Authorization=${boardToken}
    DELETE On Session    alias=develop    url=board/${Id_Board}    headers=${headers}    expected_status=200
