-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAENVIOCORREOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAENVIOCORREOPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTAENVIOCORREOPRO`(
	-- STORED PROCEDURE PARA LLENAR LA TABLA EDOCTAENVIOCORREO CON BASE EN LA TABLA EDOCTADATOSCTE
	Par_AnioMes			INT(11),		-- Periodo del estado de cuenta
	Par_ActCorreo		CHAR(1),		-- Indica si a los registros existentes del periodo procesado se les actualizara el correo, en caso que uno o mas clientes tenga actualizado el correo

	Par_Salida			CHAR(1),		-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr	INT(11),		-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen	VARCHAR(400),	-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID		INT(11),		-- Parametros de Auditoria
	Aud_Usuario			INT(11),		-- Parametros de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametros de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametros de Auditoria
	Aud_Sucursal		INT(11),		-- Parametros de Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de Control

	-- Declaracion de Constantes.
	DECLARE Var_SalidaSi			CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia				DATE;				-- Fecha Vacia
	DECLARE Entero_Cero				INT(11);			-- Entero Cero
	DECLARE	Est_NoEnviado			CHAR(1);			-- Estatus de Correo no Enviado (Estatus Default)
	DECLARE	Var_ActualizaCorreo		CHAR(1);			-- Indica que si se debe actualizar el correo
	DECLARE	Var_PDFGeneradoNo		CHAR(1);			-- Indica que el PDF del Estado de Cuenta ha sido generado (Default)

	-- Asignacion de Constantes
	SET	Var_SalidaSi				:= 'S';				-- El SP si genera una salida
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET	Est_NoEnviado				:= 'N';				-- Estatus de Correo de Estado de Cuenta no Enviado
	SET	Var_ActualizaCorreo			:= 'S';				-- Indica que si se debe actualizar el correo
	SET	Var_PDFGeneradoNo			:= 'N';				-- El PDF del Estado de Cuenta no se ha generado

	-- Valores por default
	SET Par_AnioMes			:= IFNULL(Par_AnioMes, Entero_Cero);
	SET Par_ActCorreo		:= IFNULL(Par_ActCorreo, Cadena_Vacia);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAENVIOCORREOPRO');
			SET Var_Control = 'sqlException';
		END;

		IF (Par_AnioMes = Entero_Cero) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El periodo esta vacio';
			SET Var_Control := 'Par_AnioMes';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_ActCorreo = Cadena_Vacia) THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'No se especifico si se actualizaran o no los correos';
			SET Var_Control := 'Par_ActCorreo';
			LEAVE ManejoErrores;
		END IF;

		-- Inserta Los Registros que se tienen en Datos Cliente del EdoCta y no estan en la tabla de envio de Correo
		INSERT INTO EDOCTAENVIOCORREO
		SELECT	EdoCta.AnioMes,					EdoCta.ClienteID,				EdoCta.SucursalID,					COALESCE(Cli.Correo, Cadena_Vacia) AS CorreoEnvio,	EdoCta.Estatus AS EstatusEdoCta,
				Est_NoEnviado AS EstatusEnvio,	Fecha_Vacia AS FechaEnvio,		Entero_Cero AS UsuarioEnvia,		Var_PDFGeneradoNo AS PDFGenerado,					Par_EmpresaID,
				Aud_Usuario,					Aud_FechaActual,				Aud_DireccionIP,					Aud_ProgramaID,										Aud_Sucursal,
				Aud_NumTransaccion
			FROM EDOCTADATOSCTE EdoCta
			INNER JOIN CLIENTES Cli ON Cli.ClienteID = EdoCta.ClienteID
			LEFT JOIN EDOCTAENVIOCORREO Correo ON EdoCta.AnioMes = Correo.AnioMes AND EdoCta.ClienteID = Correo.ClienteID
			WHERE Correo.ClienteID IS NULL;

		IF Par_ActCorreo = Var_ActualizaCorreo THEN
			-- Actualizar campos de Registros que no se han enviado.
			UPDATE EDOCTAENVIOCORREO Correo
			INNER JOIN EDOCTADATOSCTE EdoCta on EdoCta.AnioMes = Correo.AnioMes AND EdoCta.ClienteID = Correo.ClienteID
			INNER JOIN CLIENTES Cli on EdoCta.ClienteID = Cli.ClienteID
			SET	Correo.CorreoEnvio = COALESCE(Cli.Correo, Cadena_Vacia),
				Correo.EstatusEdoCta = EdoCta.Estatus
			WHERE Correo.EstatusEnvio = Est_NoEnviado;
		END IF;

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'Registro de Estados de Cuenta para Envio por Correo Finalizado con exito';
		SET Var_Control := 'Par_AnioMes';
		LEAVE ManejoErrores;
	END ManejoErrores; -- Fin del bloque manejo de errores

	IF (Par_Salida = Var_SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;
END TerminaStore$$