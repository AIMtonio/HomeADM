-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBEXTRACCIONDET
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBEXTRACCIONDET`;
DELIMITER $$


CREATE TABLE `TARDEBEXTRACCIONDET` (
    `TarDebExtraccionDetID`     BIGINT(12)      NOT NULL AUTO_INCREMENT COMMENT 'ID de la tabla.',
    `TarDebExtraccionID`        INT(11)         NOT NULL 				COMMENT 'ID de la tabla de Extraccion de archivo.',
    `Bin`                       VARCHAR(8)      NOT NULL 				COMMENT 'Nombre del archivo por extraer.',
    `SubBin`                    VARCHAR(2)      NOT NULL 				COMMENT 'Nombre del archivo por extraer.',
    `NomArchivoExt`             VARCHAR(70)     NOT NULL 				COMMENT 'Nombre del archivo extraido por Bin y SubBin',
  
    `EmpresaID`                 INT(11)         NOT NULL 				COMMENT 'Parametro de Auditoria.',
    `Usuario`                   INT(11)         NOT NULL 				COMMENT 'Parametro de Auditoria.',
    `FechaActual`               DATETIME        NOT NULL 				COMMENT 'Parametro de Auditoria.',
    `DireccionIP`               VARCHAR(15)     NOT NULL 				COMMENT 'Parametro de Auditoria.',
    `ProgramaID`                VARCHAR(50)     NOT NULL 				COMMENT 'Parametro de Auditoria.',
    `Sucursal`                  INT(11)         NOT NULL 				COMMENT 'Parametro de Auditoria.',
    `NumTransaccion`            BIGINT(20)      NOT NULL 				COMMENT 'Parametro de Auditoria.',
    PRIMARY KEY (`TarDebExtraccionDetID`),
    KEY `IDX_TARDEBEXTRACCIONDET_01` (`Bin`),
    KEY `IDX_TARDEBEXTRACCIONDET_02` (`SubBin`),
    KEY `IDX_TARDEBEXTRACCIONDET_03` (`NomArchivoExt`),
    KEY `IDX_TARDEBEXTRACCIONDET_04` (`NumTransaccion`),
    KEY `IDX_TARDEBEXTRACCIONDET_05` (`TarDebExtraccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la informacion de los archivos resultantes de transacciones de tarjetas.'$$
