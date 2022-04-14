-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TCR_ARCHRETERRPROSA_CAT
DELIMITER ;
DROP TABLE IF EXISTS `TCR_ARCHRETERRPROSA_CAT`;DELIMITER $$

CREATE TABLE `TCR_ARCHRETERRPROSA_CAT` (
  `RET_ESTADO` int(11) NOT NULL COMMENT 'consecutivo RET_ESTADO',
  `RET_DESCRIPCION` varchar(200) NOT NULL COMMENT 'Descripcion Error RET_ESTADO',
  PRIMARY KEY (`RET_ESTADO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Archivos de respuesta PROSA'$$