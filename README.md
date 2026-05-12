# Analisis de Riesgo Crediticio para Fintech de Prestamos Personales
---
## Pregunta de negocio
> ¿Cómo puede una fintech de préstamos personales decidir a qué solicitantes aprobar, a qué monto y bajo qué condiciones, minimizando el riesgo de impago sin rechazar clientes con capacidad real de pago?
---
## Contexto simulado
**Empresa:** LendSmart — fintech argentina de préstamos personales (perfil simulado).
 
**Situación:** LendSmart está creciendo su base de solicitantes pero empieza a registrar una tasa de impago que supera el umbral aceptable. El equipo de riesgo necesita un sistema de análisis que les permita clasificar a los solicitantes por nivel de riesgo y tomar decisiones de aprobación más fundamentadas, reemplazando el criterio subjetivo actual por uno basado en datos.
 
**A quién le presentás el análisis:** al Head of Risk o al equipo de crédito de la fintech. No es una presentación técnica — es una recomendación de negocio respaldada por datos.

---
## Insights
 
---
 
## 📊 KPI principal
 
De los 32.334 solicitantes analizados, **7.067 tuvieron impago — una tasa del 21.9%**.
 
Casi 1 de cada 4 préstamos termina sin cobrar. En la industria financiera una tasa saludable de impago para préstamos personales ronda el 3% al 8%, lo que indica que LendSmart está aprobando solicitantes sin los filtros de riesgo adecuados. Este análisis identifica qué variables explican ese riesgo y propone criterios de aprobación concretos para reducirlo.
 
---
 
## 🔍 Hallazgos por variable categórica
 
### 1. La calificación D es el punto ciego del sistema
 
La calificación crediticia con mayor tasa de impago no es la peor (G) sino la **D**. Una hipótesis que explica este comportamiento: las calificaciones E, F y G reciben menos aprobaciones o montos más bajos porque el sistema ya las filtra con más cautela. La calificación D queda en un punto intermedio — suficientemente aceptable para aprobarse masivamente, pero con un riesgo real que el sistema subestima.
 
> **Recomendación:** revisar los criterios de aprobación para solicitantes con calificación D, particularmente cuando se combinan con otros factores de riesgo como tipo de vivienda o cuota sobre ingreso elevada.
 
---
 
### 2. Los préstamos médicos y de consolidación de deuda concentran más riesgo
 
Los propósitos con mayor tasa de impago son **MEDICAL** y **DEBTCONSOLIDATION**, ambos superando el 20%. En los préstamos médicos el solicitante no eligió endeudarse — respondió a una urgencia, lo que sugiere que su situación financiera ya estaba comprometida antes de pedir. En la consolidación de deuda el patrón es similar: quien consolida deudas ya tiene dificultades previas de pago.
 
> **Recomendación:** aplicar criterios de aprobación más estrictos para estos dos propósitos, especialmente en combinación con ingresos bajos o calificación D o inferior.
 
---
 
### 3. Los inquilinos concentran el mayor riesgo por tipo de vivienda
 
Los solicitantes con **tipo de vivienda RENT** tienen una tasa de impago del **73.1%** — muy por encima del resto. Un inquilino no tiene activo propio como respaldo, su situación financiera es más volátil y su capacidad de pago depende exclusivamente del ingreso mensual. Es la variable categórica más discriminante del análisis.
 
> **Recomendación:** para solicitantes con vivienda en alquiler, exigir un ratio cuota/ingreso más bajo que el umbral general antes de aprobar.
 
---
 
### 4. El historial del bureau no alcanza para predecir el riesgo
 
El **69.3% de los impagos proviene de solicitantes sin antecedentes negativos en el bureau**. Esto significa que la mayoría de los que no pagan no tenían señales de alerta previas — el historial crediticio solo no es suficiente para tomar decisiones de aprobación. LendSmart no puede confiar únicamente en este dato para filtrar riesgo.
 
> **Recomendación:** complementar la consulta al bureau con variables de comportamiento financiero actual, como el ratio cuota/ingreso y el propósito del préstamo.
 
---
 
## 🔢 Hallazgos por variable numérica
 
| Variable | Pagaron (0) | No pagaron (1) | Diferencia |
|---|---|---|---|
| Ingreso anual promedio | $70.172 | $49.167 | **-30%** |
| Cuota sobre ingreso promedio | 14.9% | 24.7% | **+65%** |
| Tasa de interés promedio | 10.4% | 13.1% | **+26%** |
| Monto solicitado promedio | $9.245 | $10.869 | **+18%** |
| Edad promedio | 27.8 años | 27.5 años | Sin diferencia |
| Antigüedad laboral promedio | 4.97 años | 4.12 años | Sin diferencia |
 
### Lectura de los datos
 
**El ingreso anual es la variable más discriminante del análisis.** Una brecha del 30% entre grupos confirma que la capacidad de pago es el predictor más directo del impago — no la edad ni la antigüedad laboral, que prácticamente no difieren entre quienes pagan y quienes no.
 
**El ratio cuota/ingreso es el segundo criterio más importante.** Los que no pagan destinan en promedio el 24.7% de su ingreso a la cuota, casi el doble del 14.9% de los que sí pagan. Estos datos respaldan definir un umbral máximo del 20% de cuota sobre ingreso como criterio de aprobación.
 
**La combinación de monto alto e ingreso bajo es la señal de riesgo más clara.** Los que no pagan piden en promedio un 18% más que los que sí pagan, con un ingreso 30% menor. Ese desequilibrio entre lo que se pide y lo que se gana es el patrón central del solicitante de alto riesgo en este dataset.
 
---
 
## ✅ Criterios de aprobación sugeridos
 
A partir de los hallazgos anteriores, se proponen los siguientes criterios base para el sistema de aprobación de LendSmart:
 
| Criterio | Umbral sugerido |
|---|---|
| Cuota sobre ingreso | Máximo 20% |
| Calificación crediticia | Revisar D con factores adicionales; rechazar F y G |
| Tipo de vivienda | RENT requiere cuota/ingreso < 15% |
| Propósito del préstamo | MEDICAL y DEBTCONSOLIDATION requieren ingreso mínimo mayor |
| Antecedente en bureau | Condición necesaria pero no suficiente — no usar como único filtro |
 
---