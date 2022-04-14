-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASPASOVENCIDO
DELIMITER ;
DROP TABLE IF EXISTS `DIASPASOVENCIDO`;
DELIMITER $$


CREATE TABLE `DIASPASOVENCIDO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `ProducCreditoID` int(11) DEFAULT NULL COMMENT 'Numero de producto de credito',
  `Frecuencia` char(1) DEFAULT NULL COMMENT 'Frecuencia S .- Semanal\\nC.- Cartorcenal\\nQ .- Quincenal\\nM.- Mensual\\n \nBimestral B\nTrimestral T\nTetramestral R\nSemestral  E\nAnual 	A\nPeriodo   P\nPago Unico  U\nLibre L (calendario Irregular)\n',
  `DiasPasoVencido` int(4) DEFAULT NULL COMMENT 'Dias para cambiar el credito a vencido',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
