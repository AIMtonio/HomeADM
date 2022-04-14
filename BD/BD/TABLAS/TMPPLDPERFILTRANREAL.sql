-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDPERFILTRANREAL
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDPERFILTRANREAL`;DELIMITER $$

CREATE TABLE `TMPPLDPERFILTRANREAL` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente ID',
  `TotalMonto` decimal(16,2) DEFAULT '0.00' COMMENT 'suma total al mes',
  `NumMovimiento` int(11) DEFAULT '0' COMMENT 'Numero de Movimientos',
  `Mes` int(11) NOT NULL DEFAULT '0' COMMENT 'Mes',
  `Anio` int(11) NOT NULL DEFAULT '0' COMMENT 'Año',
  `Naturaleza` char(1) NOT NULL COMMENT 'Tipo de Naturaleza A:Abonos C:Cargos',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ClienteID`,`TransaccionID`,`Naturaleza`,`Anio`,`Mes`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para almacenar el perfil transaccional real'$$