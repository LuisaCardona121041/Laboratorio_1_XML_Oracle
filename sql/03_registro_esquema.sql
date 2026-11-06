
-- ============================================================
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- LABORATORIO 1: ALMACENAMIENTO Y VALIDACION XML EN ORACLE
-- ARCHIVO: 03_registro_esquema.sql
-- DESCRIPCION: Registra el esquema XSD en Oracle Database
--              y verifica que el registro sea correcto.
-- USUARIO: HR
-- CONTENEDOR: XEPDB1
-- ============================================================

-- ============================================================
-- PASO 1. VERIFICAR USUARIO Y CONTENEDOR
-- ============================================================

SELECT
    USER AS usuario,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor
FROM dual;


-- ============================================================
-- PASO 2. CONSULTAR LOS ESQUEMAS XML REGISTRADOS
-- ============================================================

SELECT
    schema_url,
    local
FROM user_xml_schemas
ORDER BY schema_url;


-- ============================================================
-- PASO 3. VERIFICAR PRIVILEGIOS DE LA SESION
-- ============================================================

-- Comprobar que CREATE TABLE esta disponible.

SELECT privilege
FROM session_privs
WHERE privilege = 'CREATE TABLE';


-- ============================================================
-- PASO 4. COMPROBAR SI EL ESQUEMA XSD YA ESTA REGISTRADO
-- ============================================================

-- Si devuelve una fila, NO ejecutar el bloque BEGIN.
-- Si no devuelve filas, se puede continuar con el registro.

SELECT schema_url
FROM user_xml_schemas
WHERE schema_url =
    'http://laboratorio1.local/empleados_departamentos.xsd';


-- ============================================================
-- PASO 5. REGISTRAR EL ESQUEMA XSD EN ORACLE
-- ============================================================

-- IMPORTANTE:
-- 1. Ejecutar este bloque UNA SOLA VEZ.
-- 2. No repetirlo si el esquema XSD ya esta registrado.
-- 3. La URL es un identificador logico del esquema;
--    no es necesario que exista como sitio web.
-- 4. Este procedimiento no modifica las tablas
--    originales EMPLOYEES y DEPARTMENTS.
-- 5. Ejecutar el bloque PL/SQL completo, incluido "/".

BEGIN
    DBMS_XMLSCHEMA.REGISTERSCHEMA(

        schemaURL =>
            'http://laboratorio1.local/empleados_departamentos.xsd',

        schemaDoc => q'~
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xs:element name="empleados">
        <xs:complexType>
            <xs:sequence>

                <xs:element name="empleado"
                            maxOccurs="unbounded">

                    <xs:complexType>
                        <xs:sequence>

                            <xs:element name="nombre"
                                        type="xs:string"/>

                            <xs:element name="apellido"
                                        type="xs:string"/>

                            <xs:element name="correo"
                                        type="xs:string"/>

                            <xs:element name="salario"
                                        type="xs:decimal"/>

                            <xs:element name="departamento">
                                <xs:complexType>
                                    <xs:simpleContent>
                                        <xs:extension base="xs:string">

                                            <xs:attribute
                                                name="id"
                                                type="xs:positiveInteger"
                                                use="required"/>

                                        </xs:extension>
                                    </xs:simpleContent>
                                </xs:complexType>
                            </xs:element>

                        </xs:sequence>

                        <xs:attribute
                            name="id"
                            type="xs:positiveInteger"
                            use="required"/>

                    </xs:complexType>
                </xs:element>

            </xs:sequence>
        </xs:complexType>
    </xs:element>

</xs:schema>
~',

        local     => TRUE,
        genTypes  => FALSE,
        genTables => FALSE,
        force     => FALSE,
        options   => DBMS_XMLSCHEMA.REGISTER_BINARYXML

    );
END;
/


-- ============================================================
-- PASO 6. VERIFICAR EL REGISTRO DEL ESQUEMA XML
-- ============================================================

-- Esta consulta debe devolver una fila con la URL
-- cuando el esquema se encuentra registrado.

SELECT schema_url
FROM user_xml_schemas
WHERE schema_url =
    'http://laboratorio1.local/empleados_departamentos.xsd';


-- ============================================================
-- FIN DEL ARCHIVO 03_registro_esquema.sql
-- ============================================================

