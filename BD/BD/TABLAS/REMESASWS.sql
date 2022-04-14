-- REMESASWS
DELIMITER ;
DROP TABLE IF EXISTS `REMESASWS`;
DELIMITER $$

CREATE TABLE `REMESASWS` (
  `RemesaWSID` bigint(20) NOT NULL COMMENT 'Identificador de la tabla REMESASWS',
  `Origen` varchar(10) NOT NULL COMMENT 'Indica el origen de la informacion a registrar en el sistema',
  `UsuarioExt` varchar(45) NOT NULL COMMENT 'indica el usuario de cajas de la empresa remesadora',
  `RemesaCatalogoID` int(11) NOT NULL COMMENT 'llave primaria para el catalogo de remesas',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto de la Remesa',
  `RemesaFolioID` varchar(45) NOT NULL COMMENT 'Indica la referencia(UNICA) de pago',
  `ClabeCobroRemesa` varchar(45) NOT NULL COMMENT 'Indica la clave de cobro para la remesa',
  `ClienteID` int(11) NOT NULL COMMENT 'Indica el cliente que recibira el pago de la remesa, 0 si es usuario servicios',
  `PrimerNombre` varchar(50) NOT NULL COMMENT 'Primer Nombre ',
  `SegundoNombre` varchar(50) NOT NULL COMMENT 'Segundo Nombre ',
  `TercerNombre` varchar(50) NOT NULL COMMENT 'Tercer Nombre ',
  `ApellidoPaterno` varchar(50) NOT NULL COMMENT 'Apellido Paterno ',
  `ApellidoMaterno` varchar(50) NOT NULL COMMENT 'Apellido Materno ',
  `NombreCompleto` varchar(200) NOT NULL COMMENT 'Indica el nombre completo del cliente o usuario',
  `NombreCompletoRemit` varchar(200) NOT NULL COMMENT 'Indica el nombre de la persona que envia el pago remitente',
  `FolioIdentificRemit` bigint(11) NOT NULL COMMENT 'Indica el numero de indentificador del remitente',
  `TipoIdentiIDRemit` int(11) NOT NULL COMMENT 'Indica el tipo de identificacion utilizada para el envio de la remesa tabla TIPOSIDENTI',
  `GeneroRemitente` char(1) NOT NULL COMMENT 'Indica el genero del remitente de la remesa',
  `Direccion` varchar(500) NOT NULL COMMENT 'Indica la direccion del beneficiario',
  `DirecRemitente` varchar(500) NOT NULL COMMENT 'Indica la direccion del remitente',
  `NumTelefonico` varchar(20) NOT NULL COMMENT 'Indica el telefono del beneficiario',
  `TipoIdentiID` int(11) NOT NULL COMMENT 'Numero de identificacion. Corresponde con la tabla TIPOSIDENTI',
  `FolioIdentific` varchar(45) NOT NULL COMMENT 'Numero de Folio de la identificacion',
  `FormaPago` char(1) NOT NULL COMMENT 'Indica la clave para identificar la forma de pago \nR: Retiro de Efectivo\nS: SPEI\nA: Abono a cuenta',
  `NumeroCuenta` varchar(18) NOT NULL COMMENT 'Indica la cuenta CLABE del cliente o usuario',
  `CuentaClabeRemesa` varchar(18) NOT NULL COMMENT 'Indica la cuenta CLABE de la remesadora',
  `TipoCuentaSpei` int(11) DEFAULT NULL COMMENT 'Tipo de Cuenta de Envio para SPEI ',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Institucion de la cuenta externa',
  `NumParticipanteSPEI` bigint(20) NOT NULL COMMENT 'Indica el numero que le asigno SPEI a la institucion para operar con SPEI valor esperado 90646',
  `CURP` char(18) NOT NULL COMMENT 'Indica la clave CURP del cliente o usuario',
  `CurpRemitente` char(18) NOT NULL COMMENT 'Curp del remitente',
  `RFC` char(13) NOT NULL COMMENT 'Indica el RFC del cliente o usuario',
  `RfcRemitente` char(13) NOT NULL COMMENT 'Indica RFC del remitente',
  `RazonSocial` varchar(150) NOT NULL COMMENT 'Indica la Razon social del cliente o usuario',
  `NomRepresenLegal` varchar(200) NOT NULL COMMENT 'Indica el nombre del representante legal de la persona moral',
  `PaisID` int(11) NOT NULL COMMENT 'Indica el Pais de nacimiento del cliente o usuario este valor debe existir en el catalogo del PAISES del SAFI',
  `PaisIDRemitente` int(11) NOT NULL COMMENT 'Indica el pais de nacimiento del remitente este valor debe existir en el catalogo del PAISES del SAFI',
  `EstadoID` int(11) NOT NULL COMMENT 'Indica la entidad federativa del cliente o usuario este valor debe existir en el catalogo de ESTADOS del SAFI',
  `EstadoIDRemitente` int(11) NOT NULL COMMENT 'Indica la entidad federativa del remitente ESTADOS',
  `CiudadIDRemitente` int(11) NOT NULL COMMENT 'Indica la ciudad del remitente',
  `ColoniaIDRemitente` decimal(16,2) NOT NULL COMMENT 'Indica la colonia del remitente',
  `CodigoPostalRemitente` char(5) NOT NULL COMMENT 'Indica el codigo postal del remitente',
  `Genero` char(1) NOT NULL COMMENT 'Indica el genero del cliente o usuario valores validos M (Masculino) F(Femenino)',
  `FechaNacimiento` date NOT NULL COMMENT 'Indica la fecha de nacimiento del cliente o usuario formato valido (aaaa-MM-dd)',
  `Nacionalidad` char(1) NOT NULL COMMENT 'Indica la nacionalidad del cliente o usuario N.- Nacional , E.- Extranjero',
  `NacionalidadRemitente` char(1) NOT NULL COMMENT 'Indica la nacionalidad del remitenteo usuario N.- Nacional , E.- Extranjero',
  `Email` varchar(50) NOT NULL COMMENT 'Indica el correo electronico del cliente o usuario',
  `Fiel` varchar(50) NOT NULL COMMENT 'Indica el FIEL del cliente o usuario',
  `GiroMercantil` varchar(200) NOT NULL COMMENT 'Indica el giro mercantil solo aplica para personas morales',
  `Actividad` varchar(200) NOT NULL COMMENT 'Indica la actividad u objeto social para persona moral.',
  `IdentificacionFiscal` varchar(30) NOT NULL COMMENT 'Indica la identificacion fiscal o equivalente para persona moral',
  `IdentiFiscalPaisID` int(11) NOT NULL COMMENT 'Indica el Pais que asigno la identificacion fiscal para personas morales codigo del pais del catalogo de SAFI',
  `FechaConstitucion` date NOT NULL COMMENT 'Indica la fecha de constitucion de la persona moral formato valido (aaaa-MM-dd)',
  `RutaIdentOficial` varchar(1000) NOT NULL COMMENT 'Indica la ruta o el archivo digitalizado de la identificacion oficial.',
  `CedulaIdentiFiscal` varchar(1000) NOT NULL COMMENT 'Indica la cedula de la identificacion fiscal de la razon social solo para personas morales',
  `TipoPersona` char(1) NOT NULL COMMENT 'Indica el tipo de persona  Fisica(F) , Fisica con Actividad Empresarial(A) y Moral (M) para el cliente o usuario',
  `TipoPersonaRemitente` char(1) NOT NULL COMMENT 'Indica el tipo de persona  Fisica(F) , Fisica con Actividad Empresarial(A) y Moral (M) para el remitente',
  `NivelRiesgo` char(1) NOT NULL COMMENT 'Indica el nivel de riego para la operacion ya sea para personas fisica, fisica con actividad empresarial o moral',
  `PermiteOperacion` char(1) NOT NULL COMMENT 'Indicar si se permite o no operar con la remesa valores permitidos S.- Si, N.- NO',
  `Comentarios` varchar(500) NOT NULL COMMENT 'Comentarios del Oficial de Cumplimiento',
  `Estatus` char(1) NOT NULL COMMENT 'Indica el estatus de las remesas valores permitidos N.- Nuevo, R.- En revision Oficial Cumplimiento, P.- Pagado, C.-Rechazado.',
  `MotivoRevision` varchar(500) NOT NULL DEFAULT '' COMMENT 'Indica el Motivo de Revision',
  `EstatusActualiza` char(1) NOT NULL DEFAULT '' COMMENT 'Estatus de Actualizacion\nA = Actualizada',
  `NumActualizacion` int(11) NOT NULL DEFAULT 0 COMMENT 'Numero de veces que ha sido actualizada la remesa',
  `UsuarioServicioID` int(11) NOT NULL COMMENT 'Indica el ID del usuario de servicio',
  `TipoBeneficiario` char(1) NOT NULL DEFAULT '' COMMENT 'Tipo de beneficiario U = usuario, C = cliente',
  `EsNuevo` char(1) NOT NULL DEFAULT '' COMMENT 'Es un nuevo beneficiario, S= si es nuevo(usuario), N=no es nuevo, ya existe(usuario,cliente)',
  `SpeiSolDesID` bigint(20) NOT NULL COMMENT 'Indica ID de la de solicitud remesa, nace con 0.',
  `FechaRegistro` date NOT NULL COMMENT 'Indica la fecha de registro de la remesa',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`RemesaWSID`),
  KEY `fk_REMESASWS_1` (`RemesaCatalogoID`),
  KEY `fk_REMESASWS_2` (`RemesaFolioID`),
  KEY `fk_REMESASWS_3` (`ClabeCobroRemesa`),
  KEY `fk_REMESASWS_4` (`ClienteID`),
  KEY `fk_REMESASWS_5` (`FolioIdentificRemit`),
  KEY `fk_REMESASWS_6` (`TipoIdentiIDRemit`),
  KEY `fk_REMESASWS_7` (`TipoIdentiID`),
  KEY `fk_REMESASWS_8` (`FolioIdentific`),
  KEY `fk_REMESASWS_9` (`FormaPago`),
  KEY `fk_REMESASWS_10` (`PaisID`),
  KEY `fk_REMESASWS_11` (`PaisIDRemitente`),
  KEY `fk_REMESASWS_12` (`EstadoID`),
  KEY `fk_REMESASWS_13` (`EstadoIDRemitente`),
  KEY `fk_REMESASWS_14` (`CiudadIDRemitente`),
  KEY `fk_REMESASWS_15` (`ColoniaIDRemitente`),
  KEY `fk_REMESASWS_16` (`IdentiFiscalPaisID`),
  KEY `fk_REMESASWS_17` (`NivelRiesgo`),
  KEY `fk_REMESASWS_18` (`UsuarioServicioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla  cabecera para almacenar la informacion principal del WS recordRemmitance'$$