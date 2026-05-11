create table stg_loan_applications
like loan_applications;

insert stg_loan_applications
select *
from loan_applications;

select *
from lendsmart.stg_loan_applications;

select *, 
row_number() over(
	partition by edad, ingreso_anual, tipo_vivienda, antiguedad_laboral, proposito_prestamo, calificacion_credito, monto_solicitado, tasa_interes, cuota_sobre_ingreso, antecedente_impago, antiguedad_historial, estado_prestamo
)as row_num
from lendsmart.stg_loan_applications;

with duplicate_cte as
(
	select *, 
	row_number() over(
		partition by edad, ingreso_anual, tipo_vivienda, antiguedad_laboral, proposito_prestamo, calificacion_credito, monto_solicitado, tasa_interes, cuota_sobre_ingreso, antecedente_impago, antiguedad_historial, estado_prestamo
	)as row_num
	from lendsmart.stg_loan_applications
)
select *
from duplicate_cte
where row_num > 1;

create table stg2_loan_applications(
	id                          INT            	PRIMARY KEY,
    person_age                  INT             NULL,
    person_income               DECIMAL(12, 2)  NULL,
    person_home_ownership       VARCHAR(20)     NULL,
    person_emp_length           DECIMAL(5, 1)   NULL,
    loan_intent                 VARCHAR(30)     NULL,
    loan_grade                  VARCHAR(5)      NULL,
    loan_amnt                   DECIMAL(12, 2)  NULL,
    loan_int_rate               DECIMAL(5, 2)   NULL,
    loan_percent_income         DECIMAL(5, 4)   NULL,
    cb_person_default_on_file   VARCHAR(5)      NULL,
    cb_person_cred_hist_length  INT             NULL,
    loan_status                 TINYINT			NULL,		         
	row_num 					int 
);

insert into stg2_loan_applications
select *,
row_number() over(
		partition by edad, ingreso_anual, tipo_vivienda, antiguedad_laboral, proposito_prestamo, calificacion_credito, monto_solicitado, tasa_interes, cuota_sobre_ingreso, antecedente_impago, antiguedad_historial, estado_prestamo
)as row_num
from lendsmart.stg_loan_applications;

select *
from lendsmart.stg2_loan_applications
where row_num > 1;

delete
from lendsmart.stg2_loan_applications
where row_num > 1;
-- duplicados eliminados

ALTER TABLE stg2_loan_applications
    RENAME COLUMN person_age                 TO edad,
    RENAME COLUMN person_income              TO ingreso_anual,
    RENAME COLUMN person_home_ownership      TO tipo_vivienda,
    RENAME COLUMN person_emp_length          TO antiguedad_laboral,
    RENAME COLUMN loan_intent                TO proposito_prestamo,
    RENAME COLUMN loan_grade                 TO calificacion_credito,
    RENAME COLUMN loan_amnt                  TO monto_solicitado,
    RENAME COLUMN loan_int_rate              TO tasa_interes,
    RENAME COLUMN loan_percent_income        TO cuota_sobre_ingreso,
    RENAME COLUMN cb_person_default_on_file  TO antecedente_impago,
    RENAME COLUMN cb_person_cred_hist_length TO antiguedad_historial,
    RENAME COLUMN loan_status                TO estado_prestamo;
    
select * from lendsmart.stg2_loan_applications;

select  * from lendsmart.stg2_loan_applications
where antiguedad_laboral is null;

select  * from lendsmart.stg2_loan_applications
where tasa_interes is null;

select  * from lendsmart.stg2_loan_applications
where tasa_interes is null and antiguedad_laboral is null; -- registros incompletos

-- eliminar filas incompletas
delete
from lendsmart.stg2_loan_applications
where tasa_interes is null and antiguedad_laboral is null;

SELECT 
    calificacion_credito,
    ROUND(AVG(tasa_interes), 2) AS tasa_promedio
FROM loan_applications
WHERE tasa_interes IS NOT NULL
GROUP BY calificacion_credito
ORDER BY calificacion_credito;

select  tasa_interes, count(*) from lendsmart.stg2_loan_applications
group by tasa_interes;

UPDATE stg2_loan_applications la
JOIN (
    SELECT 
        calificacion_credito,
        AVG(tasa_interes) AS tasa_promedio
    FROM loan_applications
    WHERE tasa_interes IS NOT NULL
    GROUP BY calificacion_credito
) promedios ON la.calificacion_credito = promedios.calificacion_credito
SET la.tasa_interes = ROUND(promedios.tasa_promedio, 2)
WHERE la.tasa_interes IS NULL;

SELECT COUNT(*) 
FROM loan_applications 
WHERE tasa_interes IS NULL;

alter table lendsmart.stg2_loan_applications
drop column row_num;