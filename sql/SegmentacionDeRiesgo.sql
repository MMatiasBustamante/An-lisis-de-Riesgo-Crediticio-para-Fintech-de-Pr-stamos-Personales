ALTER TABLE stg2_loan_applications
ADD COLUMN segmento_riesgo VARCHAR(10) NULL;

UPDATE stg2_loan_applications
SET segmento_riesgo = CASE
    -- RIESGO ALTO
    WHEN cuota_sobre_ingreso > 0.20
        THEN 'Alto'
    WHEN calificacion_credito IN ('E', 'F', 'G')
        THEN 'Alto'
    WHEN tipo_vivienda = 'RENT' AND cuota_sobre_ingreso > 0.15
        THEN 'Alto'
    WHEN proposito_prestamo IN ('MEDICAL', 'DEBTCONSOLIDATION')
        AND ingreso_anual < 49000
        THEN 'Alto'
    WHEN calificacion_credito = 'D'
        AND (cuota_sobre_ingreso > 0.15 OR tipo_vivienda = 'RENT')
        THEN 'Alto'
    -- RIESGO MEDIO
    WHEN cuota_sobre_ingreso BETWEEN 0.15 AND 0.20
        THEN 'Medio'
    WHEN calificacion_credito = 'D'
        THEN 'Medio'
    WHEN antecedente_impago = 'Y'
        THEN 'Medio'
    -- RIESGO BAJO
    ELSE 'Bajo'
END;

SELECT segmento_riesgo,
COUNT(*)  AS cantidad,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS porcentaje,
ROUND(AVG(CASE WHEN estado_prestamo = 1 THEN 1.0 ELSE 0 END) * 100, 1) AS tasa_impago_pct
FROM stg2_loan_applications
GROUP BY segmento_riesgo
ORDER BY
    CASE segmento_riesgo
        WHEN 'Alto'  THEN 1
        WHEN 'Medio' THEN 2
        WHEN 'Bajo'  THEN 3
    END;