-- CARTAAUTORIZACIONLIS

DELIMITER ;
DROP PROCEDURE IF EXISTS `CARTAAUTORIZACIONLIS`;

DELIMITER $$
CREATE PROCEDURE `CARTAAUTORIZACIONLIS`(
    -- SP datos de las cuentas de los beneficiarios a mostrar en carta de autorización.
    Par_SpeiRemesasID       JSON,                   -- Números del movimiento Ref. SPEIREMESAS.

    Aud_EmpresaID         	INT(11),				-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario         	INT(11),				-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual     	DATETIME,				-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP     	VARCHAR(15),			-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID      	VARCHAR(50),			-- Parámetro de auditoría programa.
	Aud_Sucursal        	INT(11),				-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion  	BIGINT(20)				-- Parámetro de auditoría numero de transaccion.
)

TerminaStore: BEGIN

    -- Declaración de variables.
    DECLARE Var_Indice          INT(11);            -- Variable indice para recorrer los números de movimientos.
    DECLARE Var_CantidadSpei    INT(11);            -- Variable para la cantidad de números de movimientos.
    DECLARE Var_SpeiRemsaID     BIGINT(20);         -- Variable para el número de movimiento Ref. SPEIREMESAS.
    DECLARE Var_FechaHora       DATETIME;           -- Variable para la fecha del sistema y hora actual.
    DECLARE Var_SumaTotalCargo  DECIMAL(18, 2);     -- Variable para la suma del monto total de cargo a cuenta.

    -- Declaración de constantes.
    DECLARE Entero_Cero     INT(11);        -- Número cero (0).
    DECLARE Decimal_Cero    DECIMAL(12,2);   -- Numéro decimal cero (0.00).

    -- Asignación de constantes.
    SET Entero_Cero     := 0;
    SET Decimal_Cero    := 0.00;

    DROP TEMPORARY TABLE IF EXISTS `TMPSPEIREMESAS`;

	CREATE TEMPORARY TABLE `TMPSPEIREMESAS` (
        `SpeiRemID` BIGINT(20) NOT NULL COMMENT 'Numero del movimiento.',
	    `CuentaClabe` VARCHAR(20) NOT NULL DEFAULT '' COMMENT 'Cuenta del Beneficiario.',
	    `Banco` VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'Institucion receptora.',
        `Sucursal` VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'Sucursal o Plaza.',
        `FechaHora` VARCHAR(30) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'Fecha del sistema y hora actual.',
        `MontoTransferir` DECIMAL(16,2) NOT NULL DEFAULT 0.00 COMMENT 'Monto de la transferencia.',
        `IVAPorPagar` DECIMAL(16,2) NOT NULL DEFAULT 0.00 COMMENT 'IVA por pagar.',
        `ComisionTrans` DECIMAL(16,2) NOT NULL DEFAULT 0.00 COMMENT 'Comision por la transferencia.',
        `ConceptoPago` VARCHAR(100) NOT NULL DEFAULT '' COMMENT 'Concepto de Pago/Cargo',
        `TotalCargoCuenta` DECIMAL(18,2) NOT NULL DEFAULT 0.00 COMMENT 'Monto total de cargo a cuenta',
	    PRIMARY KEY (`SpeiRemID`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    SET Var_FechaHora := (SELECT CONCAT(FechaSistema,' ', CURTIME()) FROM PARAMETROSSIS LIMIT 1);

    SET Var_Indice := Entero_Cero;
	SET Var_CantidadSpei := JSON_LENGTH(Par_SpeiRemesasID);

	WHILE (Var_Indice < Var_CantidadSpei) DO

		SET Var_SpeiRemsaID := JSON_EXTRACT(Par_SpeiRemesasID, CONCAT('$[', Var_Indice, '].SpeiRemesaID'));
        SET Var_SpeiRemsaID := (SELECT SpeiRemID FROM SPEIREMESAS WHERE SpeiRemID = Var_SpeiRemsaID);

        IF (IFNULL(Var_SpeiRemsaID, Entero_Cero) > Entero_Cero) THEN

            INSERT INTO TMPSPEIREMESAS (
                SpeiRemID,          CuentaClabe,                                        Banco,
                Sucursal,           FechaHora,                                          MontoTransferir,
                IVAPorPagar,        ComisionTrans,                                      ConceptoPago,
                TotalCargoCuenta
            ) SELECT
                SR.SpeiRemID,       LEFT(FNDECRYPTSAFI(SR.CuentaBeneficiario),20),      INS.Descripcion,
                SC.NombreSucurs,    Var_FechaHora,                                      CONVERT(FNDECRYPTSAFI(SR.MontoTransferir), DECIMAL(16,2)),
                SR.IVAPorPagar,     SR.ComisionTrans,                                   LEFT(FNDECRYPTSAFI(SR.ConceptoPago),40),
                CONVERT(FNDECRYPTSAFI(SR.TotalCargoCuenta), DECIMAL(18,2))
            FROM SPEIREMESAS SR
            INNER JOIN INSTITUCIONESSPEI INS ON INS.InstitucionID = SR.InstiReceptoraID
            LEFT JOIN SUCURSALES SC ON SC.SucursalID = SR.SucursalOpera
            WHERE SR.SpeiRemID = Var_SpeiRemsaID;
        END IF;

        SET Var_Indice := Var_Indice + 1;

    END WHILE;

    SET Var_SumaTotalCargo := (SELECT SUM(TotalCargoCuenta) FROM TMPSPEIREMESAS);
    SET Var_SumaTotalCargo := IFNULL(Var_SumaTotalCargo, Decimal_Cero);

    SELECT
        CuentaClabe,    Banco,          Sucursal,       FechaHora,          MontoTransferir,
        IVAPorPagar,    ComisionTrans,  ConceptoPago,   TotalCargoCuenta,   FORMAT(Var_SumaTotalCargo, 2) AS SumaTotalLet
    FROM TMPSPEIREMESAS;

    DROP TEMPORARY TABLE IF EXISTS `TMPSPEIREMESAS`;

END TerminaStore$$