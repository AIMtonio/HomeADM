-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAENVIOCORREOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAENVIOCORREOACT`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAENVIOCORREOACT`(
	-- STORED PROCEDURE PARA ACTUALIZAR LA TABLA EDOCTAENVIOCORREO CON BASE EN LA TABLA EDOCTADATOSCTE
	Par_AnioMes			INT(11),			-- Periodo del estado de cuenta
	Par_ClienteID		INT(11),			-- ID de Cliente
	Par_FechaEnvio		DATETIME,			-- Fecha en la que se realiza el envio del correo
	Par_Productos		VARCHAR(100),		-- Cadena de Productos de credito
    Par_NumAct			TINYINT UNSIGNED,	-- Indica El tipo de Actualizacion que se realizara

	Par_Salida			CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr	INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen	VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error
	Par_EmpresaID		INT(11),			-- Parametros de Auditoria
	Aud_Usuario			INT(11),			-- Parametros de Auditoria

    Aud_FechaActual		DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal		INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametros de Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control							VARCHAR(50);		-- Variable de Control
	DECLARE Var_EstatusEnvio					CHAR(1);			-- Variable para recuperar el estatus de Envio de Correo del EdoCta
	DECLARE	Var_FechaEnvio						DATETIME;			-- Variable para recuperar la fecha de cuando se envio el EdoCta


	-- Declaracion de Constantes.
	DECLARE Var_SalidaSi						CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE Cadena_Vacia						CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia							DATE;				-- Fecha Vacia
	DECLARE Entero_Cero							INT(11);			-- Entero Cero
	DECLARE Entero_Dos							INT(11);			-- Entero Dos
	DECLARE	Var_PDFGeneradoSi					CHAR(1);			-- Indica que el PDF del Estado de Cuenta ha sido generado
	DECLARE	Var_Enviado							CHAR(1);			-- Estatus de Correo no Enviado (Estatus Default)
	DECLARE	Var_TipoCorreoEnv					INT(11);			-- Actualizacion de estatus de envio de correo
	DECLARE	Var_ActPDFGenerado					INT(11);			-- Actualización de estatus de PDF generado
	DECLARE	Var_EstEdoCtaXCli					INT(11);			-- Actualización de estatus de timbrado realizado por cliente
	DECLARE	Var_EstEdoCtaXPer					INT(11);			-- Actualización de estatus de timbrado realizado por periodo
	DECLARE	Var_EstEdoCtaXProd					INT(11);			-- Actualización de estatus de timbrado realizado por Producto

	-- Asignacion de Constantes
	SET	Var_SalidaSi							:= 'S';				-- El SP si genera una salida
	SET Cadena_Vacia							:= '';				-- Cadena Vacia
	SET Fecha_Vacia								:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero								:= 0;				-- Entero Cero
	SET Entero_Dos								:= 2;				-- Entero Dos
	SET	Var_Enviado								:= 'S';				-- Estatus de Correo de Estado de Cuenta Ya Enviado
	SET	Var_PDFGeneradoSi						:= 'S';				-- El PDF del Estado de Cuenta si se ha generado
	SET	Var_TipoCorreoEnv						:= 1;				-- Tipo de Actualizacion para indicar Registro como Correo Enviado
	SET	Var_ActPDFGenerado						:= 2;				-- Tipo de Actualizacion para indicar si el PDF del Estado de Cuenta ha sido generado
	SET	Var_EstEdoCtaXCli						:= 3;				-- Tipo de Actualizacion para modificar el parametro EstatusEdoCta por cliente
	SET	Var_EstEdoCtaXPer						:= 4;				-- Tipo de Actualizacion para modificar el parametro EstatusEdoCta por periodo
	SET	Var_EstEdoCtaXProd						:= 5;				-- Actualización de estatus de timbrado realizado por Producto

	-- Valores por default
	SET Par_AnioMes								:= IFNULL(Par_AnioMes, Entero_Cero);
	SET Par_ClienteID							:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_FechaEnvio							:= IFNULL(Par_FechaEnvio, Fecha_Vacia);
	SET Par_NumAct								:= IFNULL(Par_NumAct, Entero_Cero);

	ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAENVIOCORREOACT');
			SET Var_Control = 'sqlException';
		END;

		IF (Par_NumAct = Entero_Cero) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El Tipo de Actualizacion no se especifico o esta vacio.';
			SET Var_Control := 'Par_NumAct';
			LEAVE ManejoErrores;
		END IF;

		-- Tipo de Actualizacion para indicar Registro como Correo Enviado
		IF (Par_NumAct = Var_TipoCorreoEnv) THEN
			IF (Par_AnioMes = Entero_Cero) THEN
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen	:= 'El periodo esta vacio';
				SET Var_Control := 'Par_AnioMes';
				LEAVE ManejoErrores;
			END IF;

			IF (Par_ClienteID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'El Numero de Cliente esta vacio';
				SET Var_Control := 'ClienteID';
				LEAVE ManejoErrores;
			END IF;

			IF (Par_FechaEnvio = Fecha_Vacia) THEN
				SET	Par_NumErr 	:= 004;
				SET	Par_ErrMen	:= 'El Numero de Cliente esta vacio';
				SET Var_Control := 'FechaEnvio';
				LEAVE ManejoErrores;
			END IF;

			SELECT	IFNULL(EstatusEnvio, Cadena_Vacia), IFNULL(FechaEnvio, Fecha_Vacia)
				INTO Var_EstatusEnvio, Var_FechaEnvio
				FROM EDOCTAENVIOCORREO
				WHERE	AnioMes = Par_AnioMes
				  AND	ClienteID = Par_ClienteID;

			SET Var_EstatusEnvio	= IFNULL(Var_EstatusEnvio, Cadena_Vacia);
			SET Var_FechaEnvio		= IFNULL(Var_FechaEnvio, Fecha_Vacia);

			IF (Var_EstatusEnvio = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 005;
				SET	Par_ErrMen	:= CONCAT('El Cliente [', CAST(Par_ClienteID AS CHAR) ,'] no existe en el registro de Estados de Cuenta por Enviar para el Periodo ', CAST(Par_AnioMes AS CHAR));
				SET Var_Control := 'ClienteID';
				LEAVE ManejoErrores;
			END IF;

			IF (Var_EstatusEnvio = Var_Enviado) THEN
				SET	Par_NumErr 	:= 006;
				SET	Par_ErrMen	:= CONCAT('El Estado de Cuenta para el cliente [', CAST(Par_ClienteID AS CHAR) ,'] ya fue enviado con anterioridad el ', DATE_FORMAT(Var_FechaEnvio, '%d/%m/%Y')) ;
				SET Var_Control := 'ClienteID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE EDOCTAENVIOCORREO SET
				EstatusEnvio	= Var_Enviado,
				FechaEnvio		= Par_FechaEnvio,
				UsuarioEnvia	= Aud_Usuario,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE AnioMes	= Par_AnioMes
				  AND ClienteID = Par_ClienteID;

			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'Estado de Cuenta Enviado con Exito';
			SET Var_Control := 'Par_AnioMes';
			LEAVE ManejoErrores;
		END IF;
		-- Se agrega una actualizacion para colocar el estatus PDFGenerado como Si. Cardinal Sistemas Inteligentes
		IF (Par_NumAct = Var_ActPDFGenerado) THEN
			UPDATE EDOCTAENVIOCORREO SET
				PDFGenerado		= Var_PDFGeneradoSi,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE AnioMes	= Par_AnioMes
				  AND ClienteID = Par_ClienteID;
		
            UPDATE EDOCTAHISCDATOSCTE SET
					PDFGenerado	= CASE Estatus WHEN 1 THEN "S"
											   WHEN 2 THEN "D"
											   WHEN 3 THEN "D"
								  ELSE PDFGenerado  END
				WHERE Periodo	= Par_AnioMes
				  AND ClienteID = Par_ClienteID
                  AND IFNULL(PDFGenerado, "N") ="N";
		
			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'PDF Generado con Exito';
			SET Var_Control := 'Par_AnioMes';
			LEAVE ManejoErrores;
		END IF;
		-- Fin de actualizacion. Cardinal Sistemas Inteligentes

		-- Se agrega una actualizacion para el estatus EstatusEdoCta de un cliente en base a la tabla EDOCTADATOSCTE. Cardinal Sistemas Inteligentes
		IF (Par_NumAct = Var_EstEdoCtaXCli) THEN
			UPDATE EDOCTAENVIOCORREO AS ENVIO
				INNER JOIN EDOCTADATOSCTE AS CTE ON CTE.ClienteID = ENVIO.ClienteID
				SET ENVIO.EstatusEdoCta		= CTE.Estatus,
					ENVIO.EmpresaID			= Par_EmpresaID,
					ENVIO.Usuario			= Aud_Usuario,
					ENVIO.FechaActual		= Aud_FechaActual,
					ENVIO.DireccionIP		= Aud_DireccionIP,
					ENVIO.ProgramaID		= Aud_ProgramaID,
					ENVIO.Sucursal			= Aud_Sucursal,
					ENVIO.NumTransaccion	= Aud_NumTransaccion
				WHERE ENVIO.AnioMes = Par_AnioMes
				  AND ENVIO.ClienteID = Par_ClienteID;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Estatus de Estado de Cuenta por Cliente actualizado con Exito';
			SET Var_Control	:= 'Par_AnioMes';
			LEAVE ManejoErrores;
		END IF;
		-- Fin de actualizacion. Cardinal Sistemas Inteligentes

		-- Se agrega una actualizacion para los estatus EstatusEdoCta de un periodo en base a la tabla EDOCTADATOSCTE. Cardinal Sistemas Inteligentes
		IF (Par_NumAct = Var_EstEdoCtaXPer) THEN
			UPDATE EDOCTAENVIOCORREO AS ENVIO
				INNER JOIN EDOCTADATOSCTE AS CTE ON CTE.ClienteID = ENVIO.ClienteID
				SET ENVIO.EstatusEdoCta		= CTE.Estatus,
					ENVIO.EmpresaID			= Par_EmpresaID,
					ENVIO.Usuario			= Aud_Usuario,
					ENVIO.FechaActual		= Aud_FechaActual,
					ENVIO.DireccionIP		= Aud_DireccionIP,
					ENVIO.ProgramaID		= Aud_ProgramaID,
					ENVIO.Sucursal			= Aud_Sucursal,
					ENVIO.NumTransaccion	= Aud_NumTransaccion
				WHERE ENVIO.AnioMes = Par_AnioMes
				  AND ENVIO.EstatusEdoCta <> Entero_Dos;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Estatus de Estados de Cuenta por Periodo actualizados con Exito';
			SET Var_Control	:= 'Par_AnioMes';
			LEAVE ManejoErrores;
		END IF;
		-- Fin de actualizacion. Cardinal Sistemas Inteligentes
       
        -- Se agrega una actualizacion para el estatus EstatusEdoCta de PRODUCTO en base a la tabla EDOCTADATOSCTE.
		IF (Par_NumAct = Var_EstEdoCtaXProd) THEN
			UPDATE EDOCTAENVIOCORREO AS ENVIO
				INNER JOIN EDOCTADATOSCTE AS CTE ON CTE.ClienteID = ENVIO.ClienteID
				SET ENVIO.EstatusEdoCta		= CTE.Estatus,
					ENVIO.EmpresaID			= Par_EmpresaID,
					ENVIO.Usuario			= Aud_Usuario,
					ENVIO.FechaActual		= Aud_FechaActual,
					ENVIO.DireccionIP		= Aud_DireccionIP,
					ENVIO.ProgramaID		= Aud_ProgramaID,
					ENVIO.Sucursal			= Aud_Sucursal,
					ENVIO.NumTransaccion	= Aud_NumTransaccion
				WHERE ENVIO.AnioMes = Par_AnioMes
				  AND FIND_IN_SET(CTE.ProductoCredID, Par_Productos) > 0;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Estatus de Estado de Cuenta por Producto Actualizado con Exito';
			SET Var_Control	:= 'Par_AnioMes';
			LEAVE ManejoErrores;
		END IF;
       
       
       
	END ManejoErrores; -- Fin del bloque manejo de errores

	IF (Par_Salida = Var_SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;
END TerminaStore$$