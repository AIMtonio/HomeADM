-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCONCREGULA419
DELIMITER ;
DROP TABLE IF EXISTS `CATCONCREGULA419`;DELIMITER $$

CREATE TABLE `CATCONCREGULA419` (
  `ConceptoID` int(11) NOT NULL COMMENT 'ID o Consecutivo del Concepto',
  `CuentaMayor` varchar(45) DEFAULT NULL COMMENT 'Cuenta de Mayor, para Agrupaciones',
  `ClaveConcepto` varchar(45) NOT NULL COMMENT 'Clave del Concepto',
  `Descripcion` varchar(400) NOT NULL COMMENT 'Descripcion',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden para el Select en los Resultados',
  `Nivel` char(1) DEFAULT NULL COMMENT 'E .- Encabezado, D .- Detalle',
  `ClasificacionID` int(11) DEFAULT NULL COMMENT 'Clasificacion de Cartera, CLASIFICCREDITO',
  `TipoSaldo` int(11) DEFAULT NULL COMMENT 'Tipo de Saldo',
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'Clasificacion del Concepto para Regulatorios',
  `TipoInstitID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoID`,`TipoInstitID`),
  KEY `CATCONCREGULA419_IDX_1` (`ClasificacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Conceptos para el Reporte Regulatorio 419'$$