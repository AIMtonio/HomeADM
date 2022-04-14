-- Creacion de tabla ESQCOMAPERNOMINA

DELIMITER ;
DROP TABLE IF EXISTS `ESQCOMAPERNOMINA`;
DELIMITER $$

CREATE TABLE `ESQCOMAPERNOMINA`
(
  `EsqComApertID` int(11) NOT NULL COMMENT 'Id del Esquema de Comisión Apertura',
  `InstitNominaID` int(11) NOT NULL COMMENT 'ID de la Institución de Nómina',
  `ProducCreditoID` int(11) NOT NULL COMMENT 'ID del Producto de Crédito',
  `ManejaEsqConvenio` char(1) NOT NULL COMMENT 'Indica si maneja esquema por Convenio de Nómina S SI, N NO',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY(`EsqComApertID`),
  UNIQUE KEY(`InstitNominaID`,`ProducCreditoID`),
  FOREIGN KEY (`InstitNominaID`) REFERENCES INSTITNOMINA(`InstitNominaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (`ProducCreditoID`) REFERENCES PRODUCTOSCREDITO(`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  KEY `INDEX_ESQUEMASCOMAPERNOMINA_1` (`InstitNominaID`),
  KEY `INDEX_ESQUEMASCOMAPERNOMINA_2` (`ProducCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'Tab: Tabla Que Parametriza Esquema de Cobro de Comisión Apertura para Empresas Nómina'$$
