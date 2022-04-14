-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSCONFXPROD
DELIMITER ;
DROP TABLE IF EXISTS `RATIOSCONFXPROD`;DELIMITER $$

CREATE TABLE `RATIOSCONFXPROD` (
  `RatiosCatalogoID` int(11) NOT NULL COMMENT 'ID del catalogo CATRATIOS',
  `ProducCreditoID` int(11) NOT NULL COMMENT 'ID del Producto de Crédito',
  `Porcentaje` decimal(14,2) DEFAULT NULL COMMENT 'Indica el Puntaje asignado a la clasificacion de ratios. Aplica para los que son de Tipo: \n1: Concepto\n2: Clasificacion\n3: SubClasificacion',
  `LimiteInferior` decimal(14,2) DEFAULT NULL COMMENT 'Este campo aplica cuando es un rango, y solo para las que son Tipo:\n4: Puntos',
  `LimiteSuperior` decimal(14,2) DEFAULT NULL COMMENT 'Este campo aplica cuando es un Rangoo, y solo para las que son Tipo:\n4: Puntos',
  `Puntos` decimal(14,2) DEFAULT NULL COMMENT 'Puntaje correspondiente a cada valor a ponderar, y solo para las que son Tipo:\n4: Puntos',
  `Empresa` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`RatiosCatalogoID`,`ProducCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de catalogo donde se indica los puntos RATIOSPORCLASIF'$$