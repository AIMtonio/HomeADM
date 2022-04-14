-- SP NOMCONDICIONCREDBAJ
DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCONDICIONCREDBAJ;

DELIMITER $$

CREATE PROCEDURE NOMCONDICIONCREDBAJ(

	Par_ConvenioNominaID			BIGINT UNSIGNED,			
	Par_InstitNominaID				INT(11),			
	Par_Salida						CHAR(1),			
	INOUT Par_NumErr				INT(11),			
	INOUT Par_ErrMen				VARCHAR(400),		

	Par_EmpresaID					INT(11),			
	Aud_Usuario						INT(11),			
	Aud_FechaActual					DATETIME,			
	Aud_DireccionIP					VARCHAR(15),		
	Aud_ProgramaID					VARCHAR(50),		
	Aud_Sucursal					INT(11),			
	Aud_NumTransaccion				BIGINT(20)			
)
TerminaStore: BEGIN


	DECLARE Var_Control				VARCHAR(50);		


	DECLARE Entero_Cero			INT(11);			
	DECLARE SalidaSI			CHAR(1);			



	SET Entero_Cero				:= 0;				
	SET SalidaSI				:= 'S';				


	SET Par_ConvenioNominaID			:= IFNULL(Par_ConvenioNominaID, Entero_Cero);
	SET Par_InstitNominaID				:= IFNULL(Par_InstitNominaID, Entero_Cero);

	ManejaErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-NOMCONDICIONCREDBAJ');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		IF (Par_ConvenioNominaID = Entero_Cero) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El número de convenio nómina esta vacío';
			SET Var_Control := 'convenioNominaID';
		END IF;

		IF(Par_InstitNominaID = Entero_Cero) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El número de instituto nómina esta vacío';
			SET Var_Control := 'institNominaID';
		END IF;
        
		DELETE FROM NOMCONDICIONCRED
			WHERE ConvenioNominaID = Par_ConvenioNominaID
			AND InstitNominaID	= Par_InstitNominaID
			AND NumTransaccion	!= Aud_NumTransaccion;
	
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Condiciones de crédito eliminados exitosamente: ', CAST(Par_ConvenioNominaID AS CHAR));
		SET Var_Control	:= 'convenioNominaID';

	END ManejaErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT			Par_NumErr			AS	NumErr,
						Par_ErrMen 			AS 	ErrMen,
						Var_Control 		AS 	Control;
	END IF;
END TerminaStore$$
