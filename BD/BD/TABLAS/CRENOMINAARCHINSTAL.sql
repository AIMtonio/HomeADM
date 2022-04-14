DELIMITER ;
DROP TABLE IF EXISTS `CRENOMINAARCHINSTAL`;

DELIMITER $$
CREATE TABLE `CRENOMINAARCHINSTAL` (

    `FolioID`       INT(11)     NOT NULL    COMMENT 'Folio del archivo de instalación',
    `Descripcion`   VARCHAR(100) NOT NULL   COMMENT 'Descripción de folio',
    `InstitucionID` INT(11)     NOT NULL    COMMENT 'Id del Banco (Institucion)',
    `ConvenioID`    INT(11)     NOT NULL    COMMENT 'Id del Convenio',
    `Estatus`       CHAR(1)     NOT NULL    COMMENT 'Estatus del folio de archivo de instalacion. E - Enviado. P- Procesado.',

    `EmpresaID`     INT(11)     NOT NULL    COMMENT 'Parametros de Auditoria',
	`Usuario`		INT(11)     NOT NULL    COMMENT 'Parametros de Auditoria',
	`FechaActual`	DATETIME    NOT NULL    COMMENT 'Parametros de Auditoria',
	`DireccionIP`	VARCHAR(15) NOT NULL    COMMENT 'Parametros de Auditoria',
	`ProgramaID`	VARCHAR(50) NOT NULL    COMMENT 'Parametros de Auditoria',
	`Sucursal`      INT(11)     NOT NULL    COMMENT 'Parametros de Auditoria',
	`NumTransaccion`BIGINT(20)  NOT NULL    COMMENT 'Parametros de Auditoria',
    PRIMARY KEY (`folioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Arhivo de Instalacion de Creditos de Nomina' $$