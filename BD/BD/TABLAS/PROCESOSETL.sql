-- PROCESOSETL
DELIMITER ;
DROP TABLE IF EXISTS `PROCESOSETL`;
DELIMITER $$

CREATE TABLE `PROCESOSETL` (
  `ProcesoETLID` int(11) NOT NULL COMMENT 'Identificador del proceso ETL',
  `RutaArchivoSH` varchar(200) NOT NULL COMMENT 'Ruta, Nombre y extension del archivo sh que ejecuta el job principal',
  `RutaCarpetaETL` varchar(200) NOT NULL COMMENT 'Ruta completa de la carpeta con el proceso ETL',
  `RutaCarpetaPentaho` varchar(200) NOT NULL COMMENT 'Ruta completa de la carpeta con la version del data integration pentaho',
  `Descripcion` TEXT NOT NULL COMMENT 'Descripcion del proceso',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`ProcesoETLID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los proceso ETL.'$$