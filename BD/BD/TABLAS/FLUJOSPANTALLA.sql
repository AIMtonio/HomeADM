-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FLUJOSPANTALLA
DELIMITER ;
DROP TABLE IF EXISTS `FLUJOSPANTALLA`;DELIMITER $$

CREATE TABLE `FLUJOSPANTALLA` (
  `TipoFlujoID` int(11) NOT NULL COMMENT 'Es el tipo de flujo de la pantalla, 1.-flujo de Socio o Cliente 2.-flujo de solicitud individual 3.- flujo de solicitud grupal ',
  `TipoPersonaID` char(1) NOT NULL COMMENT 'Tipo de persona que es el cliente, depende para varias pantalla "F" fisica, "M" moral, "A" fisica con actividad empresarial',
  `Orden` int(11) NOT NULL COMMENT 'Orden de la pantalla',
  `Recurso` varchar(200) DEFAULT NULL COMMENT 'Recurso para pantalla que se esta ordenando',
  `Desplegado` varchar(200) DEFAULT NULL COMMENT 'Desplegado del recurso que se mostrara en la pantalla',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoFlujoID`,`TipoPersonaID`,`Orden`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$