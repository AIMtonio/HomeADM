-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPREFAUTOMATICO
DELIMITER ;
DROP TABLE IF EXISTS `DEPREFAUTOMATICO`;
DELIMITER $$

CREATE TABLE `DEPREFAUTOMATICO` (
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
  `InsertaTabla` char(1) DEFAULT NULL COMMENT 'Indica si se insertara en la tabla DEPOSITOREFERE \nS = Si\nN = No',
  `NumIdenArchivo` varchar(20) DEFAULT NULL COMMENT 'Numero de identificador del archivo',
  `BancoEstandar` char(1) DEFAULT NULL COMMENT 'Indica si el tipo de banco es Estandar(E) o Bancario(B) ',
  `RutaArchivo` varchar(300) DEFAULT NULL COMMENT 'Ruta del archio de donde se extrajo la informacion',
  `FechaCarga` date DEFAULT NULL COMMENT 'Fecha en que se cargo el registro a la tabla',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del registro que se leyo del archivo A=Aplicado , N = No Aplicado',
  `ConceptoArchivo` varchar(150) DEFAULT NULL COMMENT 'Concepto de la referencia que proviene del archivo cargado.',
  `NumErr` int(11) DEFAULT '0' COMMENT 'Número de Validación resultado de la aplicación del depósito (DEPOSITOREFEREPRO).',
  `ErrMen` varchar(400) DEFAULT '' COMMENT 'Mensaje de Validación resultado de la aplicación del depósito (DEPOSITOREFEREPRO).',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_DEPREFAUTOMATICO_001` (`FechaOperacion`,`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Contiene los registro leidos del proceso de depositos automaticos'$$