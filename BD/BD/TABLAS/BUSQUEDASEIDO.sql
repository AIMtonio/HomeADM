-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUSQUEDASEIDO
DELIMITER ;
DROP TABLE IF EXISTS `BUSQUEDASEIDO`;DELIMITER $$

CREATE TABLE `BUSQUEDASEIDO` (
  `BusquedaSeidoID` bigint(20) DEFAULT NULL COMMENT 'Id consecutivo',
  `Nombre` varchar(200) DEFAULT NULL COMMENT 'Nombre de la persona buscada',
  `TipoBusqueda` char(2) DEFAULT NULL COMMENT 'Tipo de busqueda como: ''C'' Cliente, ''A'' Aval, ''RC'' Relacionado a la cuenta, ''RI'' Relacionado a la inversion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del Cliente',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `PersonaID` int(11) DEFAULT NULL COMMENT 'Id de la Persona como relacionado a la cuenta',
  `InversionID` int(11) DEFAULT NULL COMMENT 'Id de la Inversion',
  `BenefInverID` int(11) DEFAULT NULL COMMENT 'Id del beneficiario de la inversion',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha del sistema en la que se realiza la busqueda',
  `SolicitudID` bigint(20) DEFAULT NULL COMMENT 'ID de la solicitud de credito a la que esta relacionado el aval',
  `Tipo` char(1) DEFAULT NULL COMMENT 'C: Cliente, A :Aval, P: Prospecto',
  `Numero` int(11) DEFAULT NULL COMMENT 'Numero de Cliente, numero de aval o de prospecto',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de cuenta a la que esta relacionado la persona',
  KEY `index_BusquedaSeido` (`BusquedaSeidoID`,`Fecha`),
  KEY `index_TipoBusqueda` (`BusquedaSeidoID`,`TipoBusqueda`),
  KEY `index_Nombre` (`BusquedaSeidoID`,`Nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que registra todas las busquedas realizadas en pantalla'$$