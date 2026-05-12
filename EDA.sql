-- EDA
select count(*) 
from lendsmart.stg2_loan_applications; -- 32349

SELECT
    SUM(CASE WHEN edad                  IS NULL THEN 1 ELSE 0 END) AS nulos_edad,
    SUM(CASE WHEN ingreso_anual         IS NULL THEN 1 ELSE 0 END) AS nulos_ingreso_anual,
    SUM(CASE WHEN tipo_vivienda         IS NULL THEN 1 ELSE 0 END) AS nulos_tipo_vivienda,
    SUM(CASE WHEN antiguedad_laboral    IS NULL THEN 1 ELSE 0 END) AS nulos_antiguedad_laboral,
    SUM(CASE WHEN proposito_prestamo    IS NULL THEN 1 ELSE 0 END) AS nulos_proposito_prestamo,
    SUM(CASE WHEN calificacion_credito  IS NULL THEN 1 ELSE 0 END) AS nulos_calificacion_credito,
    SUM(CASE WHEN monto_solicitado      IS NULL THEN 1 ELSE 0 END) AS nulos_monto_solicitado,
    SUM(CASE WHEN tasa_interes          IS NULL THEN 1 ELSE 0 END) AS nulos_tasa_interes,
    SUM(CASE WHEN cuota_sobre_ingreso   IS NULL THEN 1 ELSE 0 END) AS nulos_cuota_sobre_ingreso,
    SUM(CASE WHEN antecedente_impago    IS NULL THEN 1 ELSE 0 END) AS nulos_antecedente_impago,
    SUM(CASE WHEN antiguedad_historial  IS NULL THEN 1 ELSE 0 END) AS nulos_antiguedad_historial,
    SUM(CASE WHEN estado_prestamo       IS NULL THEN 1 ELSE 0 END) AS nulos_estado_prestamo
FROM stg2_loan_applications; -- todo 0, menos antiguedad_laboral = 820

SELECT
    MIN(edad)                           AS edad_min,
    MAX(edad)                           AS edad_max,
    ROUND(AVG(edad), 1)                 AS edad_promedio
FROM lendsmart.stg2_loan_applications; 
SELECT
    MIN(ingreso_anual)                  AS ingreso_min,
    MAX(ingreso_anual)                  AS ingreso_max,
    ROUND(AVG(ingreso_anual), 2)        AS ingreso_promedio
FROM lendsmart.stg2_loan_applications;
SELECT
    MIN(monto_solicitado)               AS monto_min,
    MAX(monto_solicitado)               AS monto_max,
    ROUND(AVG(monto_solicitado), 2)     AS monto_promedio
FROM lendsmart.stg2_loan_applications;
SELECT
    MIN(tasa_interes)                   AS tasa_min,
    MAX(tasa_interes)                   AS tasa_max,
    ROUND(AVG(tasa_interes), 2)         AS tasa_promedio
FROM lendsmart.stg2_loan_applications;
SELECT
    MIN(antiguedad_laboral)             AS antiguedad_min,
    MAX(antiguedad_laboral)             AS antiguedad_max,
    ROUND(AVG(antiguedad_laboral), 1)   AS antiguedad_promedioi
FROM lendsmart.stg2_loan_applications;

SELECT
    tipo_vivienda,
    COUNT(*)                                    AS cantidad,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje
FROM lendsmart.stg2_loan_applications
GROUP BY tipo_vivienda
ORDER BY cantidad DESC;

SELECT
    proposito_prestamo,
    COUNT(*) AS cantidad,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje
FROM lendsmart.stg2_loan_applications
GROUP BY proposito_prestamo
ORDER BY cantidad DESC;

SELECT
    calificacion_credito,
    COUNT(*)  AS cantidad,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje
FROM lendsmart.stg2_loan_applications
GROUP BY calificacion_credito
ORDER BY calificacion_credito;

SELECT
    antecedente_impago,
    COUNT(*) AS cantidad,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje
FROM lendsmart.stg2_loan_applications
GROUP BY antecedente_impago;

-- Eliminacion de filas con outliers
SELECT ingreso_anual ,COUNT(*) AS registros_ingreso_alto
FROM lendsmart.stg2_loan_applications
WHERE ingreso_anual > 1000000
group by ingreso_anual
order by 1; -- eliminar filas

SELECT edad ,COUNT(*) AS registros_ingreso_alto
FROM lendsmart.stg2_loan_applications
WHERE edad > 100
group by edad
order by 1; -- eliminar filas

SELECT antiguedad_laboral ,COUNT(*) AS registros_ingreso_alto
FROM lendsmart.stg2_loan_applications
WHERE antiguedad_laboral > 60
group by antiguedad_laboral
order by 1;

select *
from lendsmart.stg2_loan_applications
where ingreso_anual > 1000000;

delete
from lendsmart.stg2_loan_applications
where ingreso_anual > 1000000;

select *
from lendsmart.stg2_loan_applications
where edad > 100;

delete
from lendsmart.stg2_loan_applications
where edad > 100;

select *
from lendsmart.stg2_loan_applications
where antiguedad_laboral > 60;

delete
from lendsmart.stg2_loan_applications
where antiguedad_laboral > 60;

select count(*)
from lendsmart.stg2_loan_applications; -- 32334

-- Tasa de impagos
select estado_prestamo, count(*) as cantidad, 
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje
from lendsmart.stg2_loan_applications
group by estado_prestamo; -- 21.9% de tasa de impagos

-- Calificación más riesgosa
select estado_prestamo, calificacion_credito ,count(*) as cantidad, 
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje
from lendsmart.stg2_loan_applications
where estado_prestamo = 1
group by estado_prestamo, calificacion_credito
order by cantidad desc;

-- Proposito más riesgoso
select estado_prestamo, proposito_prestamo ,count(*) as cantidad, 
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje
from lendsmart.stg2_loan_applications
where estado_prestamo = 1
group by estado_prestamo, proposito_prestamo
order by cantidad desc;

-- tipo de vivienda riesgosas
select estado_prestamo, tipo_vivienda ,count(*) as cantidad, 
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje
from lendsmart.stg2_loan_applications
where estado_prestamo = 1
group by estado_prestamo, tipo_vivienda
order by cantidad desc;

-- Antecedentes riesgosos
select estado_prestamo, antecedente_impago ,count(*) as cantidad, 
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje
from lendsmart.stg2_loan_applications
where estado_prestamo = 1
group by estado_prestamo, antecedente_impago
order by cantidad desc;

-- comparación entre estado_prestamo = 0 y estado_prestamo = 1
select estado_prestamo, count(*) as cantidad, 
avg(edad) as prom_edad,
avg(ingreso_anual) as prom_ingreso_anual,
avg(monto_solicitado) as prom_monto_solicitado,
avg(tasa_interes) as prom_tasa_interes,
avg(cuota_sobre_ingreso) as prom_cuota_sobre_ingreso,
avg(antiguedad_laboral) as prom_antiguedad_laboral
from lendsmart.stg2_loan_applications
group by estado_prestamo;