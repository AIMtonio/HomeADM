-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMEFINALSEGPLD
DELIMITER ;
DROP TABLE IF EXISTS `COMEFINALSEGPLD`;DELIMITER $$

CREATE TABLE `COMEFINALSEGPLD` (
  `ComentFinalID` char(2) NOT NULL COMMENT 'clave de comentarios finales',
  `DescripCorta` varchar(20) DEFAULT NULL COMMENT 'descripcion de comentario final corto de visita/entrevista',
  `DescripLarga` varchar(80) DEFAULT NULL COMMENT 'descripcion de comentario final latgo de visita/entrevista',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  PRIMARY KEY (`ComentFinalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de clasificacion de comentarios finales del visitad'$$