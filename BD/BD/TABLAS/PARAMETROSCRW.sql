
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSCRW
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSCRW`;

DELIMITER $$
CREATE TABLE `PARAMETROSCRW` (
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'ID del Producto de Crédito.',
  `FormulaRetencion` char(1) DEFAULT NULL COMMENT 'Formula de Calculo de Retencion:\n (T) Tasa de ISR sobre el Capital\n (P) Porcentaje Directo Sobre Rendimiento',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'Tasa de ISR aplicable las Retenciones de los Inversionistas CROWDFUNDING',
  `PorcISRMoratorio` decimal(12,4) DEFAULT NULL COMMENT 'Porcentaje o Tasa de ISR aplicable los Moratorios pagados al cliente',
  `PorcISRComision` decimal(12,4) DEFAULT NULL COMMENT 'Porcentaje o Tasa de ISR aplicable las Comisiones pagadas al cliente',
  `MinPorcFonProp` decimal(10,2) DEFAULT NULL COMMENT 'Minimo Porcentaje de Fondeo Propio que debe mantener la institucion sobre el credito',
  `MaxPorcPagCre` decimal(10,2) DEFAULT NULL COMMENT 'Maximo Porcentaje de Saldo Pagado del Credito',
  `MaxDiasAtraso` int(11) DEFAULT NULL COMMENT 'Maximo Dias de Atraso Permitidos para Fondear el Credito',
  `DiasGraciaPrimVen` int(11) DEFAULT NULL COMMENT 'Minimo Numero de Dias de Gracias para el 1er Vencimiento',
  `MargenPagos` decimal(10,2) DEFAULT NULL COMMENT 'Margen de Pagos entre la Primera y Ultima Cuota en Inversionistas, Expresado en N Veces',
  `TipoReesFondeo` int(11) DEFAULT NULL COMMENT 'Catalogo TIPOSREESFONDEO',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`ProductoCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros Generales de CROWDFUNDING por Producto de Crédito.'
$$