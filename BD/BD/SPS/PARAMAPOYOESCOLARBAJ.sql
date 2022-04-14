-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMAPOYOESCOLARBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMAPOYOESCOLARBAJ`;DELIMITER $$

CREATE PROCEDURE `PARAMAPOYOESCOLARBAJ`(

	Par_ParamApoyoEscID	INT(11),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),


	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN


	DECLARE varControl 			    CHAR(15);
	DECLARE Var_EmpresaID			INT(11);


	DECLARE  Entero_Cero    int;
	DECLARE Salida_SI			CHAR(1);


	set Entero_Cero 		:=0;
	SET Salida_SI			:='S';


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-PARAMAPOYOESCOLARBAJ');
				SET varControl = 'sqlException' ;
			END;



		IF(ifnull(Par_ParamApoyoEscID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El ID de parametros apoyo escolar esta vacio.';
			SET varControl  := 'paramApoyoEscID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ParamApoyoEscID
					FROM 	PARAMAPOYOESCOLAR
					WHERE ParamApoyoEscID = Par_ParamApoyoEscID)THEN
				SET Par_NumErr  := '002';
				SET Par_ErrMen  := 'El ID de apoyo escolar grid no existe.';
				SET varControl  := 'paramApoyoEscID' ;
				LEAVE ManejoErrores;
		END IF;

	SET Var_EmpresaID := (SELECT AC.EmpresaID FROM APOYOESCCICLO AC
						INNER JOIN PARAMAPOYOESCOLAR AE ON AC.ApoyoEscCicloID= AE.ApoyoEscCicloID
						WHERE ParamApoyoEscID=Par_ParamApoyoEscID);

	SET Aud_FechaActual := NOW();


	DELETE FROM  PARAMAPOYOESCOLAR
	WHERE ParamApoyoEscID = Par_ParamApoyoEscID;



	SET Par_NumErr  := '000';
	SET Par_ErrMen  := 'Grado Escolar Eliminado Exitosamente';
	SET varControl  := 'empresaID' ;
	LEAVE ManejoErrores;


END ManejoErrores;



	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen			 AS ErrMen,
				varControl			 AS control,
				Var_EmpresaID		 AS consecutivo;
	end IF;

END TerminaStore$$