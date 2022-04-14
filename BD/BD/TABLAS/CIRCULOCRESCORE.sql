-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRESCORE
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCRESCORE`;DELIMITER $$

CREATE TABLE `CIRCULOCRESCORE` (
  `fk_SolicitudID` varchar(10) NOT NULL COMMENT 'Es el numero de consecutivo obtenido del programa de circulo de credito de la tabla de CIRCULOCRESOL',
  `Consecutivo` int(11) NOT NULL COMMENT 'Es el consecutivo del numero de objetos que se encuentran relacionados a la tabla correspondiente en este caso son los scores.',
  `NombreScore` varchar(40) DEFAULT NULL COMMENT 'Nombre del modelo o tipo de score que se esta reportando',
  `Codigo` int(11) DEFAULT NULL COMMENT 'Corresponde al numero de tipo de score: Score de Originación',
  `Valor` int(11) DEFAULT NULL COMMENT 'Valor de la calificación (SCORE) reportado',
  `Razon1` varchar(5) DEFAULT NULL COMMENT 'Codigo de la razon por la que se genera el valor del score. Ver tabla CATRAZONESSCORECC',
  `Razon2` varchar(5) DEFAULT NULL COMMENT 'Codigo de la razon por la que se genera el valor del score. Ver tabla CATRAZONESSCORECC',
  `Razon3` varchar(5) DEFAULT NULL COMMENT 'Codigo de la razon por la que se genera el valor del score. Ver tabla CATRAZONESSCORECC',
  `Razon4` varchar(5) DEFAULT NULL COMMENT 'Codigo de la razon por la que se genera el valor del score. Ver tabla CATRAZONESSCORECC',
  `CodError` varchar(5) DEFAULT NULL COMMENT 'Código de error asociado al score generado.\n0 – Score generado exitosamente\n<>0 – Error en la generación del score',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`fk_SolicitudID`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contienen los elementos que se devuelven como parte de la respuesta cuando el producto solicitado incluye Score en cualquiera de sus combinaciones.'$$