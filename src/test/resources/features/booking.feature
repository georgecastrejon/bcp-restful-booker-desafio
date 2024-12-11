@smokeTest
Feature: Gestión de Reservas
  Como usuario del sistema,
  quiero poder gestionar las reservas de manera eficiente,
  para poder crear, consultar, actualizar y eliminar reservas en el sistema.

  Background:
    * def config = karate.call('classpath:config.js')
    * def baseURL = config.baseURL
    * def headerscommon = read('classpath:headers/CommonHeader.json')

  @happy-path
  Scenario: Obtener lista de reservas sin parámetros opcionales
    Given url baseURL
    * path '/booking'
    When method GET
    Then status 200
    And match response == '#[]'
    And match each response == { bookingid: '#number' }

  @happy-path
  Scenario Outline: Obtener lista de reservas con parámetro opcional
    Given url baseURL
    * path '/booking'
    And param lastname = "<lastname>"
    When method GET
    Then status 200
    And match response[0] contains { bookingid: '#notnull' }

    Examples:
      | lastname |
      | Jones    |

  @unhappy-path
  Scenario: Obtener lista de reservas con url incorrecta
    Given url baseURL
    * path '/test/booking'
    When method GET
    Then status 404
    And match response == 'Not Found'

  @happy-path
  Scenario Outline: Consultar reserva existente con ID válido
    Given url baseURL
    * path '/booking/<bookingId>'
    And headers headerscommon
    When method GET
    Then status 200

    Examples:
      | bookingId |
      | 8         |

  @unhappy-path
  Scenario Outline: Consultar reserva existente con ID inexistente
    Given url baseURL
    * path '/booking/<bookingId>'
    And headers headerscommon
    When method GET
    Then status 404
    And match response == "Not Found"

    Examples:
      | bookingId |
      | 9999999999|

  @happy-path
  Scenario Outline: Crear una reserva con campos correctos
    Given url baseURL
    * path '/booking'
    And headers headerscommon
    And request { "firstname": "<firstname>", "lastname": "<lastname>", "totalprice": <totalprice>, "depositpaid": <depositpaid>, "bookingdates": { "checkin": "<checkin>", "checkout": "<checkout>" }, "additionalneeds": "<additionalneeds>" }
    When method POST
    Then status 200
    And match response.booking.firstname == "<firstname>"
    And match response.booking.lastname == "<lastname>"

    Examples:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Ana       | Arias    | 100        | true        | 2024-12-01 | 2024-12-10 | Breakfast       |
      | Jorge     | Arias    | 150        | false       | 2024-12-05 | 2024-12-12 | Dinner          |

  @unhappy-path
  Scenario Outline: Crear una reserva con campo obligatorio faltante
    Given url baseURL
    * path '/booking'
    And headers headerscommon
    And request { "lastname": "<lastname>", "totalprice": <totalprice>, "depositpaid": <depositpaid>, "bookingdates": { "checkin": "<checkin>", "checkout": "<checkout>" }, "additionalneeds": "<additionalneeds>" }
    When method POST
    Then status 500
    And match response == "Internal Server Error"

    Examples:
      |lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      |Doe      | 100        | true        | 2024-12-01 | 2024-12-10 | Breakfast       |

  @happy-path
    Scenario Outline: Actualizar reserva con datos válidos
    * call read('classpath:features/auth.feature@get_token')
    Given url baseURL
    * path '/booking/<bookingId>'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Cookie = 'token=' + accessToken
    And request { "firstname": "<firstname>", "lastname": "<lastname>", "totalprice": <totalprice>, "depositpaid": <depositpaid>, "bookingdates": { "checkin": "<checkin>", "checkout": "<checkout>" }, "additionalneeds": "<additionalneeds>" }
    When method PUT
    Then status 200
    And match response.firstname == "<firstname>"
    And match response.lastname == "<lastname>"

    Examples:
      | bookingId | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | 4         | John      | Doe      | 120        | true        | 2024-12-01 | 2024-12-10 | Breakfast       |

  @unhappy-path
  Scenario Outline: Actualizar reserva con campo faltante
    * call read('classpath:features/auth.feature@get_token')
    Given url baseURL
    * path '/booking/<bookingId>'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Cookie = 'token=' + accessToken
    And request { "lastname": "<lastname>", "totalprice": <totalprice>, "depositpaid": <depositpaid>, "bookingdates": { "checkin": "<checkin>", "checkout": "<checkout>" }, "additionalneeds": "<additionalneeds>" }
    When method PUT
    Then status 400
    And match response == "Bad Request"

    Examples:
      | bookingId | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | 4         |          | 120        | true        | 2024-12-01 | 2024-12-10 | Breakfast       |

  @happy-path
  Scenario Outline: Actualizar parcialmente algunos campos válidos
    * call read('classpath:features/auth.feature@get_token')
    Given url baseURL
    * path '/booking/<bookingId>'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Cookie = 'token=' + accessToken
    And request { "firstname": "<firstname>", "lastname": "<lastname>", "additionalneeds": "<additionalneeds>" }
    When method PATCH
    Then status 200
    And match response.firstname == "<firstname>"
    And match response.additionalneeds == "<additionalneeds>"

    Examples:
      | bookingId | firstname | lastname | additionalneeds |
      | 4         | John      | Doe      | Spa             |

  @unhappy-path
  Scenario Outline: Actualizar parcialmente con campos incorrectos
    * call read('classpath:features/auth.feature@get_token')
    Given url baseURL
    * path '/booking/<bookingId>'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Cookie = 'token=' + accessToken
    And request { "firstnameTTTTT": "<firstname>"}
    When method PATCH
    Then status 400
    And match response == "Bad Request"

    Examples:
      | bookingId | firstname |
      | 4         | John      |

  @happy-path
  Scenario Outline: Eliminar reserva existente con ID válido
    * call read('classpath:features/auth.feature@get_token')
    Given url baseURL
    * path '/booking/<bookingId>'
    * header Content-Type = 'application/json'
    * header Cookie = 'token=' + accessToken
    When method DELETE
    Then status 201
    And match response == "Created"

    Examples:
      | bookingId |
      | 6         |

  @unhappy-path
  Scenario Outline: Eliminar reserva existente con ID inexistente
    * call read('classpath:features/auth.feature@get_token')
    Given url baseURL
    * path '/booking/<bookingId>'
    * header Content-Type = 'application/json'
    * header Cookie = 'token=' + accessToken
    When method DELETE
    Then status 405
    And match response == "Method Not Allowed"

    Examples:
      | bookingId |
      | 999999999 |