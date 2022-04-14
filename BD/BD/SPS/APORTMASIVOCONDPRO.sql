-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTMASIVOCONDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTMASIVOCONDPRO`;DELIMITER $$

CREATE PROCEDURE `APORTMASIVOCONDPRO`(
# =======================================================================================================
# ---- SP QUE SE ENCARGA DE REALIZAR EL CALCULO DE CONDICIONES DE REINVERSION MASIVA DE APORTACIONES ----
# =======================================================================================================
	Par_Fecha			DATE,			-- Fecha de Operacion

	INOUT Par_NumErr	INT(11),		-- Numero de error
    INOUT Par_ErrMen	VARCHAR(400),	-- Descripcion de error
    Par_Salida			CHAR(1),		-- Indica si espera un SELECT de salida

    Par_EmpresaID		INT(11),		-- Parametro de auditoria
    Aud_Usuario			INT(11),		-- Parametro de auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal		INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria
)
TerminaStore : BEGIN
	-- Declaracion de Constantes
	DECLARE EnteroCero			INT(1);
	DECLARE DecimalCero			DECIMAL(18,2);
	DECLARE FechaVacia			DATE;
	DECLARE	ConstanteCien		INT(3);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SIPagaISR			CHAR(1);
	DECLARE ProcesoAportacion	INT(11);
	DECLARE Entero_Uno          INT(11);
	DECLARE VecesSalMinAnua		INT(2);
	DECLARE Var_No				CHAR(1);
	DECLARE Var_FecBitaco		DATETIME;
	DECLARE Var_MinutosBit 		INT(11);
    DECLARE Cons360         	INT(3);
    DECLARE	ValorUMA			VARCHAR(15);
	/*Programa vencimiento masivo aportaciones*/
	DECLARE ProgramaVencMasivo  VARCHAR(100);

	-- Declaracion de Variables
	DECLARE Var_DiasInversion	INT(11);
	DECLARE Var_SalMinDF		DECIMAL(18,2);
	DECLARE Var_Inflacion		DECIMAL(12,4);
	DECLARE Var_SalMinAn		DECIMAL(18,2);
	DECLARE	Var_FechaBatch		DATE;

	-- Asignacion de Constantes
	SET EnteroCero			:=	0;				-- Constante Entero Cero
	SET DecimalCero			:=	0.0;			-- Constante DECIMAL Cero
	SET FechaVacia			:=	'1900-01-01';	-- Constante Fecha Vacia
	SET ConstanteCien		:=	100;			-- Constante Cien
	SET SalidaSI			:=	'S';			-- Constante Salida SI
	SET SIPagaISR			:=	'S';			-- Constante Paga ISR SI
	SET ProcesoAportacion	:=	1513;
	SET Entero_Uno          :=  1;              -- Valor Entero Uno
	SET VecesSalMinAnua		:=	5;				-- Veces el Salario Minimo Anualizado
	SET Var_No				:= 'N';
    SET Cons360         	:= 360;
    SET ValorUMA			:='ValorUMABase';
	/*Programa vencimiento masivo aportaciones*/
	SET ProgramaVencMasivo :='/microfin/vencMasivoAportVista.htm';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	=	999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-APORTMASIVOCONDPRO');
			END;

		SET Var_FecBitaco	:= NOW();
		SET Aud_FechaActual	:= NOW();

		  -- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			ProcesoAportacion,			Par_Fecha,			Var_FechaBatch,		Entero_Uno,			Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Var_FechaBatch = FechaVacia OR Aud_ProgramaID = ProgramaVencMasivo) THEN

			SELECT 	 		SalMinDF
			INTO 	 	Var_SalMinDF
			FROM PARAMETROSSIS;

            SELECT ValorParametro
			INTO Var_DiasInversion
			FROM PARAMGENERALES
			WHERE LlaveParametro=ValorUMA;

			SET Var_DiasInversion	:=	IFNULL(Var_DiasInversion,EnteroCero);
			SET Var_SalMinDF		:=	IFNULL(Var_SalMinDF,DecimalCero);

			SET Var_SalMinAn        := Var_SalMinDF * VecesSalMinAnua * Var_DiasInversion;

			SET Var_Inflacion		:=	(SELECT InflacionProy
											FROM INFLACIONACTUAL
											WHERE FechaActualizacion = (SELECT MAX(FechaActualizacion)
																			FROM INFLACIONACTUAL));

			UPDATE TMPAPORTACIONES temp
			INNER JOIN CLIENTES cte ON temp.ClienteID = cte.ClienteID
			INNER JOIN SUCURSALES suc ON cte.SucursalOrigen = suc.SucursalID
				SET	temp.NuevaTasaISR = CASE 	WHEN 	cte.PagaISR = SIPagaISR	THEN suc.TasaISR
												ELSE	EnteroCero
										END;

			UPDATE TMPAPORTACIONES temp
				SET temp.NuevoIntGenerado	=	ROUND(((temp.MontoReinvertir * temp.NuevaTasa * temp.NuevoPlazo)/(Cons360 * ConstanteCien)),2),
					temp.NuevaTasaNeta		=	ROUND((NuevaTasa-NuevaTasaISR),4),
					temp.NuevoValorGat		=	FUNCIONCALCTAGATAPORTACION(FechaVacia,FechaVacia,temp.NuevaTasa);

			UPDATE TMPAPORTACIONES temp
				SET temp.NuevoValorGatReal	=	FUNCIONCALCGATREAL(temp.NuevoValorGat,Var_Inflacion);

			-- CALCULA NUEVO INTERES A RETENER PERSONAS QUE NO SON MORALES
			UPDATE TMPAPORTACIONES temp
				INNER JOIN CLIENTES cte
					ON temp.ClienteID = cte.ClienteID
				SET temp.NuevoIntRetener	=	ROUND((((temp.MontoReinvertir - Var_SalMinAn) * temp.NuevoPlazo * temp.NuevaTasaISR) / (Cons360 * ConstanteCien)),2)
				WHERE 	temp.NuevaTasaISR > EnteroCero
					AND temp.MontoReinvertir > Var_SalMinAn
                    AND cte.TipoPersona <> 'M';

			-- CALCULA NUEVO INTERES A RETENER PERSONAS MORALES
            -- Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna.
			UPDATE TMPAPORTACIONES temp
				INNER JOIN CLIENTES cte
					ON temp.ClienteID = cte.ClienteID
				SET temp.NuevoIntRetener	=	ROUND(((temp.MontoReinvertir * temp.NuevoPlazo * temp.NuevaTasaISR) / (Cons360 * ConstanteCien)),2)
				WHERE 	temp.NuevaTasaISR > EnteroCero
                    AND cte.TipoPersona = 'M';


			UPDATE TMPAPORTACIONES temp
				SET temp.NuevoIntRecibir	=	ROUND((temp.NuevoIntGenerado - temp.NuevoIntRetener),2);

			IF(Par_NumErr = EnteroCero)THEN
				SET Par_NumErr	:=	EnteroCero;
				SET Par_ErrMen	:=	'Calculo de Condiciones Realizados Exitosamente.';
			END IF;

			SET Var_MinutosBit	:= TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual	:= NOW();

			/*Programa vencimiento masivo aportaciones*/
			IF(Aud_ProgramaID!=ProgramaVencMasivo)THEN
				CALL BITACORABATCHALT(
					ProcesoAportacion, 	Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
                    Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			SET Var_FecBitaco	:= NOW();

		END IF;

		SET Par_NumErr	:=	EnteroCero;
		SET Par_ErrMen	:=	'Calculo de Condiciones Realizados Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr	AS	NumErr,
				Par_ErrMen	AS	ErrMen;
	END IF;

END TerminaStore$$