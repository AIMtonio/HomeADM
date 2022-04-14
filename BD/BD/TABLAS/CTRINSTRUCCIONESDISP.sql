-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTRINSTRUCCIONESDISP
DELIMITER ;
DROP TABLE IF EXISTS `CTRINSTRUCCIONESDISP`;
DELIMITER $$

CREATE TABLE `CTRINSTRUCCIONESDISP` (
  -- Referencia de la dispersion
  `ControlDispID`         INT(11)     NOT NULL                  COMMENT 'ID de Control de la Tabla',
  `BenefiDisperID`        INT(11)     NOT NULL                  COMMENT 'Vinculo con las instrucciones de dispersion del credito',
  `CreditoID`             BIGINT(12)  NOT NULL                  COMMENT 'Numero de Credito',
  `FolioOperacion`        INT(11)     DEFAULT NULL              COMMENT 'ID o referencia de la operación de la dispersion',
  `ClaveDispMov`          INT (11)    NOT NULL DEFAULT '0'      COMMENT 'Consecutivo de la tabla de movimientos',
  `TipoDispersionID`      CHAR(1)     NULL                      COMMENT 'Tipo de Dispersion: S .- SPEI, C .- Cheque O .- Orden de Pago  E.- Efectivo, T.- TRAN. SANTANDER',
  `TipoCuentaDisper`      INT(11)     NULL  DEFAULT 1           COMMENT 'Tipo Cuenta Dispersion 1.- Instruccion Nueva , 2.- Instruc. de Carta Liq. Externas, 3.- Instruc. de Carta Liq. Interna',
  -- Referencia del credito

  -- Control de la dispersion
  `MontoDispersion`       DECIMAL(14,2) NOT NULL DEFAULT '0.0'  COMMENT 'Monto de la isntruccion a dispersar',
  `FechaDispersion`       DATETIME      DEFAULT NULL            COMMENT 'Fecha en cual se realiza la operación de la dispersión',
  `EstatusDispersion`     CHAR(1)       DEFAULT NULL            COMMENT 'Estatus con respecto a la Dispersion .\nD: Dispersada \n N: No Dispersada',
  `FechaImportacion`      DATETIME      DEFAULT NULL            COMMENT 'Fecha en cual se realiza la operación de la dispersión',
  `EstatusImportacion`    CHAR(1)       DEFAULT NULL            COMMENT 'Estatus con respecto a la Importacion de Dispersion .\nS: si Importada \n N: No Importada',

  -- Auditoria
  `EmpresaID`             INT(11)     DEFAULT NULL              COMMENT 'Campo de Auditoria',
  `Usuario`               INT(11)     DEFAULT NULL              COMMENT 'Campo de Auditoria',
  `FechaActual`           DATETIME    DEFAULT NULL              COMMENT 'Campo de Auditoria',
  `DireccionIP`           VARCHAR(15) DEFAULT NULL              COMMENT 'Campo de Auditoria',
  `ProgramaID`            VARCHAR(50) DEFAULT NULL              COMMENT 'Campo de Auditoria',
  `Sucursal`              INT(11)     DEFAULT NULL              COMMENT 'Campo de Auditoria',
  `NumTransaccion`        BIGINT(20)  DEFAULT NULL              COMMENT 'Campo de Auditoria',

  PRIMARY KEY (`ControlDispID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Control de las instrucciones de Dispersion que se han Importado en el Proceso de Dispersion.'$$
