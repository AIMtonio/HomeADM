DELIMITER ;
DROP PROCEDURE IF EXISTS `BANMAESTROPOLIZABAJ`;
DELIMITER $$
CREATE PROCEDURE `BANMAESTROPOLIZABAJ`(

	Par_Poliza			BIGINT(20),
	Par_Transaccion		BIGINT(20),
	Par_Tipo			TINYINT UNSIGNED,
	Par_NumErrPol		INT(11),
	Par_ErrMenPol		VARCHAR(400),

	Par_DescProceso		VARCHAR(400),
	Par_Salida			CHAR(1),
	INOUT	Par_NumErr	INT(11),
	INOUT	Par_ErrMen	VARCHAR(400),
	Aud_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

	DECLARE	Entero_Cero			INT(11);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Salida_SI			CHAR(1);


	SET	Entero_Cero				:= 0;
	SET	Salida_NO       		:= 'N';
	SET Salida_SI       		:= 'S';



	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BANMAESTROPOLIZABAJ');
		END;

		CALL MAESTROPOLIZABAJ(	Par_Poliza,			Par_Transaccion,	Par_Tipo,			Par_NumErrPol,	Par_ErrMenPol,
								Par_DescProceso,	Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);

		IF(Par_NumErr<>Entero_Cero) THEN
				LEAVE ManejoErrores;
		END IF;


	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr 		AS NumErr,
					Par_ErrMen 		AS ErrMen,
					'PolizaID' 	AS control,
					Entero_Cero AS consecutivo;
		END IF;

END TerminaStore$$