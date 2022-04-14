-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATLINEANEGOCIO
DELIMITER ;
DROP TABLE IF EXISTS `CATLINEANEGOCIO`;DELIMITER $$

CREATE TABLE `CATLINEANEGOCIO` (
  `LinNegID` int(11) NOT NULL COMMENT 'Llave Principal para Catalogo de Lineas de Negocio',
  `LinNegDescri` varchar(100) DEFAULT NULL COMMENT 'Descripcion de la Linea de Negocio',
  `LinNegEstatus` char(1) DEFAULT NULL COMMENT 'Estatus de La Linea de Negocio\\nA = Activo\\nI = Inactivo',
  `EsAgropecuario` char(1) DEFAULT 'N' COMMENT 'Indica si la linea del negocio es Agropecuaria  S= SI N= NO.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LinNegID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Lineas de Negocio'$$