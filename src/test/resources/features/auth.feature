@smokeTest
Feature: Autenticación API
  Como usuario del sistema,
  quiero probar el servicio de autenticación
  Para probar los escenarios happy path y unhappy path .

  Background:
    * def config = karate.call('classpath:config.js')
    * def baseURL = config.baseURL

  @happy-path
  @get_token
  Scenario Outline: Credenciales válidas generan un token exitosamente
    * def authData = {username: "<username>", password: "<password>"}
    Given url baseURL
    * path '/auth'
    And request authData
    When method POST
    Then status <status>
    And match response.token == '#notnull'
    * def accessToken = response.token

    Examples:
      | username | password    | status |
      | admin    | password123 | 200    |

  @unhappy-path
  Scenario Outline: Prueba de autenticación con credenciales incorrectas o campos faltantes
    Given url baseURL
    * path '/auth'
    And request {username: "<username>", password: "<password>"}
    When method POST
    Then status <status_code>
    And match response.reason == "<error_message>"

    Examples:
      | username       | password      | status_code | error_message          |
      | incorrectUser  | wrongPass     | 200         | Bad credentials        |
      |                | wrongPass     | 200         | Bad credentials        |
      | incorrectUser  |               | 200         | Bad credentials        |
