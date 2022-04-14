-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCALIFPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSCALIFPRO`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSCALIFPRO`(

	Par_ConceptoCalifID		INT(11),
	Par_Concepto			CHAR(5),
	Par_Descripcion			VARCHAR(100),
	Par_Puntos				FLOAT(12,2),
	Par_TotalPuntos			FLOAT(12,2),

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


	DECLARE varControl 		CHAR(15);
	DECLARE Var_RangoMax	FLOAT(12,2);



	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Elimina_SI			CHAR(1);


	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.0;
	SET Cadena_Vacia		:='';
	SET Salida_SI			:='S';
	SET Elimina_SI			:='S';


	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= '';
	SET Var_RangoMax	:=(SELECT RangoSuperior FROM CLASIFICACIONCLI ORDER BY RangoSuperior DESC LIMIT 1);


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-CONCEPTOSCALIFPRO');
				SET varControl = 'sqlException' ;
			END;

	IF EXISTS(SELECT PuntosConcepID
				FROM PUNTOSCONCEPTO
				WHERE Puntos > Par_Puntos AND ConceptoCalifID = Par_ConceptoCalifID
				LIMIT 1 )THEN
				SET Par_NumErr  := '004';
			SET Par_ErrMen  :=  CONCAT('Debe Modificar los Puntos por Concepto para: ', (SELECT Concepto FROM CONCEPTOSCALIF WHERE ConceptoCalifID = Par_ConceptoCalifID));
			SET varControl  := 'puntos' ;
			LEAVE ManejoErrores;
		END IF;


		IF (Par_Elimina = Elimina_SI) THEN
			SET FOREIGN_KEY_CHECKS=0;
			DELETE FROM CONCEPTOSCALIF;
			SET FOREIGN_KEY_CHECKS=1;
		END IF;



	 SET Aud_FechaActual := NOW();
	 INSERT INTO CONCEPTOSCALIF(ConceptoCalifID,	 Concepto, 		  Descripcion, 		Puntos, 		EmpresaID,
								Usuario,		 	 FechaActual,	  DireccionIP,		ProgramaID,		Sucursal,
								NumTransaccion)
					VALUES(Par_ConceptoCalifID,		 Par_Concepto,	  Par_Descripcion,	Par_Puntos,		Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,  Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := 'Conceptos Grabados exitosamente.';
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