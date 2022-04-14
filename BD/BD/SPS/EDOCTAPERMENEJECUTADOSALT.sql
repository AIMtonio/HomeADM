-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPERMENEJECUTADOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAPERMENEJECUTADOSALT`;DELIMITER $$

CREATE PROCEDURE `EDOCTAPERMENEJECUTADOSALT`(
	-- Stored procedure para dar de alta los registros generacion de estados de cuenta.
	Par_Anio						INT(11),				-- Anio en el que se ejecuto la generacion de estado de cuenta
	Par_MesInicio					INT(11),				-- Mes inicial en el que se ejecuto la generacion de estado de cuenta
	Par_MesFin						INT(11),				-- Mes final en el que se ejecuto la generacion de estado de cuenta
	Par_Tipo						CHAR(1),				-- Denota el tipo de ejecucion de generacion de estado de cuenta. M = Mensual, S = Semestral.

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Decimal_Cero			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE SalidaNO				CHAR(1);				-- Salida no
	DECLARE Var_SI					CHAR(1);				-- Variable con valor si
	DECLARE Var_NO					CHAR(1);				-- Variable con valor no
	DECLARE TipoGenMensual			CHAR(1);				-- Tipo de generacion de estado de cuenta mensual
	DECLARE TipoGenSemestral		CHAR(1);				-- Tipo de generacion de estado de cuenta semestral

	-- Declaracion de variables
	DECLARE Var_Consecutivo			BIGINT(20); 			-- Variable consecutivo
	DECLARE Var_Tipo				CHAR(1); 				-- Variable tipo de generacion de estado de cuenta

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_SI						:= 'S';					-- Asignacion de salida si
	SET Var_NO						:= 'N';					-- Asignacion de salida no
	SET TipoGenMensual				:= 'M';					-- Tipo de generacion de estado de cuenta mensual
	SET TipoGenSemestral			:= 'S';					-- Tipo de generacion de estado de cuenta semestral

	-- Valores por default
	SET Par_Anio					:= IFNULL(Par_Anio, Entero_Cero);
	SET Par_MesInicio				:= IFNULL(Par_MesInicio, Entero_Cero);
	SET Par_MesFin					:= IFNULL(Par_MesFin, Entero_Cero);
	SET Par_Tipo					:= IFNULL(Par_Tipo, Cadena_Vacia);

	SET Aud_EmpresaID				:= IFNULL(Aud_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAPERMENEJECUTADOSALT');
			END;

		IF(Par_Anio <= Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'Anio no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT		Tipo
			INTO	Var_Tipo
			FROM EDOCTAPERMENEJECUTADOS
			WHERE Anio = Par_Anio
			  AND MesInicio = Par_MesInicio
			  AND MesFin = Par_MesFin
			  AND Tipo = Par_Tipo;

		IF (Var_Tipo IS NOT NULL)THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El registro ingresado ya existe en la base de datos.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_MesInicio <= Entero_Cero) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'Mes de inicio no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_MesFin <= Entero_Cero) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'Mes de fin no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Tipo = Cadena_Vacia) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'Especifique el tipo de generacion de estado de cuenta.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Tipo NOT IN (TipoGenMensual, TipoGenSemestral)) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'Tipo de generacion de estado de cuenta no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Tipo = TipoGenSemestral && Par_MesInicio = Par_MesFin) THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'La generacion de estado de cuenta semestral no puede tener el mismo Mes Inicio y Mes Fin.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO EDOCTAPERMENEJECUTADOS (	Anio,					MesInicio,				MesFin,					Tipo,						EmpresaID,
											Usuario,				FechaActual,			DireccionIP,			ProgramaID,					Sucursal,
											NumTransaccion
			)
			VALUES(							Par_Anio,				Par_MesInicio,			Par_MesFin,				Par_Tipo,					Aud_EmpresaID,
											Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
											Aud_NumTransaccion
			);

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Generacion de estado de cuenta registrado correctamente';
		SET Var_Consecutivo := Par_Anio;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   'anio'	AS control,
			   Var_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$