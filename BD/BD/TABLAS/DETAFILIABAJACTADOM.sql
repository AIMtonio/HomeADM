DELIMITER ;
DROP TABLE IF EXISTS `DETAFILIABAJACTADOM`;

DELIMITER ;
CREATE TABLE `DETAFILIABAJACTADOM`(
	FolioAfiliacion		BIGINT(20) NOT NULL COMMENT 'Folio de afiliacion con le que se liga este detalle',
    Referencia			VARCHAR(50) DEFAULT NULL COMMENT 'Referencia del cliente',
    ClienteID			INT(11) DEFAULT NULL COMMENT 'Identificador de cliente que se afilia-baja',
    NombreCompleto		VARCHAR(150) DEFAULT NULL COMMENT 'Nombre del cliente',
    EsNomina			CHAR(1) DEFAULT NULL COMMENT 'Indica si el cliente es de nomina',
    InstitNominaID		INT(11) DEFAULT NULL COMMENT 'Identificador del la institucion de nomina',
    NombreEmpNomina		VARCHAR(150) DEFAULT NULL COMMENT 'Nombre de la empresa de nomina',
    InstitBancaria		INT(11) DEFAULT NULL COMMENT 'Identificador de la institucion bancaria',
    NombreBanco			VARCHAR(150) DEFAULT NULL COMMENT 'Nombre de la institucion bancaria',
    Clabe				VARCHAR(20) DEFAULT NULL COMMENT 'Clabe con la que se afiliara en la institucion bancaria para cobro de domiciliacion',
    Convenio			VARCHAR(50) DEFAULT NULL COMMENT 'Convenio en el cual se dio de alta el credito',
    Comentario			VARCHAR(150) DEFAULT NULL COMMENT 'Comentario a el cliente',
    EstatusDomicilia	CHAR(1)	DEFAULT NULL COMMENT 'Estatus de la domiciliacion\nNo Afiliada=N\nAfiliada=A\nBaja=B',
    EmpresaID			INT(11) DEFAULT NULL COMMENT 'Parametro Auditoria',
	Usuario				INT(11) DEFAULT NULL COMMENT 'Parametro Auditoria',
	FechaActual			DATETIME DEFAULT NULL COMMENT 'Parametro Auditoria',
	DireccionIP			VARCHAR(15) DEFAULT NULL COMMENT 'Parametro Auditoria',
	ProgramaID			VARCHAR(50) DEFAULT NULL COMMENT 'Parametro Auditoria',
	Sucursal			INT(11)	DEFAULT NULL COMMENT 'Parametro Auditoria',
	NumTransaccion	BIGINT(20) DEFAULT NULL COMMENT 'Parametro Auditoria',
    FOREIGN KEY (FolioAfiliacion) REFERENCES `AFILIABAJACTADOM`(FolioAfiliacion) ON UPDATE NO ACTION ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1  COMMENT='Tab: Tabla que contendra el detalle de las afiliaciones y de las bajas de las cuentas clabe';