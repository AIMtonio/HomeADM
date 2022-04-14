-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOSERV
DELIMITER ;
DROP TABLE IF EXISTS `CATALOGOSERV`;
DELIMITER $$


CREATE TABLE `CATALOGOSERV` (
  `CatalogoServID` int(11) NOT NULL,
  `Origen` char(1) DEFAULT NULL COMMENT 'Indica si el servicio es Proporcionado por un tercero o es un servicio interno de la empresa\nTercero =T\nInterno = I',
  `NombreServicio` varchar(50) DEFAULT NULL COMMENT 'Nombre del servicio',
  `RazonSocial` varchar(150) DEFAULT NULL COMMENT 'Razon social de la empresa que proporciona el servicio',
  `Direccion` varchar(500) DEFAULT NULL COMMENT 'Direccion de la empresa que proporciona el servicio',
  `CobraComision` char(1) DEFAULT NULL COMMENT 'Indica si se cobra comision por el serrvicio brindado\nS =Si\nN = No',
  `MontoComision` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Comisión cobrada ',
  `CtaContaCom` varchar(25) DEFAULT NULL COMMENT 'Cuenta contable de la Comision por el Servicio',
  `CtaContaIVACom` varchar(25) DEFAULT NULL COMMENT 'Cuenta Contable IVA de la Comision por el servicio',
  `CtaPagarProv` varchar(25) DEFAULT NULL COMMENT 'Cuenta Contable por pagar al proveedor de servicios',
  `MontoServicio` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Servicio',
  `CtaContaServ` varchar(25) DEFAULT NULL COMMENT 'Cuenta Contable  del monto del Pago del Servicio',
  `CtaContaIVAServ` varchar(25) DEFAULT NULL COMMENT 'Cuenta Contable del IVA del monto del Pago del servicio',
  `RequiereCliente` char(1) DEFAULT NULL COMMENT 'Indica si el servicio requiere Cliente\nS=SI\nN=NO',
  `RequiereCredito` char(1) DEFAULT NULL COMMENT 'Indica si requiere Credito para el pago del servicio',
  `PagoAutomatico` char(1) DEFAULT NULL COMMENT 'indica que se hara un pago automatico en dispersion al proveedor \nSI="S" NO = "N"\r',
  `CuentaClabe` char(18) DEFAULT NULL COMMENT 'cuenta clabe corresponde con CUENTASAHOTESO (requerido si es tercero y si pago automatico es "S"\r\n',
  `BancaElect` char(1) DEFAULT NULL COMMENT 'Campo para saber si el servicio tambien estara en Banca Electronica o no\nS = SI (estara en banca electronica)\nN = NO (solo ventanilla)',
  `Ventanilla` char(1) DEFAULT NULL COMMENT 'Campo para saber si el servicio se Mostrara en las Operaciones de Ventanilla\nS = SI (estara en banca electronica)\nN = NO (solo ventanilla)',
  `BancaMovil` char(1) DEFAULT NULL COMMENT 'Campo para saber si el servicio tambien estara en Banca Movil o no\nS = SI (Participa Banca Movil)\nN = NO (No participa en Pago Movil)',
  `CCostosServicio` char(30) DEFAULT NULL COMMENT 'Nomenclatura para indicar el Centro de Costos para las Remesas\n&SC = Sucursal Cliente \n&SO = sucursal Origen de la Operacion',
  `NumServProve` int(11) DEFAULT NULL COMMENT 'ALMACENA EL ID DE SERVICIO DE TERCEROS',
  `Estatus` CHAR(2) NOT NULL DEFAULT 'A' COMMENT 'Estatus del Tipo de Servicio \nA.-Activo\n I.-Inactivo.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CatalogoServID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo pago de Servicios'$$