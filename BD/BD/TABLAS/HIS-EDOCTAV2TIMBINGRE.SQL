DELIMITER ;
DROP TABLE IF EXISTS `HIS-EDOCTAV2TIMBINGRE`;
DELIMITER $$


CREATE TABLE `HIS-EDOCTAV2TIMBINGRE` (
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	SucursalID	 			INT(11) 		NOT NULL COMMENT 'Numero de surcusal del cliente',
	CadenaCFDI				VARCHAR(10000)	NOT NULL COMMENT 'Cadena para el archivo de timbrado CFDI para ingresos',
	CFDIFechaEmision		DATE			NOT NULL COMMENT 'Fecha de Emision del CFDI para Ingresos',
	CFDIVersion				VARCHAR(10)		NOT NULL COMMENT 'Tag Version del CFDI',
	CFDINoCertSat			VARCHAR(45)		NOT NULL COMMENT 'Numero de Certificado del SAT para Ingresos',
	CFDIUUID				VARCHAR(50)		NOT NULL COMMENT 'UUID del CFDI para Ingresos',
	CFDIFechaTimbrado		DATE			NOT NULL COMMENT 'Fecha de Timbrado para Ingresos',
	CFDISelloCFD			VARCHAR(1000)	NOT NULL COMMENT 'Sello CFD del CFDI para Ingresos',
	CFDISelloSAT			VARCHAR(1000)	NOT NULL COMMENT 'Sello del SAT para Ingresos',
	CFDICadenaOrig			VARCHAR(2000)	NOT NULL COMMENT 'Cadena Original para Ingresos',
	DiasPeriodo				VARCHAR(45)		NOT NULL COMMENT 'Dias del Periodo',
	CFDIFechaCertifica		VARCHAR(45)		NOT NULL COMMENT 'Fecha Certificacion para Ingresos',
	CFDINoCertEmision		VARCHAR(80)		NOT NULL COMMENT 'Numero Certificacion Emisor para Ingresos',
	CFDILugExpedicion		VARCHAR(50)		NOT NULL COMMENT 'Lugar Expedicion para Ingresos',
	EstatusTimbrado			INT(11)			NOT NULL COMMENT 'Estatus Timbrado Ingresos:\n1 = No Procesada\n2 = Procesada\n3 = Error al Procesar',
	FolioProceso			BIGINT(12)		NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
	EmpresaID 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria',
PRIMARY KEY(AnioMes,ClienteID,SucursalID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Datos de timbrado ingreso'$$
