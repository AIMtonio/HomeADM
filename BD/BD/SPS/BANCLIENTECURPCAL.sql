-- BANCLIENTECURPCAL

DELIMITER ;

DROP PROCEDURE IF EXISTS BANCLIENTECURPCAL;

DELIMITER $$

CREATE PROCEDURE `BANCLIENTECURPCAL`(

	Par_PrimerNombre					VARCHAR(50),
	Par_SegundoNombre					VARCHAR(50),
	Par_TercerNombre					VARCHAR(50),
	Par_ApellidoPat						VARCHAR(50),
	Par_ApellidoMat						VARCHAR(50),

	Par_Genero							CHAR(1),
	Par_FecNac							DATE,
	Par_EsExtranjero					CHAR(1),
	Par_EntidadFed						INT(11),
	INOUT  Par_CURP						VARCHAR(18),

	Par_Salida							CHAR(1),
	INOUT  Par_NumErr					INT(11),
	INOUT  Par_ErrMen					VARCHAR(400)

)
TerminaStore: BEGIN

	DECLARE SalidaNo					CHAR(1);
	DECLARE CadenaSI					CHAR(1);
	DECLARE CadenaNO					CHAR(1);

	DECLARE Var_Consecutivo				VARCHAR(70);
	DECLARE Var_Control					VARCHAR(100);


	SET SalidaNo						:= 'N';
	SET CadenaSI						:= 'S';
	SET CadenaNO						:= 'N';


	SET Par_NumErr  := 1;
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				'Disculpe las molestias que esto le ocasiona. Ref: SP-BANCLIENTECURPCAL');
			SET Var_Control = 'sqlException' ;
		END;


		CALL CLIENTECURPCAL(Par_PrimerNombre,  Par_SegundoNombre,  Par_TercerNombre,  Par_ApellidoPat,  Par_ApellidoMat,
							Par_Genero,        Par_FecNac,         Par_EsExtranjero,  Par_EntidadFed,   Par_CURP,
							SalidaNo,          Par_NumErr,         Par_ErrMen);


		SET Par_NumErr  := 0;
		SET Par_ErrMen	:= UPPER(Par_CURP);
		SET Var_Control := "txtCurp";
		SET Var_Consecutivo := Par_CURP;

	END ManejoErrores;

	IF (Par_Salida = CadenaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
