-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVIOMENSAJEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSENVIOMENSAJEALT`;

DELIMITER $$
CREATE PROCEDURE `SMSENVIOMENSAJEALT`(
	# ===================================================================
	# ----------- SP PARA ENVIO DE  LOS MENSAJES SMS---------
	# ===================================================================
	Par_Remitente		VARCHAR(45),
	Par_Receptor		VARCHAR(45),
	Par_FechaRealEnvio  DATETIME,
	Par_Mensaje 		VARCHAR(400),
	Par_FechaProgEnvio  DATETIME,

	Par_CampaniaID		INT(11),
	Par_FechaResp		DATETIME,
	Par_CtaAsoc     	VARCHAR(45),
	Par_NumCliente  	VARCHAR(45),
	Par_DatosCliente	VARCHAR(150),
	Par_SistemaID		VARCHAR(50),

	Par_Salida			CHAR(1),
	inout Par_NumErr    INT(11),
	inout Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(100);
	DECLARE Consecutivo			VARCHAR(100);
	
	-- Declaracion de constantes
	DECLARE  Entero_Cero		INT(11);
	DECLARE  SalidaSI			CHAR(1);
	DECLARE  SalidaNO			CHAR(1);
	DECLARE  Cadena_Vacia		CHAR(1);
	DECLARE  EstatusNE			CHAR(1);
	DECLARE  LimiteMensaje		INT(11);
	DECLARE  Var_TextoOrig		CHAR(2);	-- Tipo de limpieza alfanumerico

	-- Declaracion de Variables
	DECLARE  VarEnvioID			INT(11);
	DECLARE  VarTipoEnvio		CHAR(1); -- U= Envio Una Vez // R=Envio Repetido
	DECLARE c1					CHAR(150);
	DECLARE c2					CHAR(150);
	DECLARE Limite 				VARCHAR(5);

	-- Asignacion de constantes
	Set	Entero_Cero		:= 0;		-- Entero Cero
	Set SalidaSI		:='S';		-- Salida Si
	Set SalidaNO		:='N';		-- Salida No
	Set	Cadena_Vacia	:= '';		-- String Vacio
	Set EstatusNE	    :='N'; 		-- Estado N= no Enviado
	set LimiteMensaje	:= 160;		-- limite maximo de caracteres por mensaje
	SET Var_TextoOrig	:= 'OR';	-- Mantiene el texto original

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSENVIOMENSAJEALT');
				SET Var_Control = 'SQLEXCEPTION';
		END;

		CALL FOLIOSAPLICAACT('SMSENVIOMENSAJE', VarEnvioID);

		IF( IFNULL(Par_Remitente,Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'El Remitente esta Vacio.';
				SET Var_Control := 'remitente';
				LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Receptor,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Destinatario esta Vacio.';
			SET Var_Control := 'receptor';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Mensaje,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Mensaje esta Vacio.';
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_CampaniaID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'La Campania esta Vacia.';
			SET Var_Control := 'campaniaID';
			LEAVE ManejoErrores;
		END IF;

		IF( EXISTS ( SELECT CampaniaID
					 FROM SMSCAMPANIAS
					 WHERE CampaniaID = Par_CampaniaID) ) THEN

			IF( EXISTS(SELECT C.CampaniaID
					   FROM SMSCAMPANIAS C
					   WHERE Par_CampaniaID = C.CampaniaID
						 AND C.Estatus = 'C')) then
				SET Par_NumErr  := 5;
				SET Par_ErrMen  := 'Campania cancelada.';
				SET Var_Control := 'campaniaID';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := 'La Campania No Existe.';
			SET Var_Control := 'campaniaID';
			LEAVE ManejoErrores;
		END IF;

		IF( LENGTH(Par_Mensaje)>LimiteMensaje ) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'El Mensaje Contiene Mas de 160 Caracteres.';
			SET Var_Control := 'campaniaID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();
		SET Par_FechaProgEnvio 	:= ifnull(Par_FechaProgEnvio, Aud_FechaActual );
		SET Par_DatosCliente	:= ifnull(Par_DatosCliente, Cadena_Vacia);
		SET	Par_SistemaID		:= ifnull(Par_SistemaID, Cadena_Vacia);
		SET Par_Mensaje			:= FNLIMPIACARACSMS(Par_Mensaje, Var_TextoOrig);

		INSERT INTO SMSENVIOMENSAJE (
			EnvioID,			Estatus,			Remitente,			Receptor,			FechaRealEnvio,
			Mensaje,			ColMensaje,			FechaProgEnvio,		CodExitoErr, 		CampaniaID,
			CodigoRespuesta, 	FechaRespuesta,		DatosCliente, 		SistemaID,			PIDTarea,
			EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES(
			VarEnvioID,			EstatusNE,			Par_Remitente,		Par_Receptor,		Par_FechaRealEnvio,
			Par_Mensaje,		Cadena_Vacia,		Par_FechaProgEnvio,	Cadena_Vacia,		Par_CampaniaID,
			Cadena_Vacia,		Par_FechaResp,		Par_DatosCliente,	Par_SistemaID,		Cadena_Vacia,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF( IFNULL(Par_CtaAsoc, Cadena_Vacia) <> Cadena_Vacia OR
			IFNULL(Par_NumCliente, Cadena_Vacia) <> Cadena_Vacia ) THEN

			CALL SMSENVMENADICALT(
				VarEnvioID,     Par_CtaAsoc,    Par_NumCliente,     SalidaNO,           Par_NumErr,
				Par_ErrMen,   	Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr 	:= 000;
		SET Par_ErrMen 	:= 'Mensaje Registrado';
		SET Var_Control	:= 'campaniaID';
		SET Consecutivo := Par_CampaniaID;

	END ManejoErrores;

	IF( Par_Salida = SalidaSI ) THEN
		SELECT	Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Consecutivo AS consecutivo;
	end if;

END TerminaStore$$