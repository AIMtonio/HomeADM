-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSPLDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSPLDACT`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSPLDACT`(
/*SP que realiza la actualizacion de los Parametros de los procesos de PLD*/
	Par_NumAct							TINYINT,			-- Numero de Actualizacion
	Par_EmpresaID						INT(11),			-- Parametro Empresa ID
	Par_EvaluacionMatriz				CHAR(1),			-- Indica si se realizará la Evaluación Periódica. S.- SI N.- NO
	Par_FrecuenciaMensual				INT(11),			-- Indica la frecuencia con la que se realizará la evaluación.
	Par_ActPerfilTransOpe				CHAR(1),			-- Indica si se realizará la actualización del perfil transaccion. S.- Si N.-No

	Par_FrecuenciaMensPerf				INT(11),			-- Indica la frecuencia con la que se realizará la evaluación.
	Par_PorcCoincidencias				DECIMAL(14,2),		-- Porcentaje de Coincidencias en Deteccion en Listas Par_PorcCoincidencias
	Par_ValidarVigDomi					CHAR(1),			-- Indica si se Valida la vigencia del documento de domicilio. S.- Si N.-No
	Par_FecVigenDomicilio				INT(1),				-- Vigencia para el documento de Domicilio
	Par_TipoDocDomID					INT(11),			-- Tipo de Documento TIPOSDOCUMENTOS
	Par_ModNivelRiesgo					CHAR(1),			-- Indica si el OC puede modificar el Nivel de Riesgo
	Par_ActPerfilTransOpeMas			CHAR(1),			-- Indica si se realizará la actualización Masiva del perfil transaccional. S.- Si N.-No
	Par_NumEvalPerfilTrans				INT(11),			-- Indica el número de veces que se va generar la evaluacion masiva al año
	Par_Salida							CHAR(1),			-- Parametro Par_Salida
	INOUT Par_NumErr					INT(11),			-- Parametro Par_NumErr

	INOUT Par_ErrMen					VARCHAR(400),		-- Parametro Par_ErrMen

	/* Parametros de Auditoria */
	Aud_EmpresaID						INT(11),			-- Auditoria
	Aud_Usuario							INT(11),			-- Auditoria
	Aud_FechaActual						DATETIME,			-- Auditoria
	Aud_DireccionIP						VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID						VARCHAR(50), 		-- Auditoria
	Aud_Sucursal						INT(11), 			-- Auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia				CHAR(1);			-- Constante de cadena vacia
	DECLARE Entero_Cero					INT(11);			-- Constante de Entero cero
	DECLARE Entero_Uno					INT(11);			-- Constante de Entero uno
	DECLARE Fecha_Vacia					DATE;				-- Constante de Fecha vacia
	DECLARE SalidaNo					CHAR(1);			-- Constante salida no
	DECLARE SalidaSi					CHAR(1);			-- Constante salida si
	DECLARE Str_No						CHAR(1);			-- Constante Str_No
	DECLARE consecutivo					INT(11);			-- Constante consecutivo

	-- definicion de variables
	DECLARE Var_Control					VARCHAR(100);		-- Variable Control
	DECLARE Var_FechaSistema			DATE;				-- Fecha del Sistema
	DECLARE Var_FechaEvaluacionMatriz	DATE;				-- Fecha para la evaluacion del Nivel de Riesgo de los Clientes.
	DECLARE Var_FechaActPerfil			DATE;				-- Fecha para la Actualización del Perfil Transaccional
	DECLARE Var_AntEvaluacionMatriz		CHAR(1);			-- Valores anteriores
	DECLARE Var_AntFrecuenciaMensual	INT(11);			-- Valores anteriores
	DECLARE Var_AntFechaEvalMatriz		DATE;				-- Valores anteriores
	DECLARE Var_AntActPerfilTransOpe	CHAR(1);			-- Valores anteriores
	DECLARE Var_AntFrecuenciaMensPerf	INT(11);			-- Valores anteriores
	DECLARE Var_AntNumEvalPerfilTrans	INT(11);			-- Valores anteriores
	DECLARE Var_AntFechaActPerfil		DATE;				-- Valores anteriores
	DECLARE Var_AntFechaSigEvalMasPerf	DATE;				-- Valores anteriores
	DECLARE Var_FechaSigEvalMasPerf		DATE;				-- Valores anteriores
	DECLARE Var_AntFecVigenDomicilio	INT(11);
	DECLARE Var_EsHabil					CHAR(1);			-- Constante Var_EsHabil
	DECLARE Var_EsHabil2				CHAR(1);			-- Constante Var_EsHabil
	DECLARE Var_TipoDocumento			INT(11);

	-- Asignacion de constantes
	SET Cadena_Vacia					:= '';				--  Cadena Vaci­a
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha DEFAULT
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Entero_Uno						:= 1;				-- Entero Uno
	SET SalidaSi						:= 'S';				-- Salida Si
	SET SalidaNo						:= 'N';				-- Salida No
	SET consecutivo						:= 0;				-- Consecutivo
	SET Var_EsHabil						:='S';				-- Constante SI
	SET Str_No							:='N';				-- Constante No

	-- Asignacion de variables
	SET Var_FechaEvaluacionMatriz		:='1900-01-01';
	SET Var_FechaEvaluacionMatriz		:='1900-01-01';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSPLDACT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		SELECT
			EvaluacionMatriz,			FrecuenciaMensual,			FechaEvaluacionMatriz,			ActPerfilTransOpe,			FrecuenciaMensPerf,
			FechaActPerfil,				FecVigenDomicilio,			PAR.FechaSistema,				FechaSigEvalMasPerf,		NumEvalPerfilTrans
			INTO
			Var_AntEvaluacionMatriz,	Var_AntFrecuenciaMensual,	Var_AntFechaEvalMatriz,			Var_AntActPerfilTransOpe,	Var_AntFrecuenciaMensPerf,
			Var_AntFechaActPerfil,		Var_AntFecVigenDomicilio,	Var_FechaSistema,				Var_AntFechaSigEvalMasPerf,	Var_AntNumEvalPerfilTrans
		  FROM PARAMETROSSIS AS PAR
			WHERE EmpresaID = Par_EmpresaID;


		IF(NOT EXISTS(SELECT EmpresaID FROM PARAMETROSSIS
			WHERE EmpresaID = Par_EmpresaID)) THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'La Empresa no Existe.';
				SET Var_Control := 'empresaID' ;
				LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EvaluacionMatriz,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Especifique Evaluacion de la Matriz.';
			SET Var_Control := 'evaluacionMatriz';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EvaluacionMatriz,Cadena_Vacia) NOT IN (Var_EsHabil, Str_No)) THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'El Valor de la Evaluacion de la Matriz No es Valido.';
			SET Var_Control := 'evaluacionMatriz';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EvaluacionMatriz,Cadena_Vacia) = Var_EsHabil AND
			IFNULL(Par_FrecuenciaMensual, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 004;
			SET Par_ErrMen  := 'La Frecuencia para la Evaluacion de la Matriz esta Vacio.';
			SET Var_Control := 'frecuenciaMensual';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ActPerfilTransOpe,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'Especifique la Actualizacion del Perfil Transaccional.';
			SET Var_Control := 'evaluacionMatriz';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ActPerfilTransOpe,Cadena_Vacia) NOT IN (Var_EsHabil, Str_No)) THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'El Valor de la Actualizacion del Perfil Transaccional.';
			SET Var_Control := 'evaluacionMatriz';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ActPerfilTransOpe,Cadena_Vacia) = Var_EsHabil AND
			IFNULL(Par_FrecuenciaMensPerf, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 007;
			SET Par_ErrMen  := 'La Frecuencia para la Actualizacion del Perfil Transaccional esta Vacio.';
			SET Var_Control := 'frecuenciaMensual';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PorcCoincidencias,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 008;
			SET Par_ErrMen  := 'El Porcentaje de Coincidencias esta Vacio.';
			SET Var_Control := 'frecuenciaMensual';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ValidarVigDomi,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 009;
			SET Par_ErrMen  := 'Especifique Validar Vigencia Domicilio.';
			SET Var_Control := 'validarVigDomi';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ValidarVigDomi,Cadena_Vacia) = Var_EsHabil) THEN
			IF(IFNULL(Par_FecVigenDomicilio,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr  := 010;
				SET Par_ErrMen  := 'La Vigencia para el Documento de Domicilio esta Vacio.';
				SET Var_Control := 'fecVigenDomicilio';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TipoDocDomID,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr  := 011;
				SET Par_ErrMen  := 'El Tipo de Documento (Comprobante de Domicilio) esta Vacio.';
				SET Var_Control := 'tipoDocDomID';
				LEAVE ManejoErrores;
			END IF;
			SET Var_TipoDocumento = (SELECT TipoDocumentoID FROM TIPOSDOCUMENTOS WHERE TipoDocumentoID = Par_TipoDocDomID LIMIT 1);
			IF(IFNULL(Var_TipoDocumento,Entero_Cero)=Entero_Cero) THEN
				SET Par_NumErr  := 011;
				SET Par_ErrMen  := 'El Tipo de Documento No Existe';
				SET Var_Control := 'tipoDocDomID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_AntFecVigenDomicilio!=Par_FecVigenDomicilio) THEN
				UPDATE CLIENTEARCHIVOS AS ARC INNER JOIN CLIENTES AS CTE ON ARC.ClienteID = CTE.ClienteID SET
					FechaExpira = FNSUMMESESFECHA(ARC.FechaRegistro,Par_FecVigenDomicilio)
					WHERE ARC.FechaExpira>Var_FechaSistema;
			END IF;
		END IF;


		IF(IFNULL(Par_ModNivelRiesgo,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 012;
			SET Par_ErrMen  := 'Permite Modificacion de Riesgo esta Vacio';
			SET Var_Control := 'fecVigenDomicilio';
			LEAVE ManejoErrores;
		END IF;



		-- SE OBTIENE LA FECHA ACTUAL DE SISTEMA Y LA DE EVALUACION
		SET Var_FechaSistema			:= (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID LIMIT 1);
		SET Var_FechaEvaluacionMatriz	:= (SELECT FechaEvaluacionMatriz FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID LIMIT 1);
		SET Var_FechaActPerfil			:= Var_AntFechaActPerfil;
		SET Var_FechaEvaluacionMatriz	:= Var_AntFechaEvalMatriz;

		IF(Var_AntEvaluacionMatriz!= Par_EvaluacionMatriz) THEN
			/* SE CALCULA LA FECHA EN LA QUE SE REALIZARÁ LA EVALUCION DEL NIVEL DE RIESGO DE LOS CLIENTES.
			 * SOLO SI LA FECHA ESTA VACIA Y SI SE REQUIERE DE LA EVALUACIÓN DE LA MATRIZ. */
			IF(IFNULL(Par_EvaluacionMatriz,Cadena_Vacia) = 'S' )THEN
				-- SE SUMA A LA FECHA DEL SISTEMA LA FRECUENCIA EN MESES
				SET Var_FechaEvaluacionMatriz	:= DATE_ADD(Var_FechaSistema, INTERVAL Par_FrecuenciaMensual MONTH);
				-- SE OBTIENE LA ULTIMA FECHA, DE LA FECHA CALCULADA
				SET Var_FechaEvaluacionMatriz	:= LAST_DAY(Var_FechaEvaluacionMatriz);

				-- SE CALCULA UN DIA HÁBIL ANTERIOR A LA FECHA CALCULADA PARA QUE SE EJECUTE JUSTO EN EL CIERRE DE MES.
				CALL DIASFESTIVOSCAL(
					Var_FechaEvaluacionMatriz,	(Entero_Uno * -1),	Var_FechaEvaluacionMatriz,		Var_EsHabil,		Par_EmpresaID,
					Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,				Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);
			ELSE
				SET Var_FechaEvaluacionMatriz	:= Fecha_Vacia;
				SET Par_FrecuenciaMensual		:= Entero_Cero;
			END IF;
		END IF;

		IF(IFNULL(Par_ActPerfilTransOpeMas,Cadena_Vacia) = 'S' )THEN
			IF(Par_NumEvalPerfilTrans!= Var_AntNumEvalPerfilTrans) THEN
				-- SE SUMA A LA FECHA DEL SISTEMA LA FRECUENCIA EN MESES
				SET Var_FechaSigEvalMasPerf	:= DATE_ADD(Var_FechaSistema, INTERVAL Par_NumEvalPerfilTrans MONTH);
				-- SE OBTIENE LA ULTIMA FECHA, DE LA FECHA CALCULADA
				SET Var_FechaSigEvalMasPerf	:= LAST_DAY(Var_FechaSigEvalMasPerf);

				-- SE CALCULA UN DIA HÁBIL ANTERIOR A LA FECHA CALCULADA PARA QUE SE EJECUTE JUSTO EN EL CIERRE DE MES.
				CALL DIASFESTIVOSCAL(
					Var_FechaSigEvalMasPerf,	(Entero_Uno * -1),	Var_FechaSigEvalMasPerf,		Var_EsHabil,		Par_EmpresaID,
					Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,				Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);
			  ELSE
				SET Var_FechaSigEvalMasPerf := Var_AntFechaSigEvalMasPerf;
			END IF;
		ELSE
			SET Var_FechaSigEvalMasPerf		:= Fecha_Vacia;
			SET Par_NumEvalPerfilTrans		:= Entero_Cero;
		END IF;

		SET Aud_FechaActual := NOW();

		UPDATE PARAMETROSSIS SET
			EvaluacionMatriz 		= Par_EvaluacionMatriz,
			FrecuenciaMensual		= Par_FrecuenciaMensual,
			FechaEvaluacionMatriz	= Var_FechaEvaluacionMatriz,
			ActPerfilTransOpe		= Par_ActPerfilTransOpe,
			FrecuenciaMensPerf		= Par_FrecuenciaMensPerf,
			FechaActPerfil			= Var_FechaActPerfil,
			PorcCoincidencias		= Par_PorcCoincidencias,
			ValidarVigDomi			= Par_ValidarVigDomi,
			FecVigenDomicilio		= Par_FecVigenDomicilio,
			TipoDocDomID			= Par_TipoDocDomID,
			ModNivelRiesgo			= Par_ModNivelRiesgo,
			ActPerfilTransOpeMas 	= Par_ActPerfilTransOpeMas,
			NumEvalPerfilTrans 		= Par_NumEvalPerfilTrans,
			FechaSigEvalMasPerf 	= Var_FechaSigEvalMasPerf,

			Usuario					= Aud_Usuario,
			FechaActual             = Aud_FechaActual,
			DireccionIP             = Aud_DireccionIP,
			ProgramaID              = Aud_ProgramaID,
			Sucursal                = Aud_Sucursal,
			NumTransaccion          = Aud_NumTransaccion
			WHERE EmpresaID     = Par_EmpresaID;

		SET Par_NumErr  := 0;
		SET Par_ErrMen  := CONCAT('Parametros del Sistema Modificados Exitosamente:  ',CAST(Par_EmpresaID AS CHAR));
		SET Var_Control := 'empresaID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_EmpresaID AS Consecutivo;
	END IF;

END TerminaStore$$