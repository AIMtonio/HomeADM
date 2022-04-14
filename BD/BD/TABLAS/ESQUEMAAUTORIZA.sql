-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAAUTORIZA
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMAAUTORIZA`;DELIMITER $$

CREATE TABLE `ESQUEMAAUTORIZA` (
  `EsquemaID` int(11) NOT NULL COMMENT 'Llave Primaria del Esuqema de Autorizacion',
  `ProducCreditoID` int(11) NOT NULL COMMENT 'Llave foranea hacia la tabla de Productos de Credito',
  `CicloInicial` int(11) NOT NULL COMMENT 'Rango inicial de ciclo de credito o Grupo en caso de ser credito Grupal',
  `CicloFinal` int(11) NOT NULL COMMENT 'Rango Final de Ciclo de Credito o Grupo en caso de ser credito Grupal\n',
  `MontoInicial` decimal(18,2) NOT NULL COMMENT 'Rango Inicial de Monto ',
  `MontoFinal` decimal(18,2) NOT NULL COMMENT 'Rango Final de Monto',
  `MontoMaximo` decimal(18,2) NOT NULL COMMENT 'Monto Maximo permitido\nEste dato se usa en validacion de monto maximo de Grupo que puede autorizar',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`EsquemaID`),
  KEY `idx_ESQUEMAAUTORIZA_1` (`ProducCreditoID`,`CicloInicial`,`CicloFinal`,`MontoInicial`,`MontoFinal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametrizacion del Esquema de Autorizacion para Solicitudes'$$