-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGSERVICIO
DELIMITER ;
DROP TABLE IF EXISTS `PSLCONFIGSERVICIO`;DELIMITER $$

CREATE TABLE `PSLCONFIGSERVICIO` (
  `ServicioID` int(11) NOT NULL COMMENT 'Id de servicio del Broker',
  `ClasificacionServ` char(2) NOT NULL COMMENT 'Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)',
  `CContaServicio` char(25) NOT NULL COMMENT 'Cuenta contable para el cobro servicio (FK de la tabla CUENTASCONTABLES)',
  `CContaComision` char(25) NOT NULL COMMENT 'Cuenta contable para la comision por el servicio (FK de la tabla CUENTASCONTABLES)',
  `CContaIVAComisi` char(25) NOT NULL COMMENT 'Cuenta contable para el IVA de la comision por el servicio (FK de la tabla CUENTASCONTABLES)',
  `NomenclaturaCC` varchar(3) NOT NULL COMMENT 'Nomenclatura del centro de costo',
  `VentanillaAct` char(1) NOT NULL COMMENT 'Canal de ventanilla activa (S = SI, N = NO)',
  `CobComVentanilla` char(1) NOT NULL COMMENT 'Cobrar comision por el uso del servicio en ventanilla (S = SI, N = NO)',
  `MtoCteVentanilla` decimal(14,2) NOT NULL COMMENT 'Monto de comision a clientes por el uso del servicio en ventanilla',
  `MtoUsuVentanilla` decimal(14,2) NOT NULL COMMENT 'Monto de comision a usuarios por el uso del servicio en ventanilla',
  `BancaLineaAct` char(1) NOT NULL COMMENT 'Canal de Banca en linea activa (S = SI, N = NO)',
  `CobComBancaLinea` char(1) NOT NULL COMMENT 'Cobrar de comision por uso del servicio en Banca en linea (S = SI, N = NO)',
  `MtoCteBancaLinea` decimal(14,2) NOT NULL COMMENT 'Monto de comision a clientes por el uso del servicio en Banca en linea',
  `BancaMovilAct` char(1) NOT NULL COMMENT 'Canal de Banca movil activa (S = SI, N = NO)',
  `CobComBancaMovil` char(1) NOT NULL COMMENT 'Cobrar de comision por uso del servicio en Banca movil (S = SI, N = NO)',
  `MtoCteBancaMovil` decimal(14,2) NOT NULL COMMENT 'Monto de comision a clientes por el uso del servicio en Banca movil',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la configuracion (A = Activo, B = Baja)',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ServicioID`,`ClasificacionServ`),
  KEY `INDEX_PSLCONFIGSERVICIO_1` (`ServicioID`),
  KEY `INDEX_PSLCONFIGSERVICIO_2` (`ClasificacionServ`),
  KEY `INDEX_PSLCONFIGSERVICIO_3` (`ServicioID`,`ClasificacionServ`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la configuracion de los servicios del broker.'$$