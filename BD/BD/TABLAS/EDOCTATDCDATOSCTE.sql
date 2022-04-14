-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCDATOSCTE
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATDCDATOSCTE`;
DELIMITER $$

CREATE TABLE `EDOCTATDCDATOSCTE` (
  `Periodo` INT(11) NOT NULL COMMENT 'anio y mes de la fecha que se realizara el corte',
  `DiaCorte` INT(11) NOT NULL COMMENT 'Dia de la fecha que se realizara el corte',
  `ClienteID` INT(11) NOT NULL COMMENT 'ID del cliente',
  `NombreCompleto` VARCHAR(200) NOT NULL COMMENT 'Nombre completo del cliente',
  `SucursalID` INT(11) NOT NULL COMMENT 'ID de la sucursal del cliente',
  `NombreSucurs` VARCHAR(60) NOT NULL COMMENT 'Nombre de la sucursal del cliente',
  `TipoPer` CHAR(1) NOT NULL COMMENT 'Tipo de persona a la que pertenece el cliente F:Física, M:Moral',
  `DescriTipoPer` VARCHAR(10) NOT NULL COMMENT 'Descripción del tipo persona a la que pertenece el cliente',
  `RFC` VARCHAR(15) NOT NULL COMMENT 'RFC del cliente',
  `Calle` VARCHAR(50) NOT NULL COMMENT 'Nombre de la calle de la dirección del cliente',
  `NumInt` VARCHAR(10) NOT NULL COMMENT 'Numero interior',
  `NumExt` VARCHAR(10) NOT NULL COMMENT 'Numero exterior',
  `Colonia` VARCHAR(200) NOT NULL COMMENT 'Colonia del cliente',
  `Municip_Deleg` VARCHAR(150) NOT NULL COMMENT 'Municipo o delegación del cliente',
  `Estado` VARCHAR(150) NOT NULL COMMENT 'Estado del cliente',
  `CodigoPostal` VARCHAR(5) NOT NULL COMMENT 'Codigo postal del cliente',
  `NombreInstit` VARCHAR(250) NOT NULL COMMENT 'Nombre de la institucion',
  `DireccionInstit` VARCHAR(250) NOT NULL COMMENT 'Dirección de la institucion',
  `RegHacienda` CHAR(1) NOT NULL COMMENT 'Registrado en hacienda S:Si, N:No',
  `EmpresaID` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` DATE NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` VARCHAR(15) NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` VARCHAR(50) NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`Periodo`,`DiaCorte`,`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
