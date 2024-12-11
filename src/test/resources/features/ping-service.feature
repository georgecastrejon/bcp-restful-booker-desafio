@smokeTest
Feature: Verificación del Servicio
  Como usuario del sistema,
  quiero poder verificar el servicio de reservas,
  para poder asegurar conectividad.

  Background:
    * def config = karate.call('classpath:config.js')
    * def baseURL = config.baseURL

  @happy-path
  Scenario: Consultar estado del servicio
    Given url baseURL
    * path '/ping'
    When method get
    Then status 201
    And match response == 'Created'