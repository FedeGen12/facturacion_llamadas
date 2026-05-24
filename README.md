# Sistema de Facturación Telefónica

Implementación de un sistema de facturación mensual de llamadas telefónicas desarrollado en Smalltalk como resolución del ejercicio técnico propuesto.

## Objetivo

El sistema permite calcular la facturación mensual de clientes considerando:

* Abono mensual básico
* Consumo por llamadas locales
* Consumo por llamadas nacionales
* Consumo por llamadas internacionales

Cada tipo de llamada posee reglas de tarifación específicas según horario, día o destino.

---

# Requerimientos implementados

## Facturación mensual

La factura mensual está compuesta por:

* Abono fijo mensual
* Costo total de llamadas realizadas durante el período

---

## Llamadas locales

Las llamadas locales aplican distintas tarifas según día y horario:

| Condición                       | Costo por minuto |
| ------------------------------- | ---------------- |
| Días hábiles de 08:00 a 20:00   | 0,20             |
| Días hábiles fuera de ese rango | 0,10             |
| Sábados y domingos              | 0,10             |

---

## Llamadas nacionales

Las llamadas nacionales poseen una tarifa variable según la localidad destino.

---

## Llamadas internacionales

Las llamadas internacionales poseen una tarifa variable según el país destino.

---

# Decisiones de diseño

## Lenguaje

* Smalltalk

# Suposiciones

* La facturación se realiza de manera mensual.
* La duración de las llamadas se considera en minutos.
* Los datos se generan en memoria.
* No se implementa persistencia.
* No se implementa interfaz gráfica.
* La salida se muestra por consola.
