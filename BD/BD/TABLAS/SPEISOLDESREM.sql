-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEISOLDESREM
DELIMITER ;
DROP TABLE IF EXISTS `SPEISOLDESREM`;DELIMITER $$

CREATE TABLE `SPEISOLDESREM` (
  `SpeiSolDesID` bigint(20) NOT NULL COMMENT 'Numero de solicitud',
  `FechaRegistro` datetime NOT NULL COMMENT 'Fecha de registro',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus \nP) Pendiente por procesar\nR) Procesada ',
  `FechaProceso` datetime NOT NULL COMMENT 'Fecha de proceso',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`SpeiSolDesID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Spei Solicitud de Descarga de Remesas'$$