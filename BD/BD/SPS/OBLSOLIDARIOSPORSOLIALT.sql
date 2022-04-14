-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBLSOLIDARIOSPORSOLIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBLSOLIDARIOSPORSOLIALT`;DELIMITER $$

CREATE PROCEDURE `OBLSOLIDARIOSPORSOLIALT`(
	-- SP DE ALTA PARA OBLIGADOS SOLIDARIOS POR SOLICITUD DE CREDITO
	Par_SolCreditoID				INT(11),					-- Identificador de la Solicitud de credito
	Par_OblSolidID					INT(11),					-- Identificador del Obligado solidario
	Par_ClienteID					INT(11),					-- Identificador del Cliente
	Par_ProspectoID					INT(11),					-- Identificador del Prospecto
	Par_Estatus						CHAR(1),					-- Estatus del Obligado solidario asociado a una Solicitud A: Alta, U: Autorizado
	Par_TipoRelacionID				INT(11),					-- Identificador del tipo de relacion con el Obligado solidario
	Par_TiempoDeConocido			DECIMAL(12,2),				-- Tiempo de conocer al Obligado solidario en anios

	Par_Salida						CHAR(1),					-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr				INT(11),					-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				-- Mensaje de Error

	Aud_EmpresaID					INT(11),					-- Parametro de auditoria referente al Identificador de la empresa
	Aud_Usuario						INT(11),					-- Parametro de auditoria referente al usuario
	Aud_FechaActual					DATETIME,					-- Parametro de auditoria referente a la fecha actual
	Aud_DireccionIP					VARCHAR(15),				-- Parametro de auditoria referente a la direccion ip
	Aud_ProgramaID					VARCHAR(50),				-- Parametro de auditoria referente al identificador de el programa
	Aud_Sucursal					INT(11),					-- Parametro de auditoria referente a la sucursal
	Aud_NumTransaccion				BIGINT(20)					-- Parametro de auditoria referente al numero de transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_OblCruz				CHAR(1);					-- Declaracion de variable OblCruz
	DECLARE Var_SolApro				INT(11);					-- Declaracion de variable Solicitud Aprobada
	DECLARE Var_ReqObli				CHAR(1);					-- Declaracion de variable Requicito obligatorio
	DECLARE Var_EsGru				CHAR(1);					-- Declaracion de variable EsGru
	DECLARE Var_Control				VARCHAR(50);				-- Declaracion de variable Control
	DECLARE Var_SolProspeID			INT(11);					-- Declaracion de variable Solicitud Prospecto
	DECLARE Var_SolCliID			BIGINT;						-- Declaracion de variable Solicitud Cliente

	-- Agregado de variables nuevas que corresponden a parametro TipoRelacionID.
	DECLARE Var_TipoRelacionID		INT(11);					-- Declaracion de variables Tipo Relacion

-- Variables para el Cursor
	DECLARE Var_SolCredID			BIGINT;						-- Identificador solicitud credito
	DECLARE Var_SolEstatus			CHAR(1);					-- Solicitud Estatus
	DECLARE Var_CreditoID			BIGINT(12);					-- CreditoID
	DECLARE Var_CreEstatus			CHAR(1);					-- CreEstatus
	DECLARE Var_GrupoID				INT(11);					-- GrupoID
	DECLARE Var_GrupoSolID			INT(11);					-- GrupoSolID
	DECLARE Var_FechaSis			DATETIME;					-- FechaSis

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);					-- Entero Cero
	DECLARE Cadena_Vacia			CHAR(1);					-- Cadena Vacia
	DECLARE Decimal_Cero			DECIMAL(12,2);				-- Decimal Vacio
	DECLARE Decimal_Cien			DECIMAL(12,2);				-- Decimal Cien
	DECLARE Est_Asignado			CHAR(1);					-- Est_Asignado
	DECLARE Est_Autorizado			CHAR(1);					-- Est_Autorizado
	DECLARE No_OblCruzado			CHAR(1);					-- No_OblCruzado
	DECLARE Cre_Pagado				CHAR(1);					-- CrePagado
	DECLARE No_ReqObligad			CHAR(1);					-- No es Grupal
	DECLARE No_EsGrupal				CHAR(1);					-- Salida si
	DECLARE SalidaSI				CHAR(1);					-- Salida no
	DECLARE SalidaNO				CHAR(1);					-- Solicitud inactiva
	DECLARE Sol_Inactiva			CHAR(1);					-- Solicitud liberada
	DECLARE Sol_Autoriza			CHAR(1);					-- Solicitud Autorizada
	DECLARE Sol_Liberada			CHAR(1);					-- Solicitud liberada
	DECLARE Cre_Vigente				CHAR(1);					-- Cre_Vigente
	DECLARE Cre_Vencido				CHAR(1);					-- Cre_Vencido
	DECLARE MenorEdad				CHAR(1);					-- Menor edad

	-- Cursores para Buscar si el Obligado Solidario esta Asignado con otras Solicitudes
	DECLARE CURSORSOLOBLIGADO CURSOR FOR
		SELECT SOL.SolicitudCreditoID, SOL.Estatus, CRE.CreditoID, CRE.Estatus, SOL.GrupoID
			FROM OBLSOLIDARIOSPORSOLI OBL, SOLICITUDCREDITO SOL
				LEFT OUTER JOIN CREDITOS CRE on CRE.CreditoID = SOL.CreditoID
			WHERE OBL.OblSolidID = Par_OblSolidID
				AND SOL.SolicitudCreditoID    = OBL.SolicitudCreditoID;

	DECLARE CURSORSOLCLIENTE CURSOR FOR
		SELECT SOL.SolicitudCreditoID, SOL.Estatus, CRE.CreditoID, CRE.Estatus, SOL.GrupoID
			FROM OBLSOLIDARIOSPORSOLI OBL, SOLICITUDCREDITO SOL
				LEFT JOIN CREDITOS CRE ON CRE.CreditoID = SOL.CreditoID
			WHERE OBL.ClienteID = Par_ClienteID
				AND SOL.SolicitudCreditoID    = OBL.SolicitudCreditoID
				AND OBL.ClienteID NOT IN (  SELECT ING.ClienteID	-- Si el Obligado Solidario pertence al mismo
																-- Grupo los Discriminamos para la Validacion
												FROM INTEGRAGRUPOSCRE ING
												WHERE ING.GrupoID = Var_GrupoSolID
													AND ING.ClienteID = Par_ClienteID );

	DECLARE CURSORSOLPROSPE CURSOR FOR
		SELECT SOL.SolicitudCreditoID, SOL.Estatus, CRE.CreditoID, CRE.Estatus, SOL.GrupoID
			FROM OBLSOLIDARIOSPORSOLI OBL, SOLICITUDCREDITO SOL
				LEFT OUTER JOIN CREDITOS CRE on CRE.CreditoID = SOL.CreditoID
			WHERE OBL.ProspectoID = Par_ProspectoID
				AND SOL.SolicitudCreditoID    = OBL.SolicitudCreditoID
				AND OBL.ProspectoID NOT IN (  SELECT ING.ProspectoID		-- Si el Obligado Solidario pertence al mismo
																-- Grupo los Discriminamos para la Validacion
												FROM INTEGRAGRUPOSCRE ING
												WHERE ING.GrupoID = Var_GrupoSolID
													AND ING.ProspectoID = Par_ProspectoID );

	-- Cursores para Buscar al Obligado Solidario como Acreditado o Solicitante
	DECLARE CURSORCLISOLICI CURSOR FOR
		SELECT SOL.SolicitudCreditoID, SOL.Estatus, CRE.CreditoID, CRE.Estatus, SOL.GrupoID
			FROM SOLICITUDCREDITO SOL
				LEFT OUTER JOIN CREDITOS CRE on CRE.CreditoID = SOL.CreditoID
			WHERE SOL.ClienteID     = Par_ClienteID
				AND SOL.ClienteID NOT IN (  SELECT ING.ClienteID				-- Si el Obligado Solidario pertence al mismo
																	-- Grupo los Discriminamos
												FROM INTEGRAGRUPOSCRE ING
												WHERE ING.GrupoID = Var_GrupoSolID
													AND ING.ClienteID = Par_ClienteID);

	DECLARE CURSORPROSPESOLICI CURSOR FOR
		SELECT SOL.SolicitudCreditoID, SOL.Estatus, CRE.CreditoID, CRE.Estatus, SOL.GrupoID
			FROM SOLICITUDCREDITO SOL
				LEFT OUTER JOIN CREDITOS CRE on CRE.CreditoID = SOL.CreditoID
			WHERE SOL.ProspectoID     = Par_ProspectoID
				AND SOL.ProspectoID NOT IN (  SELECT ING.ProspectoID		-- Si el Obligado Solidario pertence al mismo
																	-- Grupo los Discriminamos
												FROM INTEGRAGRUPOSCRE ING
												WHERE ING.GrupoID = Var_GrupoSolID
													AND ING.ProspectoID = Par_ProspectoID);

	-- ------------------

	-- Cursores para Buscar al Obligado Solidario como Aval en otra solicitud
	DECLARE CURSORAVALCLISOLICI CURSOR FOR
		SELECT SOL.SolicitudCreditoID, SOL.Estatus, CRE.CreditoID, CRE.Estatus, SOL.GrupoID
			FROM AVALESPORSOLICI AVAL
				LEFT JOIN OBLSOLIDARIOSPORSOLI OBL ON AVAL.ClienteID = OBL.ClienteID
                LEFT JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = AVAL.SolicitudCreditoID
                LEFT OUTER JOIN CREDITOS CRE on CRE.CreditoID = SOL.CreditoID
			WHERE AVAL.ClienteID = Par_ClienteID
			AND AVAL.ClienteID NOT IN (  SELECT ING.ClienteID	-- Si el Obligado Solidario pertence al mismo
																-- Grupo los Discriminamos para la Validacion
												FROM INTEGRAGRUPOSCRE ING
												WHERE ING.GrupoID = Var_GrupoSolID
													AND ING.ClienteID = Par_ClienteID );



	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;			-- Entero en Cero
	SET Cadena_Vacia			:= '';			-- Cadena Vacia
	SET Decimal_Cero			:= 0.00;		-- Decimal en Cero
	SET Decimal_Cien			:= 100.00;		-- Decimal Cien
	SET Est_Autorizado			:= 'U';			-- Estatus de la Asignacion del Obligado Solidario: Autorizado
	SET Est_Asignado			:= 'A';			-- Estatus de la Asignacion del Obligado Solidario: alta o No autorizado
	SET No_OblCruzado			:= 'N';			-- El producto de Credito NO Permite Obligados Solidarios Cruzados
	SET Cre_Pagado				:= 'P';			-- Estatus del Credito: Pagado
	SET No_ReqObligad			:= 'N';			-- El producto de Credito No Requiere Avales
	SET No_EsGrupal				:= 'N';			-- El producto de Credito No es Grupal
	SET SalidaSI				:= 'S';			-- El store SI arroja un SELECT de Salida
	SET SalidaNO				:= 'N';			-- El store NO arroja un SELECT de Salida
	SET Sol_Inactiva			:= 'I';			-- Estatus de la Solicitud: Inactiva
	SET Sol_Autoriza			:= 'A';			-- Estatus de la Solicitud: Autorizada
	SET Sol_Liberada			:= 'L';			-- Estatus de la Solicitud: Liberada
	SET Cre_Vigente				:= 'V';			-- Estatus del Credito: Vigente
	SET Cre_Vencido				:= 'B';			-- Estatus del Credito: Vencido
	SET MenorEdad				:= 'S';			-- Si es Menor de Edad

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT("El SAFI ha tenido un problema al concretar la operacion. " ,
									"Disculpe las molestias que esto le ocasiona. Ref: SP-OBLSOLIDARIOSPORSOLIALT");
	END;

	IF(IFNULL(Par_SolCreditoID, Entero_Cero)) = Entero_Cero then
		SET Par_NumErr  := '001';
		SET Par_ErrMen  := 'La Solicitud de Credito esta Vacia.';
		SET Var_Control  := 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	-- Validaciones para los parametros nuevos de la tabla OBLSOLIDARIOSPORSOLI
	IF(IFNULL(Par_TiempoDeConocido, Decimal_Cero) = Decimal_Cero) THEN
		SET Par_NumErr	:= 008;
		SET Par_ErrMen	:= 'El tiempo de conocido esta vacio.';
		SELECT	Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				'clienteID' as control,
				Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(Par_TiempoDeConocido >= Decimal_Cien) THEN
		SET Par_NumErr	:= 009;
		SET Par_ErrMen	:= 'El tiempo de conocido no puede ser mayor que 100.';
		SELECT	Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				'clienteID' as control,
				Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	END IF;
	-- Se valida el ID del tipo de relacion
	SELECT TipoRelacionID INTO Var_TipoRelacionID
		FROM TIPORELACIONES
		WHERE TipoRelacionID = Par_TipoRelacionID;

	SET Var_TipoRelacionID	:= IFNULL(Var_TipoRelacionID,Entero_Cero);

	IF(Var_TipoRelacionID = Entero_Cero) THEN
		SET Par_NumErr	:= 010;
		SET Par_ErrMen	:= 'El parentesco especificado no se encuentra en la base de datos.';
		SELECT	Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				'clienteID' as control,
				Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	END IF;
	-- Fin de la validacion
	-- Fin de validaciones para los parametros nuevos.

	SELECT PRO.ReqObligadosSolidarios,  PRO.EsGrupal, 	PRO.PerObligadosCruzados, GrupoID,
		   SOL.ProspectoID,		SOL.ClienteID
	 INTO Var_ReqObli,			Var_EsGru, 		Var_OblCruz,    		Var_GrupoSolID,
		   Var_SolProspeID,   	Var_SolCliID
		FROM SOLICITUDCREDITO SOL,
			 PRODUCTOSCREDITO PRO
		WHERE SOL.SolicitudCreditoID    = Par_SolCreditoID
			AND SOL.ProductoCreditoID     = PRO.ProducCreditoID;


	SET Var_ReqObli		:= IFNULL(Var_ReqObli, Cadena_Vacia);
	SET Var_EsGru 		:= IFNULL(Var_EsGru, Cadena_Vacia);
	SET Var_OblCruz 	:= IFNULL(Var_OblCruz, Cadena_Vacia);
	SET Var_GrupoSolID	:= IFNULL(Var_GrupoSolID, Entero_Cero);
	SET Var_SolProspeID	:= IFNULL(Var_SolProspeID, Entero_Cero);
	SET Var_SolCliID	:= IFNULL(Var_SolCliID, Entero_Cero);

	SET Par_ClienteID	:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_ProspectoID	:= IFNULL(Par_ProspectoID, Entero_Cero);

	SELECT FechaSistema INTO Var_FechaSis
		FROM PARAMETROSSIS;

	IF(Var_ReqObli = Cadena_Vacia)THEN
		SET Par_NumErr := '002';
		SET Par_ErrMen := CONCAT("La Solicitud " , CAST(Par_SolCreditoID AS CHAR), " NO Existe.");
		SET Var_Control:= 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Var_ReqObli = No_ReqObligad AND Var_EsGru = No_EsGrupal)THEN
		SET Par_NumErr :='003';
		SET Par_ErrMen := CONCAT("La Solicitud " , CAST(Par_SolCreditoID AS CHAR), " NO requiere Obligados Solidarios");
		SET Var_Control:= 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	-- Valida que no se encuentre Asignado en la misma Solicitud
	IF(EXISTS(  SELECT SolicitudCreditoID
					FROM OBLSOLIDARIOSPORSOLI
					WHERE SolicitudCreditoID  = Par_SolCreditoID
					  AND OblSolidID    = Par_OblSolidID
					  AND ClienteID     = Par_ClienteID
					  AND ProspectoID   = Par_ProspectoID))THEN

		IF( Par_OblSolidID != Entero_Cero )THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := CONCAT('El Obligado Solidario ', CONVERT(Par_OblSolidID, CHAR),
									' ya se Encuentra Asignado en esta Solicitud.');
			SET Var_Control  := 'solicitudCreditoID' ;
			LEAVE ManejoErrores;
		ELSE
			IF( Par_OblSolidID != Entero_Cero AND Par_ClienteID != Entero_Cero)THEN
				SET Par_NumErr  := '004';
				SET Par_ErrMen  := CONCAT('El safilocale.cliente ', CONVERT(Par_ClienteID, CHAR),
									' ya se Encuentra Asignado como Obligado Solidario en esta Solicitud.');
				SET Var_Control  := 'solicitudCreditoID' ;
				LEAVE ManejoErrores;
			ELSE
				SET Par_NumErr  := '004';
				SET Par_ErrMen  := CONCAT('El Prospecto ', CONVERT(Par_ProspectoID, CHAR),
									' ya se Encuentra Asignado como Obligado Solidario en esta Solicitud.');
				SET Var_Control  := 'solicitudCreditoID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	-- Validamos que no se Asigne asi mismo como Obliado Solidario
	IF(Var_SolProspeID != Entero_Cero AND
		Var_SolProspeID = Par_ProspectoID )THEN

		SET Par_NumErr  := '016';
		SET Par_ErrMen  := CONCAT('El Prospecto No Puede Asignarse el Mismo como Obligado Solidario, ',
									'Prospecto: ', CONVERT(Par_ProspectoID, CHAR) );
		SET Var_Control  := 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Var_SolCliID != Entero_Cero AND
		Var_SolCliID = Par_ClienteID )THEN

		SET Par_NumErr  := '017';
		SET Par_ErrMen  := CONCAT('El safilocale.cliente No Puede Asignarse el Mismo como Obligado Solidario, ',
									'safilocale.cliente No.: ', CONVERT(Par_ClienteID, CHAR) );
		SET Var_Control  := 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	-- Validaciones de Obligados solidarios Cruzados
	-- 1.- No puede estar como Obligado Solidario en otras Solicitudes si la Solicitud que avala esta:
	-- a ) Autorizada o Pendiente de Autorizar (Inactiva)
	-- b ) Si la solicitud ya es Credito y el credito esta Vivo (vigente Ã³ vencido).
	-- 2 .- No puede estar como Obligado Solidario, si el Obligado Solidario tiene una solicitud de credito o un credito que:
	-- a ) Solicitud de Credito Autorizada o Pendiente de Autorizar
	-- b ) Si tiene un Credito y el credito esta Vivo (Vigente Ã³ Vencido)
	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := Cadena_Vacia;

	IF(Var_OblCruz = No_OblCruzado)THEN

		IF(Par_OblSolidID <> Entero_Cero)THEN

			OPEN CURSORSOLOBLIGADO;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOOBLIGADOS:LOOP
					FETCH CURSORSOLOBLIGADO INTO
						Var_SolCredID,  Var_SolEstatus, Var_CreditoID,  Var_CreEstatus, Var_GrupoID;

						SET Var_GrupoID = IFNULL(Var_GrupoID, Entero_Cero);

						IF( Var_SolEstatus = Sol_Inactiva or
							 Var_SolEstatus = Sol_Autoriza or
							 Var_SolEstatus = Sol_Liberada )THEN

							IF(Var_GrupoID = Entero_Cero)THEN
								SET Par_NumErr  := '005';
								SET Par_ErrMen  := CONCAT("El Obligado Solidario ", CONVERT(Par_OblSolidID, CHAR),
														" ya esta Asignado a la Solicitud: ",
														CONVERT(Var_SolCredID, CHAR));
								LEAVE CICLOOBLIGADOS;
							ELSE
								SET Par_NumErr  := '005';
								SET Par_ErrMen  := CONCAT("El Obligado Solidario ", CONVERT(Par_OblSolidID, CHAR),
														" ya esta Asignado a la Solicitud: ",
														CONVERT(Var_SolCredID, CHAR), ", Grupo: ",
														CONVERT(Var_GrupoID, CHAR));
								LEAVE CICLOOBLIGADOS;
							END IF;

						END IF;

						SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
						SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

						IF( Var_CreEstatus  = Cre_Vigente or
							Var_CreEstatus  = Cre_Vencido )THEN

							SET Par_NumErr  := '006';
							SET Par_ErrMen  := CONCAT("El Obligado Solidario ", CONVERT(Par_OblSolidID, CHAR),
													  " ya esta Asignado al Credito: ",
													  CONVERT(Var_CreditoID, CHAR));
							LEAVE CICLOOBLIGADOS;
						END IF;

					End LOOP CICLOOBLIGADOS;
				END;
			CLOSE CURSORSOLOBLIGADO;

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;     -- EndIf Par_OblSolidID <> Entero_Cero



		IF(Par_ClienteID != Entero_Cero)THEN

			OPEN CURSORSOLCLIENTE;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOCLIENTES:LOOP
					FETCH CURSORSOLCLIENTE INTO
						Var_SolCredID,  Var_SolEstatus, Var_CreditoID,  Var_CreEstatus, Var_GrupoID;

						SET Var_GrupoID = IFNULL(Var_GrupoID, Entero_Cero);

						IF( Var_SolEstatus = Sol_Inactiva OR
								Var_SolEstatus = Sol_Autoriza OR
								Var_SolEstatus = Sol_Liberada )THEN

							IF(Var_GrupoID = Entero_Cero)THEN

								SET Par_NumErr  := '007';
								SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
															" ya esta asignado como Obligado Solidario a la Solicitud: ",
															CONVERT(Var_SolCredID, CHAR));
								LEAVE CICLOCLIENTES;
							ELSE
								SET Par_NumErr  := '007';
								SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
															" ya esta asignado como Obligado Solidario a la Solicitud: ",
															CONVERT(Var_SolCredID, CHAR), ", Grupo: ",
															CONVERT(Var_GrupoID, CHAR));
								LEAVE CICLOCLIENTES;
							END IF;
						END IF;



						SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
						SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

						IF( Var_CreEstatus  = Cre_Vigente or
							Var_CreEstatus  = Cre_Vencido )THEN

							SET Par_NumErr  := '008';
							SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
													" ya esta Asignado como Obligado Solidario al Credito: ",
													CONVERT(Var_CreditoID, CHAR));
							LEAVE CICLOCLIENTES;
						END IF;

					End LOOP CICLOCLIENTES;
				END;
			CLOSE CURSORSOLCLIENTE;

			-- SE VALIDA QUE EL OBLIGADO SOLIDARIO(ClienteID) NO SEA AVAL
			OPEN CURSORAVALCLISOLICI;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END; -- MIKE
					CICLOAVALES:LOOP
					FETCH CURSORAVALCLISOLICI INTO
						Var_SolCredID,  Var_SolEstatus, Var_CreditoID,  Var_CreEstatus, Var_GrupoID;

						SET Var_GrupoID = IFNULL(Var_GrupoID, Entero_Cero);

						IF( Var_SolEstatus = Sol_Inactiva OR
								Var_SolEstatus = Sol_Autoriza OR
								Var_SolEstatus = Sol_Liberada )THEN

							IF(Var_GrupoID = Entero_Cero)THEN

								SET Par_NumErr  := '010';
								SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
															" que se intenta asignar como obligado solidario, esta asignado como aval de la Solicitud: ",
															CONVERT(Var_SolCredID, CHAR));
								LEAVE CICLOAVALES;
							ELSE
								SET Par_NumErr  := '010';
								SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
															" que se intenta asignar como obligado solidario, esta asignado como aval de la Solicitud: ",
															CONVERT(Var_SolCredID, CHAR), ", Grupo: ",
															CONVERT(Var_GrupoID, CHAR));
								LEAVE CICLOAVALES;
							END IF;
						END IF;

						SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
						SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

						IF( Var_CreEstatus  = Cre_Vigente or
							Var_CreEstatus  = Cre_Vencido )THEN

							SET Par_NumErr  := '008';
							SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
													" que se intenta asignar como obligado solidario, es un aval del  Credito: ",
													CONVERT(Var_CreditoID, CHAR));
							LEAVE CICLOAVALES;
						END IF;

					END LOOP CICLOAVALES;
				END;
			CLOSE CURSORAVALCLISOLICI;

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- -----------------------------------------------------------------------
			-- Validamos que el Obligado Solidario(Cliente) no este como Solicitante de un Credito Actualmente
			-- -----------------------------------------------------------------------
			OPEN CURSORCLISOLICI;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOCLISOLICI:LOOP
					FETCH CURSORCLISOLICI INTO
						Var_SolCredID,  Var_SolEstatus, Var_CreditoID,  Var_CreEstatus, Var_GrupoID;

						SET Var_GrupoID = IFNULL(Var_GrupoID, Entero_Cero);

						IF( Var_SolEstatus = Sol_Inactiva or
								Var_SolEstatus = Sol_Autoriza or
								Var_SolEstatus = Sol_Liberada )THEN


							IF(Var_GrupoID = Entero_Cero)THEN
								SET Par_NumErr  := '009';
								SET Par_ErrMen  := CONCAT("El safilocale.cliente ", Par_ClienteID,
								" No puede ser Obligado Solidario ya que Tambien es Solicitante. No. Sol.: ",Var_SolCredID,".");

								LEAVE CICLOCLISOLICI;
							ELSE
								SET Par_NumErr  := '009';
								SET Par_ErrMen  := CONCAT("El safilocale.cliente ", Par_ClienteID,
								" No puede ser Obligado Solidario ya que Tambien es Solicitante. No. Sol.: ",Var_SolCredID,
								", En el Grupo: ", CONVERT(Var_GrupoID, CHAR),".");
								LEAVE CICLOCLISOLICI;
							END IF;
						END IF;

						SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
						SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

						IF( Var_CreEstatus  = Cre_Vigente or
							Var_CreEstatus  = Cre_Vencido )THEN

							SET Par_NumErr  := '010';
							SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
														"No puede ser Obligado Solidario ya que actualmente tiene ",
														"un Credito Vigente. No: ", CONVERT(Var_CreditoID, CHAR));
							LEAVE CICLOCLISOLICI;
						END IF;

					End LOOP CICLOCLISOLICI;
				END;
			CLOSE CURSORCLISOLICI;

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			-- -----------------------------------------------------------------------
		END IF;
		IF( Par_ProspectoID != Entero_Cero) THEN
			OPEN CURSORSOLPROSPE;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOPROSPE:LOOP
					FETCH CURSORSOLPROSPE INTO
						Var_SolCredID,  Var_SolEstatus, Var_CreditoID,  Var_CreEstatus, Var_GrupoID;

						SET Var_GrupoID = IFNULL(Var_GrupoID, Entero_Cero);

						IF( Var_SolEstatus = Sol_Inactiva or
								Var_SolEstatus = Sol_Autoriza or
								Var_SolEstatus = Sol_Liberada )THEN

							IF(Var_GrupoID = Entero_Cero)THEN
								SET Par_NumErr  := '011';
								SET Par_ErrMen  := CONCAT("El Prospecto ", CONVERT(Par_ProspectoID, CHAR),
															" ya esta Asignado como Obligado Solidario a la Solicitud: ",
															CONVERT(Var_SolCredID, CHAR));
								LEAVE CICLOPROSPE;
							ELSE
								SET Par_NumErr  := '011';
								SET Par_ErrMen  := CONCAT("El Prospecto ", CONVERT(Par_ProspectoID, CHAR),
															" ya esta Asignado como Obligado a la Solicitud: ",
															CONVERT(Var_SolCredID, CHAR), ", Grupo: ",
															CONVERT(Var_GrupoID, CHAR));
								LEAVE CICLOPROSPE;
							END IF;

						END IF;

						SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
						SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

						IF( Var_CreEstatus  = Cre_Vigente or
							Var_CreEstatus  = Cre_Vencido )THEN

							SET Par_NumErr  := '012';
							SET Par_ErrMen  := CONCAT("El Prospecto ", CONVERT(Par_ProspectoID, CHAR),
														" ya esta Asignado como Obligado Solidario al Credito: ",
														CONVERT(Var_CreditoID, CHAR));
							LEAVE CICLOPROSPE;
						END IF;

					End LOOP CICLOPROSPE;
				END;
			CLOSE CURSORSOLPROSPE;

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Validamos que el Obligado Solidario(Prospecto) no este como Solicitante de un Credito Actualmente
			OPEN CURSORPROSPESOLICI;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOPROSPESOLICI:LOOP
					FETCH CURSORPROSPESOLICI INTO
						Var_SolCredID,  Var_SolEstatus, Var_CreditoID,  Var_CreEstatus, Var_GrupoID;

						SET Var_GrupoID = IFNULL(Var_GrupoID, Entero_Cero);

						IF( Var_SolEstatus = Sol_Inactiva or
								Var_SolEstatus = Sol_Autoriza or
								Var_SolEstatus = Sol_Liberada )THEN

							IF(Var_GrupoID = Entero_Cero)THEN
								SET Par_NumErr  := '013';
								SET Par_ErrMen  := CONCAT("El Prospecto ", Par_ProspectoID,
								" No puede ser Obligado Solidario ya que Tambien es Solicitante. No. Sol.: ",Var_SolCredID,".");
								LEAVE CICLOPROSPESOLICI;
							ELSE
								SET Par_NumErr  := '014';
								SET Par_ErrMen  := CONCAT("El Prospecto ", Par_ProspectoID,
								" No puede ser Obligado Solidario ya que Tambien es Solicitante. No. Sol.: ",Var_SolCredID,
								", En el Grupo: ", CONVERT(Var_GrupoID, CHAR),".");
								LEAVE CICLOPROSPESOLICI;
							END IF;

						END IF;

					End LOOP CICLOPROSPESOLICI;
				END;
			CLOSE CURSORPROSPESOLICI;

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			-- Fin de la validacion


		END IF;  -- Fin de validacion de ID de cliente igual a cero




	END IF; -- Fin de validacion de obligados cruzados

	IF(Par_Estatus != Est_Asignado AND Par_Estatus != Est_Autorizado)THEN
		SET Par_NumErr  := '015';
		SET Par_ErrMen  := CONCAT("El Estatus de la Asignacion del Obligado Solidario es incorrecto, No. Sol.: ",
								  CONVERT(Var_SolCredID, CHAR));
		LEAVE ManejoErrores;
	END IF;

	/* Valida que el Obligado Solidario no sea un menor de edad */
	IF EXISTS (SELECT ClienteID
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID
		AND EsMenorEdad = MenorEdad)THEN
			SET Par_NumErr  := '016';
			SET Par_ErrMen  := 'El Obligado Solidario No Debe ser Menor de Edad.';
			SET Var_Control  := 'clienteID' ;
			LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	-- Modificacion al alta para agregar nuevos campos de parentesco y tiempo de conocido. Cardinal Sistemas Inteligentes
	INSERT INTO OBLSOLIDARIOSPORSOLI (
		SolicitudCreditoID,		OblSolidID,				ClienteID,				ProspectoID,		Estatus,
		FechaRegistro,			TipoRelacionID,			TiempoDeConocido,		EmpresaID,			Usuario,
		FechaActual,			DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion)
    VALUES (
		Par_SolCreditoID,		Par_OblSolidID,			Par_ClienteID,			Par_ProspectoID,	Par_Estatus,
		Var_FechaSis,			Par_TipoRelacionID,		Par_TiempoDeConocido,	Aud_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
	-- Fin de modificacion al alta. Cardinal Sistemas Inteligentes
	SET  Par_NumErr := 0;
	SET  Par_ErrMen := CONCAT("Obligado Solidario Agregados Correctamente: ",CAST(Par_SolCreditoID AS CHAR));

	END ManejoErrores;  -- End del Handler de Errores

	IF(Par_Salida = SalidaSI)THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_SolCreditoID AS consecutivo;
	END IF;

END TerminaStore$$