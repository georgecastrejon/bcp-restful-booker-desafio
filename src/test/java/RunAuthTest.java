import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Clase que ejecuta pruebas de autenticación utilizando Karate.
 * Proporciona métodos para inicializar y finalizar las pruebas, además de ejecutar
 * un conjunto de pruebas etiquetadas.
 * @author [George Castrejon Sandoval]
 */
class RunAuthTest {
    private static final Logger logger = LoggerFactory.getLogger(RunAuthTest.class);

    /**
     * Metodo de prueba ejecutado por Karate.
     *
     * @return una instancia de {@link Karate} configurada para ejecutar pruebas con la etiqueta "smokeTest"
     * y relativa a la clase actual.
     */
    @Karate.Test
    Karate test() {
        return Karate.run()
                .tags("smokeTest")
                .relativeTo(getClass());
    }

    @BeforeAll
    public static void setUp() {
        logger.info("Se inicializan las pruebas.");
    }

    @AfterAll
    public static void tearDown() {
        logger.info("Se finalizan las pruebas.");
    }
}