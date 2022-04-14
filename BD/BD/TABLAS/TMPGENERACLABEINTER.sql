-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPGENERACLABEINTER
DELIMITER ;
DROP TABLE IF EXISTS `TMPGENERACLABEINTER`;
DELIMITER $$

CREATE TABLE `TMPGENERACLABEINTER` (
  `EstatusProceso` char(1) DEFAULT 'I' COMMENT 'Indicador si el proceso esta ejecutandose A = Activo  I= Inactivo'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP:Tabla temporal para identificar si el proceso de Generacion de Clabe esta Activo'$$