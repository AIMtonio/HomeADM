-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_TARDEBASIGNADASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMP_TARDEBASIGNADASPRO`;
DELIMITER $$

CREATE PROCEDURE `TMP_TARDEBASIGNADASPRO`(
	-- SP para la generacion de distintos numeros de Tarjeta por BIN y SubBIN
	Par_ID 					BIGINT(20),			-- ID del numero de tarjeta por asociar

	Par_Salida				CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Descripcion del error

	Aud_EmpresaID			INT(11),			-- Parametro de  Auditoria
	Aud_Usuario				INT(11),			-- Parametro de  Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de  Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de  Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de  Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de  Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de  Auditoria
)
TerminaStored: BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(1);			-- Entero en Cero
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE SalidaSi				CHAR(1);		-- Salida SI
	DECLARE SalidaNo				CHAR(1);		-- Salida NO
	DECLARE Est_Exitoso				CHAR(1);		-- Estatus de asociacion Exitosa
	DECLARE Est_Fallido				CHAR(1);		-- Estatus de asociacion Fallida
	DECLARE Est_Registrado			CHAR(1);		-- Estatus de asociacion Registada

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(200);	-- Variable de control
	DECLARE Var_TablaTarjetas		VARCHAR(40);	-- Tabla con la informacion de tarjetas
	DECLARE Var_TablaExists			VARCHAR(40);	-- Tabla con la informacion de tarjetas
	DECLARE Error_Key				INT(11);		-- Numero de error
	DECLARE Var_CantTarjetas		INT(11);		-- Cantidad de tarjetas
	DECLARE Var_SubBin				VARCHAR(2);		-- SubBIN
	DECLARE Var_BinCompleto 		VARCHAR(10);	-- Cadena con BIN completo
	DECLARE Var_Contador			INT(11);		-- Contador de Vueltas
	DECLARE Var_Cantidad 			INT(11);		-- Cantidad de Vueltas
	DECLARE Var_NumTarjeta			VARCHAR(16);	-- Numero de tarjeta
	DECLARE Var_ID 					BIGINT(20);		-- ID del registro por asociar
	DECLARE Var_CompTajeta			VARCHAR(9);		-- Compuesto del SubBin y Consecutivo de tarjeta
	DECLARE Var_Estatus 			CHAR(1);		-- Estatus
	DECLARE Var_Consecutivo			BIGINT(12);		-- Consecutivo

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;			-- Entero en Cero
	SET Cadena_Vacia				:= '';			-- Cadena Vacia
	SET SalidaSi					:= 'S';			-- Salida SI
	SET SalidaNo					:= 'N';			-- Salida NO
	SET Est_Exitoso 				:= 'E';			-- Estatus de asociacion Exitosa
	SET Est_Fallido					:= 'F';			-- Estatus de asociacion Fallida
	SET Est_Registrado				:= 'R';			-- Estatus de asociacion Registrada

	-- Asignacion de valores por defecto
	SET Par_ID := IFNULL(Par_ID, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-TMP_TARDEBASIGNADASPRO');
				SET Var_Control:='SQLEXCEPTION';
			END;

		IF(Par_ID = Cadena_Vacia) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique el ID del numero de tarjeta a procesar.';
			SET Var_Control := 'numTarjeta';
			LEAVE ManejoErrores;
		END IF;


		SELECT 		ID,				CompTarjeta,			Estatus
			INTO 	Var_ID,			Var_CompTajeta,			Var_Estatus
			FROM TMP_TARDEBASIGNADAS
			WHERE ID = Par_ID;

		IF(IFNULL(Var_ID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'No se encontro el numero de tarjeta por asociar.';
			SET Var_Control := 'numTarjeta';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_Estatus, Cadena_Vacia) <> Est_Registrado) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El numero de tarjeta ha sido asociado previamente.';
			SET Var_Control := 'numTarjeta';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CompTajeta, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'Compuesto de tarjeta no valido.';
			SET Var_Control := 'numTarjeta';
			LEAVE ManejoErrores;
		END IF;

		CALL REGISTRATARDEBSAFIPRO (
			Var_CompTajeta,			SalidaNo,				Par_NumErr,				Par_ErrMen,				Var_Consecutivo,
			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion
		);

		IF(Par_NumErr = Entero_Cero) THEN
			UPDATE TMP_TARDEBASIGNADAS
				SET Estatus = Est_Exitoso,
					CodRespAsoc = Par_NumErr,
					MenRespAsoc = Par_ErrMen
				WHERE ID = Par_ID;
		ELSE
			UPDATE TMP_TARDEBASIGNADAS
				SET Estatus = Est_Fallido,
					CodRespAsoc = Par_NumErr,
					MenRespAsoc = Par_ErrMen
				WHERE ID = Par_ID;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Numero de tarjeta registrado correctamente.';
		SET Var_Control := '';
	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Entero_Cero  AS consecutivo;
	END IF;

END TerminaStored$$
