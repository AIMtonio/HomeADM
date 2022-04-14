-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMOTCANCELCHEQUEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMOTCANCELCHEQUEALT`;DELIMITER $$

CREATE PROCEDURE `CATMOTCANCELCHEQUEALT`(

	Par_MotivoID			INT(11),
	Par_Descripcion			VARCHAR(200),
	Par_Estatus				CHAR(1),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
    INOUT Par_ErrMen		VARCHAR(350),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN


DECLARE  Entero_Cero       INT(11);
DECLARE  Decimal_Cero      DECIMAL(14,2);
DECLARE	 Cadena_Vacia	   CHAR(1);
DECLARE  Salida_SI		   CHAR(1);



DECLARE  Var_MotCanCheID   INT(11);
DECLARE  Var_Control	   VARCHAR(200);
DECLARE  Var_Consecutivo   INT(11);


SET	Cadena_Vacia		:= '';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.0;
SET Salida_SI			:= 'S';


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := '999';
					SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											 'esto le ocasiona. Ref: SP-CATMOTCANCELCHEQUEALT');
					SET Var_Control := 'sqlException' ;
				END;



	IF(IFNULL(Par_MotivoID, Entero_Cero))= Entero_Cero then
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:='El Numero de Motivo esta Vacio.';
			SET Var_Control := 'motivoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Descripcion, Cadena_Vacia))= Cadena_Vacia then
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen 	:='La Descripcion esta Vacia';
			SET Var_Control := 'descripcion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Estatus, Cadena_Vacia))= Cadena_Vacia then
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:='El Estatus esta Vacio';
			SET Var_Control := 'estatus' ;
		LEAVE ManejoErrores;
	END IF;


	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	INSERT INTO CATMOTCANCELCHEQUE(
		MotivoID,				Descripcion,		Estatus,	  	EmpresaID,		Usuario,
		FechaActual,	    	DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
	VALUES (
		Par_MotivoID,			Par_Descripcion,	Par_Estatus,  	Aud_EmpresaID,	 Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	 Aud_NumTransaccion);


			SET Par_NumErr := 000;
			SET Par_ErrMen := "Motivos de Cancelacion de Cheques Grabados Exitosamente";
			SET Var_Control := 'motivoID';
			SET Var_Consecutivo := Par_MotivoID;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$