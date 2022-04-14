-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMAPOYOESCOLARALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMAPOYOESCOLARALT`;DELIMITER $$

CREATE PROCEDURE `PARAMAPOYOESCOLARALT`(

	Par_ApoyoEscCicloID		INT(11),
	Par_TipoCalculo			CHAR(2),
	Par_PromedioMinimo		DECIMAL(12,2),
	Par_Cantidad			DECIMAL(12,2),

	Par_MesesAhorroCons		INT(11),

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
TerminaStore:BEGIN


	DECLARE Var_ParamApoyoEscID		INT(11);
	DECLARE varControl 			    CHAR(15);
	DECLARE Var_EmpresaID			INT(11);


	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI			CHAR(1);



	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.0;
	SET Cadena_Vacia		:='';
	SET Salida_SI			:='S';



	SET Par_NumErr			:= 0;
	SET Par_ErrMen			:= '';


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-PARAMAPOYOESCOLARALT');
				SET varControl = 'sqlException' ;
			END;

		IF(ifnull(Par_ApoyoEscCicloID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El grado escolar esta vacio.';
			SET varControl  := 'apoyoEscCicloID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_TipoCalculo,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El tipo de calculo esta vacio.';
			SET varControl  := 'tipoCalculo' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_PromedioMinimo,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'El promedio minimo esta vacio.';
			SET varControl  := 'promedioMinimo' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_Cantidad,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'La cantidad esta vacia.';
			SET varControl  := 'cantidad' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ApoyoEscCicloID
					FROM 	APOYOESCCICLO
					WHERE ApoyoEscCicloID = Par_ApoyoEscCicloID)THEN
				SET Par_NumErr  := '005';
				SET Par_ErrMen  := 'El ID de apoyo escolar no existe.';
				SET varControl  := 'apoyoEscCicloID' ;
				LEAVE ManejoErrores;
		END IF;


	CALL FOLIOSAPLICAACT('APOYOESCOLARGRID', Var_ParamApoyoEscID);
		IF(ifnull(Var_ParamApoyoEscID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '006';
			SET Par_ErrMen  := 'El ID de apoyo escolar grid esta vacio.';
			SET varControl  := 'paramApoyoEscID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_MesesAhorroCons,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '007';
			SET Par_ErrMen  := 'El numero de meses de ahorro constante esta vacio.';
			SET varControl  := 'mesesAhorroCons' ;
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS(SELECT ApoyoEscCicloID
					FROM 	PARAMAPOYOESCOLAR
					WHERE ApoyoEscCicloID = Par_ApoyoEscCicloID)THEN
				SET Par_NumErr  := '008';
				SET Par_ErrMen  := 'El grado escolar ya se encuentra registrado.';
				SET varControl  := 'apoyoEscCicloID' ;
				LEAVE ManejoErrores;
		END IF;




	SET Aud_FechaActual 	:= NOW();

	 INSERT INTO PARAMAPOYOESCOLAR(
					ParamApoyoEscID,		ApoyoEscCicloID,		 TipoCalculo,			Cantidad,			PromedioMinimo,
					MesesAhorroCons,		EmpresaID,				 Usuario,				FechaActual,		DireccionIP,
					ProgramaID,				Sucursal,  				 NumTransaccion)
			VALUES(
					Var_ParamApoyoEscID,	Par_ApoyoEscCicloID,	  Par_TipoCalculo, 		Par_Cantidad,		Par_PromedioMinimo,
					Par_MesesAhorroCons,	Aud_EmpresaID,		      Aud_Usuario,	 		Aud_FechaActual, 	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,	 		  Aud_NumTransaccion);

	SET Var_EmpresaID := (SELECT AC.EmpresaID FROM APOYOESCCICLO AC
						INNER JOIN PARAMAPOYOESCOLAR AE ON AC.ApoyoEscCicloID= AE.ApoyoEscCicloID
						WHERE ParamApoyoEscID=Var_ParamApoyoEscID);
	SET Par_NumErr  := '000';
	SET Par_ErrMen  := 'Grado Escolar Registrado Exitosamente';
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