
-- =====================================================
-- IMPORTANTE: INSTRUCCIONES DE EJECUCION
-- =====================================================
-- 1. El esquema XSD debe estar registrado previamente.
-- 2. Crear LAB_EMPLEADOS_XML solo si no existe.
-- 3. Ejecutar la insercion valida una sola vez.
-- 4. Comprobar que COUNT(*) devuelve 1.
-- 5. La insercion invalida debe generar un error.
-- 6. Ejecutar COUNT(*) nuevamente para confirmar
--    que el documento invalido no fue almacenado.
--
-- Ejecutar las secciones por separado en SQL Developer.
-- No ejecutar todo el archivo indiscriminadamente.
-- =====================================================

CREATE TABLE lab_empleados_xml OF XMLTYPE
  XMLTYPE STORE AS BINARY XML
  XMLSCHEMA
    "http://laboratorio1.local/empleados_departamentos.xsd"
  ELEMENT "empleados";


-- Verificar la creacion de la tabla XMLType

SELECT table_name
FROM user_xml_tables
WHERE table_name = 'LAB_EMPLEADOS_XML';

-- IMPORTANTE:
-- Ejecutar esta insercion una sola vez.
-- Repetirla puede aumentar el numero de documentos
-- almacenados y alterar el resultado esperado.
-- El conteo inicial de la tabla debe ser 0.

-- PRUEBA 1: INSERCION XML VALIDA

INSERT INTO lab_empleados_xml
VALUES (
  XMLTYPE(
    '<empleados>
       <empleado id="100">
         <nombre>Steven</nombre>
         <apellido>King</apellido>
         <correo>SKING</correo>
         <salario>24000</salario>
         <departamento id="90">Executive</departamento>
       </empleado>
     </empleados>'
  ).createSchemaBasedXML(
    'http://laboratorio1.local/empleados_departamentos.xsd'
  )
);

COMMIT;

-- Verificar el documento almacenado

SELECT COUNT(*) AS documentos_almacenados
FROM lab_empleados_xml;

-- PRUEBA 2: INSERCION XML INVALIDA
-- El salario contiene texto en lugar de un decimal.
-- Se espera que Oracle rechace la insercion.

INSERT INTO lab_empleados_xml
VALUES (
  XMLTYPE(
    '<empleados>
       <empleado id="999">
         <nombre>Empleado</nombre>
         <apellido>Prueba</apellido>
         <correo>PRUEBA</correo>
         <salario>NO_VALIDO</salario>
         <departamento id="90">Executive</departamento>
       </empleado>
     </empleados>'
  ).createSchemaBasedXML(
    'http://laboratorio1.local/empleados_departamentos.xsd'
  )
);


-- Verificar que el documento invalido no se almaceno

SELECT COUNT(*) AS documentos_almacenados
FROM lab_empleados_xml;

