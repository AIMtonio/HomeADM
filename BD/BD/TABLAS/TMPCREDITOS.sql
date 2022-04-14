-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOS`;DELIMITER $$

CREATE TABLE `TMPCREDITOS` (
  `CreditoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'Id del Crédito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del Cliente',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Crédito \nI .- Inactivo\nA.- Autorizado\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nK.- Castigado',
  `ProductoCredito` int(11) DEFAULT NULL COMMENT 'Id del Producto de crédito',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'Clasificación del Destino de crédito',
  `SubClasifacion` int(11) DEFAULT NULL COMMENT 'Sub clasificacion del destino de credito',
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal Fisica que se usa para guardar información de créditos que tiene un cliente, se usa para el cambio de sucursal'$$