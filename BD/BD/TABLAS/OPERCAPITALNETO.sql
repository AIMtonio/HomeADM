-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERCAPITALNETO
DELIMITER ;
DROP TABLE IF EXISTS `OPERCAPITALNETO`;
DELIMITER $$


CREATE TABLE `OPERCAPITALNETO` (
  OperacionID int(11) NOT NULL COMMENT "FOLIO DE LA OPERACION",
  InstrumentoID BIGINT(12) NOT NULL COMMENT "NUMERO DEL INSTRUMENTO",
  ClienteID  int(11) DEFAULT NULL COMMENT "CLINETE ID",
  FechaOperacion date DEFAULT '1900-01-01' COMMENT "FECHA DE LA OPERACION",
  ProductoID int(11) DEFAULT NULL COMMENT "PRODUCTO ID",
  SucursalCliID int(11) DEFAULT NULL COMMENT "SUCURSAL DEL CLIENTE",
  CapitalNeto decimal(18,2) DEFAULT NULL COMMENT "CAPITAL NETO",
  Porcentaje varchar(10) DEFAULT NULL COMMENT "PORCENTAJE",
  MontoOper decimal(18,2) DEFAULT NULL COMMENT "MONTO DE LA OPERAACION",
  EstatusOper char(1) DEFAULT 'R' COMMENT "ESTAUS DE LA OPERACION\n I.-SIN PROCESAR, R.-RECHAZADA, A.-AUTORIZADA",
  Comentario varchar(1000) DEFAULT '' COMMENT "MOTIVO DE AUTORIZACION O RECHAZO",
  OrigenOperacion char(1) DEFAULT '' COMMENT "Origen V.-Ventanilla\n I.-Inversiones\n C.-CEDES\n S.-Solicitud Credito",
  PantallaOrigen varchar(3) DEFAULT '' COMMENT "PANTALLA DE LA OPERACION\n AS.-Autorizacion Solicitud Cred.\n AI.-Autorizacion Inversion\n AC.-Autorizacion CEDE\n AC.-ABONO A CUENTA",
  Mensaje varchar(1000) DEFAULT '' COMMENT "MENSAJE DE VALIDACION",
  UsuarioAut int(11) DEFAULT NULL COMMENT "USUARIO QUE AUTORISA",
  FechaAut date DEFAULT '1900-01-01' COMMENT "FECHA DE AUTORIZACION",

  EmpresaID int(11) DEFAULT NULL COMMENT "AUDITORIA",
  Usuario int(11) DEFAULT NULL COMMENT "AUDITORIA",
  FechaActual datetime DEFAULT NULL COMMENT "AUDITORIA",
  DireccionIP varchar(20) DEFAULT NULL COMMENT "AUDITORIA",
  ProgramaID varchar(50) DEFAULT NULL COMMENT "AUDITORIA",
  Sucursal int(11) DEFAULT NULL COMMENT "AUDITORIA",
  NumTransaccion varchar(45) DEFAULT NULL COMMENT "AUDITORIA",
  PRIMARY KEY (`OperacionID`, `InstrumentoID`),
  KEY `fk_OPERCAPITALNETO_1` (`ClienteID`),
  KEY `fk_OPERCAPITALNETO_2` (`ProductoID`),
  KEY `fk_OPERCAPITALNETO_3` (`EstatusOper`),
  KEY `fk_OPERCAPITALNETO_4` (`SucursalCliID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: TABLA QUE CONTIENE LAS OPERACIONES QUE SUPERAN EL CAPITAL NETO.'$$
