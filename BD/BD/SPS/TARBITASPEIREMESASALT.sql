-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARBITASPEIREMESASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARBITASPEIREMESASALT`;

DELIMITER $$

CREATE PROCEDURE `TARBITASPEIREMESASALT`(

	Par_SpeiRemID						BIGINT(20),
	Par_ClaveRastreo					VARCHAR(30),
	Par_Metodo							CHAR(1),
	Par_FolioSTP						INT(11),

	Par_Salida							CHAR(1),
	INOUT Par_NumErr					INT(11),
	INOUT Par_ErrMen					VARCHAR(400),

	Par_EmpresaID 						INT(11),
	Aud_Usuario							INT(11),
	Aud_FechaActual						DATETIME,
	Aud_DireccionIP						VARCHAR(15),
	Aud_ProgramaID						VARCHAR(50),
	Aud_Sucursal						INT(11),
	Aud_NumTransaccion					BIGINT(20)
)

TerminaStore: BEGIN

	DECLARE Var_Control					VARCHAR(50);
	DECLARE Var_FechaSistema			DATE;
	DECLARE Var_FechaHoraAlta			DATETIME;
	DECLARE Var_ClaveRastreo			VARCHAR(30);
	DECLARE Var_Estatus					CHAR(1);
	DECLARE Var_Observa					VARCHAR(100);


	DECLARE Entero_Cero					INT(11);
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Fecha_Vacia					DATE;
	DECLARE Var_SalidaSI				CHAR(1);
	DECLARE Var_SalidaNO				CHAR(1);
	DECLARE Var_EstPendiente			CHAR(1);
	DECLARE Var_EstInvalido				CHAR(1);


	SET Entero_Cero						:= 0;
	SET Cadena_Vacia					:= '';
	SET Fecha_Vacia						:= '1900-01-01';
	SET Var_SalidaSI					:= 'S';
	SET Var_SalidaNO					:= 'N';
	SET Var_EstPendiente				:= 'P';
	SET Var_EstInvalido					:= 'X';


	SET Par_SpeiRemID					:= IFNULL(Par_SpeiRemID, Entero_Cero);
	SET Par_ClaveRastreo				:= IFNULL(Par_ClaveRastreo, Cadena_Vacia);
	SET Par_Metodo						:= IFNULL(Par_Metodo, Cadena_Vacia);

	SET Par_EmpresaID					:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario						:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual					:= NOW();
	SET Aud_DireccionIP					:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID					:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal					:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion				:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TARBITASPEIREMESASALT');
			SET Var_Control = 'sqlException';
		END;


		IF (Par_SpeiRemID = Entero_Cero) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El identificador de la remesa esta vacio';
			SET Var_Control := 'speiRemID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_ClaveRastreo = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen	:= 'La clave de rastreo SPEI esta vacia';
			SET Var_Control := 'claveRastreo';
			LEAVE ManejoErrores;
		END IF;

		SELECT		ClaveRastreo
			INTO	Var_ClaveRastreo
			FROM	TARBITASPEIREMESAS
			WHERE	ClaveRastreo = Par_ClaveRastreo
			LIMIT	1;

		SET Var_ClaveRastreo	:= IFNULL(Var_ClaveRastreo, Cadena_Vacia);

		IF (Var_ClaveRastreo <> Cadena_Vacia) THEN

			SET Var_Estatus	:= Var_EstInvalido;
			SET Var_Observa	:= 'La clave de rastreo SPEI ya ha sido procesada anteriormente';

		ELSE

			SET Var_Estatus	:= Var_EstPendiente;
			SET Var_Observa	:= Cadena_Vacia;

		END IF;

		IF (Par_Metodo = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen	:= 'Especifique el metodo a consumir por la tarea';
			SET Var_Control := 'metodo';
			LEAVE ManejoErrores;
		END IF;

		SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM	PARAMETROSSIS;

		SET Var_FechaHoraAlta	:= CONCAT(Var_FechaSistema, ' ', TIME(NOW()));

		INSERT INTO TARBITASPEIREMESAS	(	SpeiRemID,				ClaveRastreo,			Metodo,				Estatus,				PIDTarea,
											Observacion,			FechaHoraAlta,			TransaccionPago,	EmpresaID,				Usuario,
											FechaActual,			DireccionIP,			ProgramaID,			Sucursal,				NumTransaccion	)
								VALUES	(	Par_SpeiRemID,			Par_ClaveRastreo,		Par_Metodo,			Var_Estatus,			Cadena_Vacia,
											Var_Observa,			Var_FechaHoraAlta,		Par_FolioSTP,		Par_EmpresaID,			Aud_Usuario,
											Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion	);


		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Registro de la bitacora dado de Alta exitosamente. Clave Rastreo : ', CAST(Par_ClaveRastreo AS CHAR));
		SET Var_Control	:= 'speiRemID';
	END ManejoErrores;


	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_SpeiRemID			AS consecutivo;
	END IF;


END TerminaStore$$