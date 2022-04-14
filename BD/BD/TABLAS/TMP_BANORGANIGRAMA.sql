-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_BANORGANIGRAMA
DELIMITER ;

DROP TABLE IF EXISTS `TMP_BANORGANIGRAMA`;

DELIMITER $$


CREATE TABLE `TMP_BANORGANIGRAMA` (
	ID 						BIGINT(20) NOT NULL AUTO_INCREMENT,		-- Identificador de la tabla
	PuestoPadreID			BIGINT(20),								-- Puesto padre del Organigrama
    NomCompletoPadre		VARCHAR(200),							-- Nombre completo del empleado con puesto padre
    ClaveUsuarioPadre		VARCHAR(45),							-- Clave del empleado con puesto padre
    PadreEsGestor			CHAR(1),								-- Indica si puesto padre es gestor
    PadreEsSupervisor		CHAR(1),								-- Indica si puesto padre es supervisor
    PuestoHijoID			BIGINT(20),								-- Puesto hijo del Organigrama
    NomCompletoHijo			VARCHAR(200),							-- Nombre completo del empleado con puesto hijo
    ClaveUsuarioHijo		VARCHAR(45),							-- Clave del empleado con puesto hijo
    HijoEsGestor			CHAR(1),								-- Indica si puesto hijo es gestor
    HijoEsSupervisor		CHAR(1),								-- Indica si puesto hijo es supervisor
    RequiereCtaCon			CHAR(1),								-- Indica si requiere cuenta contable
    CtaContable				VARCHAR(50),							-- Cuenta contable
    CentroCostoID			INT(11),								-- Centro de Costo
    ClavePuestoPadre		VARCHAR(10),							-- Clave del puesto padre
    ClavePuestoHijo			VARCHAR(10),							-- Clave del puesto hijo
    NumTransaccion			BIGINT(20),								-- Numero de Transaccion

    INDEX(PuestoPadreID),
    INDEX(PuestoPadreID, NumTransaccion),
    INDEX(ClavePuestoPadre),
    INDEX(ClavePuestoPadre, NumTransaccion),
    INDEX(PuestoHijoID),
    INDEX(PuestoHijoID, NumTransaccion),
    INDEX(ClavePuestoHijo),
    INDEX(ClavePuestoHijo, NumTransaccion),
	INDEX(NumTransaccion),
	PRIMARY KEY (ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla temporal fisica para guardar la informacion de los Organigramas para Servicios REST.'$$
