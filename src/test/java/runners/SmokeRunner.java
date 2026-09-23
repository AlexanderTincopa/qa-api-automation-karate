package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Ejecuta solo los escenarios @smoke. No forma parte del include por defecto
 * de surefire; se invoca explicitamente con: mvn test -Dtest=SmokeRunner
 */
class SmokeRunner {

    @Test
    void testSmoke() {
        Results results = Runner.path("classpath:features")
                .tags("@smoke")
                .outputCucumberJson(true)
                .parallel(5);
        assertTrue(results.getFailCount() == 0, results.getErrorMessages());
    }
}
