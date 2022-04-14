-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROVIDABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMASEGUROVIDABAJ`;DELIMITER $$

CREATE PROCEDURE `ESQUEMASEGUROVIDABAJ`(




	Par_ProducCreditoID		INT(11),
	Par_TipoPagoSeguro		CHAR(1),
	Par_EsquemaSeguroID		INT(11),

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


	DECLARE varControl 		    CHAR(15);
	DECLARE Var_ConsecutivoID	INT(10);


	DECLARE Entero_Cero			INT;
	DECLARE Salida_SI			CHAR(1);

	SET Entero_Cero			:=0;


	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= '';
	SET Salida_SI		:='S';



	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-ESQUEMAGARANTIALIQBAJ');
				SET varControl = 'sqlException' ;
			END;

		IF(ifnull(Par_ProducCreditoID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El Producto de Credito esta vacio.';
			SET varControl  := 'producCreditoID' ;
			LEAVE ManejoErrores;
		END IF;


	IF NOT EXISTS(SELECT ProducCreditoID
				FROM PRODUCTOSCREDITO
				WHERE ProducCreditoID = Par_ProducCreditoID)THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'No existe el Producto de Credito.';
			SET varControl  := 'agregar' ;
			LEAVE ManejoErrores;
	END IF;

	DELETE
		FROM ESQUEMASEGUROVIDA
		WHERE ProducCreditoID = Par_ProducCreditoID
		AND EsquemaSeguroID = Par_EsquemaSeguroID
		AND TipoPagoSeguro = Par_TipoPagoSeguro;

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := 'Esquema(s) de Seguro de Vida Eliminado(s) exitosamente.';
	SET varControl  := 'producCreditoID' ;
	LEAVE ManejoErrores;


END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		 AS ErrMen,
				varControl		 AS control,
				Par_ProducCreditoID	 AS consecutivo;
	end IF;

END TerminaStore$$