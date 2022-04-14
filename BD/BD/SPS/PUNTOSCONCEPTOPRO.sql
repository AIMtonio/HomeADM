-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUNTOSCONCEPTOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUNTOSCONCEPTOPRO`;DELIMITER $$

CREATE PROCEDURE `PUNTOSCONCEPTOPRO`(

	Par_PuntosConcepID		INT(11),
	Par_ConceptoCalifID		INT(11),
	Par_RangoInferior		FLOAT(12,2),
	Par_RangoSuperior		FLOAT(12,2),
	Par_Puntos				FLOAT(12,2),

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
	DECLARE Var_NoValido		INT(11);



	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE Salida_SI			CHAR(1);
	DECLARE Elimina_SI			CHAR(1);


	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.0;
	SET Salida_SI			:='S';
	SET Elimina_SI			:='S';


	SET Par_NumErr			:= 0;
	SET Par_ErrMen			:= '';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-PUNTOSCONCEPTOPRO');
				SET varControl = 'sqlException' ;
			END;

			IF(Par_Elimina = Elimina_SI) THEN
				DELETE FROM PUNTOSCONCEPTO WHERE ConceptoCalifID = Par_ConceptoCalifID;
			END IF;

		IF(Par_PuntosConcepID = 0) THEN
			SET Par_NumErr  := '000';
			SET Par_ErrMen  := 'Puntos por Concepto Grabados exitosamente.';
			SET varControl  := 'conceptoCalifID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_ConceptoCalifID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El ID del concepto esta vacio.';
			SET varControl  := 'conceptoCalifID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_RangoSuperior < Par_RangoInferior) THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El Rango Superior no debe ser menor al Rango Inferior.';
			SET varControl  := 'rangoSuperior' ;
			LEAVE ManejoErrores;
		END IF;

		SET Var_NoValido	:= (SELECT '1' AS Falso
							FROM PUNTOSCONCEPTO
							WHERE ConceptoCalifID = Par_ConceptoCalifID AND(
							(Par_RangoInferior >= RangoInferior AND Par_RangoSuperior <= RangoSuperior)
							OR  (Par_RangoInferior <= RangoSuperior AND Par_RangoSuperior >= RangoSuperior)
							OR  (Par_RangoInferior <= RangoInferior AND Par_RangoSuperior >= RangoInferior))
							LIMIT 1);
		IF(Var_NoValido = 1 ) THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'El rango no es valido.';
			SET varControl  := 'rangoInferior' ;
			LEAVE ManejoErrores;
		END IF;

	IF EXISTS(SELECT PuntosConcepID
				FROM PUNTOSCONCEPTO
				WHERE Puntos > Par_Puntos AND ConceptoCalifID = Par_ConceptoCalifID
				LIMIT 1 )THEN
				SET Par_NumErr  := '004';
			SET Par_ErrMen  :=  CONCAT('El puntaje no es valido: ', (SELECT Concepto FROM CONCEPTOSCALIF WHERE ConceptoCalifID = Par_ConceptoCalifID));
			SET varControl  := 'puntos' ;
			LEAVE ManejoErrores;
		END IF;


	 SET Aud_FechaActual := NOW();
	 INSERT INTO PUNTOSCONCEPTO(PuntosConcepID,		 ConceptoCalifID,		 RangoInferior, 		  RangoSuperior, 		Puntos,
								EmpresaID,  		 Usuario,		 		 FechaActual,			  DireccionIP,			ProgramaID,
								Sucursal,			 NumTransaccion)
					VALUES(		Par_PuntosConcepID,	 Par_ConceptoCalifID,    Par_RangoInferior,	  	  Par_RangoSuperior,	Par_Puntos,
								Par_EmpresaID,	     Aud_Usuario,			 Aud_FechaActual,  		  Aud_DireccionIP,		Aud_ProgramaID,
								Aud_Sucursal,		 Aud_NumTransaccion);

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := 'Puntos por Concepto Grabados exitosamente.';
	SET varControl  := 'conceptoCalifID' ;
	LEAVE ManejoErrores;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		 	AS ErrMen,
				varControl		 	AS control,
				Par_ConceptoCalifID	AS consecutivo;
	END IF;

END TerminaStore$$