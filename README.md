# Laboratorio 1. Almacenamiento y validación de ficheros XML en Oracle

**Asignatura:** Bases de Datos Avanzadas  
**Universidad:** Universidad Internacional de La Rioja (UNIR)  
**Programa:** Ingeniería Informática  
**Estudiantes:** Luisa Fernanda Cardona Ortiz y Leidy Yolanda Jaramillo López  
**Fecha:** noviembre de 2026

## Descripción

Este repositorio reúne los archivos desarrollados para el Laboratorio 1, cuyo objetivo es generar, validar y almacenar documentos XML en **Oracle Database 21c Express Edition**.

Se utiliza el esquema de ejemplo **Human Resources (HR)**, relacionando las tablas `EMPLOYEES` y `DEPARTMENTS` por medio de `DEPARTMENT_ID`. A partir de esta información se genera un documento XML con funciones SQL/XML, se valida frente a un esquema XSD y se comprueba su aplicación en Oracle mediante inserciones válidas e inválidas.

## Objetivos de la práctica

1. Diseñar un esquema XSD para representar información de empleados y departamentos.
2. Generar un documento XML mediante `XMLELEMENT`, `XMLATTRIBUTES`, `XMLFOREST`, `XMLAGG` y `XMLSERIALIZE`.
3. Validar externamente el XML generado frente al XSD.
4. Registrar el esquema XSD en Oracle y comprobar las restricciones mediante una inserción válida y otra inválida.

## Herramientas

- Oracle Database 21c Express Edition (XE).
- Oracle SQL Developer.
- Visual Studio Code.
- Validador XML/XSD en línea: [XMLValid](https://xmlvalid.com/validate).
- Esquema HR de Oracle, con acceso a `EMPLOYEES` y `DEPARTMENTS`.

La práctica se ejecutó mediante la conexión local `HR_Local_XE`, con el usuario `HR` en el contenedor `XEPDB1`. Estos nombres corresponden al entorno utilizado y pueden variar en otra instalación.

## Estructura del repositorio

```text
Laboratorio_1_XML_Oracle/
├── sql/
│   ├── 02_generacion_xml.sql
│   ├── 03_registro_esquema.sql
│   └── 04_pruebas_validacion.sql
├── xml/
│   ├── empleados_departamentos.xml
│   └── empleados_departamentos.xsd
├── evidencias/
│   └── 01_...png a 11_...png
├── documentacion/
│   └── Memoria explicativa del laboratorio
└── README.md
```

La carpeta `evidencias` contiene las capturas de pantalla de los procedimientos y resultados. La carpeta `documentacion` contiene el informe académico cuando esté incorporado a la versión publicada.

## Orden de ejecución

> **Importante:** ejecutar los bloques de forma controlada en Oracle SQL Developer. No volver a ejecutar indiscriminadamente todo el contenido de los archivos, porque algunas instrucciones crean objetos, insertan datos o generan un error intencional.

### 1. Generar el documento XML

Ejecutar `sql/02_generacion_xml.sql` con acceso a las tablas `EMPLOYEES` y `DEPARTMENTS` del esquema HR. La consulta produce **una fila con el documento XML completo** en la columna `DOCUMENTO_XML`, ya que `XMLAGG` agrupa los elementos correspondientes a los empleados. El archivo de resultado se conserva como `xml/empleados_departamentos.xml`.

Esta consulta es de lectura y puede repetirse sin modificar las tablas originales.

### 2. Validar el XML frente al XSD

En [XMLValid](https://xmlvalid.com/validate), proporcionar `xml/empleados_departamentos.xml` y `xml/empleados_departamentos.xsd`. Durante la práctica, el validador informó **«Document is valid»**, sin errores ni advertencias.

### 3. Registrar el esquema XSD

Abrir `sql/03_registro_esquema.sql`. Ejecutar primero las consultas de comprobación de usuario, contenedor, privilegios y existencia previa del esquema.

El identificador utilizado es:

```text
http://laboratorio1.local/empleados_departamentos.xsd
```

Esta dirección funciona como **identificador lógico** del esquema y no requiere un sitio web activo.

**Ejecutar el bloque `DBMS_XMLSCHEMA.REGISTERSCHEMA` únicamente si el esquema todavía no está registrado.** Si la consulta a `USER_XML_SCHEMAS` devuelve el identificador anterior, omitir el registro. Al finalizar, verificar su existencia en esa misma vista.

### 4. Crear la tabla XMLType

Abrir `sql/04_pruebas_validacion.sql`. Crear `LAB_EMPLEADOS_XML` **solo si la tabla aún no existe**, una vez registrado el XSD. Comprobar su creación mediante `USER_XML_TABLES`.

La tabla de prueba utiliza almacenamiento XML binario y está asociada con el elemento raíz `empleados` del esquema registrado. No modifica las tablas originales de HR.

### 5. Ejecutar la inserción válida

Antes de insertar, comprobar que la tabla de prueba esté vacía. Ejecutar **una sola vez** la inserción del documento válido, confirmar con `COMMIT` y consultar:

```sql
SELECT COUNT(*) AS documentos_almacenados
FROM lab_empleados_xml;
```

En las condiciones iniciales del laboratorio, el resultado esperado es **1 documento almacenado**. Repetir la inserción válida puede agregar más documentos y alterar este conteo.

### 6. Ejecutar la inserción inválida

Ejecutar por separado la segunda inserción, que contiene deliberadamente:

```xml
<salario>NO_VALIDO</salario>
```

Como `salario` se define en el XSD mediante `xs:decimal`, **se espera que Oracle rechace el documento** y presente el error `LSX-00234: invalid decimal "NO_VALIDO"`.

El error es el **resultado esperado de la prueba**, no una instrucción que deba corregirse para que la inserción funcione. Consultar nuevamente `COUNT(*)`: si la tabla comenzó vacía y la inserción válida se hizo una sola vez, debe permanecer **1 documento**.

## Resultados principales

| Actividad | Resultado observado |
|---|---|
| Generación SQL/XML | Documento XML creado a partir de empleados y departamentos. |
| Validación externa | Documento válido frente al XSD utilizado. |
| Registro del XSD | Registro confirmado en `USER_XML_SCHEMAS`. |
| Creación de tabla XMLType | Tabla `LAB_EMPLEADOS_XML` creada y verificada. |
| Inserción válida | Aceptada; un documento almacenado. |
| Inserción inválida | Rechazada por incompatibilidad con `xs:decimal`. |
| Verificación final | Permanece un documento almacenado. |

## Alcance de la validación

El XSD comprueba la estructura y determinados tipos de datos. No establece por sí solo unicidad global de los identificadores, un formato de correo electrónico ni límites mínimos o máximos para el salario. Las pruebas corresponden a un entorno académico y no constituyen una evaluación de rendimiento.

## Documentación y evidencias

El informe y las capturas se conservan en las carpetas `documentacion/` y `evidencias/`. Los archivos SQL incluyen comentarios que identifican las consultas de verificación, las operaciones que deben ejecutarse una sola vez y el error esperado en la prueba inválida.
