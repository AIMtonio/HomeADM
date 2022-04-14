-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SECTORES
DELIMITER ;
DROP TABLE IF EXISTS `SECTORES`;DELIMITER $$

CREATE TABLE `SECTORES` (
  `SectorID` int(11) NOT NULL COMMENT 'ID o Numero del Sector',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripción del Sector Gral\n',
  `PagaIVA` char(1) NOT NULL COMMENT 'Especifica si el sector paga ó no IVA\n''S'' .- Si Paga \n''N'' .- No Paga ',
  `PagaISR` char(1) NOT NULL COMMENT 'Especifica si el sector paga ó no ISR\n''S'' .- Si Paga \n''N'' .- No Paga ',
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'Clasificacion Segun Reportes Regulatorios',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SectorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Sector donde se Desmepenia el cliente\nya sea person'$$