-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURDET
DELIMITER ;
DROP TABLE IF EXISTS `PRESUCURDET`;DELIMITER $$

CREATE TABLE `PRESUCURDET` (
  `FolioID` int(11) NOT NULL,
  `EncabezadoID` int(11) NOT NULL,
  `Concepto` int(11) NOT NULL COMMENT 'id del Concepto\ntelefono,renta etc.',
  `Descripcion` varchar(45) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estados que pasa un\nDetalle son:\n\nS=Solicitado\nC=Cancelado\nA=aprobado\n\nE= Eliminado',
  `Monto` decimal(13,2) DEFAULT NULL,
  `MontoDispon` decimal(13,2) DEFAULT NULL,
  `Observaciones` varchar(250) DEFAULT NULL,
  `EmpresaID` varchar(45) DEFAULT NULL,
  `Usuario` varchar(45) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(45) DEFAULT NULL,
  `ProgramaID` varchar(45) DEFAULT NULL,
  `Sucursal` varchar(45) DEFAULT NULL,
  `NumTransaccion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`FolioID`,`EncabezadoID`),
  KEY `fk_PRESUCURDET_1` (`Concepto`),
  CONSTRAINT `fk_PRESUCURDET_1` FOREIGN KEY (`Concepto`) REFERENCES `TESOCATTIPGAS` (`TipoGastoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Presupuestos por Sucursal'$$