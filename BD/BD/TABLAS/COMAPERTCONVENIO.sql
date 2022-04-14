-- Creacion de tabla COMAPERTCONVENIO

DELIMITER ;
DROP TABLE IF EXISTS `COMAPERTCONVENIO`;
DELIMITER $$

CREATE TABLE `COMAPERTCONVENIO`(
  `EsqConvComAperID` int(11) NOT NULL COMMENT 'Identificador Esquema por Convenio',
  `EsqComApertID` int(11) NOT NULL COMMENT 'Identificador Esquema Comision Apertura',
  `ConvenioNominaID` bigINT unsigned NOT NULL COMMENT 'Numero de Convenio de Nomina',
  `FormCobroComAper` char(1) NOT NULL COMMENT 'Tipo Forma Cobro F FINANCIAMIENTO, D DEDUCCION, A ANTICIPADO P PROGRAMADO',
  `TipoComApert` char(1) NOT NULL COMMENT 'Tipo Comisión por Apertura. M MONTO, P PORCENTAJE',
  `PlazoID` varchar(20) NOT NULL COMMENT 'Numero de Plazos',
  `MontoMin` decimal(12,2) NOT NULL COMMENT 'Monto Mínimo',
  `MontoMax` decimal(12,2) NOT NULL COMMENT 'Monto Máximo',
  `Valor` decimal(12,4) NOT NULL COMMENT 'Valor',
  `Fila` decimal(12,4) NOT NULL COMMENT 'Linea de Configuración',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
PRIMARY KEY (`EsqConvComAperID`),
UNIQUE KEY(`EsqComApertID`,`ConvenioNominaID`,`PlazoID`,`MontoMin`,`MontoMax`),
FOREIGN KEY (`EsqComApertID`) REFERENCES ESQCOMAPERNOMINA(`EsqComApertID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'Tab: Tabla para el registro de Esquema de Comisión Apertura por Convenio.'$$
