-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CS_CAMBIOTASA
DELIMITER ;
DROP TABLE IF EXISTS `CS_CAMBIOTASA`;DELIMITER $$

CREATE TABLE `CS_CAMBIOTASA` (
  `SolicitudCreditoID` bigint(11) NOT NULL COMMENT 'identificador de la solicitud de credito',
  `NumActualizacion` int(11) DEFAULT NULL COMMENT 'Numero de actualizacion que se envia',
  `TasaFija` varchar(45) DEFAULT NULL COMMENT 'Tasa fija para la solcitud de credito',
  `FactorMora` varchar(45) DEFAULT NULL COMMENT 'Factor mora',
  `MontoPorComAper` varchar(45) DEFAULT NULL COMMENT 'monto correspondiente a la comision por apertura',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'parametro de auditoria',
  `DireccioIP` varchar(15) DEFAULT NULL COMMENT 'parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'parametro de auditoria',
  `NumTransaccion` varchar(45) DEFAULT NULL COMMENT 'Bitacora para almecanar las solicitudes a las que se modifique las condiciones\n6 - Tasa Ordinaria\n7 - Tasa Moratoria\n8 - Comision por apertura\n9 - TODAS'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$