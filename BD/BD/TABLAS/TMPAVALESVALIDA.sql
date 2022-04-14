-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALESVALIDA
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALESVALIDA`;DELIMITER $$

CREATE TABLE `TMPAVALESVALIDA` (
  `AvalID` int(11) DEFAULT NULL COMMENT 'ID Aval, si se encuentra en la tabla de Avales',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID Cliente, si es cliente',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'ID Prospecto, si es prospecto',
  `CantidadAvales` int(11) DEFAULT NULL COMMENT 'Número de créditos que puede avalar una persona',
  `IntercambiaAvales` char(1) DEFAULT NULL COMMENT '(S=si, N=no)',
  `ProducCreditoID` int(11) DEFAULT NULL COMMENT 'ID del Producto de Credito',
  `ClienteCre` int(11) DEFAULT NULL COMMENT 'IDCliente de la tabla Credito',
  `NumCreditosAvalados` int(3) DEFAULT NULL COMMENT 'Numero de Creditos Avalados ',
  `NumeroTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transacción generada en el reporte'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que se usa en el SP MINISTRACREPRO para almacenar avales'$$