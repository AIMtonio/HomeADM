-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBASIGNADASBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBASIGNADASBAJ`;
DELIMITER $$

CREATE PROCEDURE `TARDEBASIGNADASBAJ`(
	-- SP para la generacion de distintos numeros de Tarjeta por BIN y SubBIN
	Par_LoteDebSAFIID 		INT(11),				-- ID Lote de TARJETAS

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

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;			-- Entero en Cero
	SET Cadena_Vacia				:= '';			-- Cadena Vacia
	SET SalidaSi					:= 'S';			-- Salida SI
	SET SalidaNo					:= 'N';			-- Salida NO

	-- Asignacion de valores por defecto
	SET Par_LoteDebSAFIID := IFNULL(Par_LoteDebSAFIID, Cadena_Vacia);


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-TARDEBASIGNADASBAJ');
				SET Var_Control:='SQLEXCEPTION';
			END;

		IF(Par_LoteDebSAFIID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique el ID del Lote de tarjetas.';
			SET Var_Control := 'loteDebSAFIID';
			LEAVE ManejoErrores;
		END IF;

		DELETE
			FROM TARDEBASIGNADAS
			WHERE LoteDebSAFIID = Par_LoteDebSAFIID;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Tarjetas eliminadas correctamente.';
		SET Var_Control := '';
	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Entero_Cero  AS consecutivo;
	END IF;

END TerminaStored$$
