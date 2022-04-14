-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITNOMINA
DELIMITER ;
DROP TABLE IF EXISTS `INSTITNOMINA`;
DELIMITER $$

CREATE TABLE `INSTITNOMINA` (
  `InstitNominaID` int(11) NOT NULL COMMENT 'Consecutivo o ID de la Institucion de Nomina',
  `NombreInstit` varchar(200) DEFAULT NULL COMMENT 'Nombre de la Institucion de Nomina',
  `Domicilio` varchar(200) DEFAULT NULL COMMENT 'Domicilio de la Institucion de Nomina',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID de la institucion de nomina',
  `ContactoRH` varchar(400) DEFAULT NULL COMMENT 'Nombre de la persona o contacto encargado de la nomina',
  `TelContactoRH` varchar(20) DEFAULT NULL COMMENT 'Telefono de contacto de la persona encargada de la Nomina',
  `ExtTelContacto` varchar(7) DEFAULT NULL COMMENT 'Contiene en Numero de Extensión del Telefono del contacto',
  `Correo` varchar(200) DEFAULT NULL COMMENT 'Correo del Contacto',
  `BancoDeposito` int(11) DEFAULT NULL COMMENT 'Banco default donde realizara el deposito de la nomina',
  `CuentaDeposito` char(18) DEFAULT NULL COMMENT 'Cuenta donde se realizara el deposito de la nomina',
  `ReqVerificacion` char(1) DEFAULT NULL COMMENT 'Requiere Verificacion \nS.- Si	\nN.-No',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la institucion de nomina\nA- alta',
  `EspCtaCon` CHAR(1) DEFAULT 'N' COMMENT 'Especifica cuenta contable S:Si/N:No',
  `CtaContable` VARCHAR(30) DEFAULT '' COMMENT 'Numero de Cuenta contable',
  `TipoMovID` INT(11) DEFAULT 0 COMMENT 'ID del tipo de movimiento',
  `AplicaTabla` CHAR(1) DEFAULT 'N' COMMENT 'Indica si aplica tabla real S:SI/N:NO',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InstitNominaID`),
  KEY `INSTITNOMINA_IDX1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Institucion o empresa de Nomina'$$