-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPERFILES
DELIMITER ;
DROP TABLE IF EXISTS `BAMPERFILES`;DELIMITER $$

CREATE TABLE `BAMPERFILES` (
  `PerfilID` bigint(20) NOT NULL COMMENT 'Identificador Perfil',
  `NombrePerfil` varchar(50) NOT NULL COMMENT 'Nombre del Perfil',
  `Descripcion` varchar(200) NOT NULL COMMENT 'Descripcion del perfil',
  `AccesoConToken` char(1) NOT NULL COMMENT 'S.- Token requerido para login \nN.- Token no requerido\n',
  `TransacConToken` char(1) NOT NULL COMMENT 'S.-Token requerido para transaccion ',
  `CostoPrimeraVez` decimal(12,2) NOT NULL COMMENT 'Costo por contratacion del servicio ',
  `CostoMensual` decimal(12,2) NOT NULL COMMENT 'Costo mensual por el servicio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PerfilID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Perfiles o Roles de la Banca Movil'$$