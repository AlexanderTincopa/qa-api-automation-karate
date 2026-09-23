package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Runner "maestro", es el unico incluido por defecto por maven-surefire-plugin
 * (ver pom.xml). Ejecuta todos los features del proyecto salvo los marcados con @ignore.
 * Para ejecuciones dirigidas usar SmokeRunner, UsersRunner o AuthRunner con
 * -Dtest=NombreDelRunner.
 */
class TestRunner {

    @Test
    void testAll() {
        Results results = Runner.path("classpath:features")
                .tags("~@ignore")
                .outputCucumberJson(true)
                .parallel(5);
        assertTrue(results.getFailCount() == 0, results.getErrorMessages());
    }
}
