-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSCONFXPRODALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `RATIOSCONFXPRODALT`;
DELIMITER $$


CREATE PROCEDURE `RATIOSCONFXPRODALT`(
	/*SP PARA CONSULTAR LA CONFIGURACION DE LOS RATIOS PARAMETRIZADOS POR PRODUCTO DE CREDITO.*/
	Par_ProducCreditoID		INT(11),			# Id del producto de credito
	Par_RatiosCatalogoID	INT(11),			# Numero de ID del Catalogo de Ratios ; CATRATIOS
	Par_Porcentaje			DECIMAL(14,2),		# Porcentaje
	Par_LimiteInferior		DECIMAL(14,2),		# Limite inferior aplica solo para los ratios de tipo puntos 4
	Par_LimiteSuperior		DECIMAL(14,2),		# Limite superior aplica solo para los ratios de tipo puntos 4

	Par_Puntos				DECIMAL(14,2),		# Puntos, aplica solo para los ratios de tipo puntos
	Par_Transaccion			TINYINT,			# Numero de lista
	Par_Salida 				CHAR(1), 			# Salida S:Si N:No
	INOUT	Par_NumErr		INT(11),			# Numero de error
	INOUT	Par_ErrMen		VARCHAR(400),		# Mensaje de error

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
	# DECLARACION DE CONSTANTES
	DECLARE Entero_Cero				INT(11);		# Entero Cero
	DECLARE Cadena_Vacia			CHAR(1);		# Cadena Vacia
	DECLARE Salida_SI				CHAR(1);		# Salida Si
	DECLARE Tipo_Concepto			INT(11);		# Tipo Concepto; Aplica para el filtro de CATRATIOS
	DECLARE Tipo_Clasificacion		INT(11);		# Tipo Clasificacion; Aplica para el filtro de CATRATIOS
	DECLARE Tipo_SubClasificacion	INT(11);		# Tipo SubClasificacion; Aplica para el filtro de CATRATIOS
	DECLARE Tipo_Puntos				INT(11);		# Tipo Puntos; Aplica para el filtro de CATRATIOS
	DECLARE Estatus_Inactivo   	 CHAR(1); 			# Estatus Inactivo


	DECLARE Var_Control				VARCHAR(20);	# Campo para el id del control de pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);	# Consecutivo que se mostrara en pantalla
	DECLARE Var_RatiosCatalogoID	INT(11);		# Consecutivo que se mostrara en pantalla
	DECLARE Var_ColateralesID		INT(11);		# ID de Colaterales CATRATIOS
	DECLARE Var_EstatusProducCred	CHAR(2);		# Estatus del Producto Credito
	DECLARE Var_Descripcion			VARCHAR(100);	# Descripcion Producto Credito


	# ASIGNACION DE CONSTANTES
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET Salida_SI					:= 'S';
	SET Tipo_Concepto				:= 1;
	SET Tipo_Clasificacion			:= 2;
	SET Tipo_SubClasificacion		:= 3;
	SET Tipo_Puntos					:= 4;
	SET Var_Control					:= 'producCreditoID';
	SET Var_Consecutivo				:= '0';
	SET Var_ColateralesID			:= 5;
    SET Estatus_Inactivo			:= 'I';			# Estatus Inactivo


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-RATIOSCONFXPRODALT');
			SET Var_Control := 'sqlException';
		END;
		SET Var_RatiosCatalogoID	:= IFNULL(Var_RatiosCatalogoID,Entero_Cero);
		SET Par_LimiteInferior		:= IFNULL(Par_LimiteInferior,Entero_Cero);
		SET Par_LimiteSuperior		:= IFNULL(Par_LimiteSuperior,Entero_Cero);
		SET Par_Puntos				:= IFNULL(Par_Puntos,Entero_Cero);

		IF(Par_Transaccion IN(Tipo_Concepto,Tipo_Clasificacion, Tipo_SubClasificacion)) THEN
			IF(Par_Porcentaje<= Entero_Cero AND Par_RatiosCatalogoID != Var_ColateralesID) THEN
				SET Par_NumErr := 001;
				SET	Par_ErrMen	:= CONCAT('El Porcentaje debe ser Mayor a 0.');
				SET Var_Control	:= 'graba';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;
		END IF;
		SELECT
			RatiosCatalogoID INTO Var_RatiosCatalogoID
			FROM RATIOSCONFXPROD
			WHERE RatiosCatalogoID = Par_RatiosCatalogoID
				AND ProducCreditoID =  Par_ProducCreditoID;

		SELECT 	Estatus, 				Descripcion
		INTO	Var_EstatusProducCred,	Var_Descripcion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = IFNULL(Par_ProducCreditoID, Entero_Cero);

		IF(Var_EstatusProducCred = Estatus_Inactivo) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control:= 'producCreditoID' ;
            SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual			:= NOW();

		IF(Var_RatiosCatalogoID != Entero_Cero) THEN
			DELETE FROM RATIOSCONFXPROD
				WHERE RatiosCatalogoID		= Par_RatiosCatalogoID
					AND ProducCreditoID		= Par_ProducCreditoID;
		END IF;
		IF NOT EXISTS(
			SELECT ProducCreditoID
				FROM RATIOSCONFXPROD AS Rat INNER JOIN
					CATRATIOS Cat ON Rat.RatiosCatalogoID = Cat.RatiosCatalogoID
					WHERE Tipo=1 AND ProducCreditoID = Par_ProducCreditoID
					GROUP BY ProducCreditoID) THEN
			INSERT INTO RATIOSCONFXPROD(
					RatiosCatalogoID,				ProducCreditoID,			Porcentaje,			LimiteInferior,		LimiteSuperior,
					Puntos,							Empresa,					Usuario,			FechaActual,		DireccionIP,
					ProgramaID,						Sucursal,					NumTransaccion)
				SELECT
					RatiosCatalogoID,				Par_ProducCreditoID,		PorcentajeDefault,	Entero_Cero,		Entero_Cero,
					Entero_Cero,					Aud_Empresa,				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,					Aud_Sucursal,				Aud_NumTransaccion
				FROM CATRATIOS
					WHERE Tipo = 1;

		END IF;

		INSERT INTO RATIOSCONFXPROD(
				RatiosCatalogoID,				ProducCreditoID,			Porcentaje,			LimiteInferior,		LimiteSuperior,
				Puntos,							Empresa,					Usuario,			FechaActual,		DireccionIP,
				ProgramaID,						Sucursal,					NumTransaccion)
			VALUES (
				Par_RatiosCatalogoID,			Par_ProducCreditoID,		Par_Porcentaje,		Par_LimiteInferior,		Par_LimiteSuperior,
				Par_Puntos,						Aud_Empresa,				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,					Aud_Sucursal,				Aud_NumTransaccion);

		SET Par_NumErr := 000;
		SET	Par_ErrMen	:= 'Configuracion Grabada Exitosamente.';
		SET Var_Control	:= 'producCreditoID';
		SET Var_Consecutivo := Par_ProducCreditoID;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$