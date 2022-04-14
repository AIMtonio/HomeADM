-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMISIONNOTICOB
DELIMITER ;
DROP TABLE IF EXISTS `EMISIONNOTICOB`;DELIMITER $$

CREATE TABLE `EMISIONNOTICOB` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del credito al que se notificara',
  `FechaEmision` date NOT NULL COMMENT 'Fecha en que se  realiza la Emision de notificacion',
  `UsuarioID` int(11) NOT NULL COMMENT 'ID del usuario que realiza la emision',
  `ClaveUsuario` varchar(45) NOT NULL COMMENT 'Clave del usuario que realizo la emision',
  `SucursalUsuID` int(11) NOT NULL COMMENT 'ID de la sucursal donde se realiza la emision',
  `FormatoID` int(11) NOT NULL COMMENT 'ID del formato de notificacion de la tabla FORMATONOTIFICACOB',
  `FechaCita` date NOT NULL COMMENT 'Fecha de cita',
  `HoraCita` varchar(10) NOT NULL COMMENT 'Hora de cita',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los creditos a los que se les realizo notificacion de cobranza en el dia'$$