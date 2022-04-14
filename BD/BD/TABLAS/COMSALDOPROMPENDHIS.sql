-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMPENDHIS
DELIMITER ;
DROP TABLE IF EXISTS `COMSALDOPROMPENDHIS`;

DELIMITER $$
CREATE TABLE COMSALDOPROMPENDHIS(
    `ComisionID`			INT(11) NOT NULL COMMENT 'ID Comision de la tabla',
    `FechaCorte`			DATE NOT NULL COMMENT 'Fecha del cierre de mes donde se genero la comision',
    `CuentaAhoID`			BIGINT(12) NOT NULL	COMMENT 'Cuenta de Ahorro',
    `ComSaldoPromOri`		DECIMAL(14,2) NOT NULL 	COMMENT 'Monto de comision original que quedo pendiente en el cierre de mes',
    `IVAComSalPromOri`	    DECIMAL(14,2) NOT NULL	COMMENT 'IVA del monto de comision original',
    `ComSaldoPromAct`		DECIMAL(14,2) NOT NULL	COMMENT 'Monto de comision que aun no ha sido cubierta pendiente de pago',
    `IVAComSalPromAct`	    DECIMAL(14,2) NOT NULL 	COMMENT 'IVA del monto que aun no ha sido cubierta pendiente de pago',
	`ComSaldoPromCob`		DECIMAL(14,2) NOT NULL	COMMENT 'Monto de Comision que se ha cobrado a la cuenta',
    `IVAComSalPromCob`	    DECIMAL(14,2) NOT NULL	COMMENT 'Monto Acumulado del IVA que se ha cobrado de comision',
    `ComSaldoPromCond`	    DECIMAL(14,2) NOT NULL	COMMENT 'Monto de la condonacion',
    `IVAComSalPromCond`	    DECIMAL(14,2) NOT NULL	COMMENT 'IVA del monto de condonacion',
    `Estatus`				CHAR(1) NOT NULL		COMMENT 'Estatus de la Comision V - Vigente, P - Pagado en su totalidad, C - Condonado',
    `OrigenComision`		CHAR(1)	NOT NULL		COMMENT 'Origne de la Comision C - Cierre de mes, R - Reversa de cobro',
    `FechaHistorico`		DATE NOT NULL COMMENT 'Fecha en que paso a historico',
    `EmpresaID`             INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `Usuario`               INT(11) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `FechaActual`           DATETIME DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `DireccionIP`           VARCHAR(15) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `ProgramaID`            VARCHAR(50) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `Sucursal`              INT(11) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `NumTransaccion`        BIGINT(20) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    PRIMARY KEY (`ComisionID`),
    KEY `INDEX_COMSALDOPROMPENDHIS_1` (`CuentaAhoID`,`FechaHistorico`),
    KEY `INDEX_COMSALDOPROMPENDHIS_2` (`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1  COMMENT='hIS: Tabla Historica de Comisiones Pendientes por Cobrar de Saldo Promedio'$$