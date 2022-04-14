-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANDEVINTALTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVBANDEVINTALTAPRO`;
DELIMITER $$


CREATE PROCEDURE `INVBANDEVINTALTAPRO`(
-- SP para generar el devengo de intereses de inversiones bancarias

	Par_InversionID			INT(11),			-- Identifcador de la inversion
	Par_CentroCostoID		INT(11),			-- Centro de costo para el devego
	Par_FechaInicio			DATE, 				-- Fecha de inicio de la inversion
	Par_FechaVencimiento	DATE,				-- Fecha de vencimiento de la inversion
	Par_PolizaID			BIGINT,				-- Poliza

	Par_AltaPoliza			CHAR(1),			-- Si requeire dar de alta una poliza
	Par_RealizarMovOper		CHAR(1),			-- Si requiere hacer movimientos operativos
	Par_Salida				CHAR(1),			-- Parametro que indica si se requiere una salida
	inout Par_NumErr		INT(11),			-- Parametro de numero de error
	inout Par_ErrMen		VARCHAR(400),		-- Parametro de mensaje de error

	Aud_Empresa				INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria

	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT				-- Parametro de auditoria

)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_FechaFin			DATE;
	DECLARE Sig_DiaHab				DATE;
	DECLARE Var_EsHabil				CHAR(1);
	DECLARE Fec_Calculo				DATE;


	DECLARE Var_ContadorInv			INT(11);
	DECLARE Error_Key				INT(11);
	DECLARE Var_InversionStr		VARCHAR(50);

	DECLARE Var_InversionID			BIGINT;
	DECLARE Var_InstitucionID		INT(11);
	DECLARE Var_NumCtaInstit		VARCHAR(20);
	DECLARE Var_TipoInversion		VARCHAR(200);
	DECLARE Var_Monto				DECIMAL(14,2);
	DECLARE Var_MontoCC				DECIMAL(14,2);
	DECLARE Var_Tasa				DECIMAL(12,2);
	DECLARE Var_FechaVencim			DATE;
	DECLARE Var_MonedaID			INT(11);

	DECLARE Var_DiasInversion		DECIMAL(12,2);
	DECLARE Var_Intere				DECIMAL(14,2);
	DECLARE Var_InteresGenerado		DECIMAL(14,2);
	DECLARE Var_InteresRetener 		DECIMAL(14,2);
	DECLARE Var_SalIntProvision 	DECIMAL(14,2);
	DECLARE Var_InteresCC			DECIMAL(14,2);
	DECLARE Var_InteresGeneradoCC	DECIMAL(14,2);
	DECLARE Var_InteresRetenerCC	DECIMAL(14,2);
	DECLARE Var_SalIntProvisionCC 	DECIMAL(14,2);
	DECLARE DiasInteres				INT(11);

	DECLARE Var_MenError			VARCHAR(200);
	DECLARE Var_CentroCostoID		INT(11);
	DECLARE Var_CCDetalle			INT(11);

	DECLARE Var_TempInversionID		INT(11);
	DECLARE Var_AnioBancario		INT(11);
	DECLARE Var_ConceptoInvBan		VARCHAR(100);
	DECLARE Var_ConceptoTeso		VARCHAR(100);
	DECLARE Var_ConceptoRendInvBan	VARCHAR(100);
	DECLARE Var_Dias 				INT(11);
	DECLARE Var_Inv 				CHAR(1);
	DECLARE	Var_Estatus				CHAR(1);

	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Nat_Abono				CHAR(1);
	DECLARE Pol_Automatica			CHAR(1);
	DECLARE Par_SalidaNO			CHAR(1);
	DECLARE AltaPoliza_NO			CHAR(1);
	DECLARE AltaPoliza_SI			CHAR(1);
	DECLARE Con_GenIntere			INT(11);
	DECLARE Un_DiaHabil				INT(11);
	DECLARE Ref_GenInt				VARCHAR(50);
	DECLARE Pro_GenIntere			INT(11);
	DECLARE Teso_DevenInt			INT(11);
	DECLARE Teso_IngresoInt			INT(11);
	DECLARE Dec_Cien				DECIMAL(10,2);
	DECLARE Tipo_IntProv			CHAR(3);
	DECLARE Salida_NO				CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Sin_Error				CHAR(3);
	DECLARE AltaMovAho_NO			CHAR(1);
	DECLARE Int_SinError			INT(11);
	DECLARE Si_RealizaMovOper		CHAR(1);
	DECLARE No_RealizaMovOper		CHAR(1);
	DECLARE No_RealizaMovTeso		CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE TipoMovTeso				CHAR(4);
	DECLARE Es_Inversion			CHAR(1);
	DECLARE Es_Reporto				CHAR(1);
	DECLARE Estatus_Activo			CHAR(1);

	-- FIN DEVENGAMIENTO :;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;
	DECLARE Pro_CiDiInvBan			INT(11);
	DECLARE Pro_DevInvBan			INT(11);
	DECLARE Pro_VenInvBan			INT(11);

	-- Asignacion de constantes
	SET Cadena_Vacia	:= '';					-- Cadena vacia
	SET Fecha_Vacia		:= '1900-01-01';		-- Fecha vacia
	SET Entero_Cero		:= 0;					-- Entero Cero
	SET Par_SalidaNO	:= 'N';					-- Salida No

	SET Pro_CiDiInvBan	:= 600;					-- Cierre de dia
	SET Pro_DevInvBan	:= 601;					-- Devengamiento de Inversion Bancaria
	SET Pro_VenInvBan	:= 602;					-- Vencimiento de Inversion Bancaria

	SET Aud_FechaActual	:= now();				-- Fecha Actual para auditoria
	--  ASIGNACION DE CONSTANTES DE DEVENGAMIENTO
	/* Asignacion de Constantes */

	SET Nat_Cargo				:= 'C';										-- Naturaleza Cargo
	SET Nat_Abono				:= 'A';										-- Naturaleza abono
	SET Pol_Automatica			:= 'A';										-- Poliza automatica
	SET Un_DiaHabil				:= 1;										-- Un dia habil
	SET Par_SalidaNO			:= 'N';										-- Salida en maestro poliza
	SET AltaPoliza_NO			:= 'N';										-- Alta de Poliza NO
	SET AltaPoliza_SI			:= 'S';										-- Alta Poliza SI
	SET Pro_GenIntere			:= 601;										-- Numero de Proceso de generacion de Interes para la alta de excepciones
	SET Dec_Cien				:= 100.00;									-- Decimal Cien
	SET Con_GenIntere			:= 76;										-- DEVENGAMIENTO INT. INVERSIONES BANCARIAS
	SET Teso_DevenInt			:= 2;										-- Concepto Tesoreria: Devengamiento Int. de Inversion Bancaria
	SET Teso_IngresoInt			:= 3;										-- Concepto Tesoreria: Ingreso por Interes de Inv. Bancaria
	SET Salida_NO				:= 'N';										-- Salida No
	SET Salida_SI				:= 'S';										-- Salida Si
	SET Sin_Error				:= '000';									-- Codigo de Respuesta del Store: Sin Error
	SET AltaMovAho_NO			:= 'N';										-- Alta del Movimiento en Cta de Ahorro: NO
	SET Int_SinError			:= 0;										-- Codigo de Respuesta del Store: Sin Error
	SET Ref_GenInt				:= 'GENERACION INTERES INV. BANCARIAS';		-- Referecnia de generacion de intereses
	SET Tipo_IntProv			:= '002';									-- Interes Provisionado
	SET Var_CentroCostoID		:=0;										-- Centro de Costos de la Cuenta Bancaria
	SET Var_TempInversionID		:= Entero_Cero;								-- Variable temporal de inversion ID
	SET Si_RealizaMovOper		:= 'S';										-- Si realiza movimientos de operacion
	SET No_RealizaMovOper		:= 'N';										-- No realiza movimientos de operacion
	SET No_RealizaMovTeso		:= 'N';										-- No realiza movimientos de tesoreria
	SET Estatus_Activo			:= 'A';										-- Estatus Activo
	SET Es_Inversion			:= 'I';										-- Es inversion
	SET Es_Reporto				:= 'R';										-- Es reporto
	SET DiasInteres				:=1;

	-- Asignacion de variables
	SET Var_ConceptoInvBan		:='';
	SET Var_DiasInversion		:=	0;
	SET Decimal_Cero			:= 0.0;
	SET TipoMovTeso				:= Cadena_Vacia;
	SET Var_ContadorInv			:= IFNULL(Var_ContadorInv, Entero_Cero);
	SET Var_ConceptoTeso		:= (SELECT UPPER(Descripcion)	FROM CONCEPTOSCONTA WHERE ConceptoContaID=Con_GenIntere);

	-- FIN DE ASGINACION DE CONSTANTS DE DEVENGAMIENTO
	SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS
	WHERE EmpresaID=Aud_Empresa;
	SET Var_FechaFin := Par_FechaInicio;



	IF(Par_FechaInicio < Var_FechaSistema ) THEN
	-- Mientras la fecha calculada sea menor a la fecha del sistema
		WHILE (Var_FechaFin < Var_FechaSistema AND Var_FechaFin < Par_FechaVencimiento) DO

			-- Devengamiento de interes generados para la inversion Bancaria
				SET Aud_FechaActual	:= now();

				-- DAR DE ALTA EL DEVENGAMIENTO DE LA INVERSION
				SELECT	Inv.InversionID,				InstitucionID,			NumCtaInstit,			TipoInversion,		dis.Monto AS MontoCC,
					Inv.Monto,							Tasa,					FechaVencimiento,		MonedaID,			dis.CentroCosto,
					Inv.InteresGenerado, 				Inv.InteresRetener,		Inv.SalIntProvision,	Inv.DiasBase,		dis.InteresGenerado AS InteresGeneradoCC,
					dis.ISR AS InteresRetenerCC,		dis.SalIntProvisionCC,	ClasificacionInver, Estatus
			INTO
				Var_InversionID,		Var_InstitucionID,		Var_NumCtaInstit,		Var_TipoInversion,	Var_MontoCC,
				Var_Monto,				Var_Tasa,				Var_FechaVencim,		Var_MonedaID,		Var_CCDetalle,
				Var_InteresGenerado,	Var_InteresRetener,		Var_SalIntProvision,	Var_DiasInversion,	Var_InteresGeneradoCC,
				Var_InteresRetenerCC,	Var_SalIntProvisionCC,	Var_Inv, Var_Estatus
				FROM INVBANCARIA Inv
					INNER JOIN DISTCCINVBANCARIA AS dis
					ON Inv.InversionID=dis.InversionID
				WHERE Inv.InversionID=Par_InversionID
					AND dis.CentroCosto=Par_CentroCostoID
					AND FechaVencimiento > Var_FechaFin AND Estatus = Estatus_Activo;

				IF(Var_Estatus = Estatus_Activo) THEN
					SELECT	COUNT(InversionID) INTO Var_ContadorInv
					FROM INVBANCARIA Inv
						WHERE FechaVencimiento > Var_FechaFin
							AND InversionID=Par_InversionID
							AND Estatus	= Estatus_Activo;		 -- Aperturada o Vigente


					IF (Par_AltaPoliza = AltaPoliza_SI) THEN
						CALL MAESTROPOLIZAALT(
							Par_PolizaID,	 Aud_Empresa,	Var_FechaFin, Pol_Automatica,	Con_GenIntere,
							Ref_GenInt,	 Salida_NO,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID, Aud_Sucursal,	Aud_NumTransaccion);
					END IF;

					SET Error_Key			:= Entero_Cero;
					SET Var_Intere			:= Entero_Cero;

					SET Var_InteresCC		:= Entero_Cero;
					SET Var_InversionStr	:= CONCAT(CONVERT(Var_InversionID, CHAR));

					SET Var_SalIntProvisionCC :=IFNULL(Var_SalIntProvisionCC, Decimal_Cero);
					-- -----------------------------------------------------------------------------------------------------
					-- Tomando numero de concepto dependiendo si es una inversion normal o un reporto
					IF(Var_Inv = Es_Inversion) THEN
							SET Teso_DevenInt			:= 2;										-- Concepto Tesoreria: Devengamiento Int. de Inversion Bancaria
							SET Teso_IngresoInt			:= 3;										-- Concepto Tesoreria: Ingreso por Interes de Inv. Bancaria
						ELSE
							IF(Var_Inv = Es_Reporto) THEN
								SET Teso_DevenInt			:= 6;	-- Devengamiento Interes Reportos
								SET Teso_IngresoInt			:= 7;	-- Rendimiento Reportos
							END IF;
					END IF;
					SET Var_ConceptoInvBan		:= (SELECT UPPER(Descripcion)	FROM CONCEPTOSINVBAN WHERE ConceptoInvBanID = Teso_DevenInt);
					SET Var_ConceptoRendInvBan	:= (SELECT UPPER(Descripcion)	FROM CONCEPTOSINVBAN WHERE ConceptoInvBanID = Teso_IngresoInt);

					-- ACTUALIZAR EL SALDO DE RETENCION

					SET Var_InteresCC 	:= ROUND((Var_MontoCC * Var_Tasa * DiasInteres / (Var_DiasInversion * Dec_Cien)), 2);

					IF (DATEDIFF(Var_FechaVencim, Var_FechaFin) = Entero_Cero) THEN
						SET	Var_InteresCC		:= Entero_Cero;
					END IF;


					IF((Var_SalIntProvisionCC + Var_InteresCC) > Var_InteresGeneradoCC) THEN
						SET Var_InteresCC := ROUND(Var_InteresGeneradoCC-Var_SalIntProvisionCC , 2);
					END IF;

					IF((Var_SalIntProvisionCC + Var_InteresCC) < Var_InteresGeneradoCC AND Par_FechaVencimiento = DATE_ADD(Var_FechaFin,INTERVAL 1 DAY)) THEN
						SET Var_InteresCC :=  Var_InteresCC+ROUND(Var_InteresGeneradoCC-(Var_SalIntProvisionCC + Var_InteresCC) , 2);
					END IF;

					IF(Var_InteresCC > Entero_Cero)	THEN
						-- Registramos el Movimientos Contable De Interes Devengado
						UPDATE DISTCCINVBANCARIA SET
								SalIntProvisionCC = IFNULL(SalIntProvisionCC,Decimal_Cero)+ IFNULL(Var_InteresCC,Decimal_Cero)
								WHERE InversionID = Var_InversionID
								AND	 CentroCosto=Par_CentroCostoID;

						UPDATE INVBANCARIA
							SET	SalIntProvision=IFNULL(SalIntProvision,Decimal_Cero)+ IFNULL(Var_InteresCC,Decimal_Cero)
							WHERE InversionID=Var_InversionID;
						-- Agregamos el movimiento operativo
						CALL INVBANCARIAMOVSALT(
							Var_InversionID,	Aud_NumTransaccion, Var_FechaFin,			Nat_Cargo,		ROUND(Var_InteresCC,2),
							Ref_GenInt,		 	Tipo_IntProv,		Var_MonedaID,		Salida_NO,			Par_NumErr,
							Par_ErrMen,		 	Aud_Empresa,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,	 	Aud_Sucursal,		Aud_NumTransaccion	);


						-- Abono cuenta de resultados Rendimiento por incersion bancaria
						CALL CONTAINVBANPRO(
							Var_InversionID,		Var_CCDetalle,				Var_TipoInversion,			Var_MonedaID,			Var_InstitucionID,
							Var_FechaFin,			Var_Monto,					ROUND(Var_InteresCC,2),				 Var_NumCtaInstit,		AltaPoliza_NO,
							Con_GenIntere,			Teso_IngresoInt,			TipoMovTeso, 				Var_ConceptoTeso,		Var_ConceptoRendInvBan,
							Nat_Abono,
							Par_PolizaID,				Par_RealizarMovOper,		No_RealizaMovTeso,						Salida_NO,			 Par_NumErr,
							Par_ErrMen,				Aud_Empresa,				Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
							Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

						-- Cargo Devengamiento de Inversion Bancaria cuenta por cobrar
						CALL CONTAINVBANPRO(
							Var_InversionID,		Var_CCDetalle,				Var_TipoInversion,			Var_MonedaID,				Var_InstitucionID,
							Var_FechaFin,			Var_Monto,					ROUND(Var_InteresCC,2),				 Var_NumCtaInstit,			AltaPoliza_NO,
							Con_GenIntere,			Teso_DevenInt,				TipoMovTeso, Var_ConceptoTeso,			Var_ConceptoInvBan,		 Nat_Cargo,
							Par_PolizaID,				No_RealizaMovOper,						No_RealizaMovOper,						Salida_NO,				 Par_NumErr,
							Par_ErrMen,				Aud_Empresa,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,
							Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

						IF (Par_NumErr != Int_SinError) THEN
							IF (Par_Salida = Salida_SI) THEN
								SELECT	Par_NumErr AS NumErr,
										Par_ErrMen	AS ErrMen,
										'institucionID' AS control,
										Par_InversionID AS consecutivo;
							END IF;
							LEAVE TerminaStore;
						END IF;
					END IF;
				END IF;

			-- END WHILE;
			-- Proceso de devengamiento
			-- ::: VENCIMIENTO          :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			-- Vencimiento de Inversiones Bancarias
			SET	Var_FechaFin	:= ADDDATE(Var_FechaFin, 1);
		END WHILE;
	END IF;
		SET Par_NumErr:= 0;
		SET Par_ErrMen:= CONCAT('Alta de Devengamiento para la inversion ',Par_InversionID,' el centro de costo ', Par_CentroCostoID, ' generado correctamente.');

	IF(Par_Salida =Salida_SI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
					Par_ErrMen AS ErrMen,
					'agrega' AS control,
					Par_PolizaID AS consecutivo;
	 END IF;
END TerminaStore$$