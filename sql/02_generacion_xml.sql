
-- Asignatura: Bases de Datos Avanzadas
-- Laboratorio 1: Almacenamiento y validacion XML en Oracle
-- Archivo: 02_generacion_xml.sql
-- Descripcion: Genera un documento XML a partir de
-- las tablas EMPLOYEES y DEPARTMENTS del esquema HR.
-- Utiliza XMLELEMENT, XMLATTRIBUTES, XMLFOREST,
-- XMLAGG y XMLSERIALIZE.
-- Ejecucion: Oracle SQL Developer, conexion HR_Local_XE.

SELECT XMLSERIALIZE(
         DOCUMENT
           XMLELEMENT("empleados",
             XMLAGG(
               XMLELEMENT("empleado",
                 XMLATTRIBUTES(
                   e.employee_id AS "id"
                 ),
                 XMLFOREST(
                   e.first_name AS "nombre",
                   e.last_name AS "apellido",
                   e.email AS "correo",
                   e.salary AS "salario"
                 ),
                 XMLELEMENT("departamento",
                   XMLATTRIBUTES(
                     d.department_id AS "id"
                   ),
                   d.department_name
                 )
               )
               ORDER BY e.employee_id
             )
           )
         AS CLOB
       ) AS documento_xml
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.department_id;
