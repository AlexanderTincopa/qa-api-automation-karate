Feature: CRUD de usuarios

  Background:
    * url baseUrl
    * def userSchema =
      """
      {
        id: '#number',
        email: '#string',
        first_name: '#string',
        last_name: '#string',
        avatar: '#string'
      }
      """

  @smoke
  Scenario: listar usuarios paginados
    Given path 'users'
    And param page = 2
    When method get
    Then status 200
    And match response.page == 2
    And match each response.data contains userSchema

  @smoke
  Scenario: obtener un usuario existente por id
    Given path 'users', 2
    When method get
    Then status 200
    And match response.data contains userSchema

  Scenario: usuario inexistente retorna 404
    Given path 'users', 999
    When method get
    Then status 404

  @regression
  Scenario: crear un usuario
    Given path 'users'
    And request { name: 'morpheus', job: 'leader' }
    When method post
    Then status 201
    And match response contains { name: 'morpheus', job: 'leader', id: '#string', createdAt: '#string' }

  @regression
  Scenario: actualizar un usuario existente
    Given path 'users', 2
    And request { name: 'morpheus', job: 'zion resident' }
    When method put
    Then status 200
    And match response contains { name: 'morpheus', job: 'zion resident', updatedAt: '#string' }

  @regression
  Scenario: eliminar un usuario
    Given path 'users', 2
    When method delete
    Then status 204

  @regression
  Scenario Outline: crear usuarios con distintos roles (data-driven)
    Given path 'users'
    And request { name: '<name>', job: '<job>' }
    When method post
    Then status 201
    And match response.name == '<name>'
    And match response.job == '<job>'

    Examples:
      | name     | job          |
      | neo      | the one      |
      | trinity  | hacker       |
      | morpheus | captain      |
