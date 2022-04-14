-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNFOLIOS
DELIMITER ;
DROP TABLE IF EXISTS `SERVIFUNFOLIOS`;DELIMITER $$

CREATE TABLE `SERVIFUNFOLIOS` (
  `ServiFunFolioID` int(11) NOT NULL COMMENT 'Folio o Consecutivo, del servicio Financiero',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente o Socio',
  `TipoServicio` char(1) DEFAULT NULL COMMENT 'Tipo de Solicitud del Apoyo de Servicio\nFunerario\n\nC .- Fallecimiento de Cliente o Socio\nF .- Fallecimiento de Familiar',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de Registro de la Solicitud de Apoyo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Solicitud de Apoyo\nC .- Capturado\nR .- Rechazado o Cancelado\nA .- Autorizado\nP .- Pagado',
  `DifunClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente o Socio del Difunto\nNota: En caso de que el difunto sea el socio\nEste campo deberá ser el mismo de ClienteID\nNo poner como llave foranea, pq el difunto puede\nNo ser cliente o socio',
  `DifunPrimerNombre` varchar(200) DEFAULT NULL COMMENT 'Primer Nombre del Difunto',
  `DifunSegundoNombre` varchar(200) DEFAULT NULL COMMENT 'Segundo Nombre del Difunto',
  `DifunTercerNombre` varchar(200) DEFAULT NULL COMMENT 'Tercer Nombre del Difunto',
  `DifunApePaterno` varchar(200) DEFAULT NULL COMMENT 'Apellido Paterno Difunto',
  `DifunApeMaterno` varchar(200) DEFAULT NULL COMMENT 'Apellido Materno Difunto',
  `DifunNombreComp` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo del Difunto',
  `DifunFechaNacim` date DEFAULT NULL COMMENT 'Fecha de Nacimiento del Difunto',
  `DifunParentesco` int(11) DEFAULT NULL COMMENT 'Tipo de Relación del difunto con el cliente\nO socio. \nNota: Requerido solo cuando el difunto\nEs un familiar\nsin FK, esto por que cuando es muerte del Socio no se guarda este campo',
  `TramClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente o Socio que realiza el tramite\nDel apoyo funarario\nNota: En caso de que el difunto sea un familiar\nEste campo deberá ser el mismo que ClienteID\nNo poner como llave foranea ya que la \nPersona que realiza el tramite en caso de que\nEl falle',
  `TramPrimerNombre` varchar(200) DEFAULT NULL COMMENT 'Primer Nombre del Tramitador',
  `TramSegundoNombre` varchar(200) DEFAULT NULL COMMENT 'Segundo Nombre del Tramitador',
  `TramTercerNombre` varchar(200) DEFAULT NULL COMMENT 'Tercer Nombre del Tramitador',
  `TramApePaterno` varchar(200) DEFAULT NULL COMMENT 'Apellido Paterno Tramitador',
  `TramApeMaterno` varchar(200) DEFAULT NULL COMMENT 'Apellido Materno Tramitador',
  `TramFechaNacim` date DEFAULT NULL COMMENT 'Fecha de Nacimiento del Tramitador',
  `TramParentesco` int(11) DEFAULT NULL COMMENT 'Tipo de Relación del tramitador con el cliente\nO socio. \nNota: Requerido solo cuando el difunto\nEs el mismo Cliente o Socio',
  `NoCertificadoDefun` varchar(100) DEFAULT NULL COMMENT 'Numero de Certificado de Defunción',
  `FechaCertifDefun` date DEFAULT NULL COMMENT 'Fecha del Certificado de Defunción',
  `UsuarioAutoriza` int(11) DEFAULT NULL COMMENT 'Usuario que Autoriza.\nNota: No poner como llave foranea\nPq al inicio cuando se registra, se graba\nVació',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha de Autorizacion',
  `UsuarioRechaza` int(11) DEFAULT NULL COMMENT 'Usuario que Rechaza.\nNota: No poner como llave foranea\nPq al inicio cuando se registra, se graba\nVació',
  `FechaRechazo` date DEFAULT NULL COMMENT 'Fecha de Rechazo\n',
  `MotivoRechazo` varchar(400) DEFAULT NULL COMMENT 'Motivo de Rechazo',
  `MontoApoyo` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Apoyo Solicitado\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ServiFunFolioID`),
  KEY `INDEX_ClienID` (`ClienteID`) USING HASH,
  KEY `INDEX_DifunPar` (`DifunParentesco`),
  CONSTRAINT `FK_ClientesID_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Solicitudes de Apoyo para Servicios Funerarios'$$