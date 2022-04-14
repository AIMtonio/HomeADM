-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSUCURMOV
DELIMITER ;
DROP TABLE IF EXISTS `REQGASTOSUCURMOV`;DELIMITER $$

CREATE TABLE `REQGASTOSUCURMOV` (
  `DetReqGasID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID  del detalle\n',
  `NumReqGasID` int(11) DEFAULT '0' COMMENT 'ID de \nREQGASTOSUCUR\n(encabezado)',
  `TipoGastoID` int(11) NOT NULL COMMENT 'conceptos\n',
  `Observaciones` varchar(50) DEFAULT NULL COMMENT 'Obserbaciones\n',
  `CentroCostoID` int(11) DEFAULT '0' COMMENT 'Centro de  costo\n',
  `PartPresupuesto` decimal(12,2) DEFAULT '0.00' COMMENT 'Partida \npresupuesto \n\n',
  `MontPresupuest` decimal(12,2) DEFAULT '0.00' COMMENT 'Monto Presupuestado',
  `NoPresupuestado` decimal(12,2) DEFAULT '0.00' COMMENT 'Monto No\n Presupuestado',
  `MontoAutorizado` decimal(12,2) DEFAULT '0.00' COMMENT 'Monto \nautorizado\n',
  `Estatus` char(1) DEFAULT 'N' COMMENT 'Estatus\nA=Aprobado\nP=Pendiente\nC=Cancelado\n',
  `FolioPresupID` int(11) DEFAULT NULL COMMENT 'ID del presupuesto\nque pertenece\nsi es = 0  : la Req \nno fue presupuestado',
  `ClaveDispMov` int(11) DEFAULT '0' COMMENT '\\nClaveDispMov= es la clave que genera la dispersion una vez agregado\\nsi es Spei = S, entonces ClaveDispMov debe ser > 0\\nsi no es Spei = N, entonces ClaveDispMov debe ser = -1\\nSi ClaveDispMov = 0 entonces es estatus esta en P= pendiente\\n ',
  `TipoDeposito` char(1) DEFAULT NULL COMMENT 'C .-Cheque\r\nS .-Spei\r\nB .-Banca Electrónica\r\nT .-Tarjeta Empresarial',
  `NoFactura` varchar(20) DEFAULT NULL COMMENT 'Numero de factura  ',
  `ProveedorID` int(11) DEFAULT NULL COMMENT 'Numero de proveedor de la factura',
  `UsuarioAutoID` int(11) DEFAULT NULL COMMENT 'Usuario que Autorizo el Movimiento',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL COMMENT '	',
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DetReqGasID`),
  KEY `fk_REQGASTOSUCURMOV_1` (`NumReqGasID`),
  KEY `fk_REQGASTOSUCURMOV_2` (`CentroCostoID`),
  KEY `fk_ProveedorID` (`ProveedorID`),
  CONSTRAINT `fk_ProveedorID` FOREIGN KEY (`ProveedorID`) REFERENCES `PROVEEDORES` (`ProveedorID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REQGASTOSUCURMOV_1` FOREIGN KEY (`NumReqGasID`) REFERENCES `REQGASTOSUCUR` (`NumReqGasID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REQGASTOSUCURMOV_2` FOREIGN KEY (`CentroCostoID`) REFERENCES `CENTROCOSTOS` (`CentroCostoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalles de Requisición de Gastos a Sucursal'$$