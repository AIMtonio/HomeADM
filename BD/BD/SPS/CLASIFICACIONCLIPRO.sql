-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICACIONCLIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICACIONCLIPRO`;DELIMITER $$

CREATE PROCEDURE `CLASIFICACIONCLIPRO`(




	Par_ClasificaCliID		INT(11),
	Par_Clasificacion		CHAR(1),
	Par_RangoInferior		FLOAT(12,2),
	Par_RangoSuperior		FLOAT(12,2),

	Par_Elimina				CHAR(1),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN


	DECLARE varControl 			CHAR(15);
	DECLARE Var_NoValido		CHAR(1);



	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Elimina_SI			CHAR(1);
	DECLARE ClienteA			CHAR(1);
	DECLARE ClienteB			CHAR(1);
	DECLARE ClienteC			CHAR(1);



	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.0;
	SET Cadena_Vacia		:='';
	SET Salida_SI			:='S';
	SET Elimina_SI			:='S';
	SET ClienteA			:='A';
	SET ClienteB			:='B';
	SET ClienteC			:='C';


	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= '';


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-CLASIFICACIONCLIPRO');
				SET varControl = 'sqlException' ;
			END;


		IF (Par_Elimina = Elimina_SI) THEN
			DELETE FROM CLASIFICACIONCLI;
		END IF;


		IF(ifnull(Par_ClasificaCliID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El ID de la clasificacion esta vacio.';
			SET varControl  := 'clasificaCliID' ;
			LEAVE ManejoErrores;
		END IF;
		IF(ifnull(Par_Clasificacion,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'La clasificacion esta vacia.';
			SET varControl  := 'clasificacion' ;
			LEAVE ManejoErrores;
		END IF;
		IF(Par_RangoInferior > Par_RangoSuperior) THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'El Rango Inferior no debe ser mayor al Rango Superior.';
			SET varControl  := 'rangoInferior' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Clasificacion = ClienteB) THEN
			SET Var_NoValido	:= (SELECT Clasificacion
								FROM CLASIFICACIONCLI
								WHERE Clasificacion = ClienteA
								AND  Clasificacion = Par_Clasificacion
								AND Par_RangoSuperior >= RangoInferior
								AND RangoInferior != Decimal_Cero
								LIMIT 1);
			IF(Var_NoValido = ClienteA ) THEN
				SET Par_NumErr  := '004';
				SET Par_ErrMen  := 'El rango no es valido: A ';
				SET varControl  := 'rangoInferior' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_Clasificacion = ClienteC) THEN
			SET Var_NoValido	:= (SELECT Clasificacion
								FROM CLASIFICACIONCLI
								WHERE Clasificacion = ClienteB
								AND  Clasificacion = Par_Clasificacion
								AND Par_RangoSuperior >= RangoInferior
								AND RangoInferior != Decimal_Cero
								LIMIT 1);
			IF(Var_NoValido = ClienteB ) THEN
				SET Par_NumErr  := '005';
				SET Par_ErrMen  := 'El rango no es valido: B';
				SET varControl  := 'rangoInferior' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;



	 SET Aud_FechaActual := NOW();
	 INSERT INTO CLASIFICACIONCLI(ClasificaCliID,		 Clasificacion,		  RangoInferior, 	 RangoSuperior, 	EmpresaID,
								Usuario,		 	 FechaActual,	 	  DireccionIP,		 ProgramaID,		Sucursal,
								NumTransaccion)
					VALUES(Par_ClasificaCliID,		 Par_Clasificacion,	  Par_RangoInferior, Par_RangoSuperior,		Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,  Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := 'Clasificaciones Grabadas exitosamente.';
	SET varControl  := 'clasificaCliID' ;
	LEAVE ManejoErrores;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		 	AS ErrMen,
				varControl		 	AS control,
				Par_ClasificaCliID	AS consecutivo;
	END IF;

END TerminaStore$$