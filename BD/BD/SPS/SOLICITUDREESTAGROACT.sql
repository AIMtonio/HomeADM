-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDREESTAGROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDREESTAGROACT`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDREESTAGROACT`(
/*SP para Actualizar los campos FIRA de las Solicitudes de Creditos Reestrucuturados Agropecuarios*/
	Par_SolicitudCreditoID		BIGINT(20),				-- Numero de Solicitud de Credito o Número de Crédito
	Par_CreditoID		        BIGINT(12),				-- Numero de Credito Origen por la que se Reestructura
	Par_AcreditadoIDFIRA		BIGINT(20),				-- Numero de Identificador de Acreditado por FIRA
	Par_CreditoIDFIRA			BIGINT(20),				-- Numero de Identificador de Credito por FIRA

	Par_NumAct					TINYINT UNSIGNED,		-- Numero de Actualizacion
	
	Par_Salida					CHAR(1),                -- Parametro de Salida
	INOUT Par_NumErr			INT(11),                -- Parametro de Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),           -- Parametro de Mensaje de Error

	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),                -- Parametro de Auditoria
	Aud_Usuario					INT(11),                -- Parametro de Auditoria
	Aud_FechaActual				DATETIME,               -- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),            -- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),            -- Parametro de Auditoria
	Aud_Sucursal				INT(11),                -- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)              -- Parametro de Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Consecutivo					BIGINT(20);
	DECLARE Var_Control						VARCHAR(50);
	DECLARE Var_CreditoID					BIGINT(12);
	DECLARE Var_ProductoCreditoID			INT(11);
	DECLARE Var_TipoCancelacion				CHAR(1);
	DECLARE Var_Refinancia					CHAR(1);
	DECLARE Var_ProduCredID					INT(11);
	DECLARE Var_CadenaProductivaID			INT(11);
	DECLARE Var_RamaFIRAID					INT(11);
	DECLARE Var_SubramaFIRAID				INT(11);
	DECLARE Var_ActividadFIRAID				INT(11);
	DECLARE Var_TipoGarantiaFIRAID			INT(11);
	DECLARE Var_ProgEspecialFIRAID			VARCHAR(10);
	DECLARE Var_MontoCredito				DECIMAL(12,2);
	DECLARE Var_EstatusGarantiaFIRA			CHAR(1);
	DECLARE Var_AcreditadoIDFIRA			BIGINT(20);				# Numero de Acreditado FIRA
 	DECLARE Var_CreditoIDFIRA				BIGINT(20);				# Numero de Credito FIRA
	# Actualizacion del Pagare de Crédito
	DECLARE Var_EstFondeo					CHAR(1);
	DECLARE Var_SaldoFondo					DECIMAL(14,2);

	-- Declaracion de Constantes
	DECLARE Act_DatosFIRA		INT(11);
	DECLARE Act_CreditoAgro			INT(11);
	DECLARE Act_PagareCredito		INT(11);
	DECLARE Act_CambioFonAgro		INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE SiEsAgropecuario		CHAR(1);
	DECLARE	TipoCancUltCoutas		CHAR(1);
	DECLARE	TipoCancProrrateo		CHAR(1);
	DECLARE	TipoCancSigInmed		CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE Rec_Propios				CHAR(1);
	DECLARE Rec_Fondeo				CHAR(1);
	DECLARE Est_Inactivo			CHAR(1);
	DECLARE Est_Autorizado			CHAR(1);
	DECLARE Fondeo_FIRA				INT;
	DECLARE Sin_Garantia			INT;
	DECLARE Gar_FEGA				INT;
	DECLARE Var_IdentificadorID		VARCHAR(18);			# Numero de Identificador FIRA

	-- Asignacion de Constantes
	SET Act_DatosFIRA   			:= 1;					-- Actualizacion para la Solicitud de Crédito
	SET Act_CreditoAgro				:= 2;					-- Actualizacion para el Crédito
	SET Act_PagareCredito			:= 3;					-- Actualizacion para el pagare de crédito
	SET Act_CambioFonAgro			:= 4;					-- Actualizacion en Cambio de Fondeo.
	SET Cadena_Vacia				:= '';					-- Cadena Vacia
	SET Entero_Cero					:= 0;					-- Entero Cero
	SET SalidaSI					:= 'S';					-- Salida Si
	SET SiEsAgropecuario			:= 'S';					-- Si es Agropecuario
	SET TipoCancUltCoutas			:= 'U'; 				-- Tipo de Cancelacion Ultimas cuotas
	SET TipoCancProrrateo			:= 'V'; 				-- Tipo de Cancelacion Prorrateo
	SET TipoCancSigInmed			:= 'I'; 				-- Tipo de Cancelacion Coutas siguientes inmediatas (cuotas vivas)
	SET Cons_NO						:= 'N';					-- Constante No
	SET Estatus_Activo				:= 'A';
	SET Rec_Propios					:= 'P';
	SET Rec_Fondeo					:= 'F';
	SET Est_Inactivo				:= 'I';					-- Garantía inactiva para pantalla de creditos sin fondeo
	SET Est_Autorizado				:= 'A';					-- Garantía Autorizada cuando es fondeado por fira
	SET Fondeo_FIRA					:= 1;					-- Fondeador 1 .- Fira
	SET Sin_Garantia				:= 0;					-- Clave sin garantía fira
	SET Gar_FEGA					:= 1;					-- Clave garantia FEGA

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDITOAGROACT');
			SET Var_Control:= 'sqlException';
		END;

		SET Aud_FechaActual :=  NOW();

		IF (IFNULL(Par_CreditoID,Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr 		:= 001;
				SET Par_ErrMen 		:= CONCAT('La Solicitud de Credito No Existe.');
				SET Var_Control 	:= 'solicitudCreditoID';
				SET Var_Consecutivo	:= Par_SolicitudCreditoID;
				LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_CreditoID,Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr 		:= 002;
				SET Par_ErrMen 		:= CONCAT('El Credito No Existe.');
				SET Var_Control 	:= 'solicitudCreditoID';
				SET Var_Consecutivo	:= Par_SolicitudCreditoID;
				LEAVE ManejoErrores;
		END IF;

		--  Actualizacion 1: Actualizacion de Campos Agropecuarios(FIRA) para Solicitudes de Crédito de Reestructura
		IF(Par_NumAct = Act_DatosFIRA) THEN

            SELECT CadenaProductivaID,      RamaFIRAID,                 SubramaFIRAID,                  ActividadFIRAID,
                    TipoGarantiaFIRAID,     EstatusGarantiaFIRA,        ProgEspecialFIRAID,				Refinancia
            INTO
                Var_CadenaProductivaID,     Var_RamaFIRAID,             Var_SubramaFIRAID,              Var_ActividadFIRAID,
                Var_TipoGarantiaFIRAID,     Var_EstatusGarantiaFIRA,    Var_ProgEspecialFIRAID,			Var_Refinancia
            FROM CREDITOS
            WHERE CreditoID = Par_CreditoID;


			UPDATE SOLICITUDCREDITO SET
				CadenaProductivaID		= Var_CadenaProductivaID,
				RamaFIRAID				= Var_RamaFIRAID,
				SubramaFIRAID			= Var_SubramaFIRAID,
				ActividadFIRAID			= Var_ActividadFIRAID,
				TipoGarantiaFIRAID		= Var_TipoGarantiaFIRAID,
				EstatusGarantiaFIRA		= Var_EstatusGarantiaFIRA,
				ProgEspecialFIRAID		= Var_ProgEspecialFIRAID,
				Refinancia				= Var_Refinancia,
			 	AcreditadoIDFIRA		= Par_AcreditadoIDFIRA,
			 	CreditoIDFIRA			= Par_CreditoIDFIRA,

				EmpresaID				= Par_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual				= Aud_FechaActual,
				DireccionIP				= Aud_DireccionIP,
				ProgramaID				= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal,
				NumTransaccion			= Aud_NumTransaccion
			WHERE SolicitudCreditoID	= Par_SolicitudCreditoID;

			-- Se Actualiza los Datos en el Registro de CREDITOS, ya que ahora se tomara los nuevos registros de FIRA
			UPDATE CREDITOS SET
				AcreditadoIDFIRA = Par_AcreditadoIDFIRA,
				CreditoIDFIRA = Par_CreditoIDFIRA
			WHERE CreditoID = Par_CreditoID;

			SET Par_NumErr 		:= 000;
			SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicitudCreditoID, CHAR));
			SET Var_Control 	:= 'solicitudCreditoID';
			SET Var_Consecutivo	:= Par_SolicitudCreditoID;
			LEAVE ManejoErrores;
		END IF;


	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$