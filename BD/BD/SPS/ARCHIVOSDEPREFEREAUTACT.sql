-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOSDEPREFEREAUTACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOSDEPREFEREAUTACT`;
DELIMITER $$

CREATE PROCEDURE `ARCHIVOSDEPREFEREAUTACT`(
	Par_ConsecutivoID		INT(11),			-- Valor consecutivo de la tabla
	Par_Estatus				CHAR(1),			-- Estatus al que se actualizara
	Par_NumAct				INT(11),			-- Numero de Actualiacion
	Par_Salida				CHAR(1),			-- Indica si se espera una salida
	INOUT Par_NumErr		INT(11),			-- Parametro de salida para el numero de error o exito
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de salida para el mensaje de error o exito
	Aud_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria

	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(50);	-- Variable de control
	DECLARE Var_Contador		INT(11);		-- Contador para el WHILE
	DECLARE Var_Tamanio			INT(11);		-- Tamanio de la tabla
	DECLARE Var_Cuenta			INT(11);		-- Cuenta si existe registro de un archivo
	DECLARE Var_RutaArchivo		VARCHAR(300);	-- Ruta del archivo a buscar
	DECLARE Var_Consecutivo		VARCHAR(50);	-- Consecutivo de la  tabla
	-- Declaracion de constantes
	DECLARE	Entero_Cero 	INT(11); 		-- Constante Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia		DATE;			-- Constante Fecha Vacia
	DECLARE SalidaSI		CHAR(1);		-- Constante Salida SI
	DECLARE Con_Principal	INT(11);		-- Constante para la actualizacion por el ktr

	-- Seteo de valores
	SET Entero_Cero		:= 0;
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET SalidaSI		:= 'S';
	SET Aud_FechaActual := NOW();
	SET Con_Principal	:= 1;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciones. Ref: SP-ARCHIVOSDEPREFEREAUTACT');
			SET Var_Control	:='SQLEXCEPTION';
		END;


		IF Par_NumAct = Con_Principal THEN

			SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero) INTO Var_Tamanio
			FROM ARCHIVOSDEPREFEREAUT;

			SET Var_Contador := 1;

			ActualizaEstatus: WHILE Var_Contador <= Var_Tamanio DO

				SELECT RutaArchivo INTO Var_RutaArchivo
				FROM ARCHIVOSDEPREFEREAUT
				WHERE ConsecutivoID = Var_Contador;

				SET Var_RutaArchivo := IFNULL(Var_RutaArchivo,Cadena_Vacia);

				SELECT IFNULL(COUNT(ConsecutivoID),Entero_Cero) INTO Var_Cuenta
				FROM DEPREFAUTOMATICO
				WHERE RutaArchivo = Var_RutaArchivo;

				IF Var_Cuenta != Entero_Cero THEN

					UPDATE ARCHIVOSDEPREFEREAUT
					SET Estatus = 'T'
					WHERE ConsecutivoID = Var_Contador;

				END IF;

				SET Var_Contador := Var_Contador+1;

			END WHILE ActualizaEstatus;

			SET Var_Consecutivo := Entero_Cero;

			-- Eliminacion de la tabla temporal
			DELETE FROM TMPCABECERADEPREFAUTO;

		END IF;

		SET Par_NumErr :=0;
		SET Par_ErrMen := 'Registro Actualizado Correctamente';
		SET Var_Control := Cadena_Vacia;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS Control,
				Var_Consecutivo	AS Consecutivo;
	END IF;
END TerminaStore$$