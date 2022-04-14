-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROVIDAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMASEGUROVIDAACT`;
DELIMITER $$

CREATE PROCEDURE `ESQUEMASEGUROVIDAACT`(

	Par_ProducCreditoID		INT(11),
	Par_TipoPagoSeguro		CHAR(1),
	Par_EsquemaSeguroID		INT(11),
	Par_ReqSeguroVida		CHAR(1),
	Par_TipPago				CHAR(1),
	Par_FactRiesSeg			DECIMAL(12,6),
	Par_DescuentoSeg		DECIMAL(12,2),
	Par_MontoPolSegVida		DECIMAL(12,2),
	Par_Modalidad			CHAR(1),

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
	DECLARE Var_Estatus			CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion		VARCHAR(100);	-- Almacena la descripcion del producto de credito

	DECLARE Entero_Cero			INT;
	DECLARE	Cadena_Vacia		VARCHAR(50);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Var_ModUnico		CHAR(1);
	DECLARE Deduccion			CHAR(1);
	DECLARE Anticipado			CHAR(1);
	DECLARE ReqSeguro			CHAR(1);
	DECLARE Estatus_Inactivo	CHAR(1);	-- Estatus Inactivo

	SET Entero_Cero			:=0;
	SET Cadena_Vacia		:='';


	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= '';
	SET Salida_SI		:= 'S';
	SET Var_ModUnico	:= 'U';
	SET Deduccion		:= 'D';
	SET Anticipado		:= 'A';
	SET ReqSeguro		:= 'S';
	SET Estatus_Inactivo 	:= 'I';		 -- Estatus Inactivo

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen =  CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-ESQUEMASEGUROVIDAACT');
			SET varControl = 'sqlException' ;
		END;

	SET Par_TipoPagoSeguro		:= IFNULL(Par_TipoPagoSeguro, Cadena_Vacia);
	SET	Par_ReqSeguroVida		:= IFNULL(Par_ReqSeguroVida, Cadena_Vacia);
	SET	Par_TipPago				:= IFNULL(Par_TipPago, Cadena_Vacia);
	SET	Par_FactRiesSeg			:= IFNULL(Par_FactRiesSeg, Entero_Cero);
	SET	Par_DescuentoSeg		:= IFNULL(Par_DescuentoSeg, Entero_Cero);
	SET	Par_MontoPolSegVida		:= IFNULL(Par_MontoPolSegVida, Entero_Cero);
	SET Par_Modalidad			:= IFNULL(Par_Modalidad, Cadena_Vacia);

	SELECT 	Estatus,		Descripcion
	INTO 	Var_Estatus,	Var_Descripcion
	FROM PRODUCTOSCREDITO
	WHERE ProducCreditoID = Par_ProducCreditoID;

	IF(Var_Estatus = Estatus_Inactivo) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
		SET varControl:= 'producCreditoID';
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_ProducCreditoID,Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr  := '001';
		SET Par_ErrMen  := 'El Producto de Credito esta vacio.';
		SET varControl  := 'producCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS(SELECT ProducCreditoID
				FROM PRODUCTOSCREDITO
				WHERE ProducCreditoID = Par_ProducCreditoID)THEN
			SET Par_NumErr  := '006';
			SET Par_ErrMen  := 'NO existe el Producto de Credito.';
			SET varControl  := 'producCreditoID' ;
			LEAVE ManejoErrores;
	END IF;

	IF(Par_ReqSeguroVida = Cadena_Vacia) THEN
		SET Par_NumErr  := '007';
		SET Par_ErrMen  := 'Requiere Seguro esta vacio.';
		SET varControl  := 'reqSeguroVida' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ReqSeguroVida = ReqSeguro)THEN

		IF(IFNULL(Par_TipPago,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '008';
			SET Par_ErrMen  := 'El Tipo de Pago del Seguro esta vacio.';
			SET varControl  := 'tipoPagoSeguro' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FactRiesSeg,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '009';
			SET Par_ErrMen  := 'El Factor de Riesgo del Seguro esta vacio.';
			SET varControl  := 'factorRiesgoSeguro' ;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Modalidad,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '012';
			SET Par_ErrMen  := 'La Modalidad de Pago esta vacia.';
			SET varControl  := 'modalidad' ;
			LEAVE ManejoErrores;
		END IF;

	END IF;

		DELETE FROM ESQUEMASEGUROVIDA
			WHERE ProducCreditoID = Par_ProducCreditoID;

	UPDATE PRODUCTOSCREDITO
	SET ReqSeguroVida		 = Par_ReqSeguroVida,
		TipoPagoSeguro	 	 = Par_TipPago,
		FactorRiesgoSeguro	 = Par_FactRiesSeg,
		DescuentoSeguro		 = Par_DescuentoSeg,
		MontoPolSegVida		 = Par_MontoPolSegVida,
		Modalidad			 = Par_Modalidad,
		EsquemaSeguroID		 = Par_EsquemaSeguroID,
		EmpresaID 		 	 = Par_EmpresaID,
		Usuario			 	 = Aud_Usuario,
		FechaActual		  	 = Aud_FechaActual,
		DireccionIP		 	 = Aud_DireccionIP,
		ProgramaID		 	 = Aud_ProgramaID,
		Sucursal		 	 = Aud_Sucursal,
		NumTransaccion   	 = Aud_NumTransaccion
	WHERE ProducCreditoID = Par_ProducCreditoID;

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := 'Datos de Seguro de Vida grabados exitosamente.';
	SET varControl  := 'producCreditoID' ;
	LEAVE ManejoErrores;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen		 AS ErrMen,
			varControl		 AS control,
			Par_ProducCreditoID	 AS consecutivo;
END IF;


END TerminaStore$$