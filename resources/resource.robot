*** Settings ***
Documentation        Arquivos das bibliotecas

Library    RequestsLibrary
Library    String
Library    Collections
Library    FakerLibrary

Resource    users.robot

*** Variables ***
${baseUrl}    https://api-15-the-originals.qacoders.dev.br/api/
${url_4}    https://api-15-the-originals.qacoders.dev.br/api/ 
${id_user}
${id_board}
${DIRETORIA}
  