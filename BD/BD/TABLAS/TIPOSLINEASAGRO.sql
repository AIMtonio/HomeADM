-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEASAGRO
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSLINEASAGRO`;

DELIMITER $$
CREATE TABLE IF NOT EXISTS `TIPOSLINEASAGRO` (
  `TipoLineaAgroID` INT NOT NULL,
  `Nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre del tipo de linea',
  `FechaRegistro` DATE NOT NULL COMMENT 'Fecha en la que se registro el tipo de linea de agro',
  `Estatus` CHAR(1) NOT NULL COMMENT 'A - Activa\nI  - Inactiva o Baja',
  `EsRevolvente` CHAR(1) NOT NULL COMMENT 'S - Si\nN - No',
  `MontoLimite` DECIMAL(16,2) NOT NULL COMMENT 'Monto tope del tipo de línea, se podran otorgar sobre este tipo de línea, lineas de crédito inferiores pero no mayores al monto señalado. ',
  `PlazoLimite` INT NOT NULL COMMENT 'Plazo maximo de vigencia en meses de este tipo de línea, se podran definir plazos menores, pero no mayores al plazo establecido. ',
  `ManejaComAdmon` CHAR(1) NOT NULL COMMENT 'Manena Comision por Administracion \nS - Si\nN - No',
  `ManejaComGaran` CHAR(1) NOT NULL COMMENT 'Manena Comision por Servicio de Garantía \nS - Si\nN - No',
  `ProductosCredito` VARCHAR(100) NOT NULL COMMENT 'ID de los Productos de Crédito Agro, separado por comas',
  `FechaBaja` DATE NOT NULL COMMENT 'Fecha en la que se dio de baja el tipo de linea',
  `FechaReactivacion` DATE NOT NULL COMMENT 'Fecha en la que se reactivo un tipo de linea ',
  `UsuarioRegistro` INT NOT NULL COMMENT 'ID del usuario que dio de alta el tipo de linea',
  `UsuarioBaja` INT NOT NULL COMMENT 'ID del usuario que dio de baja el tipo de linea',
  `EmpresaID`	INT(11)	NOT NULL	COMMENT 'Parametro de auditoria.',
  `Usuario`		INT(11)	NOT NULL	COMMENT 'Parametro de auditoria.',
  `FechaActual`	DATETIME  NOT NULL	COMMENT 'Parametro de auditoria.',
  `DireccionIP`	VARCHAR(15)	NOT NULL	COMMENT 'Parametro de auditoria.',
  `ProgramaID`	VARCHAR(50)	NOT NULL	COMMENT 'Parametro de auditoria.',
  `Sucursal`	INT(11)	NOT NULL	COMMENT 'Parametro de auditoria.',
  `NumTransaccion`	BIGINT(20)	NOT NULL	COMMENT 'Parametro de auditoria.',
  PRIMARY KEY (`TipoLineaAgroID`))
ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb. Tipos de Lineas de Credito Agropecuarias\n'$$