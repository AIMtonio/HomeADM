-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPASIGCARTASLIQUIDAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS TMPASIGCARTASLIQUIDAALT;


DELIMITER $$

CREATE PROCEDURE TMPASIGCARTASLIQUIDAALT(
	Par_ConsolidaCartaID	INT(11)			, -- Consecutivo de consolidación de acuerdo con la solicitud de crédito
	Par_CasaComercialID		BIGINT(12)		, -- ID de la Casa Comercial.
	Par_Monto				DECIMAL(18,2)	, -- Monto de la Carta de Liquidación.
	Par_FechaVigencia		DATETIME		, -- Fecha de Vencimiento de la Carta de Liquidación.
	Par_RecursoCarta		MEDIUMBLOB		, -- Almancena la carta externa de manera binaria
	Par_ExtencionCarta		VARCHAR(15)		, -- Extension del archivo
	Par_ComentarioCarta		VARCHAR(250)	, -- Comentario de la Carta
	Par_RecursoPagare		MEDIUMBLOB		, -- Almancena el documento de pagaré de la carta externa, de manera binaria.
	Par_ExtencionPagare		VARCHAR(15)		, -- Extension del archivo
	Par_ComentarioPagare	VARCHAR(250)	, -- Comentario de la Carta

	Par_Salida				CHAR(1)			, -- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11)			, -- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400)	, -- Control de Errores: Descripcion del Error

	Aud_EmpresaID			INT(11)			, -- Parametro de Auditoria
	Aud_Usuario				INT(11)			, -- Parametro de Auditoria
	Aud_FechaActual			DATETIME		, -- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15)		, -- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50)		, -- Parametro de Auditoria
	Aud_Sucursal			INT(11)			, -- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		  -- Parametro de Auditoria
	)

TerminaStore: BEGIN
	-- Declaraciòn de variables y constantes
	DECLARE Entero_Cero				INT;			-- Constante Entero cero
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante Decimal cero
	DECLARE Var_Estatus				CHAR(1);		-- Variable de estatus activa o inactiva: A = Activa, I = Inactiva.
	DECLARE Var_Control				VARCHAR(100);	-- Variable de control
	DECLARE Var_SalidaSI			CHAR(1);		-- Constante de SI
	DECLARE Var_Vacio				CHAR(1);		-- Constante de vacío
	DECLARE Var_Interna				CHAR(1);		-- Constante de Interna
	DECLARE Var_Externa				CHAR(1);		-- Constante de Externa
	DECLARE Var_Cuenta				INT;			-- Variable para contar registros
	DECLARE Var_Consecutivo			INT;			-- Variable de salida de la consolidacion
	DECLARE Var_TipoCarta			VARCHAR(10);	-- Tipo de Carta de liquidacion I = Internas, E = Externas
	DECLARE Var_AsignacionCartaID	INT;			-- Consecutivo de la AsignacionCartaID
	DECLARE Var_EstatusCarta		VARCHAR(10);	-- Estatus de la Carta de Asignación con respecto a Dispersion .\\nS: si Dispersada \\n N: No Dispersada
	DECLARE Var_DispImportada		VARCHAR(10);	-- Movimiento Importada en Dispersiones S- SI Impirtada  N- NO Importada
	DECLARE Var_TipoDocCarta		INT(11);		-- Para las cartas Externas el tipo de documento sera el existente 9996
	DECLARE Var_ModificaArchCarta	CHAR(1);		-- Indica si el proceso dara de baja archivos existentes. \\nS: Si elimina \\n N: No Elimina. Para los nuevos siempre es SI
	DECLARE Var_TipoDocPagare		INT(11);		-- Para los pagare el tipo de documento sera el existente 9997
	DECLARE Var_ModificaArchPago	CHAR(1);		-- Indica si el proceso dara de baja archivos existentes. \\nS: Si elimina \\n N: No Elimina Para los nuevos siempre es SI.
	DECLARE Entero_Uno				INT;
	DECLARE SalidaNO				CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);


	-- Inicialización de constantes
	SET Entero_Cero				:= 0;				-- Constante entero cero
	SET Decimal_Cero			:= 0.0;				-- Constante DECIMAL cero
	SET Var_SalidaSI			:= 'S';				-- Constante de SI
	SET Var_Vacio				:= '';				-- Constante de vacío
	SET Var_Estatus				:= 'A';				-- Estatus A = Activa
	SET Var_Interna				:= 'I';				-- Carta Interna
	SET Var_Externa				:= 'E';				-- Carta Externa
	SET Var_TipoCarta			:= 'I,E'; 			-- Tipo de Carta de liquidacion I = Internas, E = Externas
	SET Var_EstatusCarta		:= 'S,N';			-- Estatus de la Carta de Asignación con respecto a Dispersion .\\nS: si Dispersada \\n N: No Dispersada
	SET Var_DispImportada		:= 'S,N';			-- Movimiento Importada en Dispersiones S- SI Impirtada  N- NO Importada
	SET Var_TipoDocCarta		:= 9996;			-- Para las cartas Externas el tipo de documento sera el existente 9996
	SET Var_ModificaArchCarta	:= 'S';				-- Indica si el proceso dara de baja archivos existentes. Defaul S
	SET Var_TipoDocPagare		:= 9997;			-- Para los pagare el tipo de documento sera el existente 9997
	SET Var_ModificaArchPago	:= 'S';				-- Indica si el proceso dara de baja archivos existentes. \\nS: Si elimina \\n N: No Elimina Para los nuevos siempre es SI.
	SET Entero_Uno				:= 1;
	SET SalidaNO				:= 'N';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TMPASIGCARTASLIQUIDAALT');

			SET Var_Control:= 'sqlException';
		END;


		-- Valida Par_CasaComercialID

		-- Valida Par_Monto
		IF Par_Monto = Entero_Cero THEN

			SET Par_NumErr		:= 10;
			SET Par_ErrMen		:= 'El monto de la carta de liquidación no puede ser cero.' ;
			SET Var_Control		:= 'monto';
			SET Var_Consecutivo	:= Par_Monto;
			LEAVE ManejoErrores;

		END IF;


		-- Valida Par_ExtencionCarta
		IF Par_ExtencionCarta = Var_Vacio THEN

			SET Par_NumErr		:= 20;
			SET Par_ErrMen		:= 'La Extensión de la carta de liquidación adjuntada no es válida.' ;
			SET Var_Control		:= 'extencionCarta';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;

		END IF;


		-- Obtiene el consecutivo de carta externa de acuerdo con el ID de consolidación
		SET Var_AsignacionCartaID := (SELECT IFNULL(MAX(Consecutivo),0) + 1 FROM TMPASIGCARTASLIQUIDA WHERE ConsolidaCartaID =  Par_ConsolidaCartaID);


		SET	Aud_FechaActual	:= CURRENT_TIMESTAMP();

			-- Inserta Detalle de consolidación
			INSERT INTO TMPASIGCARTASLIQUIDA (
							ConsolidaCartaID,	Consecutivo,		CasaComercialID,	Monto,				FechaVigencia,
							TipoDocCarta,		ModificaArchCarta,	RecursoCarta,		ExtencionCarta,		ComentarioCarta,
							TipoDocPagare,		ModificaArchPago,	RecursoPagare,		ExtencionPagare,	ComentarioPagare,
							EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
							Sucursal,			NumTransaccion)

			VALUES	(
						Par_ConsolidaCartaID,	Var_AsignacionCartaID,		Par_CasaComercialID,	Par_Monto,				Par_FechaVigencia,
						Var_TipoDocCarta,		Var_ModificaArchCarta,		Par_RecursoCarta,		Par_ExtencionCarta,		Par_ComentarioCarta,
						Var_TipoDocPagare,		Var_ModificaArchPago,		Par_RecursoPagare,		Par_ExtencionPagare,	Par_ComentarioPagare,
						Aud_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion);

			-- Ejecuta la actualización de la consolidación de acuerdo con su clarificación, relacionado, tipo de Credito
			CALL CONSOLIDACIONCARTALIQACT(
						Entero_Cero,			Par_ConsolidaCartaID,	Var_Vacio,			Entero_Uno, 		SalidaNO,
						Par_NumErr,		 		Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr > Entero_Cero) THEN
				SET Par_NumErr := Par_NumErr;
				SET Par_ErrMen := Par_ErrMen;
				SET Var_Control:= 'Par_ConsolidaCartaID';

				LEAVE ManejoErrores;
			END IF;


		SET		Par_NumErr		:= 0;
		SET		Par_ErrMen		:= CONCAT('Consolidación de carta externa agregada Exitosamente: ', CONVERT(Par_ConsolidaCartaID, CHAR));
		SET		Var_Control		:= 'consolidaCartaID';
		SET 	Var_Consecutivo	:= Par_ConsolidaCartaID;

END ManejoErrores;

		IF(Par_Salida = Var_SalidaSI) THEN
			SELECT  Par_NumErr			AS NumErr,
					Par_ErrMen			AS ErrMen,
					Var_Control			AS control,
					Var_Consecutivo		AS consecutivo; -- Enviar siempre en exito el numero de consolidacion
		END IF;

END TerminaStore$$





