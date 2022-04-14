DELIMITER ;
DROP TABLE IF EXISTS `BITACORAREESTRUCREDCRCB`;
DELIMITER $$

CREATE TABLE `BITACORAREESTRUCREDCRCB` (
  `BitacoraID` int(11) NOT NULL COMMENT 'Identificador consecutivo de la bitacora',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente tabla CLIENTES',
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'Numero de Producto de Credito tabla PRODUCTOSCREDITO',
  `Frecuencia` char(1) NOT NULL COMMENT 'Frecuencia de Pagos: Semanal, Catorcenal, Quincenal, Mensual ...... Anual',
  `PlazoID` int(11) NOT NULL COMMENT 'Numero de Plazo',
  `CreditoOrigen` bigint(20) NOT NULL COMMENT 'Si es 0, indica que se generara un nuevo credito con el producto que se indique.\nSi es diferente a 0, el dato corresponda a un credito existente en SAFI ese credito se reestructurara unicamente extendiendo el plazo por default 6 meses, esto modificara unicamente la fecha de vencimiento.',
  `PlazoExt` int(11) NOT NULL COMMENT 'indica el plazo a extender del credito a reestructurar.',
  `FechaSistema` date NOT NULL COMMENT 'indica la fecha del sistema en la que se reigistro en la bitacora.',
  `Hora` time NOT NULL COMMENT 'indica la hora en que se registro en la bitacora.',
  `Descripcion` varchar(600) NOT NULL COMMENT 'indica la descripcion de por que no se dio de alta la reestructura.',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`BitacoraID`),
  KEY `idx_BITACORAREESTRUCREDCRCB_1` (`ClienteID`),
  KEY `idx_BITACORAREESTRUCREDCRCB_2` (`ProductoCreditoID`),
  KEY `idx_BITACORAREESTRUCREDCRCB_3` (`PlazoID`),
  KEY `idx_BITACORAREESTRUCREDCRCB_4` (`CreditoOrigen`),
  KEY `idx_BITACORAREESTRUCREDCRCB_5` (`PlazoExt`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Almacacena la bitacora de los creditos no se pudieron reestructurar en el proceso masivo de CRCB'$$
