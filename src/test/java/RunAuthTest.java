import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class RunAuthTest {
    private static final Logger logger = LoggerFactory.getLogger(RunAuthTest.class);

    @Karate.Test
    Karate testAuth() {
        return Karate.run("features/auth.feature").relativeTo(getClass());
    }

    @BeforeAll
    public static void setUp() {
        logger.info("Configuración global antes de ejecutar los features.");
    }

    @AfterAll
    public static void tearDown() {
        logger.info("Limpieza después de ejecutar todos los features.");
    }
}