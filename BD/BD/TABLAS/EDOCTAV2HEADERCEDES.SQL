DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2HEADERCEDES;
DELIMITER $$

CREATE TABLE `EDOCTAV2HEADERCEDES` (
  `AnioMes`          INT(11)        NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
  `SucursalID`       INT(11)        NOT NULL COMMENT 'Numero de surcusal del cliente',
  `ClienteID`        INT(11)        NOT NULL COMMENT 'Numero Identificador del cliente',
  `CuentaAhoID`      BIGINT(12)     NOT NULL COMMENT 'Identificador de la cuenta a la que esta relacionado el Cede',
  `CedeID`           INT(11)        NOT NULL COMMENT 'ID Identificador del cede',
  `Estatus`          CHAR(1)                 COMMENT 'Estatus del Cede N =vigente  P =Pagada  C =Cancelada  A =Registrada',
  `FechaLiquida`     DATE                    COMMENT 'Fecha de Pago o Liquidacion del Cede',
  `TipoCedeID`       INT(11)        NOT NULL COMMENT 'Numero Identficador del Producto de Cede',
  `ProductoDesc`     VARCHAR(200)   NOT NULL COMMENT 'Descripcion del producto del Cede',
  `Capital`          DECIMAL(14,2)  NOT NULL COMMENT 'Monto de Capital del Cede',
  `FechaInicio`      DATE           NOT NULL COMMENT 'Fecha de Inicio del Cede',
  `FechaVencimiento` DATE           NOT NULL COMMENT 'Fecha de Vencimiento del Cede',
  `Plazo`            VARCHAR(15)    NOT NULL COMMENT 'plazo del Cede representado en dias',
  `TasaInteresAnual` DECIMAL(14,4)  NOT NULL COMMENT 'Tasa de rendimiento anual',
  `ISRRetenido`      DECIMAL(14,2)  NOT NULL COMMENT 'ISR retenido',
  `GatNominal`       DECIMAL(5,2)            COMMENT 'Gat nominal',
  `GatReal`          DECIMAL(5,2)            COMMENT 'Gat real',
  `InteresPeriodo`   DECIMAL(14,2)           COMMENT 'Intereses generados en el periodo',
  `MontoComision`    DECIMAL(14,2)           COMMENT 'Total de comisiones de Cede cobradas',
  `IvaComision`      DECIMAL(14,2)           COMMENT 'IVA de la comisiones de Cede Cobradas',
  `FolioProcesoID`   BIGINT(12)     NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
  `EmpresaID`        INT(11)        NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`          INT(11)        NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`      DATETIME       NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`      VARCHAR(15)    NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`       VARCHAR(50)    NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`         INT(11)        NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`   BIGINT(20)     NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioMes`,`CedeID`),
  KEY(ClienteID),
  KEY(FechaInicio),
  KEY(FechaVencimiento),
  KEY(FolioProcesoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de cabecera de las cedes del estado de cuenta'$$
