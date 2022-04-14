-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBASIGNADASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBASIGNADASALT`;
DELIMITER $$

CREATE PROCEDURE `TARDEBASIGNADASALT`(
	-- SP para la generacion de distintos numeros de Tarjeta por BIN y SubBIN
	Par_NumTarjeta 			VARCHAR(16),			-- Numero de Tarjeta
	Par_NumBin				VARCHAR(8),				-- Numero de BIN de la tarjeta
	Par_NumSubBin			VARCHAR(2),				-- Numero de SubBIN de la tarjeta
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
	SET Par_NumTarjeta := IFNULL(Par_NumTarjeta, Cadena_Vacia);
	SET Par_NumBin := IFNULL(Par_NumBin, Cadena_Vacia);
	SET Par_NumSubBin := IFNULL(Par_NumSubBin, Cadena_Vacia);
	SET Par_LoteDebSAFIID := IFNULL(Par_LoteDebSAFIID, Cadena_Vacia);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-TARDEBASIGNADASALT');
				SET Var_Control:='SQLEXCEPTION';
			END;

		IF(Par_NumTarjeta = Cadena_Vacia) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique el numero de tarjeta a registrar.';
			SET Var_Control := 'numTarjeta';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumBin = Cadena_Vacia) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'Especifique el BIN de la tarjeta a registrar.';
			SET Var_Control := 'numTarjeta';
			LEAVE ManejoErrores;
		END IF;

		SELECT 		NumTarjeta
			INTO 	Var_NumTarjeta
			FROM TARDEBASIGNADAS
			WHERE NumTarjeta = Par_NumTarjeta;
		SET Var_NumTarjeta:= IFNULL(Var_NumTarjeta, Cadena_Vacia);

		IF(Var_NumTarjeta <> Cadena_Vacia) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El numero de tarjeta ha sido registrado previamente.';
			SET Var_Control := 'numTarjeta';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_LoteDebSAFIID = Entero_Cero) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'Especifique el ID del Lote de tarjetas.';
			SET Var_Control := 'loteDebSAFIID';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO TARDEBASIGNADAS(
				NumTarjeta,				NumBin,					NumSubBin,				LoteDebSAFIID,				Usuario,
				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,					NumTransaccion
			)
			VALUES (
				Par_NumTarjeta,			Par_NumBin,				Par_NumSubBin,			Par_LoteDebSAFIID,			Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
			);

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
