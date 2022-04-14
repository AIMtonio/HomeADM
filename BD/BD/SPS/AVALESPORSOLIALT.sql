-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESPORSOLIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESPORSOLIALT`;DELIMITER $$

CREATE PROCEDURE `AVALESPORSOLIALT`(
/* =========== SP DE ALTA PARA AVALES POR SOLICITUD DE CREDITO ============ */
    Par_SolCreditoID    INT,			-- ID de la Solicitud de credito
    Par_AvalID          INT,			-- ID del Aval
    Par_ClienteID       INT,			-- ID del Cliente
    Par_ProspectoID     INT,			-- ID del Prospecto
    Par_Estatus         CHAR(1),        -- Estatus del Aval asociado a una Solicitud A: Alta, U: Autorizado

	Par_TipoRelacionID		INT(11),		-- Identificador del tipo de relacion con el Aval
	Par_TiempoDeConocido	DECIMAL(12,2),	-- Tiempo de conocer al Aval en anios

    Par_Salida          CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
    INOUT Par_NumErr    INT(11),		-- Numero de Error
    INOUT Par_ErrMen    VARCHAR(400),	-- Mensaje de Error
	/* Parametro de Auditoria */
    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),

    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
			)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_AvCruz      CHAR(1);
DECLARE Var_SolApro     INT;
DECLARE Var_ReqAval     CHAR(1);
DECLARE Var_EsGru       CHAR(1);
DECLARE Var_Control     VARCHAR(50);
DECLARE Var_SolProspeID INT;
DECLARE Var_SolCliID    BIGINT;
-- Agregado de variables nuevas que corresponden a parametro TipoRelacionID. Cardinal Sistemas Inteligentes
	DECLARE Var_TipoRelacionID	INT(11);
-- Fin de agregado de variables nuevas. Cardinal Sistemas Inteligentes

-- Variables para el Cursor
DECLARE Var_SolCredID   BIGINT;         --
DECLARE Var_SolEstatus  CHAR(1);
DECLARE Var_CreditoID   BIGINT(12);
DECLARE Var_CreEstatus  CHAR(1);
DECLARE Var_GrupoID     INT;

DECLARE Var_AvalCruzado CHAR(1);
DECLARE Var_GrupoSolID  INT;
DECLARE Var_FechaSis    DATETIME;

-- Declaracion de Constantes
DECLARE Entero_Cero     INT;
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE Decimal_Cien    DECIMAL(12,2);
DECLARE Est_Asignado    CHAR(1);
DECLARE Est_Autorizado  CHAR(1);
DECLARE Per_AvCruzado   CHAR(1);
DECLARE No_AvCruzado    CHAR(1);
DECLARE Cre_Pagado      CHAR(1);
DECLARE No_ReqAvales    CHAR(1);
DECLARE No_EsGrupal     CHAR(1);
DECLARE SalidaSI        CHAR(1);
DECLARE SalidaNO        CHAR(1);
DECLARE Es_AvalCruzado  CHAR(1);
DECLARE Sol_Inactiva    CHAR(1);
DECLARE Sol_Autoriza    CHAR(1);
DECLARE Sol_Liberada    CHAR(1);
DECLARE Cre_Vigente     CHAR(1);
DECLARE Cre_Vencido     CHAR(1);
DECLARE MenorEdad		CHAR(1);

-- Cursores para Buscar si el Avalista esta Asignado con otras Solicitudes
DECLARE CURSORSOLAVAL CURSOR FOR
    SELECT Sol.SolicitudCreditoID, Sol.Estatus, Cre.CreditoID, Cre.Estatus, Sol.GrupoID
        FROM AVALESPORSOLICI Avs,
             SOLICITUDCREDITO Sol
        LEFT OUTER JOIN CREDITOS Cre on Cre.CreditoID = Sol.CreditoID
        WHERE Avs.AvalID = Par_AvalID
          AND Sol.SolicitudCreditoID    = Avs.SolicitudCreditoID;

DECLARE CURSORSOLCLIENTE CURSOR FOR
    SELECT Sol.SolicitudCreditoID, Sol.Estatus, Cre.CreditoID, Cre.Estatus, Sol.GrupoID
        FROM AVALESPORSOLICI Avs,
             SOLICITUDCREDITO Sol
        LEFT JOIN CREDITOS Cre ON Cre.CreditoID = Sol.CreditoID
        WHERE Avs.ClienteID = Par_ClienteID
          AND Sol.SolicitudCreditoID    = Avs.SolicitudCreditoID
          AND Avs.ClienteID NOT IN (  SELECT Ing.ClienteID  -- Si el Avalista pertence al mismo
                                                            -- Grupo los Discriminamos para la Validacion
                                                FROM INTEGRAGRUPOSCRE Ing
                                                WHERE Ing.GrupoID = Var_GrupoSolID
                                                  AND Ing.ClienteID = Par_ClienteID );

DECLARE CURSORSOLPROSPE CURSOR FOR
    SELECT Sol.SolicitudCreditoID, Sol.Estatus, Cre.CreditoID, Cre.Estatus, Sol.GrupoID
        FROM AVALESPORSOLICI Avs,
             SOLICITUDCREDITO Sol
        LEFT OUTER JOIN CREDITOS Cre on Cre.CreditoID = Sol.CreditoID
        WHERE Avs.ProspectoID = Par_ProspectoID
          AND Sol.SolicitudCreditoID    = Avs.SolicitudCreditoID
         AND Avs.ProspectoID NOT IN (  SELECT Ing.ProspectoID  -- Si el Avalista pertence al mismo
                                                            -- Grupo los Discriminamos para la Validacion
                                                FROM INTEGRAGRUPOSCRE Ing
                                                WHERE Ing.GrupoID = Var_GrupoSolID
                                                  AND Ing.ProspectoID = Par_ProspectoID );



-- Cursores para Buscar al Avalista como Acreditado o Solicitante
DECLARE CURSORCLISOLICI CURSOR FOR
    SELECT Sol.SolicitudCreditoID, Sol.Estatus, Cre.CreditoID, Cre.Estatus, Sol.GrupoID
        FROM SOLICITUDCREDITO Sol
        LEFT OUTER JOIN CREDITOS Cre on Cre.CreditoID = Sol.CreditoID
        WHERE Sol.ClienteID     = Par_ClienteID
        AND Sol.ClienteID NOT IN (  SELECT Ing.ClienteID            -- Si el Avalista pertence al mismo
                                                                    -- Grupo los Discriminamos
                                        FROM INTEGRAGRUPOSCRE Ing
                                        WHERE Ing.GrupoID = Var_GrupoSolID
                                          AND Ing.ClienteID = Par_ClienteID);

DECLARE CURSORPROSPESOLICI CURSOR FOR
    SELECT Sol.SolicitudCreditoID, Sol.Estatus, Cre.CreditoID, Cre.Estatus, Sol.GrupoID
        FROM SOLICITUDCREDITO Sol
        LEFT OUTER JOIN CREDITOS Cre on Cre.CreditoID = Sol.CreditoID
        WHERE Sol.ProspectoID     = Par_ProspectoID
        AND Sol.ProspectoID NOT IN (  SELECT Ing.ProspectoID       -- Si el Avalista pertence al mismo
                                                                   -- Grupo los Discriminamos
                                        FROM INTEGRAGRUPOSCRE Ing
                                        WHERE Ing.GrupoID = Var_GrupoSolID
                                          AND Ing.ProspectoID = Par_ProspectoID);

-- Asignacion de Constantes
SET Entero_Cero     := 0;       -- Entero en Cero
SET Cadena_Vacia    := '';      -- Cadena Vacia
SET Decimal_Cero    := 0.00;    -- Decimal en Cero
SET Decimal_Cien    := 100.00;  -- Decimal Cien
SET Est_Autorizado  := 'U';     -- Estatus de la Asignacion del Aval: Autorizado
SET Est_Asignado    := 'A';     -- Estatus de la Asignacion del Aval: alta o No autorizado
SET Per_AvCruzado   := 'S';     -- El producto de Credito Permite Avales Cruzados
SET No_AvCruzado    := 'N';     -- El producto de Credito NO Permite Avales Cruzados
SET Cre_Pagado      := 'P';     -- Estatus del Credito: Pagado
SET No_ReqAvales    := 'N';     -- El producto de Credito No Requiere Avales
SET No_EsGrupal     := 'N';     -- El producto de Credito No es Grupal
SET SalidaSI        := 'S';     -- El store SI arroja un SELECT de Salida
SET SalidaNO        := 'N';     -- El store NO arroja un SELECT de Salida
SET Es_AvalCruzado  := 'S';     -- Si encontro en la Validacion que es un Aval Cruzado
SET Sol_Inactiva    := 'I';     -- Estatus de la Solicitud: Inactiva
SET Sol_Autoriza    := 'A';     -- Estatus de la Solicitud: Autorizada
SET Sol_Liberada    := 'L';     -- Estatus de la Solicitud: Liberada
SET Cre_Vigente     := 'V';     -- Estatus del Credito: Vigente
SET Cre_Vencido     := 'B';     -- Estatus del Credito: Vencido
SET MenorEdad		:= 'S';		-- Si es Menor de Edad

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-AVALESPORSOLIALT");
    END;

	IF(IFNULL(Par_SolCreditoID, Entero_Cero)) = Entero_Cero then
		SET Par_NumErr  := '001';
		SET Par_ErrMen  := 'La Solicitud de Credito esta Vacia.';
		SET Var_Control  := 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

-- Validaciones para los parametros nuevos de la tabla AVALESPORSOLICI. Cardinal Sistemas Inteligentes
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
-- Fin de validaciones para los parametros nuevos. Cardinal Sistemas Inteligentes

	SELECT Pro.RequiereAvales,  Pro.EsGrupal, 	Pro.PerAvaCruzados, GrupoID,
		   Sol.ProspectoID,     Sol.ClienteID
	 INTO Var_ReqAval,       	Var_EsGru, 		Var_AvCruz,    		Var_GrupoSolID,
		   Var_SolProspeID,   	Var_SolCliID
		FROM SOLICITUDCREDITO Sol,
			 PRODUCTOSCREDITO Pro
		WHERE Sol.SolicitudCreditoID    = Par_SolCreditoID
		  AND Sol.ProductoCreditoID     = Pro.ProducCreditoID;


	SET Var_ReqAval 	:= IFNULL(Var_ReqAval, Cadena_Vacia);
	SET Var_EsGru   	:= IFNULL(Var_EsGru, Cadena_Vacia);
	SET Var_AvCruz  	:= IFNULL(Var_AvCruz, Cadena_Vacia);
	SET Var_GrupoSolID  := IFNULL(Var_GrupoSolID, Entero_Cero);
	SET Var_SolProspeID := IFNULL(Var_SolProspeID, Entero_Cero);
	SET Var_SolCliID    := IFNULL(Var_SolCliID, Entero_Cero);

	SET Par_ClienteID   := IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_ProspectoID := IFNULL(Par_ProspectoID, Entero_Cero);

	SELECT FechaSistema INTO Var_FechaSis
		FROM PARAMETROSSIS;

	IF(Var_ReqAval = Cadena_Vacia)THEN
		SET Par_NumErr := '002';
		SET Par_ErrMen := CONCAT("La Solicitud " , CAST(Par_SolCreditoID AS CHAR), " NO Existe.");
		SET Var_Control:= 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Var_ReqAval = No_ReqAvales AND Var_EsGru = No_EsGrupal)THEN
		SET Par_NumErr :='003';
		SET Par_ErrMen := CONCAT("La Solicitud " , CAST(Par_SolCreditoID AS CHAR), " NO requiere Avales.");
		SET Var_Control:= 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	-- Valida que no se encuentre Asignado en la misma Solicitud
	IF(EXISTS(  SELECT SolicitudCreditoID
					FROM AVALESPORSOLICI
					WHERE SolicitudCreditoID  = Par_SolCreditoID
					  AND AvalID        = Par_AvalID
					  AND ClienteID     = Par_ClienteID
					  AND ProspectoID   = Par_ProspectoID))THEN

		IF( Par_AvalID != Entero_Cero )THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := CONCAT('El Aval ', CONVERT(Par_AvalID, CHAR),
									  ' ya se Encuentra Asignado en esta Solicitud.');
			SET Var_Control  := 'solicitudCreditoID' ;
			LEAVE ManejoErrores;
		ELSE
			IF( Par_AvalID != Entero_Cero AND Par_ClienteID != Entero_Cero)THEN
				SET Par_NumErr  := '004';
				SET Par_ErrMen  := CONCAT('El safilocale.cliente ', CONVERT(Par_ClienteID, CHAR),
									  ' ya se Encuentra Asignado como Aval en esta Solicitud.');
				SET Var_Control  := 'solicitudCreditoID' ;
				LEAVE ManejoErrores;
			ELSE
				SET Par_NumErr  := '004';
				SET Par_ErrMen  := CONCAT('El Prospecto ', CONVERT(Par_ProspectoID, CHAR),
									  ' ya se Encuentra Asignado como Aval en esta Solicitud.');
				SET Var_Control  := 'solicitudCreditoID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	-- Validamos que no se Asigne asi mismo como Aval
	IF(Var_SolProspeID != Entero_Cero AND
		Var_SolProspeID = Par_ProspectoID )THEN

		SET Par_NumErr  := '016';
		SET Par_ErrMen  := CONCAT('El Prospecto No Puede Asignarse el Mismo como Aval, ',
								  'Prospecto: ', CONVERT(Par_ProspectoID, CHAR) );
		SET Var_Control  := 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Var_SolCliID != Entero_Cero AND
		Var_SolCliID = Par_ClienteID )THEN

		SET Par_NumErr  := '017';
		SET Par_ErrMen  := CONCAT('El safilocale.cliente No Puede Asignarse el Mismo como Aval, ',
								  'safilocale.cliente No.: ', CONVERT(Par_ClienteID, CHAR) );
		SET Var_Control  := 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	-- Validaciones de Avales Cruzados
	-- 1.- No puede estar como Aval en otras Solicitudes si la Solicitud que avala esta:
	-- a ) Autorizada o Pendiente de Autorizar (Inactiva)
	-- b ) Si la solicitud ya es Credito y el credito esta Vivo (vigente Ã³ vencido).
	-- 2 .- No puede estar como Aval, si el Aval tiene una solicitud de credito o un credito que:
	-- a ) Solicitud de Credito Autorizada o Pendiente de Autorizar
	-- b ) Si tiene un Credito y el credito esta Vivo (Vigente Ã³ Vencido)
	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := Cadena_Vacia;

	IF(Var_AvCruz = No_AvCruzado)THEN

		IF(Par_AvalID <> Entero_Cero)THEN

			OPEN CURSORSOLAVAL;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOAVALES:LOOP
					FETCH CURSORSOLAVAL INTO
						Var_SolCredID,  Var_SolEstatus, Var_CreditoID,  Var_CreEstatus, Var_GrupoID;

						SET Var_GrupoID = IFNULL(Var_GrupoID, Entero_Cero);

						IF( Var_SolEstatus = Sol_Inactiva or
							 Var_SolEstatus = Sol_Autoriza or
							 Var_SolEstatus = Sol_Liberada )THEN

							IF(Var_GrupoID = Entero_Cero)THEN
								SET Par_NumErr  := '005';
								SET Par_ErrMen  := CONCAT("El Aval ", CONVERT(Par_AvalID, CHAR),
														" ya esta Asignado a la Solicitud: ",
														CONVERT(Var_SolCredID, CHAR));
								LEAVE CICLOAVALES;
							ELSE
								SET Par_NumErr  := '005';
								SET Par_ErrMen  := CONCAT("El Aval ", CONVERT(Par_AvalID, CHAR),
														" ya esta Asignado a la Solicitud: ",
														CONVERT(Var_SolCredID, CHAR), ", Grupo: ",
														CONVERT(Var_GrupoID, CHAR));
								LEAVE CICLOAVALES;
							END IF;

						END IF;

						SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
						SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

						IF( Var_CreEstatus  = Cre_Vigente or
							Var_CreEstatus  = Cre_Vencido )THEN

							SET Par_NumErr  := '006';
							SET Par_ErrMen  := CONCAT("El Aval ", CONVERT(Par_AvalID, CHAR),
													  " ya esta Asignado al Credito: ",
													  CONVERT(Var_CreditoID, CHAR));
							LEAVE CICLOAVALES;
						END IF;

					End LOOP CICLOAVALES;
				END;
			CLOSE CURSORSOLAVAL;

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;     -- EndIf Par_AvalID <> Entero_Cero

		IF(Par_AvalID = Entero_Cero)THEN

			IF(Par_ClienteID != Entero_Cero)THEN

				OPEN CURSORSOLCLIENTE;
					BEGIN
						DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
						CICLOCLIENTES:LOOP
						FETCH CURSORSOLCLIENTE INTO
							Var_SolCredID,  Var_SolEstatus, Var_CreditoID,  Var_CreEstatus, Var_GrupoID;

							SET Var_GrupoID = IFNULL(Var_GrupoID, Entero_Cero);

							IF( Var_SolEstatus = Sol_Inactiva or
								 Var_SolEstatus = Sol_Autoriza or
								 Var_SolEstatus = Sol_Liberada )THEN

							IF(Var_CreEstatus = Cre_Vigente OR Var_CreEstatus = Cre_Vencido)THEN

								IF(Var_GrupoID = Entero_Cero)THEN

									SET Par_NumErr  := '007';
									SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
															  " ya esta asignado como Aval a la Solicitud: ",
															  CONVERT(Var_SolCredID, CHAR));
									LEAVE CICLOCLIENTES;
								ELSE
									SET Par_NumErr  := '007';
									SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
															  " ya esta asignado como Aval a la Solicitud: ",
															  CONVERT(Var_SolCredID, CHAR), ", Grupo: ",
															  CONVERT(Var_GrupoID, CHAR));
									LEAVE CICLOCLIENTES;
								END IF;
							END IF;

							END IF;

							SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
							SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

							IF( Var_CreEstatus  = Cre_Vigente or
								Var_CreEstatus  = Cre_Vencido )THEN

								SET Par_NumErr  := '008';
								SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),
														  " ya esta Asignado como Aval al Credito: ",
														  CONVERT(Var_CreditoID, CHAR));
								LEAVE CICLOCLIENTES;
							END IF;

						End LOOP CICLOCLIENTES;
					END;
				CLOSE CURSORSOLCLIENTE;

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				-- -----------------------------------------------------------------------
				-- Validamos que el Aval(Cliente) no este como Solicitante de un Credito Actualmente
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
									" No puede ser Aval ya que Tambien es Solicitante. No. Sol.: ",Var_SolCredID,".");

									LEAVE CICLOCLISOLICI;
								ELSE
									SET Par_NumErr  := '009';
									SET Par_ErrMen  := CONCAT("El safilocale.cliente ", Par_ClienteID,
									" No puede ser Aval ya que Tambien es Solicitante. No. Sol.: ",Var_SolCredID,
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
														  "No puede ser Aval ya que actualmente tiene ",
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

			ELSE
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
															  " ya esta Asignado como Aval a la Solicitud: ",
															  CONVERT(Var_SolCredID, CHAR));
									LEAVE CICLOPROSPE;
								ELSE
									SET Par_NumErr  := '011';
									SET Par_ErrMen  := CONCAT("El Prospecto ", CONVERT(Par_ProspectoID, CHAR),
															  " ya esta Asignado como Aval a la Solicitud: ",
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
														  " ya esta Asignado como Aval al Credito: ",
														  CONVERT(Var_CreditoID, CHAR));
								LEAVE CICLOPROSPE;
							END IF;

						End LOOP CICLOPROSPE;
					END;
				CLOSE CURSORSOLPROSPE;

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				-- -----------------------------------------------------------------------
				-- Validamos que el Aval(Prospecto) no este como Solicitante de un Credito Actualmente
				-- -----------------------------------------------------------------------
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
									" No puede ser Aval ya que Tambien es Solicitante. No. Sol.: ",Var_SolCredID,".");
									LEAVE CICLOPROSPESOLICI;
								ELSE
									SET Par_NumErr  := '014';
									SET Par_ErrMen  := CONCAT("El Prospecto ", Par_ProspectoID,
									" No puede ser Aval ya que Tambien es Solicitante. No. Sol.: ",Var_SolCredID,
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
				-- -----------------------------------------------------------------------


			END IF;  -- EndIf Par_ClienteID != Entero_Cero

		END IF;  -- EndIf Par_AvalID = Entero_Cero


	END IF; -- Var_AvCruz = No_AvCruzado

	IF(Par_Estatus != Est_Asignado AND Par_Estatus != Est_Autorizado)THEN
		SET Par_NumErr  := '015';
		SET Par_ErrMen  := CONCAT("El Estatus de la Asignacion del Aval es incorrecto, No. Sol.: ",
								  CONVERT(Var_SolCredID, CHAR));
		LEAVE ManejoErrores;
	END IF;

	/* Valida que el aval no sea un menor de edad */
	IF EXISTS (SELECT ClienteID
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID
		AND EsMenorEdad = MenorEdad)THEN
			SET Par_NumErr  := '016';
			SET Par_ErrMen  := 'El Aval No Debe ser Menor de Edad.';
			SET Var_Control  := 'clienteID' ;
			LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

-- Modificacion al alta para agregar nuevos campos de parentesco y tiempo de conocido. Cardinal Sistemas Inteligentes
	INSERT INTO AVALESPORSOLICI (
		SolicitudCreditoID,		AvalID,					ClienteID,				ProspectoID,		Estatus,
		FechaRegistro,			TipoRelacionID,			TiempoDeConocido,		EmpresaID,			Usuario,
		FechaActual,			DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion)
    VALUES (
		Par_SolCreditoID,		Par_AvalID,				Par_ClienteID,			Par_ProspectoID,	Par_Estatus,
		Var_FechaSis,			Par_TipoRelacionID,		Par_TiempoDeConocido,	Aud_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
-- Fin de modificacion al alta. Cardinal Sistemas Inteligentes
	SET  Par_NumErr := 0;
	SET  Par_ErrMen := CONCAT("Avales Agregados Correctamente: ",CAST(Par_SolCreditoID AS CHAR));

 END ManejoErrores;  -- End del Handler de Errores

 IF(Par_Salida = SalidaSI)THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_SolCreditoID AS consecutivo;
 END IF;

END TerminaStore$$