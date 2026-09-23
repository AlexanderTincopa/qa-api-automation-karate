function fn() {
  var env = karate.env; // valor de -Dkarate.env
  karate.log('karate.env ->', env);

  if (!env) {
    env = 'dev';
  }

  var config = {
    env: env,
    baseUrl: 'https://reqres.in/api',
    apiKey: 'reqres-free-v1'
  };

  // Overrides especificos por ambiente. Reemplazar por las URLs reales del proyecto.
  if (env == 'dev') {
    config.baseUrl = 'https://reqres.in/api';
  } else if (env == 'qa') {
    config.baseUrl = 'https://reqres.in/api';
  } else if (env == 'prod') {
    config.baseUrl = 'https://reqres.in/api';
  } else {
    karate.log('WARN: ambiente desconocido "' + env + '", usando baseUrl de dev');
  }

  // Timeouts y headers globales aplicados a todas las llamadas
  karate.configure('connectTimeout', 15000);
  karate.configure('readTimeout', 15000);
  karate.configure('headers', { 'x-api-key': config.apiKey });

  // SSL relajado solo para ambientes no productivos con certificados self-signed
  if (env != 'prod') {
    karate.configure('ssl', true);
  }

  return config;
}
