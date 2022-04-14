-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANCARIA
DELIMITER ;
DROP TABLE IF EXISTS `INVBANCARIA`;DELIMITER $$

CREATE TABLE `INVBANCARIA` (
  `InversionID` int(11) NOT NULL COMMENT 'Num de Inversión',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Numero de institucion',
  `NumCtaInstit` varchar(20) DEFAULT NULL COMMENT 'Numero de cuenta de institucion, Fk de la tabla CUENTASAHOTESO',
  `TipoInversion` varchar(150) DEFAULT NULL,
  `FechaInicio` datetime DEFAULT NULL COMMENT 'Fecha de inicio',
  `FechaVencimiento` datetime DEFAULT NULL COMMENT 'Fecha fin ',
  `Monto` decimal(12,2) DEFAULT NULL COMMENT 'Monto Invertido',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Numero de dias',
  `Tasa` decimal(12,4) DEFAULT NULL COMMENT 'Tasa anualizada',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'Tasa ISR',
  `TasaNeta` decimal(12,4) DEFAULT NULL,
  `InteresGenerado` decimal(12,4) DEFAULT NULL COMMENT 'Interes generado',
  `InteresRecibir` decimal(12,4) DEFAULT NULL COMMENT 'Interes a recibir',
  `InteresRetener` decimal(12,4) DEFAULT NULL COMMENT 'Interes a retener',
  `TotalRecibir` decimal(12,4) DEFAULT NULL COMMENT 'total a recibir por la inversion',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\\nA=Aperturada\\nC=Cancelada\\nP=Pagada',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario quien realizo la inversion',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Tipo de moneda que se uso',
  `SalIntProvision` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Provisionado',
  `DiasBase` int(3) DEFAULT NULL COMMENT 'Año bancario en días',
  `ClasificacionInver` char(1) DEFAULT NULL COMMENT 'Clasificación de la Inv. \nI: Inv. En Valores  \nR:Reportos',
  `TipoTitulo` char(1) DEFAULT NULL COMMENT ' Si selecciona Opcion I (Inv. En Valores) En el Campo ClasificacionInver\nTipo de Titulo \nN:Para Negociar   \nD: Disp. Para Venta   \nC:Conservados al Vencimiento\n',
  `TipoRestriccion` char(1) DEFAULT NULL COMMENT ' Si selecciona Opcion I (Inv. En Valores) En el Campo ClasificacionInver\nRestricción \nC:Con Restricción   \nS: Sin Restricción',
  `TipoDeuda` char(1) DEFAULT NULL COMMENT ' Tipo de Deuda G:Gubernamental  \nB:Bancaria   \nO:Otros Títulos',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InversionID`),
  KEY `fk_INVBANCARIA_1_idx` (`InstitucionID`,`NumCtaInstit`),
  CONSTRAINT `fk_INVBANCARIA_1` FOREIGN KEY (`InstitucionID`, `NumCtaInstit`) REFERENCES `CUENTASAHOTESO` (`InstitucionID`, `NumCtaInstit`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$