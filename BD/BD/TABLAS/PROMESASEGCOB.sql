-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMESASEGCOB
DELIMITER ;
DROP TABLE IF EXISTS `PROMESASEGCOB`;DELIMITER $$

CREATE TABLE `PROMESASEGCOB` (
  `BitacoraID` int(11) NOT NULL COMMENT 'Identificador consecutivo del registro de la bitacora tabla BITACORASEGCOB',
  `NumPromesa` int(11) NOT NULL COMMENT 'Numero de promesa ',
  `FechaPromPago` date NOT NULL COMMENT 'Fecha promesa de pago',
  `MontoPromPago` decimal(16,2) NOT NULL COMMENT 'Monto promesa de pago',
  `ComentarioProm` varchar(300) NOT NULL COMMENT 'Comentario promesa de pago',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  KEY `IDX_PROMESASEGCOB_1` (`BitacoraID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena las promesas de pago de los creditos'$$