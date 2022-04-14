-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANDEVINTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVBANDEVINTPRO`;
DELIMITER $$


CREATE PROCEDURE `INVBANDEVINTPRO`(
# SP para el devengamiento de intereses de las inversiones bancarias
# Nota si modifica este SP tambien modifica el de INVBANDEVINTALTAPRO
	Par_Fecha			DATE,					-- Fecha de devengamiento de intereses
	Par_EmpresaID		INT,					-- Empresa ID
	Par_Salida			CHAR(1),				-- Salida S:Si N:No
	inout Par_NumErr	int(11),				-- Numero de error
	inout Par_ErrMen	VARCHAR(400),			-- Mensaje de error

	Aud_Usuario		 	INT,					-- Auditoria
	Aud_FechaActual	 	DATETIME,				-- Auditoria
	Aud_DireccionIP	 	VARCHAR(15),			-- Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Auditoria
	Aud_Sucursal		INT,					-- Auditoria
	Aud_NumTransaccion	BIGINT					-- Auditoria
	)

TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_ContadorInv			INT;							-- Numero de inversiones
	DECLARE Var_Poliza				BIGINT;							-- Id de la poliza
	DECLARE Error_Key				INT;							-- Numero de error
	DECLARE Var_InversionStr		VARCHAR(50);					-- Inversion ID

	DECLARE Var_InversionID			BIGINT;							-- Inversion ID
	DECLARE Var_InstitucionID		INT;							-- ID de la institucion bancaria
	DECLARE Var_NumCtaInstit		VARCHAR(20);					-- Numero de cuenta de la institucion
	DECLARE Var_TipoInversion		VARCHAR(200);					-- Tipo de inversion
	DECLARE Var_Monto				DECIMAL(14,2);					-- Monto original de la inversion
	DECLARE Var_MontoCC				DECIMAL(14,2);					-- Monto por centro de costos
	DECLARE Var_Tasa				DECIMAL(12,4);					-- Tasa
	DECLARE Var_FechaVencim			DATE;							-- Fecha de vencimiento de Inversion
	DECLARE Var_MonedaID			INT;							-- Moneda ID

	DECLARE Var_DiasInversion		DECIMAL(12,2);					-- Dias de Inversion
	DECLARE Var_Intere				DECIMAL(14,4);					-- Intereses generados
	DECLARE Var_InteresGenerado		DECIMAL(14,4);					-- Intereses generados
	DECLARE Var_InteresRetener 		DECIMAL(14,4);					-- Interes a retener de la inversion
	DECLARE Var_SalIntProvision 	DECIMAL(14,4);					-- Saldo provisional de la inversion
	DECLARE Var_InteresCC			DECIMAL(14,4);					-- Interes por centro de costos
	DECLARE Var_InteresGeneradoCC	DECIMAL(14,4);					-- Interes generado por centro de costp
	DECLARE Var_InteresRetenerCC	DECIMAL(14,4);					-- Interes retenido por centro de costo
	DECLARE Var_SalIntProvisionCC 	DECIMAL(14,4);					-- Saldo provisional de la inv por centro de costos

	DECLARE Var_MenError			VARCHAR(200);					-- Mensaje de error
	DECLARE Var_CentroCostoID		INT(11);						-- Centro de costo de la institucion Bancaria
	DECLARE Var_CCDetalle			INT(11);						-- Centro de costo de la distribucion por centro de costo por Inv Bancaria

	DECLARE Var_TempInversionID		INT(11);						-- Temporal de inversion ID
	DECLARE Var_RealizarMovOper		CHAR(1);						-- Realizar movimientos de operacion
	DECLARE Var_AnioBancario		INT(11);						-- Anio bancario de la inversion
	DECLARE Var_ConceptoInvBan		VARCHAR(100);					-- Concepto de Inversion Bancaria
	DECLARE Var_ConceptoTeso		VARCHAR(100);					-- Concepto de Tesoreria
	DECLARE Var_ConceptoRendInvBan	VARCHAR(100);					-- Descripcion de Concepto de Inversion Bancaria 3 Rendimiento de inv. Bancaria
	DECLARE Var_Inv 				CHAR(1);						-- Tipo de Inversion R: Reporto I:Inversion

	/* Declaracion de Constantes */
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Nat_Abono				CHAR(1);
	DECLARE Pol_Automatica			CHAR(1);
	DECLARE Par_SalidaNO			CHAR(1);
	DECLARE AltaPoliza_NO			CHAR(1);
	DECLARE Con_GenIntere			INT;
	DECLARE Ref_GenInt				VARCHAR(50);
	DECLARE Pro_GenIntere			INT;
	DECLARE Teso_DevenInt			INT;
	DECLARE Teso_IngresoInt			INT;
	DECLARE Dec_Cien				DECIMAL(10,2);
	DECLARE Tipo_IntProv			CHAR(3);
	DECLARE Salida_NO				CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Sin_Error				CHAR(3);
	DECLARE AltaMovAho_NO			CHAR(1);
	DECLARE Int_SinError			INT;
	DECLARE Si_RealizaMovOper		CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE TipoMovTeso				CHAR(4);
	DECLARE Es_Inversion			CHAR(1);
	DECLARE Es_Reporto				CHAR(1);
	DECLARE No_RealizaMovOper		CHAR(1);
	DECLARE No_RealizaMovTeso		CHAR(1);
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE DiasInteres				INT;

	DECLARE ConTeso_DevIntInver		INT;
	DECLARE ConTeso_IngIntInver		INT;
	DECLARE ConTeso_DevIntReporto	INT;
	DECLARE ConTeso_IngIntReporto	INT;

	DECLARE CURSORINTER CURSOR FOR
	SELECT	Inv.InversionID,				InstitucionID,			NumCtaInstit,			TipoInversion,		dis.Monto AS MontoCC,
		Inv.Monto,							Tasa,					FechaVencimiento,		MonedaID,			dis.CentroCosto,
		Inv.InteresGenerado, 				Inv.InteresRetener,		Inv.SalIntProvision,	Inv.DiasBase,		dis.InteresGenerado AS InteresGeneradoCC,
		dis.ISR AS InteresRetenerCC,		dis.SalIntProvisionCC,	ClasificacionInver
	FROM INVBANCARIA Inv
		INNER JOIN DISTCCINVBANCARIA AS dis ON Inv.InversionID=dis.InversionID
			WHERE FechaVencimiento > Par_Fecha AND Estatus	= Estatus_Activo;		 -- Aperturada o Vigente

		/* Asignacion de Constantes */
	SET Cadena_Vacia			:= '';										-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';							-- Fecha vacia
	SET Entero_Cero				:= 0;										-- Entero Cero
	SET Nat_Cargo				:= 'C';										-- Naturaleza Cargo
	SET Nat_Abono				:= 'A';										-- Naturaleza abono
	SET Pol_Automatica			:= 'A';										-- Poliza automatica
	SET Par_SalidaNO			:= 'N';										-- Salida en maestro poliza
	SET AltaPoliza_NO			:= 'N';										-- Alta de Poliza NO
	SET Pro_GenIntere			:= 601;										-- Numero de Proceso de generacion de Interes para la alta de excepciones
	SET Dec_Cien				:= 100.00;									-- DECIMAL Cien
	SET Con_GenIntere			:= 76;										-- DEVENGAMIENTO INT. INVERSIONES BANCARIAS
	SET Teso_DevenInt			:= 2;										-- Concepto Tesoreria: Devengamiento INT. de Inversion Bancaria
	SET Teso_IngresoInt			:= 3;										-- Concepto Tesoreria: Ingreso por Interes de Inv. Bancaria
	SET Salida_NO				:= 'N';										-- Salida No
	SET Salida_SI				:= 'S';										-- Salida Si
	SET Sin_Error				:= '000';									-- Codigo de Respuesta del Store: Sin Error
	SET AltaMovAho_NO			:= 'N';										-- Alta del Movimiento en Cta de Ahorro: NO
	SET Int_SinError			:= 0;										-- Codigo de Respuesta del Store: Sin Error
	SET Ref_GenInt				:= 'GENERACION INTERES INV. BANCARIAS';		-- Referecnia de generacion de intereses
	SET Tipo_IntProv			:= '002';									-- Interes Provisionado
	SET Var_CentroCostoID		:= 0;										-- Centro de Costos de la Cuenta Bancaria
	SET Var_TempInversionID		:= Entero_Cero;								-- Variable temporal de inversion ID
	SET Si_RealizaMovOper		:= 'S';										-- Si realiza movimientos de operacion
	SET Var_DiasInversion		:=	0;										-- Dias de inversion
	SET Decimal_Cero			:= 0.0;										-- DECIMAL cero
	SET TipoMovTeso				:= Cadena_Vacia;							-- Tipo de movimiento de tesoreria
	SET Es_Inversion			:= 'I';										-- Es inversion
	SET Es_Reporto				:= 'R';										-- Es reporto
	SET No_RealizaMovOper		:= 'N';										-- No realiza movimientos operativos
	SET No_RealizaMovTeso		:= 'N';										-- No realiza movimientos de tesoreria
	SET Estatus_Activo			:= 'A';										-- Estatus de la inversion Activa
	SET DiasInteres 			:= 1;										-- Dias para el Calculo de Interes: Un Dia

	SET ConTeso_DevIntInver		:= 2;										-- Concepto Tesoreria: Devengamiento INT. de Inversion Bancaria
	SET ConTeso_IngIntInver		:= 3;										-- Concepto Tesoreria: Ingreso por Interes de Inv. Bancaria
	SET ConTeso_DevIntReporto	:= 6;										-- Concepto Tesoreria: Devengamiento Interes Reportos
	SET ConTeso_IngIntReporto	:= 7;										-- Concepto Tesoreria: Rendimiento Reportos

	-- Asignacion de variables
	SET Var_ConceptoInvBan		:= Cadena_Vacia;
	SET Var_RealizarMovOper		:= Cadena_Vacia;

	SELECT	count(InversionID) into Var_ContadorInv
			FROM INVBANCARIA Inv
			WHERE FechaVencimiento > Par_Fecha
			AND Estatus	= Estatus_Activo;		 -- Aperturada o Vigente

	SET Var_ContadorInv			:= IFNULL(Var_ContadorInv, Entero_Cero);
	SET Var_ConceptoTeso		:=(SELECT UPPER(Descripcion)	FROM CONCEPTOSCONTA WHERE ConceptoContaID=Con_GenIntere);

	IF (Var_ContadorInv > Entero_Cero) THEN
		call MAESTROPOLIZAALT(
			Var_Poliza,	 	Par_EmpresaID,		Par_Fecha,		Pol_Automatica,	Con_GenIntere,
			Ref_GenInt,	 	Par_SalidaNO,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion);
	END IF;

	OPEN CURSORINTER;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP

		FETCH CURSORINTER into
			Var_InversionID,		Var_InstitucionID,		Var_NumCtaInstit,	Var_TipoInversion,	Var_MontoCC,
			Var_Monto,				Var_Tasa,				Var_FechaVencim,	Var_MonedaID,		Var_CCDetalle,
			Var_InteresGenerado,	Var_InteresRetener,		Var_SalIntProvision,Var_DiasInversion,	Var_InteresGeneradoCC,
			Var_InteresRetenerCC,	Var_SalIntProvisionCC,	Var_Inv;

		START TRANSACTION;
		InicioCiclo: BEGIN
			 DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
			DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
			DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
			DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

			SET Error_Key			:= Entero_Cero;
			SET Var_Intere			:= Entero_Cero;
			SET Var_InteresCC		:= Entero_Cero;
			SET Var_InversionStr 	:= CONCAT(CONVERT(Var_InversionID, CHAR));

			-- Guardando temporal de la inversion ID --------------------------------------------------------------
			IF( Var_InversionID != Var_TempInversionID ) THEN
				SET Var_TempInversionID := Var_InversionID;
				SET Var_RealizarMovOper := Si_RealizaMovOper;
			ELSE
				SET Var_RealizarMovOper := No_RealizaMovOper;
			END IF;

			-- -----------------------------------------------------------------------------------------------------
			-- Tomando numero de concepto dependiendo si es una inversion normal o un reporto
			IF(Var_Inv = Es_Inversion) THEN
				SET Teso_DevenInt				:= ConTeso_DevIntInver;										-- Concepto Tesoreria: Devengamiento INT. de Inversion Bancaria
				SET Teso_IngresoInt				:= ConTeso_IngIntInver;										-- Concepto Tesoreria: Ingreso por Interes de Inv. Bancaria
			ELSE
				IF(Var_Inv = Es_Reporto) THEN
					SET Teso_DevenInt			:= ConTeso_DevIntReporto;									-- Devengamiento Interes Reportos
					SET Teso_IngresoInt			:= ConTeso_IngIntReporto;									-- Rendimiento Reportos
				END IF;
			END IF;

			SET Var_ConceptoInvBan		:= (SELECT UPPER(Descripcion)	FROM CONCEPTOSINVBAN WHERE ConceptoInvBanID = Teso_DevenInt);
			SET Var_ConceptoRendInvBan	:= (SELECT UPPER(Descripcion)	FROM CONCEPTOSINVBAN WHERE ConceptoInvBanID = Teso_IngresoInt);

			SET Var_InteresCC 	:= round(Var_MontoCC * Var_Tasa * DiasInteres / (Var_DiasInversion * Dec_Cien), 2);

			IF (datediff(Var_FechaVencim, Par_Fecha) = Entero_Cero) THEN
				SET	Var_InteresCC		:= Entero_Cero;
			END IF;

			IF((Var_SalIntProvisionCC + Var_InteresCC) > Var_InteresGeneradoCC) THEN
				SET Var_InteresCC := round(Var_InteresGeneradoCC-Var_SalIntProvisionCC , 2);
			END IF;

			IF((Var_SalIntProvisionCC + Var_InteresCC) < Var_InteresGeneradoCC AND Par_Fecha = DATE_SUB(Var_FechaVencim,INTERVAL 1 DAY)) THEN
						SET Var_InteresCC :=  Var_InteresCC+ ROUND(Var_InteresGeneradoCC-(Var_SalIntProvisionCC + Var_InteresCC),2);
			END IF;

			IF(Var_InteresCC > Entero_Cero)	THEN
			-- Registramos el Movimientos Contable De Interes Devengado

			UPDATE DISTCCINVBANCARIA SET
					SalIntProvisionCC = IFNULL(SalIntProvisionCC,Decimal_Cero)+ IFNULL(Var_InteresCC,Decimal_Cero)
				WHERE InversionID = Var_InversionID
				AND	 CentroCosto=Var_CCDetalle;

			UPDATE INVBANCARIA
					SET	SalIntProvision=IFNULL(SalIntProvision, Decimal_Cero) + IFNULL(Var_InteresCC,Decimal_Cero)
				WHERE InversionID=Var_InversionID;

			-- Realizando movimiento operativo
			CALL INVBANCARIAMOVSALT(
				Var_InversionID,	Aud_NumTransaccion, Par_Fecha,			Nat_Cargo,			Var_InteresCC,
				Ref_GenInt,		 	Tipo_IntProv,		Var_MonedaID,		Salida_NO,			Par_NumErr,
				Par_ErrMen,		 	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	 	Aud_Sucursal,		Aud_NumTransaccion	);

			-- Abono cuenta de resultados Rendimiento por incersion bancaria
			CALL CONTAINVBANPRO(
				Var_InversionID,		Var_CCDetalle,				Var_TipoInversion,			Var_MonedaID,			Var_InstitucionID,
				Par_Fecha,				Var_Monto,					Var_InteresCC,				Var_NumCtaInstit,		AltaPoliza_NO,
				Con_GenIntere,			Teso_IngresoInt,			TipoMovTeso, 				Var_ConceptoTeso,		Var_ConceptoRendInvBan,
				Nat_Abono,				Var_Poliza,					Var_RealizarMovOper,		No_RealizaMovTeso,		Par_Salida,
				Par_NumErr, 			Par_ErrMen,					Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

			-- Cargo Devengamiento de Inversion Bancaria cuenta por cobrar
			CALL CONTAINVBANPRO(
				Var_InversionID,		Var_CCDetalle,				Var_TipoInversion,			Var_MonedaID,				Var_InstitucionID,
				Par_Fecha,				Var_Monto,					Var_InteresCC,				Var_NumCtaInstit,			AltaPoliza_NO,
				Con_GenIntere,			Teso_DevenInt,				TipoMovTeso, 				Var_ConceptoTeso,			Var_ConceptoInvBan,
				Nat_Cargo,				Var_Poliza,				 	No_RealizaMovOper,			No_RealizaMovTeso,			Par_Salida,
				Par_NumErr,				Par_ErrMen,				 	Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			 	Aud_Sucursal,				Aud_NumTransaccion);

			IF (Par_NumErr != Int_SinError) THEN
				IF (Par_Salida = Salida_SI) THEN
					SELECT	Par_NumErr AS NumErr,
							Par_ErrMen	AS ErrMen,
							'institucionID' AS control,
							Entero_Cero AS consecutivo;
				ELSE
					SET Par_NumErr := LPAD(CONVERT(Par_NumErr, CHAR),3,0);
					SET Var_MenError := Par_ErrMen;
					SET Error_Key = 5;
				END IF;
				LEAVE InicioCiclo;
			END IF;
		END IF;
	END InicioCiclo;

	IF Error_Key = 0 THEN
		COMMIT;
	END IF;
	IF Error_Key = 1 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_GenIntere,	Par_Fecha,		Var_InversionStr,	'ERROR DE SQL GENERAL',
				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	END IF;
	IF Error_Key = 2 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_GenIntere,	Par_Fecha,		Var_InversionStr,	'ERROR EN ALTA, LLAVE DUPLICADA',
				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	END IF;
	IF Error_Key = 3 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_GenIntere,	Par_Fecha,		Var_InversionStr,	'ERROR AL LLAMAR A STORE PROCEDURE',
				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	END IF;
	IF Error_Key = 4 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_GenIntere,	Par_Fecha,		Var_InversionStr,	'ERROR VALORES NULOS',
				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	END IF;

	IF Error_Key = 5 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_GenIntere,	Par_Fecha,		Var_InversionStr,	Var_MenError,
				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	END IF;

	END LOOP;
	END;
CLOSE CURSORINTER;
-- ok
END TerminaStore$$