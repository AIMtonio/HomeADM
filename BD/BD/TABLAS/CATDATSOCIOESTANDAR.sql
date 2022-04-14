-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATDATSOCIOESTANDAR
DELIMITER ;
DROP TABLE IF EXISTS `CATDATSOCIOESTANDAR`;
DELIMITER $$


CREATE TABLE `CATDATSOCIOESTANDAR` (
  `CatSocioEID` int(11) NOT NULL COMMENT 'Llave Principal para Catalogo de Datos SocioEconomicos(Consecutivo)',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion del Datos Socioeconomico',
  `Tipo` char(1) DEFAULT NULL COMMENT 'Tipo de Datos SocioEconomico\\nI = Ingresos\\nE = Egresos',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus \\nA= Activo\\nI= Inactivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  PRIMARY KEY (`CatSocioEID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Datos SocioEconomincos Ingresos-Egresos para Estandarización de WS Solicitud'$$
