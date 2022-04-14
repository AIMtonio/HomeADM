-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSPEICANCELA
DELIMITER ;
DROP TABLE IF EXISTS `TMPSPEICANCELA`;
DELIMITER $$


CREATE TABLE `TMPSPEICANCELA` (
  `FolioSpeiID` bigint(20) NOT NULL COMMENT 'ID de SPEI.',
  `ClaveRastreo` varchar(30) DEFAULT NULL COMMENT 'Numero la clave de rastreo spei.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `idx_TMPSPEICANCELA_1` (`FolioSpeiID`,`ClaveRastreo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: TABLA AUXILIAR PARA CANCELACION DE SPEI';
