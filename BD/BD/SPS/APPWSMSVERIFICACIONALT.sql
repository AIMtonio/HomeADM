-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWSMSVERIFICACIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWSMSVERIFICACIONALT`;

DELIMITER $$
CREATE PROCEDURE `APPWSMSVERIFICACIONALT`(



	Par_Receptor		VARCHAR(45),
	Par_FechaRealEnvio  DATETIME,
	Par_Mensaje 		VARCHAR(400),

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


	DECLARE Var_Control			VARCHAR(100);
	DECLARE Consecutivo			VARCHAR(100);


	DECLARE  Entero_Cero		INT(11);
	DECLARE  SalidaSI			CHAR(1);
	DECLARE  SalidaNO			CHAR(1);
	DECLARE  Cadena_Vacia		CHAR(1);
	DECLARE  EstatusNE			CHAR(1);
	DECLARE  LimiteMensaje		INT(11);
	DECLARE  Var_TextoOrig		CHAR(2);


	DECLARE  VarEnvioID			INT(11);
	DECLARE  VarTipoEnvio		CHAR(1);
	DECLARE c1					CHAR(150);
	DECLARE c2					CHAR(150);
	DECLARE Limite 				VARCHAR(5);


	Set	Entero_Cero		:= 0;
	Set SalidaSI		:='S';
	Set SalidaNO		:='N';
	Set	Cadena_Vacia	:= '';
	Set EstatusNE	    :='N';
	set LimiteMensaje	:= 160;
	SET Var_TextoOrig	:= 'OR';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-APPWSMSVERIFICACIONALT');
				SET Var_Control = 'SQLEXCEPTION';
		END;

		CALL FOLIOSAPLICAACT('APPWSMSVERIFICACION', VarEnvioID);

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

		IF( LENGTH(Par_Mensaje)>LimiteMensaje ) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'El Mensaje Contiene Mas de 160 Caracteres.';
			SET Var_Control := 'campaniaID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();

		INSERT INTO APPWSMSVERIFICACION (
			EnvioID,				Receptor,				FechaRealEnvio,			Codigo,					EmpresaID,
			Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
			NumTransaccion
		)
		VALUES
		(
			VarEnvioID,				Par_Receptor,			Par_FechaRealEnvio,		Par_Mensaje,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion
		);

		SET Par_NumErr 	:= 000;
		SET Par_ErrMen 	:= 'Mensaje Registrado';
		SET Var_Control	:= 'campaniaID';
		SET Consecutivo := Entero_Cero;

	END ManejoErrores;

	IF( Par_Salida = SalidaSI ) THEN
		SELECT	Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Consecutivo AS consecutivo;
	end if;

END TerminaStore$$