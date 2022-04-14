-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERCIEMESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERCIEMESPRO`;DELIMITER $$

CREATE PROCEDURE `INVERCIEMESPRO`(
	Par_Fecha			DATE,
	/* Parametros de Auditoria */
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


DECLARE	Var_InversionID			BIGINT;
DECLARE	Var_Monto				FLOAT;
DECLARE	Var_TasaNeta			FLOAT;
DECLARE	Var_Tasa				FLOAT;
DECLARE	Var_FechaInicio			DATE;
DECLARE	Var_FechaVencimiento	DATE;
DECLARE	Var_MonedaID			INT;
DECLARE	Var_MonedaBase			INT;
DECLARE	Var_TipoCambio			DECIMAL(14,2);
DECLARE	Var_Empresa				INT;

DECLARE	Var_Dias				INT;
DECLARE	Var_DiasBase			INT;
DECLARE	Var_Provision			FLOAT;
DECLARE	Var_Acumulado			FLOAT;
DECLARE Var_CalcProv			FLOAT;
DECLARE	Var_Instrumento			VARCHAR(20);
DECLARE	Var_Poliza				BIGINT;
DECLARE Var_ProvMN				FLOAT;

DECLARE Error_Key 				INT DEFAULT 0;
DECLARE Var_InverStr 			VARCHAR(15);


DECLARE	Estatus_Vigente			CHAR(1);
DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Tipo_Provision			CHAR(4);
DECLARE	Entero_Cero				INT;
DECLARE	Flotante_Cien			FLOAT;
DECLARE	Nat_Cargo				CHAR(1);
DECLARE	Nat_Abono				CHAR(1);
DECLARE	Tip_Venta				CHAR(1);
DECLARE	Ref_CierreMes			VARCHAR(50);
DECLARE Ope_Interna				CHAR(1);
DECLARE	Pol_Automatica 			CHAR(1);
DECLARE	Par_SalidaNO 			CHAR(1);
DECLARE	AltaPoliza_NO			CHAR(1);
DECLARE	Mov_AhorroNO			CHAR(1);
DECLARE	Con_ProInv				INT;
DECLARE	Pro_Interes				INT;
DECLARE	Var_Descripcion			VARCHAR(50);
DECLARE	Var_Referencia			VARCHAR(50);
DECLARE	Pro_CieDiaInv			INT;

DECLARE CURSORINVER CURSOR FOR
	(SELECT InversionID, Monto, TasaNeta,	Tasa, FechaInicio,
			FechaVencimiento, MonedaID,	EmpresaID
		FROM INVERSIONES
		WHERE	Estatus		= 'N'
		  AND	FechaInicio	<= Par_Fecha);


SET	Estatus_Vigente		:= 'N';
SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Tipo_Provision		:= '100';
SET	Entero_Cero			:= 0;
SET	Flotante_Cien		:= 100.00;
SET	Nat_Cargo			:= 'C';
SET	Nat_Abono			:= 'A';
SET Tip_Venta			:= 'V';
SET Ope_Interna			:= 'I';
SET Pol_Automatica 		:= 'A';
SET Par_SalidaNO 		:= 'N';
SET AltaPoliza_NO		:= 'N';
SET Mov_AhorroNO		:= 'N';
SET Con_ProInv			:= 13;
SET Pro_Interes			:= 5;
SET Var_Descripcion		:= 'Provision Inv. Venta Divisa';
SET Var_Referencia		:= 'Provision Inversion. Cierre Mes';
SET	Pro_CieDiaInv 		:= 1;


SET	Ref_CierreMes		:= 'CIERRE MENSUAL DE INVERSIONES';

SELECT DiasInversion, MonedaBaseID INTO Var_DiasBase, Var_MonedaBase
	FROM PARAMETROSSIS;

SET AUTOCOMMIT=0;

OPEN CURSORINVER;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORINVER INTO
		Var_InversionID, 		Var_Monto, 		Var_TasaNeta, Var_Tasa, Var_FechaInicio,
		Var_FechaVencimiento,	Var_MonedaID,	Var_Empresa;
	START TRANSACTION;
	BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;


		SET Error_Key 		:= Entero_Cero;
		SET Var_Acumulado 	:= Entero_Cero;
		SET Var_Provision 	:= Entero_Cero;
		SET Var_Dias		:= Entero_Cero;
		SET Var_CalcProv	:= Entero_Cero;
		SET Var_Poliza		:= Entero_Cero;
		SET Var_ProvMN		:= Entero_Cero;
		SET Var_TipoCambio	:= Entero_Cero;
		SET Var_InverStr	:= Cadena_Vacia;

		SET	Var_Dias		:= DATEDIFF(Par_Fecha, Var_FechaInicio) + 1;
		SET	Var_Provision 	:= FORMAT(Var_Monto * Var_Tasa * Var_Dias / (Var_DiasBase * Flotante_Cien), 2);

		SELECT SUM(Monto)	AS Var_Acumulado
			FROM INVERSIONESMOV
			WHERE InversionID  = Var_InversionID
			  AND TipoMovInvID = Tipo_Provision
			  AND NatMovimiento = Nat_Cargo
			GROUP BY InversionID;

		SET	Var_Acumulado = IFNULL(Var_Acumulado, Entero_Cero);

		SELECT Var_CalcProv 	= Var_Provision - Var_Acumulado;

		IF (Var_CalcProv > Entero_Cero) THEN

			CALL MAESTROPOLIZAALT(
				Var_Poliza,		Var_Empresa,		Par_Fecha,			Pol_Automatica,		Con_ProInv,
				Var_Referencia,	Par_SalidaNO,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

			CALL INVERSIONESMOVALT(
				Var_InversionID,	Aud_NumTransaccion,	Par_Fecha,		Tipo_Provision,	Var_CalcProv,
				Nat_Cargo,			Ref_CierreMes,		Var_MonedaID,	Var_Poliza,		Var_Empresa,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);

			CALL CONTAINVERSIONPRO (
				Var_InversionID,	Var_Empresa,		Par_Fecha,			Var_CalcProv,		String_Vacio,
				Con_ProInv,			Pro_Interes,		Entero_Cero,		Nat_Abono,			AltaPoliza_NO,
				Mov_AhorroNO,		Var_Poliza,			Entero_Cero,		Entero_Cero,		Var_MonedaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Var_MonedaID != Var_MonedaBase) THEN
				SELECT	ROUND(TipCamVenInt, 2) INTO Var_TipoCambio
					FROM MONEDAS
					WHERE MonedaId = Var_MonedaID;

				SELECT	Var_ProvMN = ROUND((Var_CalcProv * Var_TipoCambio), 2);

			ELSE
				SELECT	Var_ProvMN = Var_CalcProv;

			END IF;

			CALL CONTAINVERSIONPRO (
				Var_InversionID,	Var_Empresa,		Par_Fecha,			Var_ProvMN,			String_Vacio,
				Con_ProInv,			Pro_Interes,		Entero_Cero,		Nat_Cargo,			AltaPoliza_NO,
				Mov_AhorroNO,		Var_Poliza,			Entero_Cero,		Entero_Cero,		Var_MonedaBase,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);


			IF (Var_MonedaID != Var_MonedaBase) THEN
				SELECT	ROUND(TipCamVenInt, 2) INTO Var_TipoCambio
					FROM MONEDAS
					WHERE MonedaId = Var_MonedaID;

				SET	Var_Instrumento = CONVERT(Var_InversionID, CHAR);


				CALL COMVENDIVISAALT(
					Var_MonedaID,		Aud_NumTransaccion,		Par_Fecha,			Var_CalcProv,		Var_TipoCambio,
					Ope_Interna,		Tip_Venta,				Var_Instrumento,	Var_Referencia,		Var_Descripcion,
					Var_Poliza,			Var_Empresa,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			END IF;
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