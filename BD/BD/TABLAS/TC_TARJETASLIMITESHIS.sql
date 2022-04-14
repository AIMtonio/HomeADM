-- TC_TARJETASLIMITESHIS
DELIMITER ;
	DROP TABLE IF EXISTS TC_TARJETASLIMITESHIS;
DELIMITER $$

CREATE TABLE TC_TARJETASLIMITESHIS (
  TarjetaID CHAR(16) NOT NULL DEFAULT '0' COMMENT 'ID del Tipo de Tarjeta de Debito',
  NoDisposiDia INT(11) DEFAULT NULL COMMENT 'Numero de Disposiciones por Dia',
  Fecha DATE NOT NULL COMMENT 'Fecha en que pasa al historico',
  PRIMARY KEY (TarjetaID,Fecha)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Limites de Operacion de una Tarjeta de Debito en Particular.'$$
