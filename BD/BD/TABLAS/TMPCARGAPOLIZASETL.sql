DELIMITER ;
DROP TABLE IF EXISTS `TMPCARGAPOLIZASETL`;
DELIMITER $$

CREATE TABLE `TMPCARGAPOLIZASETL` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la tabla',
  `FechaSistema` date DEFAULT NULL COMMENT 'Fecha del sistema',
  `CuentaCompleta` char(50) DEFAULT NULL COMMENT 'Numero del cuenta contable',
  `CentroCostoID` int(11) DEFAULT NULL COMMENT 'ID centro de costos',
  `Referencia` varchar(100) DEFAULT NULL COMMENT 'Referencia',
  `Fecha` varchar(15) DEFAULT NULL COMMENT 'Fecha',
  `Cargos` decimal(16,4) DEFAULT NULL COMMENT 'Cargos',
  `Abonos` decimal(16,4) DEFAULT NULL COMMENT 'Abonos',
  `DescripPoliza` varchar(200) DEFAULT NULL COMMENT 'Referencia',
  `DescripCuenta` varchar(200) DEFAULT NULL COMMENT 'Referencia',
  `ValidoCenCosID` CHAR(1) DEFAULT NULL COMMENT 'Si es valido el ID centro de costos S= si, N= no',
  `ValidoCtaComp` CHAR(1) DEFAULT NULL COMMENT 'Si es valida la cuenta completa S= si, N= no',
  `Grupo` CHAR(1) DEFAULT NULL COMMENT 'Si cuenta completa D= detalle, E= Encabezado',
  `DescripCtaCompleta` varchar(250) DEFAULT NULL COMMENT 'Descripcion de cuenta completa',
  `EsExitoso` CHAR(1) DEFAULT NULL COMMENT 'Si un registro exitoso S= si, N= no',
  `DesPertenece` varchar(200) DEFAULT NULL COMMENT 'Descripcion registro',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`ID`),
  KEY `IDX_TMPCARGAPOLIZASETL_1` (`CuentaCompleta`),
  KEY `IDX_TMPCARGAPOLIZASETL_2` (`CentroCostoID`),
  KEY `IDX_TMPCARGAPOLIZASETL_3` (`NumTransaccion`),
  KEY `IDX_TMPCARGAPOLIZASETL_4` (`FechaSistema`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para almacenar los datos cargados de un archivo de de polizas con un ETL'$$