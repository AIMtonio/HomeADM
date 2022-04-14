-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCLASIFSEGTO
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOCLASIFSEGTO`;DELIMITER $$

CREATE TABLE `SEGTOCLASIFSEGTO` (
  `SeguimientoID` int(11) NOT NULL COMMENT 'Clave compuesta del Seguimiento ',
  `ClasificacionID` int(11) DEFAULT NULL COMMENT 'Identificador de Clasificacion',
  `CampoClasificacion` int(11) DEFAULT NULL COMMENT 'Condicion de Clasificacion 1.-Region, 2.-Sucursal, 3.-Oficial, 4.-Municipio, 5.-Genero, 6.-Monto Original Credito,\n7.-Saldo del Credito, 8.-Saldo Mora + Cargos, 9.-Fecha Proximo Vencimiento, 10.-Fecha Otorgamiento Credito\n11.-Fecha Liquidacion Credito',
  `OrdenClasificacion` char(5) DEFAULT NULL COMMENT 'Orden Clasificacion ASC.- Ascendente, DESC.- Descendente',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_SEGTOCLASIFSEGTO_1` (`SeguimientoID`),
  CONSTRAINT `fk_SEGTOCLASIFSEGTO_1` FOREIGN KEY (`SeguimientoID`) REFERENCES `SEGUIMIENTOCAMPO` (`SeguimientoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Definicion de Criterios de Clasificacion de Seguimiento'$$