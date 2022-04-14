-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCODLEYENDA
DELIMITER ;
DROP TABLE IF EXISTS `CATCODLEYENDA`;DELIMITER $$

CREATE TABLE `CATCODLEYENDA` (
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Valor consecutivo para el registro de la tabla es la llave primaria',
  `CodigoLeyenda` varchar(5) DEFAULT NULL COMMENT 'Codigo de leyenda para el archivo de carga del banco',
  `Identificador` varchar(10) DEFAULT NULL COMMENT 'identifcador del tipo de depositos que va relacionado con la escripcion de la leyenda',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion del codigo de leyenda',
  `TipoDeposito` char(1) DEFAULT NULL COMMENT 'Tipo de deposito al que corresponde el codigo de leyenda E = Efectivo , C= Cheque y T = Transferencia',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catalogo de codigos de leyendas para los depositos referenciados de Bancomer'$$