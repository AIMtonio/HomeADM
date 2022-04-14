-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_TARDEBASIGNADASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMP_TARDEBASIGNADASACT`;
DELIMITER $$

CREATE PROCEDURE `TMP_TARDEBASIGNADASACT`(
	-- SP para la generacion de distintos numeros de Tarjeta por BIN y SubBIN
	Par_ID 					BIGINT(20),			-- ID del numero de tarjeta por asociar
	Par_NumAct 				INT(11),			-- Numero de Actualizacion

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
	DECLARE Est_Cancelado			CHAR(1);		-- Estatus de asociacion Cancelada
	DECLARE Est_Registrado			CHAR(1);		-- Estatus de asociacion Registada
	DECLARE Act_Cancelacion 		TINYINT;		-- Opcion para cancelacion

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
	SET Est_Cancelado				:= 'C';			-- Estatus de asociacion Cancelada
	SET Est_Registrado				:= 'R';			-- Estatus de asociacion Registrada
	SET Act_Cancelacion 			:= 1;		-- Opcion para cancelacion

	-- Asignacion de valores por defecto
	SET Par_ID := IFNULL(Par_ID, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-TMP_TARDEBASIGNADASACT');
				SET Var_Control:='SQLEXCEPTION';
			END;

		IF(Par_NumAct = Act_Cancelacion) THEN
			UPDATE TMP_TARDEBASIGNADAS
				SET Estatus = Est_Cancelado
				WHERE Estatus IN (Est_Fallido, Est_Registrado)
				AND NumTransaccion = Aud_NumTransaccion;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := 'Tarjetas en temporal canceladas correctamete.';
			SET Var_Control := '';
		END IF;
	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Entero_Cero  AS consecutivo;
	END IF;

END TerminaStored$$
