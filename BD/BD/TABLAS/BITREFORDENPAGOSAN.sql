DELIMITER ;
DROP TABLE IF EXISTS `BITREFORDENPAGOSAN`;

DELIMITER $$
CREATE TABLE `BITREFORDENPAGOSAN` (
  `ConsecutivoID` INT(11) NOT NULL COMMENT 'Identificador de la tabla',
  `RefOrdenID` INT(11) NOT NULL COMMENT 'Identificador de la tabla REFORDENPAGOSAN',
  `Referencia` VARCHAR(20) NULL COMMENT 'Referencia que se genera para la dispersion por orden de pago',
  `Complemento` VARCHAR(18) NULL COMMENT 'Los digito aleatorios de la referecia ',
  `FolioOperacion` INT(11) NULL COMMENT 'Identificador de la tabla DISPERSION',
  `ClaveDispMov` INT(11) NULL COMMENT 'Id de la tabla DISPERSIONMOV',
  `FechaRegistro` DATE NULL COMMENT 'Fecha en que se realizo el registro',
  `FechaVencimiento` DATE NULL COMMENT 'Fecha de vencimiento de la referencia',
  `FechaCambio` DATE NULL COMMENT 'Fecha en que se realiza el cambio de estatus',
  `Tipo` INT(11) NULL COMMENT 'Tipo de referencia creada 71.-Credito 81.- Solicitud de Dispersion 91.- Cuentas',
  `Folio` VARCHAR(12) NULL COMMENT 'Folio que se utiliza para generar la referencia creditoID,CuentaID, Folio de dispersion',
  `Estatus` CHAR(1) NULL COMMENT 'Estatus de la referencia:\nGenerada(G): Cuando se genera la referencia.\nEnviada(E): Cuando se incluye en un archivo de dispersion por ordenes de pago.\nVencido(V): nunca se cobro y la fecha para cobro ya vencio\nModificado(M): se modifica alguna informacion de la orden de pago (antes de que sea cobrada).\nCancelado(C): se da la destruccion de cancelar la orden de pago\nEjecutado(O): orden pagada\nEn proceso(P):  pendiente de cobro por parte del beneficiario\nProgramado(R): se programa para que empiece a pagarse en una fecha específica',
  `EmpresaID` INT(11) NULL DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` INT(11) NULL DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` DATETIME NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` VARCHAR(15) NULL DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` INT(11) NULL DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` BIGINT(20) NULL DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  INDEX `BITREFORDENPAGOSAN_IDX2` (`FolioOperacion` ASC),
  INDEX `BITREFORDENPAGOSAN_IDX3` (`ClaveDispMov` ASC),
  INDEX `BITREFORDENPAGOSAN_IDX4` (`FechaRegistro` ASC),
  INDEX `BITREFORDENPAGOSAN_IDX5` (`FechaCambio` ASC),
  INDEX `BITREFORDENPAGOSAN_IDX6` (`RefOrdenID` ASC))
ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla para la bitacora de referenciuas por orden de pago.'$$