-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMANOTICOB
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMANOTICOB`;DELIMITER $$

CREATE TABLE `ESQUEMANOTICOB` (
  `EsquemaID` int(11) NOT NULL COMMENT 'Identificacor consecutivo de la tabla',
  `DiasAtrasoIni` int(11) NOT NULL COMMENT 'Dias de atraso inicio del rango',
  `DiasAtrasoFin` int(11) NOT NULL COMMENT 'Dias de atraso fin del rango',
  `NumEtapa` int(11) NOT NULL COMMENT 'Numero de etapa',
  `EtiquetaEtapa` varchar(10) NOT NULL COMMENT 'Descripcion de la etapa',
  `Accion` varchar(200) NOT NULL COMMENT 'Descripción de la accion',
  `FormatoID` int(11) NOT NULL COMMENT 'ID de la tabla FORMATONOTIFICACOB',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`EsquemaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena la parametrizacion del esquema de notificaciones de cobranza'$$