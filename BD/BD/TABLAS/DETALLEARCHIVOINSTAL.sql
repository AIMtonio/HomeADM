-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEARCHIVOINSTAL
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEARCHIVOINSTAL`;
DELIMITER $$


CREATE TABLE `DETALLEARCHIVOINSTAL` (
  `DetalleArchivoID`      INT(11) NOT NULL COMMENT 'Identificador del detalle',
  `FolioID`               INT(11) NOT NULL COMMENT 'Identificador del archivo de instalacion',
  `Estatus`               CHAR(1) NOT NULL COMMENT 'N- No Enviado. E- Enviado. A- Autorizado',
  `FechaLimiteRecep`      DATE    NOT NULL COMMENT 'Fecha limite de recepcion de archivo de instalacion',
  `CreditoID`             INT(11) NOT NULL COMMENT 'Identificador del credito',
  `EmpresaID`             INT(11) NOT NULL COMMENT 'ID de la empresa',
  `Usuario`               INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
  `FechaActual`           DATETIME NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
  `DireccionIP`           Varchar(15) NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
  `ProgramaID`            Varchar(50) NOT NULL COMMENT 'Parámetro de auditoría Programa',
  `Sucursal`              INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
  `NumTransaccion`        BIGINT(20) NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
  PRIMARY KEY (`DetalleArchivoID`),
  KEY `IDX_DETALLEARCHIVOINSTAL_1` (`DetalleArchivoID`),
  KEY `fk_DETALLEARCHIVOINSTAL_1` (`FolioID`),
  KEY `fk_DETALLEARCHIVOINSTAL_2` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo para el detalle del archivo de instalacion'$$