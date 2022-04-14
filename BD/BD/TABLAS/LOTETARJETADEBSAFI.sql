
-- LOTETARJETADEBSAFI
DELIMITER ;
DROP TABLE IF EXISTS `LOTETARJETADEBSAFI`;
DELIMITER $$

CREATE TABLE `LOTETARJETADEBSAFI` (
  `LoteDebSAFIID`     INT(11)       NOT NULL COMMENT 'ID Lote. Es un consecutivo que se mantiene en FOLIOSAPLIC',
  `TipoTarjetaDebID`  INT(11)       NOT NULL COMMENT 'ID del Tipo de Tarjeta de Debito tabla TIPOTARJETADEB',
  `FechaRegistro`     DATE          NOT NULL COMMENT 'Fecha de Registro del Lote',
  `SucursalSolicita`  CHAR(4)       NOT NULL COMMENT 'Sucursal solicitante',
  `UsuarioID`         INT(11)       NOT NULL COMMENT 'Usuario que Genero el Lote tabla USUARIOS',
  `NumTarjetas`       INT(11)       NOT NULL COMMENT 'Numero de Tarjetas Generadas con este Folio',
  `Estatus`           INT(11)       NOT NULL COMMENT 'Estatus en la que se encuentra la tarjeta',
  `EsAdicional`       VARCHAR(5)    NOT NULL COMMENT 'Indica si la tarjeta es adicional',
  `EsPersonalizado`   CHAR(1)       NOT NULL COMMENT 'Indica que las tarjeta personalizado o no S-Si, N-No',
  `EsVirtual`         CHAR(1)       NOT NULL COMMENT 'Especifica si el lote de tarjetas son virtuales S-Si, N-No',
  `RutaNomArch`       VARCHAR(300)  NOT NULL COMMENT 'Nombre y ruta del archivo en la que se genero el lote',
  `FolioInicial`      INT(11)       NOT NULL COMMENT 'Folio Inicial',
  `FolioFinal`        INT(11)       NOT NULL COMMENT 'Folio Final',
  `BitCargaSAFIID`    INT(11)       NOT NULL COMMENT 'ID de la Bitacora de Carga. tabla BITACORALOTEDEBSAFI',
  `ServiceCode`       CHAR(3)       NOT NULL COMMENT 'Service Code obtenidos de la tabla cátalogo CATSERVICECOD',
  `EmpresaID`         INT(11)       NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario`           INT(11)       NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual`       DATETIME      NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP`       VARCHAR(15)   NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID`        VARCHAR(50)   NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal`          INT(11)       NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion`    BIGINT(20)    NOT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`LoteDebSAFIID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Lotes Generados de las Tarjetas de Debito por SAFI'$$