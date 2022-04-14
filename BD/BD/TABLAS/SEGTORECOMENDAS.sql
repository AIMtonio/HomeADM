-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTORECOMENDAS
DELIMITER ;
DROP TABLE IF EXISTS `SEGTORECOMENDAS`;DELIMITER $$

CREATE TABLE `SEGTORECOMENDAS` (
  `RecomendacionSegtoID` int(11) NOT NULL,
  `Descripcion` varchar(200) DEFAULT NULL,
  `Alcance` char(1) DEFAULT NULL COMMENT 'G=General,P=Particular\nDetermina si la Recomendacion se lleva a nivel del encabezado SEGTOPROGRAMADO',
  `ReqSupervisor` char(1) DEFAULT NULL COMMENT 'Indica si la recomendacion requiere autorizacion de Supervisor \nS.-Si\nN.- No',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja\nEstado de la Recomendacion',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RecomendacionSegtoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Recomendaciones de seguimientos'$$