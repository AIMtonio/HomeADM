-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWINVCASTIGO
DELIMITER ;
DROP TABLE IF EXISTS `CRWINVCASTIGO`;
DELIMITER $$

CREATE TABLE `CRWINVCASTIGO` (
    `FondeoID`              BIGINT(20)              NOT NULL COMMENT 'ID de la inversion',
    `CreditoID`             BIGINT(12)                 NOT NULL COMMENT 'Numero de Credito',
    `ClienteID`             INT(11)                 NOT NULL COMMENT 'Numero de cliente',
    `Fecha`                 DATE                    NOT NULL COMMENT 'Fecha del Castigo Definitivo',
    `CapitalCastigado`      DECIMAL(14,2)           NOT NULL COMMENT 'Capital Castigado',
    `InteresCastigado`      DECIMAL(14,2)           NOT NULL COMMENT 'Interes Castigado',
    `IntMoraCastigado`      DECIMAL(14,2)           NOT NULL COMMENT 'Interes Moratorio Castigado',
    `CapCtaOrden`           DECIMAL(14,2)           NOT NULL COMMENT 'Capital en cuenta de orden castigado',
    `IntCtaOrden`           DECIMAL(14,2)           NOT NULL COMMENT 'Interes en cuenta de Orden Castigado',
    `TotalCastigo`          DECIMAL(14,2)           NOT NULL COMMENT 'Monto Total Castigado',
    `MonRecuperado`         DECIMAL(14,2)           NOT NULL COMMENT 'Monto Total Castigado Recuperado',
    `SaldoCapital`          DECIMAL(12,2)           NOT NULL COMMENT 'Saldo del Capital Castigado',
    `SaldoInteres`          DECIMAL(12,2)           NOT NULL COMMENT 'Saldo del Interes Castigado',
    `SaldoMoratorio`        DECIMAL(12,2)           NOT NULL COMMENT 'Saldo del Moratorios Castigado',
    `SaldoIntCtaOrden`      DECIMAL(14,2)           NOT NULL COMMENT 'Saldo que se encuentra en cuentas de orden por la apliacion de garantias',
    `SaldoCapCtaOrden`      DECIMAL(14,2)           NOT NULL COMMENT 'Saldo en cuentas de orden por aplicacion de Garantias',
    `NumRetirosMes`         INT(11)                 NOT NULL COMMENT 'Numero de Retiros en el mes',
    `CuentaAhoID`           BIGINT(12)                 NOT NULL COMMENT 'Cuenta de Ahorro del Inversionista',
    `EmpresaID`             INT(11)                 NOT NULL COMMENT 'Campo de Auditoria',
    `Usuario`               INT(11)                 NOT NULL COMMENT 'Campo de Auditoria',
    `FechaActual`           DATETIME                NOT NULL COMMENT 'Campo de Auditoria',
    `DireccionIP`           VARCHAR(15)             NOT NULL COMMENT 'Campo de Auditoria',
    `ProgramaID`            VARCHAR(50)             NOT NULL COMMENT 'Campo de Auditoria',
    `Sucursal`              INT(11)                 NOT NULL COMMENT 'Campo de Auditoria',
    `NumTransaccion`        BIGINT(20)              NOT NULL COMMENT 'Campo de Auditoria',
    PRIMARY KEY (`FondeoID`),
    KEY `INDEX_TMPCREDATRASADOS_1` (`CreditoID`),
    KEY `INDEX_TMPCREDATRASADOS_2` (`CreditoID`,`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Almacena la informacion los saldos de inversion al momento'$$