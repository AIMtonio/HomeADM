-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDHISPERFILTRANS
DELIMITER ;
DROP TABLE IF EXISTS `PLDHISPERFILTRANS`;
DELIMITER $$

CREATE TABLE `PLDHISPERFILTRANS` (
  `TransaccionID`       BIGINT(20) NOT NULL         COMMENT 'Numero de Transaccion',
  `FechaAct`            DATE NOT NULL               COMMENT 'Fecha de Actualización',
  `Hora`                TIME NOT NULL               COMMENT 'Hora del Registro',
  `ClienteID`           INT(11) NOT NULL            COMMENT 'Numero de Cliente ID',
  `UsuarioServicioID`   INT(11) NOT NULL            COMMENT 'Numero de usuario de servicios ID',
  `DepositosMax`        DECIMAL(16,2) DEFAULT NULL  COMMENT 'Monto Máximo de Abonos y Retiros por Operación.',
  `RetirosMax`          DECIMAL(16,2) DEFAULT NULL  COMMENT 'Número Máximo de Transacciones',
  `NumDepositos`        INT(11) DEFAULT NULL        COMMENT 'Número de Depositos Maximos realizados en un periodo de un Mes',
  `NumRetiros`          INT(11) DEFAULT NULL        COMMENT 'Número de Retiros Maximos realizados en un periodo de un Mes',
  `CatOrigenRecID`      INT(11) DEFAULT NULL        COMMENT 'Origen de los Recursos CATPLDDESTINOREC',
  `CatDestinoRecID`     INT(11) DEFAULT NULL        COMMENT 'Destino de los Recursos CATPLDORIGENREC',
  `ComentarioOrigenRec` VARCHAR(600) DEFAULT NULL   COMMENT 'Comentario del Origen de los Recursos',
  `ComentarioDestRec`   VARCHAR(600) DEFAULT NULL   COMMENT 'Comentario del Destino de los Recursos',
  `NumDepoApli`         INT(11) DEFAULT '0'         COMMENT 'Numero de Depositos Aplicados, Incrementa con Cada Deposito a la Cuenta.\nInicia en Cero',
  `NumRetiApli`         INT(11) DEFAULT '0'         COMMENT 'Numero de Retiros Aplicados, Incrementa con Cada Retiro a la Cuenta.\nInicia en Cero',
  `TipoProceso`         CHAR(1) DEFAULT NULL        COMMENT 'Proceos que genero el perfil.\nM:Manual\nA:Automatico',
  `AntDepositosMax`     DECIMAL(16,2) DEFAULT NULL  COMMENT 'Monto Maximo de Depositos Anterior',
  `AntRetirosMax`       DECIMAL(16,2) DEFAULT NULL  COMMENT 'Monto Maximo de Retiros Anterior',
  `AntNumDepositos`     INT(11) DEFAULT NULL        COMMENT 'Numero de depositos anterior',
  `AntNumRetiros`       INT(11) DEFAULT NULL        COMMENT 'Numero de Retiros anterior declarado en el perfil y que esta autorizado',
  `NivelRiesgo`         CHAR(1) DEFAULT NULL        COMMENT 'Nivel de riesgo que tiene el cliente a la fecha que se hace la evaluacion del perfil.',
  `EmpresaID`           INT(11) DEFAULT NULL        COMMENT 'Campo de Auditoria',
  `Usuario`             INT(11) DEFAULT NULL        COMMENT 'Campo de Auditoria',
  `FechaActual`         DATETIME DEFAULT NULL       COMMENT 'Campo de Auditoria',
  `DireccionIP`         VARCHAR(15) DEFAULT NULL    COMMENT 'Campo de Auditoria',
  `ProgramaID`          VARCHAR(50) DEFAULT NULL    COMMENT 'Campo de Auditoria',
  `Sucursal`            INT(11) DEFAULT NULL        COMMENT 'Campo de Auditoria',
  `NumTransaccion`      BIGINT(20) DEFAULT NULL     COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ClienteID`,`UsuarioServicioID`,`TransaccionID`,`FechaAct`,`Hora`),
  KEY `IDX_PLDHISPERFILTRANS_1` (`ClienteID`,`FechaAct`),
  KEY `IDX_PLDHISPERFILTRANS_2` (`FechaAct`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena el historico del perfil transaccional'$$