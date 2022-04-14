-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLPARAMBROKERACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLPARAMBROKERACT`;DELIMITER $$

CREATE PROCEDURE `PSLPARAMBROKERACT`(
	-- Stored procedure para actualizar los parametros del broker
	Par_LlaveParametro 		VARCHAR(50),				-- Llave del parametro
	Par_ValorParametro 		VARCHAR(200),				-- Valor del parametro

	Par_NumAct				INT(11),					-- OPcion de actualizacion

	Par_Salida				CHAR(1),					-- Parametro para salida de datos
    inout Par_NumErr		INT(11),					-- Parametro de entrada/salida de numero de error
    inout Par_ErrMen		VARCHAR(400),				-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID			INT(11),					-- Parametros de auditoria
	Aud_Usuario				INT(11),					-- Parametros de auditoria
	Aud_FechaActual			DATETIME,					-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),				-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),				-- Parametros de auditoria
	Aud_Sucursal			INT(11),					-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT						-- Parametros de auditoria
)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
DECLARE	Entero_Cero				INT;					-- Entero vacio
DECLARE	SalidaSI				CHAR(1);				-- Salida SI (S)
DECLARE Act_PorLlave 			TINYINT;				-- Tipo de actualizacion por llave
DECLARE Var_LlaveURLHubServ		VARCHAR(30);			--
DECLARE Var_LlaveUsuHubServ		VARCHAR(30);
DECLARE Var_LlavePassHubServ	VARCHAR(30);
DECLARE Var_LlaveHoraActProd	VARCHAR(30);
DECLARE Var_LlaveActDiaProd		VARCHAR(30);
DECLARE Var_LlaveUltActProd		VARCHAR(30);
DECLARE Var_LlaveActProd		VARCHAR(30);

-- Declaracion de variables
DECLARE Var_ValorParametro		VARCHAR(200);			-- Variable para almacenar el valor del parametro
DECLARE Var_LlaveParametro		VARCHAR(50);			-- Variable para almacenar la llave del parametro
DECLARE Var_Control				VARCHAR(50);			-- Variable de control


-- Asignacion de valor a constantes
SET Cadena_Vacia        		:= '';					-- Cadena vacia
SET	Entero_Cero					:= 0;					-- Entero vacio
SET	SalidaSI					:= 'S';					-- Salida SI (S)
SET Act_PorLlave 				:= 1;					-- Tipo de actualizacion por llav
SET Var_LlaveURLHubServ			:= "URLHubServicios";
SET Var_LlaveUsuHubServ			:= "UsuarioHubServicios";
SET Var_LlavePassHubServ		:= "PasswordHubServicios";
SET Var_LlaveHoraActProd		:= "HoraActulizacioProductos";
SET Var_LlaveActDiaProd			:= "ActualizacionDiariaProductos";
SET Var_LlaveUltActProd			:= "FechaUltimaActualizacion";
SET Var_LlaveActProd			:= "ActualizandoProductos";

ManejoErrores: BEGIN

	IF(Par_NumAct = Act_PorLlave) THEN
		SELECT 		ValorParametro,  		LLaveParametro
			INTO 	Var_ValorParametro, 	Var_LlaveParametro
			FROM PSLPARAMBROKER
			WHERE LLaveParametro = Par_LlaveParametro;

		IF(Var_LlaveParametro IS NULL) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'Parametro no encontrado.';
			SET Var_Control := 'LLaveParametro';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_LlaveParametro = Var_LlaveActDiaProd) THEN
			IF(Par_ValorParametro IS NULL OR Par_ValorParametro = Cadena_Vacia) THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'Especifique el valor de actualizacion diaria';
				SET Var_Control := 'ValorParametro';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_LlaveParametro = Var_LlaveHoraActProd) THEN
			IF(Par_ValorParametro IS NULL OR Par_ValorParametro = Cadena_Vacia) THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'Especifique la hora de actualizacion.';
				SET Var_Control := 'ValorParametro';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_LlaveParametro = Var_LlaveUsuHubServ) THEN
			IF(Par_ValorParametro IS NULL OR Par_ValorParametro = Cadena_Vacia) THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'Especifique el usuario.';
				SET Var_Control := 'ValorParametro';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_LlaveParametro = Var_LlavePassHubServ) THEN
			IF(Par_ValorParametro IS NULL OR Par_ValorParametro = Cadena_Vacia) THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'Especifique la contraseña';
				SET Var_Control := 'ValorParametro';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_LlaveParametro = Var_LlaveURLHubServ) THEN
			IF(Par_ValorParametro IS NULL OR Par_ValorParametro = Cadena_Vacia) THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'Especifique la URL del Proveedor de servicios';
				SET Var_Control := 'ValorParametro';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		UPDATE PSLPARAMBROKER
			SET ValorParametro 	= Par_ValorParametro,
				EmpresaID 		= Aud_EmpresaID,
				Usuario 		= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID 		= Aud_ProgramaID,
				Sucursal 		= Aud_Sucursal,
				NumTransaccion 	= Aud_NumTransaccion
			WHERE LLaveParametro = Par_LlaveParametro;

		SET Par_NumErr  := 0;
		SET Par_ErrMen  := 'Parametro actualizado correctamente.';
		SET Var_Control := 'LLaveParametro';
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr  := 1;
	SET Par_ErrMen  := 'Opcion de actualizacion desconocida.';
	SET Var_Control := 'LLaveParametro';

END ManejoErrores;


IF (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
END IF;

END TerminaStore$$