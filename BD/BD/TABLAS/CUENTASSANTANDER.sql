-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASSANTANDER
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASSANTANDER`;
DELIMITER $$

CREATE TABLE `CUENTASSANTANDER` (
	`SolicitudCreditoID`	BIGINT(20) COMMENT 'ID de la tabla',
	`ClienteID`				INT(11) COMMENT 'ID del cliente que le corresponde a la Solicitud de credito',
    `TipoCtaSAFIID`			CHAR(1) COMMENT 'Tipo de Cta.\n  A.-Santander\n O.-Otro',
    `TipoCuenta`			VARCHAR(6) COMMENT 'Descripcion del tipo de Cta. SANTAN.-Santander\n EXTRNA.-Otro',
	`NumeroCta`				VARCHAR(20) COMMENT 'Cuenta Clabe a la cual se hara el abono de la dispersión del credito',
	`Titular`				VARCHAR(200) COMMENT 'Nombre completo del Cliente',
	`ClaveBanco`			VARCHAR(5) COMMENT 'Clave del banco externo al que corresponde la cuenta',
	`PazaBanxico`			INT(11) COMMENT 'Numero de plaza ante banxico',
	`SucursalID`			INT(11) COMMENT 'Numero Sucursal titular',
	`TipoCta`				CHAR(4) COMMENT 'Tipo de cuenta\n 02.- Débito\n 40.- Clabe',
	`BenefAppPaterno`		VARCHAR(50) COMMENT 'Apellido Paterno del Beneficiario',
	`BenefAppMaterno`		VARCHAR(50) COMMENT 'Apellido Materno del Beneficiario',
	`BenefNombre`			VARCHAR(200) COMMENT 'Nombre del Beneficiario',
	`BenefDireccion`		VARCHAR(500) COMMENT 'Direccion del Beneficiario',
	`BenefCiudad`			VARCHAR(100) COMMENT 'Ciudad del Beneficiario',
	`Estatus`				CHAR(3) COMMENT 'Estatus en que se encuentra la Cuenta.\n E.-Enviado\n	A.-Autorizado por el banco\n 	C.-Cancelada por el banco\n J.-Ejecutada por el banco \n N.-En proceso por el banco \n P.-Pendiente por autorizar por el banco\n D.-Pendiente por Activar\n R.-Rechazada',
	`DesEstatus`			VARCHAR(100) COMMENT 'Descripcion del estatus',
    `FechaRegistro`			DATE DEFAULT NULL COMMENT 'Fecha de registro de la solicitud de credito',
    `EmpresaID` 			INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
	`Usuario` 				INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
	`FechaActual` 			DATETIME DEFAULT NULL COMMENT 'AUDITORIA',
	`DireccionIP` 			VARCHAR(15) DEFAULT NULL COMMENT 'AUDITORIA',
	`ProgramaID` 			VARCHAR(50) DEFAULT NULL COMMENT 'AUDITORIA',
	`Sucursal` 				INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
	`NumTransaccion` 		BIGINT(20) DEFAULT NULL COMMENT 'AUDITORIA',
	PRIMARY KEY (`SolicitudCreditoID`,`ClienteID`,`NumeroCta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla que contiene las cuentas generadas de Santander u Otros Bancos'$$
