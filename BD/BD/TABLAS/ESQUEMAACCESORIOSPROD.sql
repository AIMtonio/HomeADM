-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAACCESORIOSPROD
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMAACCESORIOSPROD`;
DELIMITER $$


CREATE TABLE `ESQUEMAACCESORIOSPROD` (
  `EsquemaAccesorioID` int(11) NOT NULL COMMENT 'Id del Esquema',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'Producto de Credito(PRODUCTOSCREDITO)',
  `AccesorioID` int(11) DEFAULT NULL COMMENT 'ID del Accesorio',
  `InstitNominaID` INT(11) DEFAULT NULL COMMENT 'Identificador de la institucion de nomina',
  `CobraIVA` char(1) DEFAULT NULL COMMENT 'Indica si el accesorio cobra IVA\nS: Si\nN: No',
  `GeneraInteres` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si el accesorio genera intereses. Se puede marcar como N: No genera intereses. S: Si genera intereses.',
  `CobraIVAInteres` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si el accesorio cobra intereses del IVA. Se puede marcar como N: No cobra IVA intereses. S: Si cobra IVA intereses.',
  `TipoFormaCobro` char(1) DEFAULT NULL COMMENT 'Indica la forma de Cobro del Accesorio\nA: Anticipado\nD: Deduccion\nF: Financiamiento\n',
  `TipoPago` char(1) DEFAULT NULL COMMENT 'Tipo de Pago cuando la forma de cobro sea FINANCIAMIENTO\nM: Monto Fijo\nP: Porcentaje',
  `BaseCalculo` char(1) DEFAULT NULL COMMENT 'Base de Calculo cuando la forma de cobro sea FINANCIAMIENTO y el tipo de pago sea PORCENTAJE\n1: Indica que es sobre el monto original del credito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`EsquemaAccesorioID`),
  KEY `INDEX_ESQPROCRE` (`ProductoCreditoID`,`AccesorioID`,`InstitNominaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena las caracteristicas generales que tienen los accesorios por producto de credito'$$