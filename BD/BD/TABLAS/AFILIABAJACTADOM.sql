DELIMITER ;
DROP TABLE IF EXISTS `AFILIABAJACTADOM`;

DELIMITER ;
CREATE TABLE `AFILIABAJACTADOM`(
	FolioAfiliacion		BIGINT(20) PRIMARY KEY NOT NULL COMMENT 'Folio con el que se indeitifca el lote de cuentas a registrar',
    FechaRegistro		DATE DEFAULT NULL COMMENT 'Fecha en que se realiza el registro de la tabla',
    NombreArchivo		VARCHAR(20) DEFAULT NULL COMMENT 'Nombre con el que se guardo y genero el archivo',
    Consecutivo			INT(11) DEFAULT NULL COMMENT 'Valor consecutivo para los arhivos que se generan en un dia',
    Estatus				CHAR(1) DEFAULT NULL COMMENT 'Estatus en el que se encuentra el lote de afiliacion.\nS = Sin Procesar\nP = Procesado',
    TipoOperacion		CHAR(1) DEFAULT NULL COMMENT 'Tipo de operacion realizada en el archivo Alta o Baja',
    EmpresaID			INT(11) DEFAULT NULL COMMENT 'Parametro Auditoria',
	Usuario				INT(11) DEFAULT NULL COMMENT 'Parametro Auditoria',
	FechaActual			DATETIME DEFAULT NULL COMMENT 'Parametro Auditoria',
	DireccionIP			VARCHAR(15) DEFAULT NULL COMMENT 'Parametro Auditoria',
	ProgramaID			VARCHAR(50) DEFAULT NULL COMMENT 'Parametro Auditoria',
	Sucursal			INT(11)	DEFAULT NULL COMMENT 'Parametro Auditoria',
	NumTransaccion	BIGINT(20) DEFAULT NULL COMMENT 'Parametro Auditoria'
)ENGINE=InnoDB DEFAULT CHARSET=latin1  COMMENT='Tab: Tabla que contendra las afiliaciones y de las bajas de las cuentas clabe';