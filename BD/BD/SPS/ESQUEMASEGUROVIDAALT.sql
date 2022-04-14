-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROVIDAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMASEGUROVIDAALT`;
DELIMITER $$

CREATE PROCEDURE `ESQUEMASEGUROVIDAALT`(

	Par_ProducCredID		INT(11),
	Par_TipoPagoSeguro		CHAR(1),
	Par_FactRiesgoSeguro	DECIMAL(12,6),
	Par_DescSeguro			DECIMAL(12,2),
	Par_MontoPolSegVida		DECIMAL(12,2),

	Par_EsPrimero			CHAR(1),

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
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE EliminarExistentes	CHAR(1);
	DECLARE Adelantado			CHAR(1);
	DECLARE Financiamiento		CHAR(1);
	DECLARE Deduccion			CHAR(1);
	DECLARE Otro				CHAR(1);
	DECLARE	TipoPago			VARCHAR(20);
	DECLARE ReqSeguro			CHAR(1);
	DECLARE ModTipPag			CHAR(1);
	DECLARE Estatus_Inactivo	CHAR(1);	-- Estatus Inactivo


	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.0;
	SET Cadena_Vacia		:='';
	SET Salida_SI			:='S';
	SET EliminarExistentes	:='S';
	SET Adelantado			:='A';
	SET Financiamiento		:='F';
	SET Deduccion			:='D';
	SET Otro				:='O';
	SET ReqSeguro			:='S';
	SET ModTipPag			:='T';
	SET Estatus_Inactivo 	:= 'I';		 -- Estatus Inactivo


	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= '';


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen =  CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-ESQUEMASEGUROVIDAALT');
			SET varControl = 'sqlException' ;
		END;

		SELECT 	Estatus,		Descripcion
		INTO 	Var_Estatus,	Var_Descripcion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Par_ProducCredID;

		IF(Var_Estatus = Estatus_Inactivo) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET varControl:= 'producCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_EsPrimero = EliminarExistentes) THEN
			DELETE FROM ESQUEMASEGUROVIDA
				WHERE ProducCreditoID = Par_ProducCredID;
		END IF;


		IF(IFNULL(Par_TipoPagoSeguro,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El Tipo de Pago del Seguro esta vacio.';
			SET varControl  := 'tipoPagoSeguro1' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FactRiesgoSeguro,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'El Factor de Riesgo esta vacio.';
			SET varControl  := 'factorRiesgoSeguro1' ;
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS(SELECT TipoPagoSeguro
					FROM ESQUEMASEGUROVIDA
					WHERE ProducCreditoID = Par_ProducCredID
					AND TipoPagoSeguro = Par_TipoPagoSeguro)THEN

			   IF (Par_TipoPagoSeguro = Adelantado)THEN
					SET TipoPago := 'Adelantado';
					SET TipoPago := 'Adelantado';
				END IF;
				IF (Par_TipoPagoSeguro = Financiamiento)THEN
					SET TipoPago := 'Financiamiento';
				END IF;
				IF (Par_TipoPagoSeguro = Deduccion)THEN
					SET TipoPago := 'Deduccion';
				END IF;
				IF (Par_TipoPagoSeguro = Otro)THEN
					SET TipoPago := 'Otro';
				END IF;

				SET Par_NumErr :='006';
					SET Par_ErrMen := CONCAT("Solo puede existir un Tipo de Pago ",TipoPago);
					SET varControl := 'tipoPagoSeguro1' ;
					LEAVE ManejoErrores;
		END IF;


		UPDATE PRODUCTOSCREDITO SET Modalidad = ModTipPag,
			   ReqSeguroVida = ReqSeguro
		WHERE ProducCreditoID = Par_ProducCredID;

		UPDATE PRODUCTOSCREDITO SET TipoPagoSeguro = Cadena_Vacia,
			   FactorRiesgoSeguro = Decimal_Cero,
			   DescuentoSeguro =Decimal_Cero,
			   MontoPolSegVida =Decimal_Cero
		WHERE ProducCreditoID = Par_ProducCredID;


		SET Aud_FechaActual := NOW();
		SET Var_ConsecutivoID := (SELECT EsquemaSeguroID FROM ESQUEMASEGUROVIDA
									WHERE ProducCreditoID =  Par_ProducCredID
									LIMIT 1);
		SET Var_ConsecutivoID := IFNULL(Var_ConsecutivoID,0);

		IF(Var_ConsecutivoID = 0)THEN
			CALL FOLIOSAPLICAACT('ESQUEMASEGUROVIDA', Var_ConsecutivoID);
		END IF;


	 INSERT INTO ESQUEMASEGUROVIDA(
		EsquemaSeguroID,			ProducCreditoID,		TipoPagoSeguro,		FactorRiesgoSeguro,		DescuentoSeguro,
		MontoPolSegVida,
		EmpresaID,					Usuario,				FechaActual,		DireccionIP,			ProgramaID,
		Sucursal,					NumTransaccion)
	VALUES(
		Var_ConsecutivoID,			Par_ProducCredID,		Par_TipoPagoSeguro,	Par_FactRiesgoSeguro,	Par_DescSeguro,
		Par_MontoPolSegVida,
		Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,				Aud_NumTransaccion);

	UPDATE PRODUCTOSCREDITO SET EsquemaSeguroID = Var_ConsecutivoID
			WHERE ProducCreditoID = Par_ProducCredID;

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := 'Esquema de Seguro de Vida Grabado exitosamente.';
	SET varControl  := 'producCreditoID' ;
	LEAVE ManejoErrores;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen		 AS ErrMen,
			varControl		 AS control,
			Par_ProducCredID	 AS consecutivo;
END IF;

END TerminaStore$$