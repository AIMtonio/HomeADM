-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTMASIVOTASACAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTMASIVOTASACAL`;DELIMITER $$

CREATE PROCEDURE `APORTMASIVOTASACAL`(
# ==============================================================================================
# -------- SP QUE SE ENCARGA DE REALIZAR EL CALCULO DE VENCIMIENTO MASIVO DE APORTACIONES ------
# ==============================================================================================
	Par_Fecha			DATE,				-- Fecha Operacion
	INOUT Par_NumErr	INT(11),			-- Numero de error
    INOUT Par_ErrMen	VARCHAR(400),		-- Descripcion de error
    Par_Salida			CHAR(1),			-- Indica si espera un SELECT de salida
    Par_EmpresaID		INT(11),			-- Parametro de auditoria

    Aud_Usuario			INT(11),			-- Parametro de auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal		INT(11),			-- Parametro de auditoria

	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria
)
TerminaStore : BEGIN

	-- Declaracion de variables
	DECLARE	Var_FechaBatch		DATE;

	-- Declaracion de Constantes
	DECLARE SalidaSI			CHAR(1);
	DECLARE TasaF				CHAR(1);
	DECLARE TasaV				CHAR(1);
	DECLARE ProcesoAportacion	INT(11);
	DECLARE Entero_Uno          INT(11);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE ProgramaVencMasivo  VARCHAR(100);
	DECLARE Var_FecBitaco		DATETIME;
	DECLARE Var_MinutosBit 		INT(11);


	-- Asginacion de Constantes
	SET SalidaSI				:= 'S';				-- Constante Salida SI
	SET TasaF					:= 'F';				-- Constante Tasa Fija
	SET TasaV					:= 'V';				-- Constante Tasa Variable
	SET ProcesoAportacion		:= 1512;			-- ID Proceso Batch
	SET Entero_Uno          	:= 1;          		-- Entero Uno
	SET Fecha_Vacia         	:= '1900-01-01';	-- Constante Fecha Vacia
	SET Entero_Cero				:= 0;			 	-- Entero Cero

	/*Programa vencimiento masivo aportaciones*/
	SET ProgramaVencMasivo 	:='/microfin/vencMasivoAportVista.htm';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-APORTMASIVOTASACAL');
			END;

		SET Var_FecBitaco	:= NOW();
		SET Aud_FechaActual	:= NOW();

		 -- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			ProcesoAportacion,		Par_Fecha,			Var_FechaBatch,		Entero_Uno,			Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Var_FechaBatch = Fecha_Vacia OR Aud_ProgramaID = ProgramaVencMasivo) THEN

			UPDATE TMPAPORTACIONES temp
				INNER JOIN CLIENTES cte	ON temp.ClienteID	=	cte.ClienteID
					SET temp.Calificacion	= cte.CalificaCredito;

			UPDATE TMPAPORTACIONES temp
				INNER JOIN PLAZOSAPORTACIONES plazo ON temp.TipoAportacionID = plazo.TipoAportacionID
												AND temp.PlazoOriginal 	>= 	plazo.PlazoInferior
												AND temp.PlazoOriginal	<=	plazo.PlazoSuperior
				SET temp.PlazoInferior = plazo.PlazoInferior,
					temp.PlazoSuperior = plazo.PlazoSuperior;

			UPDATE TMPAPORTACIONES temp
				INNER JOIN MONTOSAPORTACIONES monto ON  temp.TipoAportacionID		=	monto.TipoAportacionID
											 AND temp.MontoGlobal	>=	monto.MontoInferior
											 AND temp.MontoGlobal	<=	monto.MontoSuperior
					SET temp.MontoInferior	=	monto.MontoInferior,
						temp.MontoSuperior	= 	monto.MontoSuperior;

			UPDATE TMPAPORTACIONES temp
				INNER JOIN TASASAPORTACIONES tasa	ON	temp.TipoAportacionID			=	tasa.TipoAportacionID
											AND temp.MontoInferior		=	tasa.MontoInferior
											AND temp.MontoSuperior		=	tasa.MontoSuperior
											AND temp.PlazoInferior		=	tasa.PlazoInferior
											AND temp.PlazoSuperior		=	tasa.PlazoSuperior
											AND temp.Calificacion		=	tasa.Calificacion
				INNER JOIN TASAAPORTSUCURSALES tasaSuc	ON	tasa.TipoAportacionID	=	tasaSuc.TipoAportacionID
														AND	tasa.TasaAportacionID	=	tasaSuc.TasaAportacionID
														AND temp.SucursalID	=	tasaSuc.SucursalID
					SET temp.NuevaTasa		=	CASE	WHEN temp.TasaFV	=	TasaF 	THEN tasa.TasaFija
														WHEN temp.TasaFV	=	TasaV	THEN FNTASAAPORTACIONES(tasa.CalculoInteres,	tasa.TasaBase,	tasa.SobreTasa,	tasa.PisoTasa,	tasa.TechoTasa)
												END,
						temp.NuevoCalInteres	=	tasa.CalculoInteres,
						temp.NuevaTasaBaseID	=	tasa.TasaBase,
						temp.NuevaSobreTasa		=	tasa.SobreTasa,
						temp.NuevoPisoTasa		=	tasa.PisoTasa,
						temp.NuevoTechoTasa		=	tasa.TechoTasa;


			IF(Par_NumErr = Entero_Cero)THEN
				SET Par_NumErr	:=	Entero_Cero;
				SET Par_ErrMen	:=	'Calculo de Nueva Tasa Realizado Exitosamente.';
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

		SET Par_NumErr	:=	Entero_Cero;
		SET Par_ErrMen	:=	'Calculo de Nueva Tasa Realizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr 	AS NumErr,
				Par_ErrMen	AS ErrMen;
	END IF;

END TerminaStore$$