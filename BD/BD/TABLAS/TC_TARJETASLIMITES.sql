-- TC_TARJETASLIMITES
DELIMITER ;
	DROP TABLE IF EXISTS TC_TARJETASLIMITES;
DELIMITER $$

CREATE TABLE TC_TARJETASLIMITES (
  TarjetaID CHAR(16) NOT NULL DEFAULT '0' COMMENT 'ID del Tipo de Tarjeta de Debito',
  NoDisposiDia INT(11) DEFAULT NULL COMMENT 'Numero de Disposiciones por Dia',
  PRIMARY KEY (TarjetaID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Limites de Operacion de una Tarjeta de Debito en Particular.'$$
