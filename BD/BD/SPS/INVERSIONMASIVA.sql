-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONMASIVA
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONMASIVA`;
DELIMITER $$


CREATE PROCEDURE `INVERSIONMASIVA`(
# ====================================================================
# -------SP PARA EL PROCESO DE INVERCIONES AUTOMATICAS PRINCIPAL------
# ====================================================================
	Par_Fecha			DATE,					-- Fecha del proceso
	Par_EmpresaID		INT(11),				-- Numero de empresa

	Par_Salida			CHAR(1),				-- Tipo de Salida.
	INOUT Par_NumErr 	INT(11),				-- Numero de Error.
	INOUT Par_ErrMen 	VARCHAR(400),			-- Mensaje de Error.

	/*parametros de auditoria*/
	Aud_Usuario			INT(11),				-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal		INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT					-- Parametro de Auditoria
			)

TerminaStore: BEGIN

/*Declaracion de variables*/
DECLARE Var_Concepto 		DECIMAL(14,2);		-- Concepto
DECLARE ConceptoInversion 	DECIMAL(14,2);		-- Cocepto de inversion
DECLARE Var_FecBitaco 		DATETIME;			-- Variable para guardar el tiempo del proceso
DECLARE Var_MinutosBit 		INT(11);			-- Variable para guardar el tiempo del proceso
DECLARE Var_SalMinDF 		DECIMAL(12,2);		-- Variable para guardar el salario minimo del DF

DECLARE Var_SalMinAn 		DECIMAL(12,2);		-- Variable para guardar el salario minimo anual
DECLARE Var_DiasInversion 	DECIMAL(12,4);		-- Variable para guardar los dias de la inversion
DECLARE Var_ISRReal 		DECIMAL(12,2);		-- Variable que guarda el valor de ISR REAL por socio
DECLARE Var_ISR_pSocio		CHAR(1);			-- Variable que guarda el valor si se
DECLARE Var_FechaISR		DATE;				-- Variable fecha de inicio cobro isr por socio
DECLARE Var_ContadorInv		INT(11); 			-- Variable que almacena el numero de Inversiones a Reinvertir
DECLARE Var_Control			VARCHAR(50);		-- Control ID
DECLARE Var_ValorUMA		DECIMAL(12,4);
DECLARE Var_Inflacion		DECIMAL(12,4);		-- Variable para la inflacion

/*Declaracion de constante*/
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT(11);
DECLARE Entero_Dos			INT(11);
DECLARE Entero_Cinco		INT(11);

DECLARE Entero_Cuatro		INT(11);
DECLARE Entero_Cien			INT(11);
DECLARE Pro_CieDiaInv		INT(11);
DECLARE Estatus_Vigente		CHAR(1);
DECLARE Rei_NO				CHAR(2);

DECLARE Rei_Capital			CHAR(2);
DECLARE Rei_CapInte			CHAR(2);
DECLARE Ren_SelVencim		INT(11);
DECLARE Ren_CalFechas		INT(11);
DECLARE Ren_CalCondicion 	INT(11);

DECLARE Ren_AltaReinver		INT(11);
DECLARE SI_PagaISR			CHAR(1);
DECLARE SI_Isr_Socio 		CHAR(1);
DECLARE ISRpSocio			VARCHAR(10);
DECLARE No_constante		VARCHAR(10);

DECLARE EnteroUno			INT(11);
DECLARE ProcesoCierre		CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE TasaFija			CHAR(1);
DECLARE TasaVariable		CHAR(1);
DECLARE SalidaSI			CHAR(1);
DECLARE Var_InstInversion 	INT(11);
DECLARE ValorUMA			VARCHAR(15);
	/*Asignacion de constantes*/
SET Cadena_Vacia 	 		:= '';					-- Constante para settear valores vacios
SET Fecha_Vacia				:= '1900-01-01';		-- Constante para settear fechas
SET Entero_Cero				:= 0;					-- Constante cero
SET Entero_Dos				:= 2;					-- Constante dos
SET Entero_Cuatro			:= 4;					-- Constante cuatro

SET Entero_Cinco			:= 5;					-- Constante cinco
SET Entero_Cien				:= 100;					-- Constante cien
SET Estatus_Vigente			:= 'N';					-- Constante para saber si es una inversion vigente
SET Rei_NO					:= 'N';					-- Constante sapara saber si no se reinvierte
SET Rei_Capital				:= 'C';					-- Constante para saber si se reinvierte capital

SET Rei_CapInte				:= 'CI';				-- Contante para saber si se reinvierte capital mas interes
SET Ren_SelVencim			:= 101;					-- Constante del proceso que se esta relizando de la tabla PROCESOSBATCH
SET Ren_CalFechas			:= 102;					-- Constante del proceso que se esta relizando de la tabla PROCESOSBATCH
SET Ren_CalCondicion		:= 103;					-- Constante del proceso que se esta relizando de la tabla PROCESOSBATCH
SET Ren_AltaReinver			:= 104;					-- Constante del proceso que se esta relizando de la tabla PROCESOSBATCH

SET SI_PagaISR				:= 'S';					-- Constante para saber si se paga ISR
SET Var_FecBitaco			:= NOW();				-- Variable para guardar la fecha del proceso
SET Aud_FechaActual			:= NOW();				-- Constante de audotiria
SET SI_Isr_Socio			:= 'S';					-- Constante para saber si se calcula el isr por socio
SET ISRpSocio				:= 'ISR_pSocio';		-- Constante para isr por socio de PARAMGENERALES

SET No_constante			:= 'N';					-- Constante NO
SET EnteroUno				:= 1;					-- Constante Entero Uno
SET ProcesoCierre			:= 'C';					-- ISR en Proceso de Cierre
SET SalidaNO 				:= 'N';					-- Salida No
SET TasaFija				:= 'F';					-- Constante Tasa Fija
SET TasaVariable			:= 'V';					-- Constante Tasa Variable
SET SalidaSI        		:= 'S';					-- Salida Si
SET Var_InstInversion		:=	13;					-- Instrumento de Inversion
SET ValorUMA				:=	'ValorUMABase';
ManejoErrores:BEGIN
		  DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al
				concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-INVERSIONMASIVA');
                SET Var_Control := 'SQLEXCEPTION';
			END;

 TRUNCATE TABLE TEMINVERSIONES;

	SELECT DiasInversion, SalMinDF,FechaISR INTO Var_DiasInversion, Var_SalMinDF,Var_FechaISR
		FROM PARAMETROSSIS;
	SELECT ValorParametro INTO Var_ISR_pSocio
		FROM PARAMGENERALES
			WHERE LlaveParametro=ISRpSocio;

    SELECT ValorParametro
			INTO Var_ValorUMA
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;

	SET Var_ISR_pSocio		:= IFNULL(Var_ISR_pSocio , No_constante);
	SET Var_DiasInversion 	:= IFNULL(Var_DiasInversion , Entero_Cero);
	SET Var_SalMinDF 		:= IFNULL(Var_SalMinDF , Entero_Cero);
	SET Var_SalMinAn 		:= Var_SalMinDF * Entero_Cinco * Var_ValorUMA;
	SET Var_FechaISR 		:= IFNULL(Var_FechaISR , Par_Fecha);
    SET Var_Inflacion		:= IFNULL((SELECT InflacionProy
											FROM INFLACIONACTUAL
											WHERE FechaActualizacion = (SELECT MAX(FechaActualizacion)
																			FROM INFLACIONACTUAL)),Entero_Cero);

		INSERT INTO TEMINVERSIONES(
			InversionID, CuentaAhoID, 	 	TipoInversionID, 	MonedaID, FechaInicio,
			Monto, Plazo, 		Tasa, 		TasaISR, TasaNeta,
			InteresGenerado, InteresRecibir, 		InteresRetener, 		ConsecutivoTabla, 		FechaPosibleVencimiento,
			NuevoPlazo,			FechaVencimiento, 		MontoReinvertir, 		NuevaTasa,				NuevaTasaISR,
			NuevaTasaNeta, 	NuevoInteresGenerado, 	NuevoInteresRetener, 	NuevoInteresRecibir, 	Reinvertir,
			ClienteID, SaldoProvision,			Etiqueta, ValorGat, 				Beneficiario,
			ValorGatReal)

			SELECT	InversionID,		CuentaAhoID,			TipoInversionID,		MonedaID,				Par_Fecha,
					Monto,				PlazoOriginal,			Tasa,					TasaISR,				TasaNeta,
					InteresGenerado,

					CASE WHEN Var_ISR_pSocio=SI_Isr_Socio  THEN
								(InteresGenerado-ISRReal)
							ELSE
								InteresRecibir
					END,
					CASE WHEN Var_ISR_pSocio=SI_Isr_Socio  THEN
								ISRReal
							ELSE
								(InteresGenerado-InteresRecibir)
					END,
					Entero_Cero,
					Fecha_Vacia,

					Entero_Cero,
					Fecha_Vacia,
					CASE WHEN (Reinvertir = Rei_Capital) THEN
									Monto
								WHEN (Reinvertir = Rei_CapInte) THEN
									CASE WHEN Var_ISR_pSocio=SI_Isr_Socio AND FechaInicio>=Var_FechaISR THEN
											(Monto + (InteresGenerado-ISRReal))
										ELSE
											(Monto + InteresRecibir)
								END
					END AS NuevoMonto,
					Entero_Cero,
					Entero_Cero,

					Entero_Cero,		Entero_Cero,			Entero_Cero,			Entero_Cero,			Reinvertir,
					ClienteID,			SaldoProvision,			Etiqueta,				ValorGat,				Beneficiario,
					ValorGatReal

				FROM INVERSIONES Inv
					WHERE	Estatus				=	Estatus_Vigente
						AND Reinvertir			!=	Rei_NO
						AND FechaVencimiento	=	Par_Fecha;

		-- ==================Calculo de ISR ===================================

	SELECT COUNT(InversionID) INTO Var_ContadorInv
			FROM TEMINVERSIONES;

			IF(Var_ContadorInv > Entero_Cero) THEN
				DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;
				INSERT INTO CTESVENCIMIENTOS(
						Fecha,				ClienteID,		EmpresaID,		UsuarioID,		FechaActual,
						DireccionIP,		ProgramaID,		Sucursal, 	NumTransaccion)

				SELECT	Par_Fecha,			inv.ClienteID,	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal, Aud_NumTransaccion
					FROM TEMINVERSIONES inv
					GROUP BY inv.ClienteID;


				CALL CALCULOISRPRO(	Par_Fecha,			Par_Fecha,		EnteroUno,		ProcesoCierre,		SalidaNO,
									Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
									Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

				DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				-- ==========================================================================================================

					/*Se actualiza el Interes a Retener*/
						UPDATE TEMINVERSIONES Inv
							SET InteresRetener =FNTOTALISRCTE(Inv.ClienteID, Var_InstInversion,Inv.InversionID);

					/*Se actualiza el Interes a Recibir*/
						UPDATE TEMINVERSIONES Inv
							SET	 InteresRecibir=Inv.InteresGenerado - Inv.InteresRetener;

					/*Se actualiza el monto a Reinvertir*/
						UPDATE TEMINVERSIONES tmp
							INNER JOIN CATINVERSION cat ON tmp.TipoInversionID = cat.TipoInversionID
						SET tmp.MontoReinvertir	=	CASE WHEN (tmp.Reinvertir = Rei_Capital) THEN tmp.Monto
														 WHEN (tmp.Reinvertir = Rei_CapInte) THEN (tmp.Monto+tmp.InteresGenerado) - tmp.InteresRetener
													END;

		END IF;
		-- =============================================================================================================
		-- ==================FIN ===================================


	SET Var_MinutosBit	:= TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	SET Aud_FechaActual	:= NOW();
	CALL BITACORABATCHALT(
		Ren_SelVencim,		Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	SET Var_FecBitaco := NOW();

	UPDATE TEMINVERSIONES SET
		FechaPosibleVencimiento = (SELECT DATE_ADD(FechaInicio, INTERVAL Plazo DAY));

	CALL INVERSIONMASIVACAL(
		Par_Fecha,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	UPDATE TEMINVERSIONES SET
		NuevoPlazo = (SELECT DATEDIFF(FechaVencimiento, FechaInicio));


	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	SET Aud_FechaActual	:= NOW();
	CALL BITACORABATCHALT(
		Ren_CalFechas,		Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	SET Var_FecBitaco = NOW();


	UPDATE TEMINVERSIONES Tem, CLIENTES Cli, SUCURSALES Suc SET
		Tem.NuevaTasaISR = Suc.TasaISR
		 WHERE Tem.ClienteID = Cli.ClienteID
		 AND Suc.SucursalID = Cli.SucursalOrigen;


	UPDATE TEMINVERSIONES	SET
		NuevaTasa = FUNCIONTASA(TipoInversionID, NuevoPlazo, MontoReinvertir);

    -- personas fisicas
	UPDATE TEMINVERSIONES tmp
		INNER JOIN CLIENTES cli
			ON tmp.ClienteID = cli.ClienteID SET
		tmp.NuevoInteresRetener = ROUND(((tmp.MontoReinvertir-Var_SalMinAn) * tmp.NuevoPlazo * tmp.NuevaTasaISR) / (Var_DiasInversion * Entero_Cien), Entero_Dos)
		WHERE tmp.NuevaTasaISR > Entero_Cero
		 AND tmp.MontoReinvertir > Var_SalMinAn
         AND cli.TipoPersona <> 'M';

    -- personas morales
	UPDATE TEMINVERSIONES tmp
		INNER JOIN CLIENTES cli
			ON tmp.ClienteID = cli.ClienteID SET
		tmp.NuevoInteresRetener = ROUND((tmp.MontoReinvertir * tmp.NuevoPlazo * tmp.NuevaTasaISR) / (Var_DiasInversion * Entero_Cien), Entero_Dos)
		WHERE tmp.NuevaTasaISR > Entero_Cero
         AND cli.TipoPersona = 'M';

	UPDATE TEMINVERSIONES	SET
		NuevaTasaNeta = ROUND(NuevaTasa - NuevaTasaISR, Entero_Cuatro),
		NuevoInteresGenerado = ROUND(((MontoReinvertir * NuevaTasa * NuevoPlazo)/(Var_DiasInversion * Entero_Cien)),Entero_Dos),
	 ValorGat = FUNCIONCALCTAGATINV(FechaVencimiento, FechaInicio, NuevaTasa);
     
	UPDATE TEMINVERSIONES temp SET 
		temp.ValorGatReal	=	FUNCIONCALCGATREAL(temp.ValorGat,Var_Inflacion);

	UPDATE TEMINVERSIONES	SET
		NuevoInteresRecibir = ROUND(NuevoInteresGenerado - NuevoInteresRetener, Entero_Dos);

	SET Var_MinutosBit	:= TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	SET Aud_FechaActual	:= NOW();
	CALL BITACORABATCHALT(
		Ren_CalCondicion,	Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	SET Var_FecBitaco	:= NOW();


	CALL INVERSINTASAPRO(
		Par_Fecha,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	CALL INVERSIONMASIVACUR(
		Par_Fecha,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	INSERT INTO BENEFICIARIOSINVER
		SELECT	Tem.NuevaInversionID,	Ben.BenefInverID,		Ben.ClienteID,		Ben.Titulo,				Ben.PrimerNombre,
				Ben.SegundoNombre,		Ben.TercerNombre,		Ben.PrimerApellido,	Ben.SegundoApellido,	Ben.FechaNacimiento,
				Ben.PaisID,				Ben.EstadoID,			Ben.EstadoCivil,	Ben.Sexo,				Ben.CURP,
				Ben.RFC,				Ben.OcupacionID,		Ben.ClavePuestoID,	Ben.TipoIdentiID,		Ben.NumIdentific,
				Ben.FecExIden,			Ben.FecVenIden,			Ben.TelefonoCasa,	Ben.TelefonoCelular,	Ben.Correo,
				Ben.Domicilio,			Ben.TipoRelacionID,		Ben.Porcentaje,		Ben.NombreCompleto,		Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion
			FROM TEMINVERSIONES Tem,
				 BENEFICIARIOSINVER Ben
				WHERE Tem.InversionID = Ben.InversionID
				 AND Tem.NuevaInversionID != Entero_Cero;

	INSERT INTO HISCREDITOINVGAR(
		Fecha,				CreditoID,		InversionID,	MontoEnGar,			FechaAsignaGar,
		UsuarioAgrego,		UsuarioElimina,	EmpresaID,		Usuario,			FechaActual,
		DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
		SELECT	Par_Fecha,			CI.CreditoID,	CI.InversionID,	CI.MontoEnGar,		CI.FechaAsignaGar,
				Usuario,			Aud_Usuario,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
			FROM	CREDITOINVGAR	CI,
					TEMINVERSIONES	TI
				WHERE CI.InversionID	= TI.InversionID;


	UPDATE	CREDITOINVGAR	CI,
			TEMINVERSIONES	TI
		SET
			CI.InversionID		= TI.NuevaInversionID
			WHERE CI.InversionID	= TI.InversionID;

	SET Var_MinutosBit	:= TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	SET Aud_FechaActual	:= NOW();
	CALL BITACORABATCHALT(
		Ren_AltaReinver, 	Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	SET Var_FecBitaco	:= NOW();

	TRUNCATE TABLE TEMINVERSIONES;

	SET Par_NumErr		:= Entero_Cero;
	SET Par_ErrMen		:= 'Inversion Masiva Realizada Exitosamente.';
    SET Var_Control		:= 'inversionID';

END ManejoErrores;
	IF (Par_Salida = SalidaSI) THEN
		SELECT CONVERT(
				Par_NumErr,  CHAR(3)) AS NumErr,
				Par_ErrMen	 AS ErrMen,
				Var_Control  AS control;
END IF;

END TerminaStore$$