-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OCUPACIONES
DELIMITER ;
DROP TABLE IF EXISTS `OCUPACIONES`;DELIMITER $$

CREATE TABLE `OCUPACIONES` (
  `OcupacionID` int(11) NOT NULL COMMENT 'Numero de Ocupacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Id de la Empresa',
  `Descripcion` text NOT NULL COMMENT 'Descripcion de la Ocupacion',
  `ImplicaTrabajo` char(1) DEFAULT NULL COMMENT 'S .- SI\\nN .- NO\\nSi requiere trabajo solicitara el puesto, nombre del centro de trabajo, antiguedad y telefono como obligatorios.',
  `Puntos` int(11) DEFAULT NULL COMMENT 'indica los puntos que le corresponde a cada ocupacion en el Calculo del ratios',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`OcupacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$