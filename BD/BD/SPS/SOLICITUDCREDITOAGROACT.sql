-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOAGROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOAGROACT`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDCREDITOAGROACT`(
/*SP para Actualizar los campos de las Solicitudes de Creditos Agropecuarios*/
	Par_NumAct					TINYINT UNSIGNED,		# Numero de Actualizacion
	Par_SolicitudCreditoID		BIGINT(20),				# Numero de Solicitud de Credito o Número de Crédito
	Par_CadenaProductivaID		INT(11),				# ID de la Cadena Productiva CATCADENAPRODUCTIVA
	Par_RamaFIRAID 				INT(11),				# ID Rama FIRA CATRAMAFIRA
	Par_SubramaFIRAID			INT(11),				# ID de la Subrama FIRA RELSUBRAMAFIRA

	Par_ActividadFIRAID			INT(11),				# ID del tipo de Actividad FIRA CATACTIVIDADFIRA
	Par_TipoGarantiaFIRAID		INT(11),				# ID del Tipo de Garantia CATTIPOGARANTIAFIRA
	Par_ProgEspecialFIRAID		VARCHAR(10),			# Clave del Programa Especial FIRA CATFIRAPROGESP
	Par_CalcInteres				INT(11),
	Par_TasaBase				DECIMAL(12,4),			# Tasa Base (Estos campos son para el pagare si es que deciden cambiar la tasa)

	Par_TasaFija				DECIMAL(12,4),			# Tasa Fija (Estos campos son para el pagare si es que deciden cambiar la tasa)
	Par_SobreTasa				DECIMAL(12,4),			# Sobre Tasa (Estos campos son para el pagare si es que deciden cambiar la tasa)
	Par_PisoTasa				DECIMAL(12,4),			# Piso Tasa (Estos campos son para el pagare si es que deciden cambiar la tasa)
	Par_TechoTasa				DECIMAL(12,4),			# Techo Tasa (Estos campos son para el pagare si es que deciden cambiar la tasa)
	Par_TipoCalInt				INT(11), 				# Tipo de Calculo de Interes (Estos campos son para el pagare si es que deciden cambiar la tasa)

	Par_TipoFondeo				CHAR(1),				# Tipo de Fondeo (Si deciden cambiar el tipo de Fondeo)
	Par_InstitFondeoID			INT(11),				# ID de Institucion de Fondeo (Si deciden cambiar el tipo de Fondeo)
	Par_NumTransacSim			BIGINT(20),
	Par_LineaFondeo				INT(11),				# Linea de Fondeo (Si deciden cambiar el tipo de Fondeo)
	Par_TasaPasiva				DECIMAL(14,4),			# Tasa Pasiva (Si deciden cambiar el la tasa pasiva)

 	Par_AcreditadoIDFIRA		BIGINT(20),				# Numero de Acreditado FIRA
 	Par_CreditoIDFIRA			BIGINT(20),				# Numero de Credito FIRA
	Par_Salida					CHAR(1),
	INOUT Par_NumErr			INT(11),
	INOUT Par_ErrMen			VARCHAR(400),

	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),

	Aud_NumTransaccion			BIGINT(20)
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
 	DECLARE Var_NumCredito					BIGINT(12);		-- Numero de Credito con Identificador
	# Actualizacion del Pagare de Crédito
	DECLARE Var_EstFondeo					CHAR(1);
	DECLARE Var_SaldoFondo					DECIMAL(14,2);

	-- Declaracion de Constantes
	DECLARE Act_SolicitudAgro		INT(11);
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
	DECLARE TipoAltaSolCred			INT;
	DECLARE TipoAltaCredito			INT;

	-- Asignacion de Constantes
	SET Act_SolicitudAgro			:= 1;					# Actualizacion para la Solicitud de Crédito
	SET Act_CreditoAgro				:= 2;					# Actualizacion para el Crédito
	SET Act_PagareCredito			:= 3;					# Actualizacion para el pagare de crédito
	SET Act_CambioFonAgro			:= 4;					# Actualizacion en Cambio de Fondeo.
	SET Cadena_Vacia				:= '';					# Cadena Vacia
	SET Entero_Cero					:= 0;					# Entero Cero
	SET SalidaSI					:= 'S';					# Salida Si
	SET SiEsAgropecuario			:= 'S';					# Si es Agropecuario
	SET TipoCancUltCoutas			:= 'U'; 				# Tipo de Cancelacion Ultimas cuotas
	SET TipoCancProrrateo			:= 'V'; 				# Tipo de Cancelacion Prorrateo
	SET TipoCancSigInmed			:= 'I'; 				# Tipo de Cancelacion Coutas siguientes inmediatas (cuotas vivas)
	SET Cons_NO						:= 'N';					# Constante No
	SET Estatus_Activo				:= 'A';
	SET Rec_Propios					:= 'P';
	SET Rec_Fondeo					:= 'F';
	SET Est_Inactivo				:= 'I';					# Garantía inactiva para pantalla de creditos sin fondeo
	SET Est_Autorizado				:= 'A';					# Garantía Autorizada cuando es fondeado por fira
	SET Fondeo_FIRA					:= 1;					# Fondeador 1 .- Fira
	SET Sin_Garantia				:= 0;					# Clave sin garantía fira
	SET Gar_FEGA					:= 1;					# Clave garantia FEGA
	SET TipoAltaSolCred				:= 1;					# Alta Tasa Pasiva: por Solicitud de Crédito
	SET TipoAltaCredito				:= 2;					# Alta Tasa Pasiva: por Crédito

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDITOAGROACT');
			SET Var_Control:= 'sqlException';
		END;

		SET Aud_FechaActual :=  NOW();

		# Actualizacion 1: Actualizacion de Campos Agropecuarios para Solicitudes de Crédito
		IF(IFNULL(Par_NumAct,Entero_Cero) = Act_SolicitudAgro) THEN

			IF NOT EXISTS(SELECT CveCadena FROM CATCADENAPRODUCTIVA WHERE CveCadena = Par_CadenaProductivaID) THEN
				SET Par_NumErr 		:= 001;
				SET Par_ErrMen 		:= CONCAT('La Cadena Productiva No Existe.');
				SET Var_Control 	:= 'cadenaProductivaID';
				SET Var_Consecutivo	:= Par_CadenaProductivaID;
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT CveCadena FROM RELCADENARAMAFIRA WHERE CveCadena = Par_CadenaProductivaID AND CveRamaFIRA = Par_RamaFIRAID) THEN
				SET Par_NumErr 		:= 002;
				SET Par_ErrMen 		:= CONCAT('La Rama FIRA no Existe o no Esta Relacionada a la Cadena Productiva.');
				SET Var_Control 	:= 'ramaFIRAID';
				SET Var_Consecutivo	:= Par_RamaFIRAID;
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT CveCadena FROM RELSUBRAMAFIRA WHERE CveCadena = Par_CadenaProductivaID AND CveRamaFIRA = Par_RamaFIRAID
					AND CveSubramaFIRA = Par_SubramaFIRAID) THEN
				SET Par_NumErr 		:= 003;
				SET Par_ErrMen 		:= CONCAT('La Subrama FIRA no Existe o no Esta Relacionada a la Rama.');
				SET Var_Control 	:= 'subramaFIRAID';
				SET Var_Consecutivo	:= Par_SubramaFIRAID;
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT CveCadena FROM RELACTIVIDADFIRA WHERE CveCadena = Par_CadenaProductivaID AND CveRamaFIRA = Par_RamaFIRAID
					AND CveSubramaFIRA = Par_SubramaFIRAID AND CveActividadFIRA = Par_ActividadFIRAID) THEN
				SET Par_NumErr 		:= 004;
				SET Par_ErrMen 		:= CONCAT('La Actividad FIRA no Existe o no Esta Relacionada a la Subrama.');
				SET Var_Control 	:= 'actividadFIRAID';
				SET Var_Consecutivo	:= Par_ActividadFIRAID;
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT TipoGarantiaID FROM CATTIPOGARANTIAFIRA WHERE TipoGarantiaID = Par_TipoGarantiaFIRAID) THEN
				SET Par_NumErr 		:= 005;
				SET Par_ErrMen 		:= CONCAT('El Tipo de Garantia No Existe.');
				SET Var_Control 	:= 'tipoGarantiaFIRAID';
				SET Var_Consecutivo	:= Par_TipoGarantiaFIRAID;
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT CveSubProgramaID FROM CATFIRAPROGESP WHERE CveSubProgramaID = Par_ProgEspecialFIRAID) THEN
				SET Par_NumErr 		:= 006;
				SET Par_ErrMen 		:= CONCAT('El Programa Especial No Existe.');
				SET Var_Control 	:= 'progEspecialFIRAID';
				SET Var_Consecutivo	:= Par_ProgEspecialFIRAID;
				LEAVE ManejoErrores;
			END IF;

			SET Var_ProduCredID := (SELECT ProductoCreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

			SELECT	Refinanciamiento INTO Var_Refinancia
				FROM PRODUCTOSCREDITO Pro
				WHERE Pro.ProducCreditoID = Var_ProduCredID;

			/* Validacion para determinar si esta fondeado por fira */
			IF  Par_InstitFondeoID = Fondeo_FIRA THEN
				SET Var_EstatusGarantiaFIRA := Est_Autorizado;

				/* Si no se selecciona garantia en la pantalla de alta y es fondeado por fira necesita especificar */
				IF Par_TipoGarantiaFIRAID = Sin_Garantia THEN
					SET Par_NumErr 		:= 007;
					SET Par_ErrMen 		:= CONCAT('Seleccione un tipo de Garantia FIRA');
					SET Var_Control 	:= 'tipoGarantiaFIRAID';
					SET Var_Consecutivo	:= Par_TipoGarantiaFIRAID;
					LEAVE ManejoErrores;
				END IF;

			ELSE
				SET Var_EstatusGarantiaFIRA := Est_Inactivo;
			END IF;

			SET Var_CreditoID := (SELECT CreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);
			SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);

			CALL CREDTASAPASIVAAGROALT(
				Var_CreditoID,		Par_SolicitudCreditoID,	Par_TasaPasiva,	TipoAltaSolCred,	Cons_NO,
				Par_NumErr,			Par_ErrMen,				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF(IFNULL(Par_NumErr,Entero_Cero)!=Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			
			-- En caso de No Tener Garantia Asignada se Limpia los Datos de FIRA
			IF(Par_TipoGarantiaFIRAID = Sin_Garantia) THEN
				SET Par_AcreditadoIDFIRA = Entero_Cero;
				SET Par_CreditoIDFIRA = Entero_Cero;
			END IF;

			UPDATE SOLICITUDCREDITO SET
				CadenaProductivaID		= Par_CadenaProductivaID,
				RamaFIRAID				= Par_RamaFIRAID,
				SubramaFIRAID			= Par_SubramaFIRAID,
				ActividadFIRAID			= Par_ActividadFIRAID,
				TipoGarantiaFIRAID		= Par_TipoGarantiaFIRAID,
				EstatusGarantiaFIRA		= Var_EstatusGarantiaFIRA,
				ProgEspecialFIRAID		= Par_ProgEspecialFIRAID,
				EsAgropecuario			= SiEsAgropecuario,
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

			SET Par_NumErr 		:= 000;
			SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicitudCreditoID, CHAR));
			SET Var_Control 	:= 'solicitudCreditoID';
			SET Var_Consecutivo	:= Par_SolicitudCreditoID;
			LEAVE ManejoErrores;
		END IF;

		# Actualizacion 2: Actualizacion de Campos Agropecuarios para Créditos
		IF(IFNULL(Par_NumAct,Entero_Cero) = Act_CreditoAgro) THEN
			-- Se obtiene el producto de crédito y si Refinancia el interes .
			SELECT
				ProductoCreditoID,			Refinancia,					CadenaProductivaID,			RamaFIRAID,
				SubramaFIRAID,				ActividadFIRAID,			TipoGarantiaFIRAID,			ProgEspecialFIRAID,
				EstatusGarantiaFIRA,		CreditoID,					AcreditadoIDFIRA,			CreditoIDFIRA
			INTO
				Var_ProductoCreditoID,		Var_Refinancia,				Var_CadenaProductivaID,		Var_RamaFIRAID,
				Var_SubramaFIRAID,			Var_ActividadFIRAID,		Var_TipoGarantiaFIRAID,		Var_ProgEspecialFIRAID,
				Var_EstatusGarantiaFIRA,	Var_CreditoID,				Var_AcreditadoIDFIRA,		Var_CreditoIDFIRA
			FROM SOLICITUDCREDITO
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			SET Var_ProductoCreditoID 	:= IFNULL(Var_ProductoCreditoID, Entero_Cero);
			SET Var_Refinancia 			:= IFNULL(Var_Refinancia, Cons_NO);
			-- Se obtiene el tipo de cancelación de acuerdo a lo parametrizado en el calendario de ministraciones.
			SET Var_TipoCancelacion 	:= (SELECT TipoCancelacion FROM CALENDARIOMINISTRA WHERE ProductoCreditoID = Var_ProductoCreditoID);

			-- Se valida el tipo de cancelación
			IF(IFNULL(Var_TipoCancelacion,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'El Tipo de Cancelacion esta vacio.';
				SET Var_Control:= 'tipoCancelacion' ;
				SET Var_Consecutivo	:= Var_CreditoID;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_TipoCancelacion,Cadena_Vacia) NOT IN (TipoCancProrrateo, TipoCancSigInmed, TipoCancUltCoutas))THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'El Tipo de Cancelacion No es Valido.';
				SET Var_Control:= 'tipoCancelacion' ;
				SET Var_Consecutivo	:= Var_CreditoID;
				LEAVE ManejoErrores;
			END IF;

			CALL CREDTASAPASIVAAGROALT(
				Var_CreditoID,		Par_SolicitudCreditoID,	Par_TasaPasiva,	TipoAltaCredito,	Cons_NO,
				Par_NumErr,			Par_ErrMen,				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF(IFNULL(Par_NumErr,Entero_Cero)!=Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE CREDITOS SET
				TipoCancelacion 		= Var_TipoCancelacion,
				EsAgropecuario			= SiEsAgropecuario,
				Refinancia				= Var_Refinancia,
				CadenaProductivaID		= Var_CadenaProductivaID,
				RamaFIRAID				= Var_RamaFIRAID,
				SubramaFIRAID			= Var_SubramaFIRAID,
				ActividadFIRAID			= Var_ActividadFIRAID,
				TipoGarantiaFIRAID		= Var_TipoGarantiaFIRAID,
				ProgEspecialFIRAID		= Var_ProgEspecialFIRAID,
				EstatusGarantiaFIRA		= Var_EstatusGarantiaFIRA,
				AcreditadoIDFIRA		= Var_AcreditadoIDFIRA,
				CreditoIDFIRA			= Var_CreditoIDFIRA,

				EmpresaID				= Par_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual				= Aud_FechaActual,
				DireccionIP				= Aud_DireccionIP,
				ProgramaID				= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal,
				NumTransaccion			= Aud_NumTransaccion
			WHERE SolicitudCreditoID	= Par_SolicitudCreditoID;

			SELECT CreditoID
			INTO Var_NumCredito
			FROM IDENTIFICADORESAGRO
			WHERE CreditoID = Var_CreditoID;

			SET Var_NumCredito := IFNULL(Var_NumCredito, Entero_Cero);

			IF( Var_NumCredito = Entero_Cero ) THEN
				IF(IFNULL(Var_CreditoID,Entero_Cero) != Entero_Cero) THEN
					CALL GENERAIDCREDAGROPRO(
						Var_CreditoID,		Var_IdentificadorID,	Cons_NO,			Par_NumErr,			Par_ErrMen,
						Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr <> Entero_Cero) THEN
						SET Var_Control	:= '';
						SET Var_Consecutivo :=0;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			SET Par_NumErr 		:= 000;
			SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicitudCreditoID, CHAR));
			SET Var_Control 	:= 'creditoID';
			SET Var_Consecutivo	:= Var_CreditoID;
			LEAVE ManejoErrores;
		END IF;


		# Actualizacion 3: Actualizacion de Campos Agropecuarios para Créditos en el Pagare
		IF(IFNULL(Par_NumAct,Entero_Cero) = Act_PagareCredito) THEN
			# Institucion de FONDEO ####################################################################
			SELECT
				MontoCredito
			INTO
				Var_MontoCredito
			FROM CREDITOS
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			SET Par_TipoFondeo		:= IFNULL(Par_TipoFondeo, Cadena_Vacia);
			SET Var_MontoCredito	:= IFNULL(Var_MontoCredito, Entero_Cero);

			IF(Par_TipoFondeo != Rec_Propios AND Par_TipoFondeo != Rec_Fondeo ) THEN
				SET Par_NumErr			:= 8;
				SET Par_ErrMen			:= 'Favor de Especificar el Origen de los Recursos.';
				SET Var_Control			:= 'tipoFondeo';
				LEAVE ManejoErrores;
			END IF;

			IF (Par_TipoFondeo = Rec_Fondeo) THEN
				SELECT
					Ins.Estatus,		Lin.SaldoLinea
					INTO
					Var_EstFondeo,		Var_SaldoFondo
					FROM INSTITUTFONDEO Ins,
						LINEAFONDEADOR Lin
						WHERE	Ins.InstitutFondID	= Lin.InstitutFondID
						AND		Ins.InstitutFondID	= Par_InstitFondeoID
						AND		Lin.LineaFondeoID	= Par_LineaFondeo;

				SET Var_EstFondeo		:= IFNULL(Var_EstFondeo, Cadena_Vacia);
				SET Var_SaldoFondo		:= IFNULL(Var_SaldoFondo, Entero_Cero);

				IF (Var_EstFondeo != Estatus_Activo) THEN
					SET Par_NumErr  := 9;
					SET Par_ErrMen  := 'La Institucion de Fondeo No Existe o No esta Activa.';
					SET Var_Control  := 'lineaFondeo';
					LEAVE ManejoErrores;
				  ELSE
					IF (Var_SaldoFondo < Var_MontoCredito) THEN
						SET Par_NumErr  := 10;
						SET Par_ErrMen  := 'Saldo de la Linea de Fondeo Insuficiente.';
						SET Var_Control  := 'lineaFondeo';
						LEAVE ManejoErrores;
					END IF;
				END IF;

			END IF;

			UPDATE CREDITOS SET
				TipoFondeo				= Par_TipoFondeo,
				InstitFondeoID			= Par_InstitFondeoID,
				LineaFondeo				= Par_LineaFondeo,
				EmpresaID				= Par_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual				= Aud_FechaActual,
				DireccionIP				= Aud_DireccionIP,
				ProgramaID				= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal,
				NumTransaccion			= Aud_NumTransaccion
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
			SET Par_NumErr 				:= 000;
			SET Par_ErrMen 				:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicitudCreditoID, CHAR));
			SET Var_Control 			:= 'creditoID';
			SET Var_Consecutivo			:= Par_SolicitudCreditoID;
			LEAVE ManejoErrores;
		END IF;


		# Actualizacion 4: Actualizacion de Campos Agropecuarios para Créditos
		IF(IFNULL(Par_NumAct,Entero_Cero) = Act_CambioFonAgro) THEN
			IF(IFNULL(Par_SolicitudCreditoID,Entero_Cero)=Entero_Cero) THEN
				SET Par_NumErr := 01;
				SET Par_ErrMen := CONCAT('El Numero de Solicitud de Credito esta vacio.');
				LEAVE ManejoErrores;
			END IF;
			-- Se obtiene el producto de crédito y si Refinancia el interes .
			SELECT
				CreditoID
			INTO
				Var_CreditoID
			FROM SOLICITUDCREDITO
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			IF(IFNULL(Var_CreditoID,Entero_Cero) = Entero_Cero) THEN
				SET Var_CreditoID := (SELECT CreditoID FROM CREDITOS AS CRED
									WHERE CRED.SolicitudCreditoID = Par_SolicitudCreditoID);
				SET Var_CreditoID := IFNULL(Var_CreditoID,Entero_Cero);
			END IF;

			IF(IFNULL(Var_CreditoID,Entero_Cero)=Entero_Cero) THEN
				SET Par_NumErr := 03;
				SET Par_ErrMen := CONCAT('El Numero de Credito esta vacio.',Var_CreditoID);
				LEAVE ManejoErrores;
			END IF;

			UPDATE CREDITOS SET
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

			CALL CREDTASAPASIVAAGROALT(
				Var_CreditoID,		Par_SolicitudCreditoID,	Par_TasaPasiva,	TipoAltaCredito,	Cons_NO,
				Par_NumErr,			Par_ErrMen,				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF(IFNULL(Par_NumErr,Entero_Cero)!=Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr 		:= 000;
			SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicitudCreditoID, CHAR));
			SET Var_Control 	:= 'creditoID';
			SET Var_Consecutivo	:= Var_CreditoID;
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