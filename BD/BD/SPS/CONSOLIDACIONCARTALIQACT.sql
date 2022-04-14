-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLIDACIONCARTALIQACT
DELIMITER ;
DROP PROCEDURE IF EXISTS CONSOLIDACIONCARTALIQACT;


DELIMITER $$
CREATE PROCEDURE CONSOLIDACIONCARTALIQACT(
# =====================================================================================
# ------- SP PARA ACTUALIZAR LA SOLICITUD DE CRÉDITO DERIVADA DE UNA CONSOLIDACIÓN-----
# =====================================================================================
	Par_SolicCredID			BIGINT(20),			-- Número de Solicitud crédito
	Par_ConsolidaCartaID	INT(11),			-- Consecutivo de consolidación de acuerdo con la solicitud de crédito
	Par_TipoCredito			CHAR(1),			-- Tipo de Crédito N.- Nuevo, O.- Renovación
	Par_NumAct				TINYINT UNSIGNED,	-- Número de proceso de actualización

	Par_Salida				CHAR(1),			-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			-- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Control de Errores: Descripcion del Error
	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
	)

	TerminaStore: BEGIN
		-- Declara variables y constantes
		DECLARE Entero_Cero			INT(11);		-- Constante entero cero
		DECLARE Entero_Uno			INT(11);		-- Constante entero uno
		DECLARE Entero_Dos			INT(11);		-- Constante entero dos
		DECLARE Cadena_Vacia		CHAR(1);		-- Constante cadena vacia
		DECLARE Act_Disp			INT(11);		-- Varible para validar la existencia de la dispersión
		DECLARE Var_ActSolCre		INT(11);		-- Actualiza Solicicitud de Crédito
		DECLARE Var_ActConsol		INT(11);		-- Actualiza consolidación
		DECLARE Var_ActOperativas	INT(11);		-- Carga tablas operativas
		DECLARE Var_ConInternas		INT(11);		-- Cuenta internas
		DECLARE Var_ConExternas		INT(11);		-- Cuenta externas
		DECLARE Var_Estatus			CHAR(1);		-- Variable para el estatus de la dispesriòn
		DECLARE Var_Control			VARCHAR(100);	-- Variable de control
		DECLARE SalidaSI			CHAR(1);		-- Parametro de salida
		DECLARE SalidaNO			CHAR(1);		-- Salida NO
		DECLARE Var_TipoCredito		CHAR(1);		-- Tipo de consolidación
		DECLARE Var_EsConsolida		CHAR(1);		-- Es Consolidado
		DECLARE Var_Renovacion		CHAR(1);		-- Consolidación -Renovación
		DECLARE Var_Normal			CHAR(1);		-- Consolidación -Normal
		DECLARE Var_Consolidacion	CHAR(1);		-- Consolidación -Consolidacion
		DECLARE Var_SI				CHAR(1);		-- Constante SI
		DECLARE Var_NO				CHAR(1);		-- Constante NO
		DECLARE Var_Relacionado		BIGINT(12);		-- Crédito relacionado
		DECLARE Var_PlazoMax		DATETIME;		-- Plazo max del crédito relacionado
		DECLARE Var_Vencido			CHAR(1);		-- Estatus de crédito Vencido.- "V"
		DECLARE Var_Bigente			CHAR(1);		-- Estatus del crédito Vigente .- "B
		DECLARE Var_MontoConsolida	DECIMAL(14,2);	-- Monto acumualdo de la consolidación de cartas de liquidación
		DECLARE Var_EstatusN		CHAR(1);		-- Estatus N de la carta EXTERNA
		DECLARE Var_TmpExterna		CHAR(1);		-- Tipo carta Externa
		DECLARE Var_TmpInterna		CHAR(1);		-- Tipo carta Interna
		DECLARE n					INT;			-- N numero de cartas externas
		DECLARE i					INT;			-- Incremental para barrer la tabla de cartas externas
		DECLARE Var_AsignaID		INT(11);			-- Consecutivo de las cartas de asignación
		DECLARE Var_NumRegTemp		INT(11);			-- REgistros en la tabla operativa


		-- Inicializa Valores
		SET	Entero_Cero			:= 0;		-- Constante entero cero
		SET	Entero_Uno			:= 1;		-- Constante entero cero
		SET	Entero_Dos			:= 2;		-- Constante entero cero
		SET Cadena_Vacia		:= '';		-- Constante cadena vacia
		SET Var_ActConsol		:= 1;		-- Actualiza consolidación
		SET Var_ActSolCre		:= 2;		-- Actualiza Solicicitud de Crédito
		SET Var_ActOperativas	:= 3;		-- Descarga las cartas consolidadas en TMP a operativas
		SET Var_Estatus			:= 'A';		-- Estatus Autorizado
		SET SalidaSI			:= 'S';		-- Salida SI
		SET SalidaNO			:= 'N';		-- Salida NO
		SET Var_Renovacion		:= 'O';		-- Consolidación -Renovación
		SET Var_Normal			:= 'N';		-- Consolidación -Normal
		SET Var_Consolidacion	:= 'C';		-- Consolidación -Consolidacion
		SET Var_SI				:= 'S';		-- Constante SI
		SET Var_NO 				:= 'N';		-- Constante NO
		SET Var_Vencido			:= 'V';		-- Estatus de crédito Vencido.- "V"
		SET Var_Bigente			:= 'B';		-- Estatus del crédito Vigente .- "B
		SET Var_EstatusN		:= 'N';		-- Estatus N de la carta EXTERNA
		SET Var_TmpExterna		:= 'E';		-- Tipo carta Externa
		SET Var_TmpInterna		:= 'I';		-- Tipo carta Interna
		SET i					:= 0;

ManejoErrores:BEGIN


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSOLIDACIONCARTALIQACT');

		SET Var_Control:= 'sqlException';
	END;


		-- Actualiza el tipo de consolidación de acuerdo la regla cumplida de consolidación
		IF (Par_NumAct = Var_ActConsol) THEN

			IF (Par_ConsolidaCartaID = Entero_Cero AND Par_SolicCredID = Entero_Cero) THEN

				SET Par_NumErr := 001;
				SET Par_ErrMen := CONCAT('El valor de consolidación no es válido: ', CONVERT(Par_ConsolidaCartaID, CHAR));
				SET Var_Control:= 'consolidaCartaID';

				LEAVE ManejoErrores;

			END IF;

		IF (Par_ConsolidaCartaID = Entero_Cero AND Par_SolicCredID <> Entero_Cero) THEN

			IF NOT EXISTS(SELECT CAB.SolicitudCreditoID
							FROM CONSOLIDACARTALIQDET DET
						   INNER JOIN CONSOLIDACIONCARTALIQ CAB ON DET.ConsolidaCartaID = CAB.ConsolidaCartaID
						   WHERE CAB.SolicitudCreditoID = Par_SolicCredID) THEN

				SET Par_NumErr := 002;
				SET Par_ErrMen := CONCAT('El Número de solicitud de crédito no está relacionado: ', CONVERT(Par_SolicCredID, CHAR));
				SET Var_Control:= 'solicCredID';

				LEAVE ManejoErrores;

			END IF;

			SELECT COUNT(CAB.SolicitudCreditoID) INTO Var_ConInternas
			  FROM CONSOLIDACARTALIQDET DET
			 INNER JOIN CONSOLIDACIONCARTALIQ CAB ON DET.ConsolidaCartaID = CAB.ConsolidaCartaID AND DET.TipoCarta = Var_TmpInterna
			 WHERE CAB.SolicitudCreditoID = Par_SolicCredID ;

			SELECT COUNT(CAB.SolicitudCreditoID) INTO Var_ConExternas
			  FROM CONSOLIDACARTALIQDET DET
			 INNER JOIN CONSOLIDACIONCARTALIQ CAB ON DET.ConsolidaCartaID = CAB.ConsolidaCartaID AND DET.TipoCarta = Var_TmpExterna
			 WHERE CAB.SolicitudCreditoID = Par_SolicCredID ;

			IF (Var_ConInternas = Entero_Cero AND  Var_ConExternas = Entero_Cero)THEN

				SET Par_NumErr := 001;
				SET Par_ErrMen := CONCAT('La solicitud de crédito no tiene cartas asociadas: ', CONVERT(Par_SolicCredID, CHAR));
				SET Var_Control:= 'solicCredID';

				LEAVE ManejoErrores;

			END IF;

			-- RENOVACIÓN: Cuando se renueva un solo crédito internos o existente en Safi
			IF(Var_ConInternas = Entero_Uno AND  Var_ConExternas = Entero_Cero)THEN

				SET Var_TipoCredito		:= Var_Renovacion;
				SET Var_EsConsolida		:= Var_NO;

			-- NORMAL: Cuando se consoliden 1 o más créditos únicamente externos.
			ELSEIF (Var_ConInternas = Entero_Cero AND  Var_ConExternas >= Entero_Uno) THEN

				SET Var_TipoCredito		:= Var_Normal;
				SET Var_EsConsolida		:= Var_NO;

			-- CONSOLIDACION: Cuando se consolide 2 o más créditos y al menos exista un interno en ellos, en este caso pueden haber varios externos.
			ELSEIF ((Var_ConInternas + Var_ConExternas) >= Entero_Dos AND  Var_ConInternas >= Entero_Uno) THEN

				SET Var_TipoCredito		:= Var_Renovacion;
				SET Var_EsConsolida		:= Var_SI;

			END IF;

			-- Obtiene relacionado
			SELECT CRE.CreditoID,		MAX(CRE.FechaVencimien)
			  INTO Var_Relacionado,		Var_PlazoMax
			  FROM CONSOLIDACARTALIQDET		AS TMP
			 INNER JOIN CARTALIQUIDACION	AS CAR ON TMP.CartaLiquidaID	= CAR.CartaLiquidaID
			 INNER JOIN CREDITOS			AS CRE ON CAR.CreditoID			= CRE.CreditoID
			 WHERE CRE.CreditoID			= Par_SolicCredID
			   AND CRE.Estatus				= Var_Vencido
			 GROUP BY CRE.CreditoID
			 ORDER BY CRE.CreditoID
			 LIMIT 1;

			IF (IFNULL(Var_Relacionado,Entero_Cero)= Entero_Cero) THEN

				SELECT CRE.CreditoID,		MAX(CRE.FechaVencimien)
				  INTO Var_Relacionado,		Var_PlazoMax
				  FROM CONSOLIDACARTALIQDET		AS TMP
				 INNER JOIN CARTALIQUIDACION	AS CAR ON TMP.CartaLiquidaID	= CAR.CartaLiquidaID
				 INNER JOIN CREDITOS			AS CRE ON CAR.CreditoID 		= CRE.CreditoID
				 WHERE CRE.CreditoID			= Par_SolicCredID
				   AND CRE.Estatus 			= Var_Bigente
				 GROUP BY CRE.CreditoID
				 ORDER BY CRE.CreditoID
				 LIMIT 1;

				SET Var_Relacionado = IFNULL(Var_Relacionado,Entero_Cero);

			END IF;

				-- obtiene acumulado de las cartas
				SELECT (
							SELECT IFNULL(SUM(CDET.MontoLiquidar),0)
							  FROM CONSOLIDACIONCARTALIQ AS CONS
							 INNER JOIN CONSOLIDACARTALIQDET AS CINT ON CONS.ConsolidaCartaID = CINT.ConsolidaCartaID
							 INNER JOIN CARTALIQUIDACION AS CLIQ ON CINT.CartaLiquidaID = CLIQ.CartaLiquidaID
							 INNER JOIN CREDITOS AS CRE ON CLIQ.CreditoID = CRE.CreditoID
							 INNER JOIN CARTALIQUIDACIONDET CDET ON CLIQ.CartaLiquidaID = CDET.CartaLiquidaID
							 WHERE CONS.SolicitudCreditoID = Par_SolicCredID
						)
						+
						(
							SELECT IFNULL(SUM(ASIG.Monto ),0)
							  FROM CONSOLIDACIONCARTALIQ AS CONS
							 INNER JOIN CONSOLIDACARTALIQDET AS CINT ON CONS.ConsolidaCartaID = CINT.ConsolidaCartaID
							 INNER JOIN ASIGCARTASLIQUIDACION AS ASIG ON CINT.AsignacionCartaID = ASIG.AsignacionCartaID
							 WHERE CONS.SolicitudCreditoID = Par_SolicCredID
						) INTO	Var_MontoConsolida;

				-- Actualiza la consolidación de acuerdo las regla cumplidas de: Tipo de crédito, Es Consolidada, Crédito relacionado y monto de consolidación
				 UPDATE CONSOLIDACIONCARTALIQ
					SET TipoCredito			= Var_TipoCredito,
						EsConsolidado		= Var_EsConsolida,
						Relacionado			= Var_Relacionado,
						MontoConsolida		= Var_MontoConsolida
				  WHERE SolicitudCreditoID	= Par_SolicCredID;


		ELSE

			IF NOT EXISTS(SELECT ConsolidaCartaID
							FROM CONSOLIDACIONCARTALIQ
						   WHERE ConsolidaCartaID = Par_ConsolidaCartaID) THEN

				SET Par_NumErr := 002;
				SET Par_ErrMen := CONCAT('El Número de consolidación no existe: ', CONVERT(Par_ConsolidaCartaID, CHAR));
				SET Var_Control:= 'consolidaCartaID';

				LEAVE ManejoErrores;

			END IF;

			SELECT COUNT(ConsolidaCartaID) INTO Var_ConInternas
			  FROM TMPCARTASLIQUIDACION
			 WHERE ConsolidaCartaID = Par_ConsolidaCartaID ;

			SELECT COUNT(ConsolidaCartaID) INTO Var_ConExternas
			  FROM TMPASIGCARTASLIQUIDA
			 WHERE ConsolidaCartaID = Par_ConsolidaCartaID ;

			IF (Var_ConInternas = Entero_Cero AND  Var_ConExternas = Entero_Cero)THEN

				SET Par_NumErr := 001;
				SET Par_ErrMen := CONCAT('El folio de consolidación no tiene cartas asociadas: ', CONVERT(Par_ConsolidaCartaID, CHAR));
				SET Var_Control:= 'consolidaCartaID';

				LEAVE ManejoErrores;

			END IF;

				-- RENOVACIÓN: Cuando se renueva un solo crédito internos o existente en Safi
				IF(Var_ConInternas = Entero_Uno AND  Var_ConExternas = Entero_Cero)THEN

					SET Var_TipoCredito		:= Var_Renovacion;
					SET Var_EsConsolida		:= Var_NO;

				-- NORMAL: Cuando se consoliden 1 o más créditos únicamente externos.
				ELSEIF (Var_ConInternas = Entero_Cero AND  Var_ConExternas >= Entero_Uno) THEN

					SET Var_TipoCredito		:= Var_Normal;
					SET Var_EsConsolida		:= Var_NO;

				-- CONSOLIDACION: Cuando se consolide 2 o más créditos y al menos exista un interno en ellos, en este caso pueden haber varios externos.
				ELSEIF ((Var_ConInternas + Var_ConExternas) >= Entero_Dos AND  Var_ConInternas >= Entero_Uno) THEN

					SET Var_TipoCredito		:= Var_Renovacion;
					SET Var_EsConsolida		:= Var_SI;

				END IF;

				-- obtiene relacionado TMPs
				SELECT CRE.CreditoID,		MAX(CRE.FechaVencimien)
				  INTO Var_Relacionado,		Var_PlazoMax
				  FROM TMPCARTASLIQUIDACION		AS TMP
				 INNER JOIN CARTALIQUIDACION	AS CAR ON TMP.CartaLiquidaID	= CAR.CartaLiquidaID
				 INNER JOIN CREDITOS			AS CRE ON CAR.CreditoID			= CRE.CreditoID
				 WHERE TMP.ConsolidaCartaID		= Par_ConsolidaCartaID
				   AND CRE.Estatus				= Var_Vencido
				 GROUP BY CRE.CreditoID
				 ORDER BY CRE.CreditoID
				 LIMIT 1;



				IF (IFNULL(Var_Relacionado,Entero_Cero)= Entero_Cero) THEN

					SELECT CRE.CreditoID,		MAX(CRE.FechaVencimien)
					  INTO Var_Relacionado,		Var_PlazoMax
					  FROM TMPCARTASLIQUIDACION		AS TMP
					 INNER JOIN CARTALIQUIDACION	AS CAR ON TMP.CartaLiquidaID	= CAR.CartaLiquidaID
					 INNER JOIN CREDITOS			AS CRE ON CAR.CreditoID 		= CRE.CreditoID
					 WHERE TMP.ConsolidaCartaID	= Par_ConsolidaCartaID
					   AND CRE.Estatus 			= Var_Bigente
					 GROUP BY CRE.CreditoID
					 ORDER BY CRE.CreditoID
					 LIMIT 1;

					SET Var_Relacionado = IFNULL(Var_Relacionado,Entero_Cero);

				END IF;

				-- obtiene acumulado de las cartas para comparar posteriormente el monto solicitado
				SELECT (
							SELECT IFNULL(SUM(CDET.MontoLiquidar),0)
							  FROM CONSOLIDACIONCARTALIQ AS CONS
							 INNER JOIN TMPCARTASLIQUIDACION AS CINT ON CONS.ConsolidaCartaID = CINT.ConsolidaCartaID
							 INNER JOIN CARTALIQUIDACION AS CLIQ ON CINT.CartaLiquidaID = CLIQ.CartaLiquidaID
							 INNER JOIN CREDITOS AS CRE ON CLIQ.CreditoID = CRE.CreditoID
							 INNER JOIN CARTALIQUIDACIONDET CDET ON CLIQ.CartaLiquidaID = CDET.CartaLiquidaID
							 WHERE CONS.ConsolidaCartaID = Par_ConsolidaCartaID
						)
						+
						(
							SELECT IFNULL(SUM(ASIG.Monto ),0)
							  FROM CONSOLIDACIONCARTALIQ AS CONS
							 INNER JOIN TMPASIGCARTASLIQUIDA AS ASIG ON CONS.ConsolidaCartaID = ASIG.ConsolidaCartaID
							 WHERE CONS.ConsolidaCartaID = Par_ConsolidaCartaID
						) INTO	Var_MontoConsolida;

				-- Actualiza la consolidación de acuerdo las regla cumplidas de: Tipo de crédito, Es Consolidada, Crédito relacionado y monto de consolidación
				 UPDATE CONSOLIDACIONCARTALIQ
					SET TipoCredito			= Var_TipoCredito,
						EsConsolidado		= Var_EsConsolida,
						Relacionado			= Var_Relacionado,
						MontoConsolida		= Var_MontoConsolida
				  WHERE ConsolidaCartaID	= Par_ConsolidaCartaID;

			END IF;



		END IF;

		-- 2.- Actualiza los valores de la solicitud para indentidicar si proviene del flujo de consolidación
		IF (Par_NumAct = Var_ActSolCre) THEN

			IF NOT EXISTS (SELECT SolicitudCreditoID
							   FROM SOLICITUDCREDITO
							  WHERE SolicitudCreditoID = Par_SolicCredID) THEN

				SET Par_NumErr := 001;
				SET Par_ErrMen := CONCAT('La solicitud de crédito no existe: ', CONVERT(Par_SolicCredID, CHAR));
				SET Var_Control:= 'solicitudCreditoID';

				LEAVE ManejoErrores;

			END IF;

			IF NOT EXISTS(SELECT ConsolidaCartaID
							FROM CONSOLIDACIONCARTALIQ
						   WHERE ConsolidaCartaID = Par_ConsolidaCartaID) THEN

				SET Par_NumErr := 002;
				SET Par_ErrMen := CONCAT('El Número de consolidación no existe: ', CONVERT(Par_ConsolidaCartaID, CHAR));
				SET Var_Control:= 'consolidaCartaID';

				LEAVE ManejoErrores;

			END IF;

			 -- Actualiza la consolidación de acuerdo con la solicitud de crédito generada
			 UPDATE CONSOLIDACIONCARTALIQ
				SET SolicitudCreditoID	= 0
			  WHERE SolicitudCreditoID 	= Par_SolicCredID;

			 UPDATE CONSOLIDACIONCARTALIQ
				SET solicitudCreditoID	= Par_SolicCredID
			  WHERE ConsolidaCartaID 	= Par_ConsolidaCartaID;

			SELECT EsConsolidado
			  INTO Var_EsConsolida
			  FROM CONSOLIDACIONCARTALIQ
			 WHERE ConsolidaCartaID = Par_ConsolidaCartaID;

			-- Actualiza los valores de la solicitud para indentidicar si proviene del flujo de consolidación

			UPDATE SOLICITUDCREDITO
			   SET	EsConsolidado		= Var_EsConsolida,
					FlujoOrigen			= Var_Consolidacion
			 WHERE SolicitudCreditoID	= Par_SolicCredID;

		END IF;

		-- 3.-	Cuando la solicitud de crédito es nueva, se descargan las cartas de liquidación
		-- 		de las tablas temporales a las tablas operativas
		IF (Par_NumAct = Var_ActOperativas) THEN

			SELECT COUNT(*)
			  INTO Var_NumRegTemp
			  FROM ASIGCARTASLIQUIDACION
			 WHERE SolicitudCreditoID = Par_SolicCredID;

			IF (Var_NumRegTemp = Entero_Cero) THEN
			-- Descarga Cartas Externas
				SELECT COUNT(TMP.ConsolidaCartaID) INTO n
				FROM TMPASIGCARTASLIQUIDA TMP
				INNER JOIN CONSOLIDACIONCARTALIQ CONS ON TMP.ConsolidaCartaID = CONS.ConsolidaCartaID
				WHERE CONS.ConsolidaCartaID = Par_ConsolidaCartaID;



				WHILE i < n DO

					SET Var_AsignaID := (SELECT IFNULL(MAX(AsignacionCartaID),Entero_Cero) + 1 FROM ASIGCARTASLIQUIDACION);


					INSERT INTO ASIGCARTASLIQUIDACION(
						AsignacionCartaID,		SolicitudCreditoID,		CasaComercialID,	Monto,			FechaVigencia,
						Estatus,				ArchivoIDCarta,			ArchivoIDPago,		EmpresaID,		Usuario,
						FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)

					SELECT	Var_AsignaID,		CONS.SolicitudCreditoID,	TMP.CasaComercialID,	TMP.Monto,			TMP.FechaVigencia,
							Var_EstatusN,		Entero_Cero,				Entero_Cero,			Aud_EmpresaID,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion

					  FROM TMPASIGCARTASLIQUIDA TMP
					 INNER JOIN CONSOLIDACIONCARTALIQ CONS ON TMP.ConsolidaCartaID = CONS.ConsolidaCartaID
					 WHERE CONS.ConsolidaCartaID = Par_ConsolidaCartaID
					 ORDER BY TMP.ConsolidaCartaID, TMP.Consecutivo
					 LIMIT i,1;

					SET i = i + 1;

					-- Se elimina detalles si ya existen
					-- DELETE FROM CONSOLIDACARTALIQDET  WHERE ConsolidaCartaID = Par_ConsolidaCartaID AND CartaLiquidaID = Entero_Cero;

					-- Carga la información de la TMP de cartas externas al detalle de consolidación
					INSERT INTO CONSOLIDACARTALIQDET (
									ConsolidaCartaID,	AsignacionCartaID,	CartaLiquidaID,		TipoCarta,		EmpresaID,
									Usuario,			FechaActual,		DireccionIP,		ProgramaID,		Sucursal,
									NumTransaccion)

					SELECT	ConsolidaCartaID,	Var_AsignaID,		Entero_Cero,		Var_TmpExterna,		Aud_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion
					  FROM TMPASIGCARTASLIQUIDA
					 WHERE ConsolidaCartaID		= Par_ConsolidaCartaID
					   AND Consecutivo			= i ;

				END WHILE;



			-- TERMINA Cartas Externas

			-- Se elimina detalles si ya existen.
			DELETE FROM CONSOLIDACARTALIQDET  WHERE ConsolidaCartaID = Par_ConsolidaCartaID AND AsignacionCartaID = Entero_Cero;

			-- Inserta Cartas de liquidación internas.

			INSERT INTO CONSOLIDACARTALIQDET (
							ConsolidaCartaID,	AsignacionCartaID,	CartaLiquidaID,		TipoCarta,		EmpresaID,
							Usuario,			FechaActual,		DireccionIP,		ProgramaID,		Sucursal,
							NumTransaccion)

			SELECT ConsolidaCartaID,	Entero_Cero	,		CartaLiquidaID,		Var_TmpInterna,		Aud_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion

			 FROM TMPCARTASLIQUIDACION
			WHERE ConsolidaCartaID = Par_ConsolidaCartaID;

			END IF;
		END IF;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('La actualización se realizó exitosamente : ',CONVERT(Par_ConsolidaCartaID, CHAR));
		SET Var_Control 	:= 'consolidaCartaID';


END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT
			Par_NumErr				AS NumErr,
			Par_ErrMen				AS ErrMen,
			Var_Control				AS Control,
			Par_ConsolidaCartaID	AS Consecutivo;
	END IF;

END TerminaStore$$