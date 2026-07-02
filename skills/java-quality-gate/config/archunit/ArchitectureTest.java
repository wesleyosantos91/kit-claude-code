package SEU_PACOTE_BASE.architecture; // ajuste ao base package do projeto

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;

import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;

/**
 * Regras de arquitetura (ArchUnit). Validam o isolamento do domínio em relação
 * a frameworks/tecnologia, conforme package-organization.md. Com
 * allowEmptyShould(true), passam de forma vacuosa enquanto os pacotes não
 * existem e tornam-se efetivas assim que a estrutura for criada.
 */
@AnalyzeClasses(packages = "SEU_PACOTE_BASE", importOptions = ImportOption.DoNotIncludeTests.class)
class ArchitectureTest {

    @ArchTest
    static final ArchRule domain_should_not_depend_on_frameworks = noClasses().that().resideInAPackage("..domain..").should()
            .dependOnClassesThat().resideInAnyPackage("org.springframework..", "jakarta.persistence..", "javax.persistence..",
                    "software.amazon.awssdk..", "com.amazonaws..", "org.apache.kafka..", "io.awspring..")
            .allowEmptyShould(true);

    @ArchTest
    static final ArchRule web_should_not_access_jpa_persistence_directly = noClasses().that().resideInAPackage("..web..").should()
            .dependOnClassesThat().resideInAPackage("..infrastructure.persistence.jpa..").allowEmptyShould(true);
}
