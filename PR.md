Detect dependencies in Gradle included builds

In Gradle, a single build is composed of one root project with zero or more subprojects. A single build can also include other independent builds, each with its own settings file and root project.

```
main-build
\_settings.gradle
\_main-build-subproject
\_included-build
    \_settings.gradle
   \_included-build-subproject
TODO...
```

https://docs.gradle.org/current/javadoc/org/gradle/api/initialization/Settings.html#includeBuild-java.lang.Object

https://docs.gradle.org/current/javadoc/org/gradle/plugin/management/PluginManagementSpec.html#includeBuild-java.lang.String


