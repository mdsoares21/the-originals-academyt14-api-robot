*** Settings ***
Documentation    Keywords para PATH / Users
Resource    resource.robot
Library    FakerLibrary

*** Keywords ***
Criar Sessão
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=develop    url=${url_4}    headers=${headers}    verify=true

Validar Status 200
    [Arguments]    ${resposta}
    Should Be Equal As Integers    ${resposta.status_code}    200

Realizar Login
    ${body}    Create Dictionary
    ...    mail=sysadmin@qacoders.com
    ...    password=1234@Test
    #Log    ${body}
    Criar Sessão
        ${resposta}    POST On Session    alias=develop    url=/Login    json=${body}
        #Log To Console    ${resposta.json()}
        #Log To Console    ${resposta.json()['token']}
        Should Be Equal As Integers    ${resposta.status_code}    200


Pegar Token
    ${body}    Create Dictionary
    ...    mail=sysadmin@qacoders.com
    ...    password=1234@Test
    #Log    ${body}
    Criar Sessão
        ${resposta}    POST On Session    alias=develop    url=/Login    json=${body}
        #Log To Console    ${resposta.json()}
        #Log To Console    ${resposta.json()['token']}
        Should Be Equal As Integers    ${resposta.status_code}    200
        RETURN    ${resposta.json()['token']}

Listar Users
    ${token}    Pegar token
    Get On Session    alias=develop    url=/user/?token=${Token}

Count users
    ${token}    Pegar token
    Get On Session    alias=develop    url=/user/count?token=${Token}

Get users
    ${token}    Pegar token
    Get On Session    alias=develop    url=/user/${id_user}?token=${Token}

Post criar usuário
    ${token}    Pegar Token
    #Gerar dados dinâmicos
    ${first_name}    FakerLibrary.First Name
    ${last_name}    FakerLibrary.Last Name
    ${name}    Set Variable    ${first_name} ${last_name}
    ${random_email}    Catenate    SEPARATOR=@    ${first_name}    teste.com
    ${random_cpf}    Generate Random String    11    [NUMBERS]
    ${body}    Create Dictionary
    ...    fullName=${name}
    ...    mail=${random_email}
    ...    accessProfile=ADMIN
    ...    cpf=${random_cpf}
    ...    password=1234@Test
    ...    confirmPassword=1234@Test
    #Criar Sessão
    ${resposta}    Post On Session    alias=develop    url=/user/?token=${token}   json=${body}    #expected_status=any
    #Esperava STATUS CODE 201, MAS API RETORNOU 200
    Status Should Be    201    ${resposta}
    ${id_user}    Set Variable    ${resposta.json()['user']['_id']}
    Log To Console    ${resposta.json()['user']['_id']}
    Set Global Variable    ${id_user}
    RETURN    ${id_user}

Put status false
    ${token}    Pegar token
    Post criar usuário
    ${body}    Create Dictionary    status=false
    Put On Session    alias=develop    url=user/status/${id_user}?token=${Token}

Put status true
    ${token}    Pegar token
    Post criar usuário
    ${body}    Create Dictionary    status=true
    ${BANANA}    Put On Session    alias=develop    url=user/status/${id_user}?token=${Token}
    Log To Console    ${banana.json()}

# Criar Sessão
#     ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json
#     Create Session    alias=develop    url=${baseUrl}    headers=${headers}    verify=true

Validar Status 200
    [Arguments]    ${resposta}
    Should Be Equal As Integers    ${resposta.status_code}    200

Delete User
    Post criar usuário
    ${token}    Pegar Token
    DELETE On Session    alias=develop    url=/user/${id_user}?token=${token}


