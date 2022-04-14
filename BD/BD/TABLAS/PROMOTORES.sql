-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTORES
DELIMITER ;
DROP TABLE IF EXISTS `PROMOTORES`;DELIMITER $$

CREATE TABLE `PROMOTORES` (
  `PromotorID` int(11) NOT NULL COMMENT 'Numero de Promotor',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Numero de Empresa',
  `NombrePromotor` varchar(100) NOT NULL COMMENT 'Nombre del Promotor',
  `NombreCoordinador` varchar(100) NOT NULL COMMENT 'Nombre del Coordinador',
  `Telefono` varchar(20) DEFAULT NULL COMMENT 'Telefono donde contactar al promotor',
  `Correo` varchar(50) DEFAULT NULL COMMENT 'Correo donde contactar al promotor',
  `Celular` varchar(20) DEFAULT NULL COMMENT 'Telefono Celular',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal donde esta el promotor',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'No, de usuario del promotor',
  `NumeroEmpleado` varchar(20) DEFAULT NULL COMMENT 'Numero de empleado',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus',
  `GestorID` int(11) DEFAULT NULL COMMENT 'Numero de Gestor del Promotor',
  `ExtTelefonoPart` varchar(6) DEFAULT NULL COMMENT 'Contiene el número de extensión de teléfono particular',
  `AplicaPromotor` char(2) DEFAULT NULL COMMENT 'Indica el Tipo de Promotor\nCR.- Promotor de Credito\nCA.- Promotor de Captacion\nA.- Ambos',
  `Usuario` varchar(30) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PromotorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Promotores o Fuerza Comercial (Ejecutivos, Geren'$$