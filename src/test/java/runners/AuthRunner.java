package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

class AuthRunner {

    @Test
    void testAuth() {
        Results results = Runner.path("classpath:features/auth")
                .outputCucumberJson(true)
                .parallel(5);
        assertTrue(results.getFailCount() == 0, results.getErrorMessages());
    }
}
