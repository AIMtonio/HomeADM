-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCUENTAS
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSCUENTAS`;
DELIMITER $$

CREATE TABLE `TIPOSCUENTAS` (
  `TipoCuentaID` int(11) NOT NULL COMMENT 'Numero de Tipo de Cuentas',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda del Tipo de Cuenta de Cheques ',
  `Descripcion` varchar(30) NOT NULL COMMENT 'Descripcion del Tipo de Cuenta',
  `Abreviacion` varchar(10) DEFAULT NULL COMMENT 'Abreviación del tipo de cuenta',
  `GeneraInteres` char(1) DEFAULT NULL COMMENT 'Si la cuenta genera o no interes. S Si genera, N no genera ',
  `TipoInteres` char(1) DEFAULT NULL COMMENT 'tipo de intereses que genera, ''D'' = diario; ''M'' = mensual',
  `EsServicio` char(1) DEFAULT NULL COMMENT '¿Es Cuenta de Servicio? S si, N no',
  `EsBancaria` char(1) DEFAULT NULL COMMENT '¿Es Cuenta bancaria? S si, N no',
  `EsConcentradora` char(1) DEFAULT NULL,
  `MinimoApertura` decimal(12,2) DEFAULT NULL,
  `ComApertura` decimal(12,2) DEFAULT NULL,
  `ComManejoCta` decimal(12,2) DEFAULT NULL,
  `ComAniversario` decimal(12,2) DEFAULT NULL,
  `CobraBanEle` char(1) DEFAULT NULL COMMENT 'Cobra comision por banca electronica S si, N no',
  `ParticipaSpei` char(1) DEFAULT NULL COMMENT 'Si participa en SPEI,  S (si), N(no).',
  `CobraSpei` char(1) DEFAULT NULL COMMENT 'Cobra comision por SPEI; Ventanilla y BE S si, N no',
  `ComSpeiPerFis` decimal(18,2) DEFAULT NULL COMMENT 'Comisión SPEI persona Física',
  `ComSpeiPerMor` decimal(18,2) DEFAULT NULL COMMENT 'Comisión SPEI persona Moral\n',
  `NumRegistroRECA` varchar(100) DEFAULT NULL COMMENT 'Se guardará el número de registro del RECA.\n',
  `FechaInscripcion` date DEFAULT '1900-01-01' COMMENT 'Se guardará la Fecha de Inscripción',
  `NombreComercial` varchar(100) DEFAULT '' COMMENT 'Guardará la descripción de cómo es conocido el producto.',
  `ComFalsoCobro` decimal(12,2) DEFAULT NULL,
  `ExPrimDispSeg` char(1) DEFAULT NULL COMMENT 'Exenta de Cobro de Comisión el Primer Dispositivo Seguridad\r\nS - Si lo exenta, No cobra comisión el primer token\r\nN - No lo exenta, Si cobra comisión        ',
  `ComDispSeg` decimal(12,2) DEFAULT NULL,
  `SaldoMInReq` decimal(12,2) DEFAULT NULL,
  `TipoPersona` char(15) DEFAULT NULL COMMENT 'Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial  E.- Menor de Edad',
  `EsBloqueoAuto` char(1) DEFAULT NULL COMMENT 'Campo que indica si el tipo de Cuenta podra ser Bloqueado Automaticamente S.- Si  N.- No\n',
  `ClasificacionConta` char(1) DEFAULT NULL COMMENT 'Clasificacion Contable: V .-Depositos a la Vista, A .- Ahorro(Ordinario)',
  `RelacionadoCuenta` char(1) DEFAULT NULL COMMENT 'S- Requiere de Relacionados cuenta para la autorizacion de una Cuenta\nN- No requiere de Relacionados cuenta para la autorizacion de una Cuenta',
  `RegistroFirmas` char(1) DEFAULT NULL COMMENT 'S- Requiere del Registro de Firmas para la autorizacion de una Cuenta\nN- No requiere del Registro de Firmas para la autorizacion de una Cuenta',
  `HuellasFirmante` char(1) DEFAULT NULL COMMENT 'S- Requiere del Registro de Huellas para la autorizacion de una Cuenta\nN- No requiere del Registro de Huellas para la autorizacion de una Cuenta',
  `ConCuenta` char(1) DEFAULT '' COMMENT 'S- Requiere de la Validación del Conocimiento Cliente Cuenta para la autorización de una Cuenta\n\nN- No requiere de la Validación del Conocimiento Cliente Cuenta para la autorización de una Cuenta\n\nI - Indistinto no es obligatoria la Validación del Conocimiento Cliente Cuenta para la autorización de la Cuenta ',
  `GatInformativo` decimal(12,2) DEFAULT NULL,
  `NivelID` int(11) DEFAULT '0' COMMENT 'Se guardará el id del CATALOGONIVELES',
  `DireccionOficial` char(1) DEFAULT '' COMMENT 'S- Requiere de la Validación de la Dirección Oficial para la autorización de una Cuenta\n\nN- No requiere de la Validación de la Dirección Oficial para la autorización de una Cuenta\n\nI - Indistinto no es obligatoria la Validación de la Dirección Oficial para la autorización de la Cuenta ',
  `IdenOficial` char(1) DEFAULT '' COMMENT 'S- Requiere de la Validación de la Identificacion Oficial para la autorización de una Cuenta\n\nN- No requiere de la Validación de la Identificación Oficial para la autorización de una Cuenta\n\nI - Indistinto no es obligatoria la Validación de la Identificación Oficial para la autorización de la Cuenta ',
  `CheckListExpFisico` char(1) DEFAULT '' COMMENT 'S- Requiere del Check List y Expediente Físico para la autorización de una Cuenta\n\nN- No requiere del Check List y Expediente Físico para la autorización de una Cuenta\n\nI - Indistinto no es obligatorio el Check List y Expediente Físico para la autorización de la Cuenta ',
  `LimAbonosMensuales` char(1) DEFAULT '' COMMENT 'S - Se guardará S si se Limitan Abonos Mensuales\n\nN - Se guardará N no se Limitan Abonos Mensuales',
  `AbonosMenHasta` decimal(14,2) DEFAULT '0.00' COMMENT 'Se guardará el Limite de Abonos Mensuales en UDIS.',
  `PerAboAdi` char(1) DEFAULT '' COMMENT 'S - Se guardará S si se Permiten Abonos Adicionales\n\nN - Se guardará N no se Permiten Abonos Adicionales',
  `AboAdiHas` decimal(14,2) DEFAULT '0.00' COMMENT 'Se guardará el numero permitido de Abonos Adicionales en UDIS.',
  `LimSaldoCuenta` char(1) DEFAULT '' COMMENT 'S - Se guardará S si se Limita el Saldo de la Cuenta\n\nN - Se guardará N no se Limita el Saldo de la Cuenta',
  `SaldoHasta` decimal(14,2) DEFAULT '0.00' COMMENT 'Se guardará el Limite de Saldo de la Cuenta en UDIS.',
  `ClaveCNBV` varchar(10) DEFAULT NULL COMMENT 'Clave CNBV del Producto de Captacion',
  `ClaveCNBVAmpCred` varchar(10) DEFAULT NULL COMMENT 'Clave Producto que Ampara credito',
  `EnvioSMSRetiro` char(1) NOT NULL COMMENT 'Indica si se realizan envios de SMS al realizar un retiro. S - Si, N - No',
  `MontoMinSMSRetiro` decimal(14,2) NOT NULL COMMENT 'Monto minimo de retiros para realizar envios de SMS',
  `EstadoCivil` char(1) DEFAULT '' COMMENT 'Indica si se valida el Estado Civil S:Si / N:No',
  `NotificacionSms` char(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si permite o no envio de sms para la bienvenida (Activacion cuenta) S - Si, N - No',
  `Estatus` CHAR(2) NOT NULL DEFAULT 'A' COMMENT 'Estatus del Tipo de Cuenta \nA.-Activo\n I.-Inactivo.',
  `PlantillaID` int(11) NOT NULL DEFAULT 0 COMMENT 'Indica la plantilla para el envio del sms de bienvenida',
  `ComisionSalProm` decimal(18,2) DEFAULT 0.00 COMMENT 'Comision por Saldo Promedio',
  `SaldoPromMinReq` decimal(18,2) DEFAULT 0.00 COMMENT 'Saldo Promedio Requerido',
  `ExentaCobroSalPromOtros` char(1) DEFAULT 'N' COMMENT 'Indica si excenta cobro saldo promedio de otros productos. S - Si, N - No',
  `DepositoActiva` char(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si el tipo de cuenta requiere un deposito para activarla S= si, N= no',
  `MontoDepositoActiva` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Si requiere un deposito para activar la cuenta, se indica el monto del deposito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoCuentaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Cuenta'$$