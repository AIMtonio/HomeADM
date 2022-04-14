-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDEPREFAUTOMATICO
DELIMITER ;
DROP TABLE IF EXISTS `TMPDEPREFAUTOMATICO`;
DELIMITER $$

CREATE TABLE `TMPDEPREFAUTOMATICO` (
  `Numero` int(11) NOT NULL COMMENT 'Numero consecutivo para la tabla',
  `ConsecutivoID` bigint(12) NOT NULL COMMENT 'Numero consecutivo que sirve como identificador del registro en la tabla',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Identifcador de la institucion bancaria de la Tabla  INSTITUCIONES',
  `NumCtaInstit` varchar(20) DEFAULT NULL COMMENT 'Numero de cuenta a la cual se afecta con el pago o deposito es cuenta de la institucion bancaria',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha en que se  aplicara el pago o deposito',
  `ReferenciaMov` varchar(150) DEFAULT NULL COMMENT 'Referencia del movimiento ya sea num cuenta, num credito, o referencia de pago',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Descripcion del movimiento conocido tambien como el concepto del deposito o cargo',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza de la aplicacion\nC = Cargo\nA = Abono',
  `MontoMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto a aplicar del archivo',
  `MontoPendApli` decimal(12,2) DEFAULT NULL COMMENT 'Monto pendiente por Aplicar',
  `TipoCanal` int(11) DEFAULT NULL COMMENT 'Indica el para que es el deposito el id utilizado es de la tabla TIPOCANAL \nTipoCredito = 1;\nTipoCtaAho = 2;\n',
  `TipoDeposito` char(1) DEFAULT NULL COMMENT 'Indica si el deposito es por E = Efectivo, T = Tarjeta, C = Cheque',
  `Moneda` int(11) DEFAULT '1' COMMENT 'Indicar el tipo de moneda utilizado por defecto es 1 MXN',
  `ConceptoArchivo` varchar(150) DEFAULT NULL COMMENT 'Concepto de la referencia que proviene del archivo cargado.',
  `InsertaTabla` char(1) DEFAULT NULL COMMENT 'Indica si se insertara en la tabla DEPOSITOREFERE \nS = Si\nN = No',
  `NumIdenArchivo` varchar(20) DEFAULT NULL COMMENT 'Numero de identificador del archivo',
  `BancoEstandar` char(1) DEFAULT NULL COMMENT 'Indica si el tipo de banco es Estandar(E) o Bancario(B) ',
  PRIMARY KEY (`Numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla de paso para el proceso de los pagos de los depositos referenciados automaticos'$$