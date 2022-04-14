-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSION
DELIMITER ;
DROP TABLE IF EXISTS `DISPERSION`;DELIMITER $$

CREATE TABLE `DISPERSION` (
  `FolioOperacion` int(11) NOT NULL COMMENT 'ID o referencia de la operación de la dispersion',
  `FechaOperacion` datetime DEFAULT NULL COMMENT 'Fecha en cual se realiza la operación de la dispersión',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Numero de la institución financiera en la cual se le hara el cargo',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NumCtaInstit` varchar(20) DEFAULT NULL COMMENT 'Corresponde con el num de cuenta de la institucion en CUENTASAHOTESO',
  `CantRegistros` int(11) DEFAULT NULL COMMENT 'Cantidad registros ingresados ',
  `CantEnviados` int(11) DEFAULT NULL COMMENT 'Cantidad de registros que son enviados',
  `MontoTotal` decimal(12,2) DEFAULT NULL COMMENT 'Suma total de las dispersiones',
  `MontoEnviado` decimal(12,4) DEFAULT NULL COMMENT 'Monto total de las dispersiones enviadas',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la dispersión realizada.\nA: Abierta\nC: Cerrada',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioOperacion`),
  KEY `fk_InstitucionID` (`InstitucionID`),
  KEY `fk_CuentasAhoID` (`CuentaAhoID`),
  CONSTRAINT `fk_CuentasAhoID` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHOTESO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_InstitucionID` FOREIGN KEY (`InstitucionID`) REFERENCES `INSTITUCIONES` (`InstitucionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Encabezado de la dispersión de recursos \nmediante medios ele'$$