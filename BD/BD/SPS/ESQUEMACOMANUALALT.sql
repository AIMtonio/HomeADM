-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMANUALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACOMANUALALT`;
DELIMITER $$


CREATE PROCEDURE `ESQUEMACOMANUALALT`(
	/*SP PARA DAR DE ALTA LOS ESQUEMAS DE COBRO DE COMISION ANUAL DE LOS CREDITOS*/
	Par_ProducCreditoID		INT(11),			-- Id del producto de credito
	Par_CobraComision		VARCHAR(1),			-- Cobra Comision S:Si N:No
	Par_TipoComision		VARCHAR(1),			-- Tipo de Comision P:Porcentaje M:Monto
	Par_BaseCalculo			VARCHAR(1),			-- Base del Cálculo M:Monto del crédito Original S:Saldo Insoluto
	Par_MontoComision		DECIMAL(14,2),		-- Monto de la Comision en caso de que el tipo de comision sea M

	Par_PorcentajeComision	DECIMAL(14,4),		-- Porcentaje de la comision en caso de que el tipo de comision sea P
	Par_DiasGracia			INT(11),			-- Dias de gracia que se dan antes de cobrar la comisión
    Par_Salida				CHAR(1),			-- Salida S:Si N:No
	INOUT	Par_NumErr		INT(11),			-- Numero de error
	INOUT	Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	/* Parametros de Auditoria */
	Aud_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
			)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(20);	-- Campo para el id del control de pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);	-- Campo para el valor consecutivo de pantalla
	DECLARE Var_EstatusProducCred	CHAR(2);		-- Estatus del Producto Credito
	DECLARE Var_Descripcion			VARCHAR(100);	-- Descripcion Producto Credito

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			VARCHAR(1);		-- Cadena vacia
	DECLARE Entero_Cero				INT(11);		-- Entero Cero
	DECLARE Cons_NO					CHAR(1);		-- Constante No
	DECLARE Cons_SI					CHAR(1);		-- Constante Si
	DECLARE Salida_SI				CHAR(1);		-- Constante Si
	DECLARE TipoComisionPorcentaje	CHAR(1);		-- Tipo de Comision por porcentaje
	DECLARE TipoComisionMonto		CHAR(1);		-- Tipo de Comision por monto
	DECLARE Estatus_Inactivo    CHAR(1); 			-- Estatus Inactivo

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET Cons_NO						:= 'N';
	SET Cons_SI						:= 'S';
	SET Salida_SI					:= 'S';
	SET TipoComisionPorcentaje		:= 'P';
	SET TipoComisionMonto			:= 'M';
    SET Estatus_Inactivo			:= 'I';

	-- Asignacion de variables
	SET Var_Control					:= 'producCreditoID';
	SET Var_Consecutivo				:= '';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMACOMANUALALT');
			SET Var_Control := 'sqlException';
		END;

		IF(IFNULL(Par_ProducCreditoID, Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr	:= 001;
			SET	Par_ErrMen	:= 'El Numero de Producto de Credito Esta Vacio.';
			SET Var_Control	:= 'producCreditoID';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		ELSE
			IF NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO
					WHERE ProducCreditoID = Par_ProducCreditoID) THEN
				SET	Par_NumErr	:= 002;
				SET	Par_ErrMen	:= 'El Producto de Credito No Existe.';
				SET Var_Control	:= 'producCreditoID';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT ProducCreditoID FROM ESQUEMACOMANUAL
					WHERE ProducCreditoID = Par_ProducCreditoID) THEN
				SET	Par_NumErr	:= 002;
				SET	Par_ErrMen	:= 'El Producto de Credito Ya esta Parametrizado.';
				SET Var_Control	:= 'producCreditoID';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(IFNULL(Par_CobraComision,Cadena_Vacia) = Cadena_Vacia) THEN
			SET	Par_NumErr	:= 003;
			SET	Par_ErrMen	:= 'El Campo de Cobra Comision Esta Vacio.';
			SET Var_Control	:= 'cobraComision';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CobraComision = Cons_SI) THEN
			IF(IFNULL(Par_TipoComision,Cadena_Vacia) = Cadena_Vacia) THEN
				SET	Par_NumErr	:= 004;
				SET	Par_ErrMen	:= 'El Campo de Tipo Comision Esta Vacio.';
				SET Var_Control	:= 'cobraComision';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
				ELSE
					IF(Par_TipoComision = TipoComisionPorcentaje) THEN
						IF(IFNULL(Par_BaseCalculo,Cadena_Vacia) = Cadena_Vacia) THEN
							SET	Par_NumErr	:= 005;
							SET	Par_ErrMen	:= 'El Campo de Base Calculo esta Vacio.';
							SET Var_Control	:= 'baseCalculo';
							SET Var_Consecutivo := '';
							LEAVE ManejoErrores;
						END IF;

						IF(IFNULL(Par_PorcentajeComision, Entero_Cero) = Entero_Cero) THEN
							SET	Par_NumErr	:= 006;
							SET	Par_ErrMen	:= 'El Campo de Comision Esta Vacio.';
							SET Var_Control	:= 'porcentajeComision';
							SET Var_Consecutivo := '';
							LEAVE ManejoErrores;
						END IF;
						ELSE
							IF(IFNULL(Par_MontoComision, Entero_Cero) = Entero_Cero) THEN
								SET	Par_NumErr	:= 007;
								SET	Par_ErrMen	:= 'El Campo de Comision Esta Vacio.';
								SET Var_Control	:= 'montoComision';
								SET Var_Consecutivo := '';
								LEAVE ManejoErrores;
							END IF;
					END IF;
			END IF;

			IF(IFNULL(Par_DiasGracia,Entero_Cero) = Entero_Cero) THEN
				SET	Par_NumErr	:= 008;
				SET	Par_ErrMen	:= 'Los Dias de Gracia Esta Vacio.';
				SET Var_Control	:= 'diasGracia';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Par_TipoComision 		:= Cadena_Vacia;
			SET Par_BaseCalculo 		:= Cadena_Vacia;
			SET Par_MontoComision		:= Entero_Cero;
			SET Par_PorcentajeComision	:= Entero_Cero;
			SET Par_DiasGracia			:= Entero_Cero;
		END IF;

        SELECT 	Estatus, 				Descripcion
		INTO	Var_EstatusProducCred,	Var_Descripcion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = IFNULL(Par_ProducCreditoID, Entero_Cero);

		IF(Var_EstatusProducCred = Estatus_Inactivo) THEN
			SET Par_NumErr := 009;
			SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control:= 'producCreditoID' ;
            SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO ESQUEMACOMANUAL(
			ProducCreditoID,		CobraComision,		TipoComision,		BaseCalculo,		MontoComision,
			PorcentajeComision,		DiasGracia,			Empresa,			Usuario,			FechaActual,
			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
			Par_ProducCreditoID,	Par_CobraComision,	Par_TipoComision,	Par_BaseCalculo,	Par_MontoComision,
			Par_PorcentajeComision,	Par_DiasGracia,		Aud_Empresa,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Esquema Grabado Exitosamente para el Producto: ',Par_ProducCreditoID,'.');
		SET Var_Control := 'producCreditoID';
		SET Var_Consecutivo := Par_ProducCreditoID;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$