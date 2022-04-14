-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOREFERENCIASAN
DELIMITER ;
DROP TABLE IF EXISTS `FOLIOREFERENCIASAN`;
DELIMITER $$


CREATE TABLE `FOLIOREFERENCIASAN` (
  `TipoInstrumento` BIGINT(20) NOT NULL COMMENT 'Tipo Instrumento 1.-CRedito 2.-Otras referencias 3.-Cuentas',
  `Instrumento` VARCHAR(30) NOT NULL COMMENT 'ID Instrumento Credito/Cuenta/Otros',
  `Folio`       INT(11) NOT NULL COMMENT 'Folio Consecutivo',
  PRIMARY KEY (TipoInstrumento,Instrumento)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catalogo folios generados por instrumento'$$