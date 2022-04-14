-- UNIFICACAMBIACLIENTEPRO
DELIMITER ;

DROP PROCEDURE IF EXISTS `UNIFICACAMBIACLIENTEPRO`;
DELIMITER $$

CREATE PROCEDURE UNIFICACAMBIACLIENTEPRO (
# =====================================================================================
# ------- STORE PARA ACTUALIZAR EL CLIENTEID A UNIFICAR EN LAS TABLAS QUE TIENEN CLIENTE ---------
# =====================================================================================
	Par_Tipo 					CHAR(1),		-- Indica el tipo de Proceso S= Generar Sentencia y A= Actualizar

	Par_Salida					CHAR(1), 		-- Indica mensaje de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Descripcion de Error
/* Parametros de Auditoria */
	Par_EmpresaID 				INT(11),		-- Parametro de Auditoria
	Aud_Usuario 				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual 			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN


-- Declaracion de Variables
	DECLARE Var_Control 			VARCHAR(30);		-- Var Control del Manejo de Errores
	DECLARE Var_Sentencia			VARCHAR(5000);		-- Variable para sentencia
	DECLARE Var_Bitacora			VARCHAR(5000);		-- Variable para sentencia de Bitacora
	DECLARE Var_Consecutivo			INT(11);			-- Consecutivo
	DECLARE Var_TotalRegistros		INT(11);			-- Variable para el total de registros a iterar

	DECLARE	Var_NombreTabla 		VARCHAR(50);		-- Variable para tabla
	DECLARE	Var_CampoDistinto 		CHAR(2);			-- Variable para conocer si el campo es distinto a ClienteID
	DECLARE	Var_Campo				VARCHAR(40);		-- Variable para el Campo
	DECLARE	Var_Condicion 			VARCHAR(60);		-- Variable para la Condicion de la actualizacion
	DECLARE Error_Key				INT(11);			-- Codigo de error de la transaccion

	DECLARE Var_Estatus 			CHAR(1);			-- Variable para el Estatus

-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Fecha_Vacia				DATE;
	DECLARE SalidaSI				CHAR(1);

	DECLARE SalidaNO 				CHAR(1);
	DECLARE Var_TipoSentencia		CHAR(1);
	DECLARE Var_TipoActualiza 		CHAR(1);
	DECLARE Var_TablaActualizada	CHAR(1);

-- Asignacion de Constantes
	SET Entero_Cero				:= 0;					-- Entero Cero
	SET Cadena_Vacia			:= '';					-- Cadena Vacia
	SET Decimal_Cero			:= 0.00;				-- DECIMAL Cero
	SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET SalidaSI				:= 'S';					-- El Store SI genera una Salida
	SET SalidaNO				:= 'N';					-- Salida No

	SET Var_TipoSentencia 		:= 'S';					-- Tipo de Proceso para crear la Sentencia Update
	SET Var_TipoActualiza		:= 'A';					-- Tipo de Proceso para Actualizar las tablas.
	SET Var_TablaActualizada 	:= 'U';					-- Constante para indicar que la tabla esta Actualizada

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr 	:= '999';
				SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-UNIFICACAMBIACLIENTEPRO');
				SET Var_Control := 'sqlException';

			END;


	IF Par_Tipo = Var_TipoSentencia THEN

		/* INICIO Crear bitacora de cada tabla previo a la actualizacion del clienteID*/

		SELECT	COUNT(Tabla)
			INTO Var_TotalRegistros
			FROM TMPUNIFICATABLACLI;

		SET Var_Consecutivo := 1;

		IteraRegistros: WHILE (Var_Consecutivo <= Var_TotalRegistros) DO

			SELECT	Tabla
				INTO Var_NombreTabla
			FROM TMPUNIFICATABLACLI
			WHERE NumRegistro = Var_Consecutivo;

			SET Var_Bitacora 	:= "INSERT INTO TMPUNIFICABITACORA ";
			SET Var_Bitacora 	:= CONCAT(Var_Bitacora, "SELECT ",Var_Consecutivo,",'", Var_NombreTabla,"',", "COUNT('X'), 'P', '' FROM `",Var_NombreTabla,'`;');

			SET @Sentencia  := (Var_Bitacora);

			PREPARE SPUNIFICA FROM @Sentencia;
			EXECUTE SPUNIFICA;
			DEALLOCATE PREPARE SPUNIFICA;

			SET Var_Consecutivo := Var_Consecutivo +1;

		END WHILE IteraRegistros;
		/*FIN */


		SET Var_TotalRegistros := 0;

		SELECT	COUNT(Tabla)
			INTO Var_TotalRegistros
			FROM TMPUNIFICATABLACLI;

		SET Var_Consecutivo := 1;

		IteraSentenciaCliente: WHILE (Var_Consecutivo <= Var_TotalRegistros) DO
		-- SE INICIALIZAN VARIABLES
			SET Var_NombreTabla 			:= Cadena_Vacia;
			SET Var_CampoDistinto	:= Cadena_Vacia;
			SET Var_Campo 			:= Cadena_Vacia;
			SET Var_Condicion 		:= Cadena_Vacia;


			SELECT Tabla, CampoDistinto, Campo, Condicion
				INTO Var_NombreTabla, Var_CampoDistinto, Var_Campo, Var_Condicion
			FROM TMPUNIFICATABLACLI
			WHERE NumRegistro = Var_Consecutivo;


			SET Var_Sentencia := CONCAT('UPDATE `',Var_NombreTabla,'` C, CLIENTESCAPTACION T SET ');


			IF Var_CampoDistinto = 'SI' THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,'C.',Var_Campo,' = T.ClienteIDUpd ');
				SET Var_Sentencia := CONCAT(Var_Sentencia,'WHERE C.',Var_Campo,' = T.ClienteID ');

				IF TRIM(Var_Condicion) !=  Cadena_Vacia THEN
					SET Var_Sentencia := CONCAT(Var_Sentencia,'AND ',Var_Condicion);
				END IF;
			ELSE
				SET Var_Sentencia := CONCAT(Var_Sentencia,'C.ClienteID = T.ClienteIDUpd ');
				SET Var_Sentencia := CONCAT(Var_Sentencia,'WHERE C.ClienteID = T.ClienteID ');
			END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND  (T.ClienteIDUpd IS NOT NULL
														 OR T.ClienteIDUpd != 0);');
			-- 		AND 1 = 0 ;');


			UPDATE TMPUNIFICABITACORA SET
				Sentencia = Var_Sentencia
			WHERE Tabla = Var_NombreTabla;


			SET Var_Consecutivo := Var_Consecutivo +1;

		END WHILE IteraSentenciaCliente;

	END IF;


	IF Par_Tipo = Var_TipoActualiza THEN


		SET Var_TotalRegistros := 0;

		SELECT	COUNT(Tabla)
			INTO Var_TotalRegistros
			FROM TMPUNIFICATABLACLI;

		SET Var_Consecutivo := 1;

		IteraCambiaCliente: WHILE (Var_Consecutivo <= Var_TotalRegistros) DO
		-- SE INICIALIZAN VARIABLES
			SET Var_NombreTabla 			:= Cadena_Vacia;
			SET Var_Sentencia		:= Cadena_Vacia;
			SET Var_Estatus			:= Cadena_Vacia;


			SELECT Tabla
				INTO Var_NombreTabla
			FROM TMPUNIFICATABLACLI
			WHERE NumRegistro = Var_Consecutivo;

			SELECT Sentencia, Estatus
				INTO Var_Sentencia, Var_Estatus
			FROM TMPUNIFICABITACORA
			WHERE Tabla 	=  Var_NombreTabla
			LIMIT 1;


			IF Var_Estatus 	!= Var_TablaActualizada THEN

				SET FOREIGN_KEY_CHECKS = 0;

				SET @Sentencia := (Var_Sentencia);

				START TRANSACTION;
				Iteraciones: BEGIN
					DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
					DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
					DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
					DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

					SET Error_Key	:= Entero_Cero;
					SET Par_NumErr	:= Entero_Cero;
					SET Par_ErrMen	:= Cadena_Vacia;

					PREPARE UNIFICACLI FROM @Sentencia;
					EXECUTE UNIFICACLI;
					DEALLOCATE PREPARE UNIFICACLI;

				END Iteraciones;

				IF Error_Key = Entero_Cero THEN
					COMMIT;

					UPDATE TMPUNIFICABITACORA SET
						Estatus = Var_TablaActualizada
					WHERE Tabla = Var_NombreTabla;
				ELSE
					ROLLBACK;
				END IF;

				SET FOREIGN_KEY_CHECKS = 1;

			END IF;

			SET Var_Consecutivo := Var_Consecutivo +1;

		END WHILE IteraCambiaCliente;

	END IF;


	SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso de cambio de ClienteId termino Exitosamente.';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT 	Par_NumErr			AS codigoRespuesta,
				Par_ErrMen			AS mensajeRespuesta,
				Var_NombreTabla  	AS tabla;
	END IF;

END TerminaStore$$