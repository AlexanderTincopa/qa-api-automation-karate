@ignore
Feature: obtener token de autenticacion reutilizable

  # Feature "callable" desde otros features con:
  #   * def authResult = call read('classpath:features/common/get-token.feature')
  #   * def token = authResult.token
  # Centraliza el login para no repetirlo en cada escenario.

  Background:
    * url baseUrl

  Scenario:
    Given path 'login'
    And request { email: 'eve.holt@reqres.in', password: 'cityslicka' }
    When method post
    Then status 200
    * def token = response.token
