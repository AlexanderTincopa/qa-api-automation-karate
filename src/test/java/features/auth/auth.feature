Feature: autenticacion

  Background:
    * url baseUrl

  @smoke
  Scenario: login exitoso retorna un token
    Given path 'login'
    And request { email: 'eve.holt@reqres.in', password: 'cityslicka' }
    When method post
    Then status 200
    And match response contains { token: '#string' }

  @regression
  Scenario: login sin password retorna 400 con mensaje de error
    Given path 'login'
    And request { email: 'eve.holt@reqres.in' }
    When method post
    Then status 400
    And match response == { error: 'Missing password' }

  @regression
  Scenario: reutilizar token obtenido de un feature comun
    * def authResult = call read('classpath:features/common/get-token.feature')
    * match authResult.token == '#string'
