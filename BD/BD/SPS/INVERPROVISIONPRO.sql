-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERPROVISIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERPROVISIONPRO`;DELIMITER $$

CREATE PROCEDURE `INVERPROVISIONPRO`(
	Par_Fecha			DATE,
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_InversionID     	BIGINT;
DECLARE Var_Monto           	DECIMAL(12,2);
DECLARE Var_TasaNeta        	DECIMAL(8,4);
DECLARE Var_Tasa            	DECIMAL(8,4);
DECLARE Var_FechaInicio         DATE;
DECLARE Var_FechaVencimiento    DATE;
DECLARE Var_MonedaID        	INT;
DECLARE Var_MonedaBase      	INT;
DECLARE Var_TipoCambio      	DECIMAL(14,6);
DECLARE Var_Empresa         	INT;
DECLARE Var_SaldoProvision		DECIMAL(12,2);
DECLARE Var_InteresGenerado		DECIMAL(12,2);
DECLARE Var_TasaISR				DECIMAL(8,4);
DECLARE Var_DiasBase        	INT;
DECLARE Var_Provision       	DECIMAL(12,2);
DECLARE Var_Instrumento     	VARCHAR(20);
DECLARE Var_Poliza          	BIGINT;
DECLARE Var_ProvMN          	DECIMAL(12,2);
DECLARE Fec_Provision       	DATE;
DECLARE Var_SigFecha			DATE;
DECLARE Con_Egreso          	INT;
DECLARE Var_EsHabil         	CHAR(1);
DECLARE Error_Key           	INT DEFAULT 0;
DECLARE Var_InverStr        	VARCHAR(15);
DECLARE Var_ContadorInv     	INT;
DECLARE Var_SucCliente      	INT;
DECLARE Var_ClienteID			INT;


/* Declaracion de Constantes */
DECLARE Estatus_Vigente CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Tipo_Provision  CHAR(4);
DECLARE Entero_Cero     INT;
DECLARE Flotante_Cero   DECIMAL(12,2);
DECLARE Flotante_Cien   DECIMAL(12,2);
DECLARE Entero_Cien     INT;
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Tip_Venta       CHAR(1);
DECLARE Ref_Provision   VARCHAR(50);
DECLARE Ope_Interna     CHAR(1);
DECLARE Pol_Automatica  CHAR(1);
DECLARE Par_SalidaNO    CHAR(1);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE Mov_AhorroNO    CHAR(1);
DECLARE Con_ProInv      INT;
DECLARE Pro_Interes     INT;
DECLARE Con_EgresoGra   INT;
DECLARE Con_EgresoExe   INT;
DECLARE DiasInteres     DECIMAL(10,2);
DECLARE Var_Descripcion VARCHAR(50);
DECLARE Var_Referencia  VARCHAR(50);
DECLARE Pro_CieDiaInv   INT;


DECLARE CURSORINVER CURSOR FOR
	(SELECT	Inv.InversionID,		Inv.Monto,				Inv.TasaNeta,	Inv.Tasa,
			Inv.FechaInicio,		Inv.FechaVencimiento,	Inv.MonedaID,	Inv.SaldoProvision,
			Inv.InteresGenerado,	Inv.TasaISR,			Inv.EmpresaID,	Cli.SucursalOrigen,
			Cli.ClienteID
		FROM INVERSIONES Inv,
			 CLIENTES Cli
		WHERE Inv.Estatus		= 'N'
		  AND Inv.FechaInicio	<= Par_Fecha
		  AND Inv.FechaVencimiento	> Par_Fecha
		  AND Inv.ClienteID = Cli.ClienteID);

/* Asignacin de Constantes */
SET Estatus_Vigente := 'N';
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Tipo_Provision  := '100';
SET Entero_Cero     := 0;
SET Flotante_Cero   := 0.00;
SET Flotante_Cien   := 100.00;
SET Entero_Cien   	:= 100;
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Tip_Venta       := 'V';
SET Ope_Interna     := 'I';
SET Pol_Automatica  := 'A';
SET Par_SalidaNO    := 'N';
SET AltaPoliza_NO   := 'N';
SET Mov_AhorroNO    := 'N';
SET Con_ProInv      := 13;
SET Pro_Interes     := 5;
SET Con_EgresoGra   := 2;
SET Con_EgresoExe   := 3;
SET DiasInteres 	:= 1;				-- Dias para el Calculo de Interes: Un Dia

SET Var_Descripcion := 'PROVISION INV. VENTA DIVISA';
SET Var_Referencia  := 'PROVISION INVERSION. CIERRE DIA';
SET Pro_CieDiaInv   := 100;
SET Ref_Provision   := 'PROVISION DE INVERSIONES';

SELECT DiasInversion, MonedaBaseID INTO Var_DiasBase, Var_MonedaBase
	FROM PARAMETROSSIS;

-- Fec_Provision
SET Var_SigFecha	:= DATE_ADD(Par_Fecha, INTERVAL 1 DAY);

SELECT COUNT(InversionID) INTO Var_ContadorInv
		FROM INVERSIONES
		WHERE	Estatus		= 'N'
		  AND	FechaInicio	<= Par_Fecha
		   AND	FechaVencimiento	> Par_Fecha;

SET Var_ContadorInv := IFNULL(Var_ContadorInv, Entero_Cero);

IF (Var_ContadorInv > Entero_Cero) THEN
    CALL MAESTROPOLIZAALT(
        Var_Poliza,		Par_EmpresaID,		Par_Fecha,		Pol_Automatica,		Con_ProInv,
        Var_Referencia,	Par_SalidaNO,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
END IF;

OPEN CURSORINVER;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORINVER INTO
		Var_InversionID, 		Var_Monto, 				Var_TasaNeta,	Var_Tasa,
		Var_FechaInicio, 		Var_FechaVencimiento,	Var_MonedaID,	Var_SaldoProvision,
		Var_InteresGenerado,	Var_TasaISR,			Var_Empresa,	Var_SucCliente,
		Var_ClienteID;

	START TRANSACTION;
	BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;


		SET Error_Key 		:= Entero_Cero;
		SET Var_Provision   := Entero_Cero;
		SET Var_ProvMN		:= Entero_Cero;
		SET Var_TipoCambio	:= Entero_Cero;
		SET Var_InverStr	:= Cadena_Vacia;
		SET Con_Egreso		:= Entero_Cero;

		SET	Var_Provision 	:= ROUND(Var_Monto * Var_Tasa * DiasInteres / (Var_DiasBase * Flotante_Cien), 2);

		-- Si Hoy es la Fecha del ultimo calculo de Interes, y es Tasa Fija
		-- Ya no lo calculamos lo tomamos de la tabla de INVERSIONES, el Interes Pactado
		IF (DATEDIFF(Var_FechaVencimiento, Var_SigFecha) = Entero_Cero) THEN
			SET	Var_Provision		:= ROUND(Var_InteresGenerado - Var_SaldoProvision, 2);
		END IF;

		-- >> Vladimir Jz
		-- Si el Saldo Provisionado de la inversión + el Interes a cargar en el cierre
		-- es mayor al Interes Calculado de la inversión, realizamos el ajuste
		IF((Var_SaldoProvision + Var_Provision) > Var_InteresGenerado) THEN
			SET Var_Provision := ROUND(Var_InteresGenerado - Var_SaldoProvision, 2);
		END IF;
		-- <<--

		IF (Var_Provision > Entero_Cero) THEN


			CALL INVERSIONESMOVALT(
				Var_InversionID,	Aud_NumTransaccion,	Par_Fecha,		Tipo_Provision,	Var_Provision,
				Nat_Cargo,			Ref_Provision,		Var_MonedaID,	Var_Poliza,		Var_Empresa,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);


			CALL CONTAINVERSIONPRO (
				Var_InversionID,	Var_Empresa,		Par_Fecha,			Var_Provision,	Cadena_Vacia,
				Con_ProInv,			Pro_Interes,		Entero_Cero,		Nat_Abono,		AltaPoliza_NO,
				Mov_AhorroNO,		Var_Poliza,			Entero_Cero,		Var_ClienteID,	Var_MonedaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Var_SucCliente,
				Aud_NumTransaccion);

			IF (Var_MonedaID != Var_MonedaBase) THEN

				SELECT	TipCamVenInt INTO Var_TipoCambio
					FROM MONEDAS
					WHERE MonedaId = Var_MonedaID;

			SET	Var_ProvMN := ROUND(Var_Provision * Var_TipoCambio,2);

			ELSE
				SET	Var_ProvMN := Var_Provision;

			END IF;
			IF (Var_TasaISR = Flotante_Cero) THEN
				SET Con_Egreso := Con_EgresoExe;
			ELSE
				SET Con_Egreso := Con_EgresoGra;
			END IF;


			CALL CONTAINVERSIONPRO (
				Var_InversionID,	Var_Empresa,		Par_Fecha,			Var_ProvMN,		Cadena_Vacia,
				Con_ProInv,			Con_Egreso,			Entero_Cero,		Nat_Cargo,		AltaPoliza_NO,
				Mov_AhorroNO,		Var_Poliza,			Entero_Cero,		Var_ClienteID,	Var_MonedaBase,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Var_SucCliente,
				Aud_NumTransaccion);


			IF (Var_MonedaID != Var_MonedaBase) THEN
				SELECT	TipCamVenInt INTO Var_TipoCambio
					FROM MONEDAS
					WHERE MonedaId = Var_MonedaID;

				SET	Var_Instrumento := CONVERT(Var_InversionID, CHAR);


				CALL COMVENDIVISAALT(
					Var_MonedaID,		Aud_NumTransaccion,	Par_Fecha,			Var_Provision,		Var_TipoCambio,
					Ope_Interna,		Tip_Venta,			Var_Instrumento,	Var_Referencia,		Var_Descripcion,
					Var_Poliza,			Var_Empresa,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Var_SucCliente,		Aud_NumTransaccion);

			END IF;


			UPDATE INVERSIONES SET
			  SaldoProvision		= SaldoProvision + Var_Provision

				WHERE InversionID = Var_InversionID;

		END IF;
	END;
	SET Var_InverStr = CONVERT(Var_InversionID, CHAR);
	IF Error_Key = 0 THEN
		COMMIT;
	END IF;
	IF Error_Key = 1 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_CieDiaInv, 	Par_Fecha,	 		Var_InverStr,		 	'ERROR DE SQL GENERAL',
				Var_Empresa,	Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	END IF;
	IF Error_Key = 2 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_CieDiaInv, 	Par_Fecha,	 		Var_InverStr,		 	'ERROR EN ALTA, LLAVE DUPLICADA',
				Var_Empresa,	Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	END IF;
	IF Error_Key = 3 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_CieDiaInv, 	Par_Fecha,	 		Var_InverStr,		 	'ERROR AL LLAMAR A STORE PROCEDURE',
				Var_Empresa,	Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	END IF;
	IF Error_Key = 4 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_CieDiaInv, 	Par_Fecha,	 		Var_InverStr,		 	'ERROR VALORES NULOS',
				Var_Empresa,	Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	END IF;

	END LOOP;
END;

CLOSE CURSORINVER;


END TerminaStore$$