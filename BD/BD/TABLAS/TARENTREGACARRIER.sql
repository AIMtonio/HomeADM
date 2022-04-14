
-- TARENTREGACARRIER
DELIMITER ;
DROP TABLE IF EXISTS `TARENTREGACARRIER`;
DELIMITER $$

CREATE TABLE `TARENTREGACARRIER` (
  `TarEntregaCarrierID` INT(11)     NOT NULL COMMENT 'ID Lote. Es un consecutivo',
  `NombreCliente`       VARCHAR(21) NOT NULL COMMENT 'Nombre del cliente',
  `CalleNo`             VARCHAR(27) NOT NULL COMMENT 'Numero y nombre de la calle',
  `Colonia`             VARCHAR(40) NOT NULL COMMENT 'Colonia',
  `Ciudad`              VARCHAR(30) NOT NULL COMMENT 'Ciudad',
  `Estado`              VARCHAR(25) NOT NULL COMMENT 'Estado',
  `CP`                  VARCHAR(5)  NOT NULL COMMENT 'Codigo postal',
  `NumSucursal`         VARCHAR(21) NOT NULL COMMENT 'Numero de la sucursal',
  `NumLote`             VARCHAR(8)  NOT NULL COMMENT 'Numero de lote',
  `NumCliente`          VARCHAR(8)  NOT NULL COMMENT 'Numero de cliente',
  `Consecutivo`         VARCHAR(6)  NOT NULL COMMENT 'Consecutivo generado por el sistema rellenado de 0 con longitud de 6',
  `EsTitularOAdicional` CHAR(1)     NOT NULL COMMENT 'Indica si es titular o adicional T-Titular, A-Adicional',
  `EsRepoNuevaReno`     CHAR(1)     NOT NULL COMMENT 'Indica si es R-Reposición,N-Nuevo,O-Renovación',
  `EmpresaID`           INT(11)     NOT NULL COMMENT 'Parametros de auditoria',
  `Usuario`             INT(11)     NOT NULL COMMENT 'Parametros de auditoria',
  `FechaActual`         DATETIME    NOT NULL COMMENT 'Parametros de auditoria',
  `DireccionIP`         VARCHAR(15) NOT NULL COMMENT 'Parametros de auditoria',
  `ProgramaID`          VARCHAR(50) NOT NULL COMMENT 'Parametros de auditoria',
  `Sucursal`            INT(11)     NOT NULL COMMENT 'Parametros de auditoria',
  `NumTransaccion`      BIGINT(20)  NOT NULL COMMENT 'Parametros de auditoria',
  PRIMARY KEY (`TarEntregaCarrierID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de tarjetas que se van a enviar a servicios de todito (tarjetas safi)'$$