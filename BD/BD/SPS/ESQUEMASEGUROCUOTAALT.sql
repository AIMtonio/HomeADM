-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROCUOTAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMASEGUROCUOTAALT`;
DELIMITER $$


CREATE PROCEDURE `ESQUEMASEGUROCUOTAALT`(

	Par_ProducCreditoID		INT(11),
	Par_Frecuencia			VARCHAR(1),
    Par_Monto				DECIMAL(12,2),
	Par_Salida 				CHAR(1),
	INOUT	Par_NumErr		INT(11),

	INOUT	Par_ErrMen		VARCHAR(400),

	Aud_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
				)

TerminaStore: BEGIN

	DECLARE Var_Control				VARCHAR(20);
	DECLARE Var_Consecutivo			VARCHAR(50);
	DECLARE Var_DescripcionFrec		VARCHAR(20);
	DECLARE Var_EstatusProducCred	CHAR(2);			-- Estatus del Producto Credito
	DECLARE Var_Descripcion			VARCHAR(100);		-- Descripcion Producto Credito



	DECLARE Cadena_Vacia			VARCHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cons_NO					CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Estatus_Inactivo   	 CHAR(1); 				-- Estatus Inactivo


	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET Cons_NO						:= 'N';
	SET Salida_SI					:= 'S';

	SET Var_Control					:= 'producCreditoID';
	SET Var_Consecutivo				:= '';
    SET Estatus_Inactivo			:= 'I';				-- Estatus Inactivo

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMASEGUROCUOTAALT');
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
		END IF;
        IF(IFNULL(Par_Frecuencia,Cadena_Vacia) = Cadena_Vacia) THEN
			SET	Par_NumErr	:= 003;
			SET	Par_ErrMen	:= 'La Frecuencia esta Vacia.';
			SET Var_Control	:= 'frecuencia';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		ELSE
			SET Var_DescripcionFrec := (SELECT DescInfinitivo
										FROM CATFRECUENCIAS
											WHERE FrecuenciaID = UPPER(Par_Frecuencia));
			SET Var_DescripcionFrec :=IFNULL(Var_DescripcionFrec,Cadena_Vacia);
			IF(Var_DescripcionFrec=Cadena_Vacia) THEN
				SET	Par_NumErr	:= 004;
				SET	Par_ErrMen	:= 'La Frecuencia No Existe.';
				SET Var_Control	:= 'frecuencia';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			ELSE
				IF EXISTS(SELECT ProducCreditoID FROM ESQUEMASEGUROCUOTA
					WHERE ProducCreditoID = Par_ProducCreditoID AND
						Frecuencia=UPPER(Par_Frecuencia)) THEN
					SET	Par_NumErr	:= 005;
					SET	Par_ErrMen	:= CONCAT('La Parametrizacion ya se Encuentra Registrada para la Frecuencia ',Var_DescripcionFrec,'.');
					SET Var_Control	:= 'frecuencia';
					SET Var_Consecutivo := '';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(IFNULL(Par_Monto,Entero_Cero) = Entero_Cero) THEN
			SET	Par_NumErr	:= 006;
			SET	Par_ErrMen	:= 'El Monto esta Vacio.';
			SET Var_Control	:= 'monto';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

        SELECT 	Estatus, 				Descripcion
		INTO	Var_EstatusProducCred,	Var_Descripcion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = IFNULL(Par_ProducCreditoID, Entero_Cero);

		IF(Var_EstatusProducCred = Estatus_Inactivo) THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control:= 'producCreditoID' ;
            SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

		SET Par_Frecuencia := UPPER(Par_Frecuencia);
		SET Aud_FechaActual := NOW();
		INSERT INTO ESQUEMASEGUROCUOTA(
			ProducCreditoID,		Frecuencia,			Monto,				Usuario,
            Empresa,				FechaActual,		DireccionIP,		ProgramaID,
            Sucursal,				NumTransaccion)
		VALUES(
			Par_ProducCreditoID,	Par_Frecuencia,		Par_Monto,			Aud_Usuario,
            Aud_Empresa,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,			Aud_NumTransaccion);

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