-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDEPOSITOSREFERE
DELIMITER ;
DROP TABLE IF EXISTS `TMPDEPOSITOSREFERE`;
DELIMITER $$

CREATE TABLE `TMPDEPOSITOSREFERE` (
  `Cliente` int(11) DEFAULT NULL COMMENT 'no cliente ',
  `NombreCompleto` VARCHAR(200) NULL COMMENT 'NombreCompeto del cliente',
  `TipoCarga` VARCHAR(10) NULL COMMENT 'Tipo de Carga relizado Automatico o Manual',
  `Referencia` varchar(40) DEFAULT NULL COMMENT 'referencia(nro socio, no credito, no cuenta)',
  `DescripcionMov` varchar(100) DEFAULT NULL COMMENT 'descripcion movimiento',
  `HoraEmision` time DEFAULT NULL COMMENT 'hora de emision',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'no  intitucion',
  `Banco` varchar(80) DEFAULT NULL COMMENT 'nombre del banco',
  `CuentaBancaria` bigint(20) DEFAULT NULL COMMENT 'no de cuenta',
  `Estado` varchar(45) DEFAULT NULL COMMENT 'Estado del deposito aplicado, no identificado',
  `FechaCarga` date DEFAULT NULL COMMENT 'Fecha carga',
  `FechaAplica` date DEFAULT NULL COMMENT 'Fecha aplicacion',
  `Monto` decimal(12,2) DEFAULT NULL COMMENT 'Monto',
  `MontoAplicado` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado',
  `TipoCanal` int(11) DEFAULT NULL COMMENT 'Tipo de canal',
  `TipoMov` varchar(60) DEFAULT NULL COMMENT 'Tipo Movimiento',
  `TipoDeposito` char(1) DEFAULT NULL COMMENT 'E = Si pago Efectivo\nT = Transferencia',
  KEY `ClienteID` (`Cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$