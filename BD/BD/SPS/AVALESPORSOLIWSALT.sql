-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESPORSOLIWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESPORSOLIWSALT`;DELIMITER $$

CREATE PROCEDURE `AVALESPORSOLIWSALT`(
    -- SP PARA DAR DE ALTA LAS REFERENCIAS DE LA SOLICITUD DE CREDITO
    Par_SolCreditoID        INT,            -- ID de la Solicitud de credito
    Par_AvalID              INT,            -- ID del Aval
    Par_ClienteID           INT,            -- ID del Cliente
    Par_FechaRegistro       DATE,           -- ID del Prospecto
    Par_Usuario             VARCHAR(400),   -- Usuario

    Par_Clave               VARCHAR(400),   -- CLAVE
    Par_Salida              CHAR(1),        -- Indica el tipo de salida del sp
    INOUT Par_NumErr        INT,            -- Numero de error
    INOUT Par_ErrMen        VARCHAR(400),   -- Mensaje de error
    Aud_EmpresaID           INT(11),        -- Parametro de Auditoria

    Aud_Usuario             INT(11),        -- Parametro de Auditoria
    Aud_FechaActual         DATETIME,       -- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Parametro de Auditoria
    Aud_Sucursal            INT(11),        -- Parametro de Auditoria

    Aud_NumTransaccion      BIGINT(20)      -- Parametro de Auditoria
)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Control             VARCHAR(50);	-- VAR CONTROL
DECLARE Var_SolicitudCre        INT;			-- SOLICITUD DE CREDITO
DECLARE Var_Cliente             INT;			-- NUMERO DE CLIENTE
DECLARE Var_Consecutivo         VARCHAR(50);	-- CONSECUTIVO
DECLARE Var_PerfilWsVbc			INT(11);		-- PERFIL OPERACIONES VBC
DECLARE Var_FechaSis    		DATETIME;       -- FECHA DEL SISTEMA
-- Variables para el Cursor
DECLARE Var_SolCredID           BIGINT;         -- PARA LA SOLICITUD DEL CURSOR
DECLARE Var_SolEstatus          CHAR(1);        -- ESTATUS SOLICITUD
DECLARE Var_CreditoID           BIGINT(12);     -- ID DEL CREDITO
DECLARE Var_CreEstatus          CHAR(1);        -- ESTATUS DEL CREDITO
DECLARE Var_GrupoID             INT;            -- ID DEL GRUPO

-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia            CHAR(1);        -- CADENA VACIA
DECLARE Fecha_Vacia             DATE;           -- FECHA VACIA
DECLARE Entero_Cero             INT;            -- CERO
DECLARE Var_SI                  CHAR(1);        -- SI
DECLARE Var_NO                  CHAR(1);        -- NO
DECLARE Est_Alta                CHAR(1);        -- ESTATUS DE ALTA
DECLARE Est_Activo              CHAR(1);        -- ESTATUS ACTIVO
DECLARE Var_ReqAval             CHAR(1);        -- REQUIERE AVALES
DECLARE No_ReqAvales            CHAR(1);		-- NO REQUIERE AVALES
DECLARE Var_EsGru               CHAR(1);		-- ES GRUPAL
DECLARE Var_AvCruz              CHAR(1);        -- AVALES CRUZADOS
DECLARE Var_SolApro             INT;            -- SOLICITUD APROBADA
DECLARE Var_GrupoSolID          INT;            -- GRUPO SOLIDARIO
DECLARE Var_SolProspeID         INT;            -- SOL PROSPECTO
DECLARE Var_SolCliID            BIGINT;         -- SOLICITUD CLIENTE
DECLARE No_EsGrupal             CHAR(1);        -- NO ES GRUPAL
DECLARE No_AvCruzado            CHAR(1);        -- NUMERO AVALES

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


-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia            := '';				-- Cadena Vacia
SET Fecha_Vacia             := '1900-01-01';	-- Fecha Vacia
SET Entero_Cero             := 0;				-- Entero en Cero
SET Var_SI                  := 'S';				-- Permite Salida SI
SET Var_NO                  := 'N';				-- Permite Salida NO
SET Est_Alta                := 'A';             -- ESTATUS ALTA
SET No_ReqAvales    		:= 'N';             -- El producto de Credito No Requiere Avales
SET Est_Activo				:= 'A';             -- ESTATUS ACTIVO
SET No_EsGrupal    			:= 'N';             -- El producto de Credito No es Grupal
SET No_AvCruzado            := 'N';     -- El producto de Credito NO Permite Avales Cruzados



-- ASIGNACION DE VARIABLES
SET Aud_FechaActual         := NOW();

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-AVALESPORSOLIWSALT');
            SET Var_Control = 'sqlException';
        END;


    -- **************************************************************************************
    -- SE VALIDA EL USUARIO   *******************
    -- **************************************************************************************

    SELECT 		FechaSistema,	PerfilWsVbc
    	INTO 	Var_FechaSis,	Var_PerfilWsVbc
		FROM PARAMETROSSIS LIMIT 1;

    SET Var_PerfilWsVbc		:= IFNULL(Var_PerfilWsVbc,Entero_Cero);


    IF(Var_PerfilWsVbc = Entero_Cero)THEN
    	SET Par_NumErr		:= '60';
		SET Par_ErrMen		:= 'No existe perfil definido para el usuario.';
		LEAVE ManejoErrores;
    END IF;

    SET Aud_Usuario := (SELECT UsuarioID
                            FROM USUARIOS
                            WHERE Clave = Par_Usuario
                                AND Contrasenia = Par_Clave
                                AND Estatus = Est_Activo  AND RolID = Var_PerfilWsVbc);

    SET Aud_Usuario := IFNULL(Aud_Usuario, Entero_Cero);
    IF(Aud_Usuario = Entero_Cero)THEN
        SET Par_NumErr      := 7;
        SET Par_ErrMen      := "Usuario o Password no valido";
        LEAVE ManejoErrores;
    END IF;


    SET Aud_DireccionIP := '127.0.0.1';
    SET Aud_ProgramaID  := 'AVALESPORSOLIWSALT';

    /** VALIDACIONES *************************************************************/
    IF(IFNULL(Par_SolCreditoID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'El Numero de Solicitud de Credito Esta Vacio.';
        SET Var_Control := 'solicitudCreditoID';
        SET Var_Consecutivo := Entero_Cero;
        LEAVE ManejoErrores;
    END IF;

    SET Var_SolicitudCre  := (SELECT SolicitudCreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID=Par_SolCreditoID);


    IF(IFNULL(Var_SolicitudCre, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  := 002;
        SET Par_ErrMen  := 'El Numero de Solicitud de Credito No Existe.';
        SET Var_Control := 'solicitudCreditoID';
        SET Var_Consecutivo := Entero_Cero;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
        IF(IFNULL(Par_AvalID, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'Debe indicar un Aval o un safilocale.cliente .';
            SET Var_Control := 'ClienteID';
            SET Var_Consecutivo := Entero_Cero;
            LEAVE ManejoErrores;
        END IF;
    ELSE
        SET Var_Cliente  := (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID);

        IF(IFNULL(Var_Cliente, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  := 004;
            SET Par_ErrMen  := 'El Numero de safilocale.cliente  No Existe.';
            SET Var_Control := 'solicitudCreditoID';
            SET Var_Consecutivo := Entero_Cero;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_ClienteID, Entero_Cero)) != Entero_Cero THEN
        IF(IFNULL(Par_AvalID, Entero_Cero)) != Entero_Cero THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'Debe indicar un Aval o un safilocale.cliente .';
            SET Var_Control := 'ClienteID';
            SET Var_Consecutivo := Entero_Cero;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_SolCreditoID, Entero_Cero)) = Entero_Cero then
		SET Par_NumErr  := '001';
		SET Par_ErrMen  := 'La Solicitud de Credito esta Vacia.';
		SET Var_Control  := 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	SELECT  Pro.RequiereAvales,    Pro.EsGrupal,       Pro.PerAvaCruzados,     GrupoID,
            Sol.ProspectoID,       Sol.ClienteID
	 INTO   Var_ReqAval,           Var_EsGru,          Var_AvCruz,             Var_GrupoSolID,
            Var_SolProspeID,   	   Var_SolCliID
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
					  AND ClienteID     = Par_ClienteID))THEN

		IF( Par_AvalID != Entero_Cero )THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := CONCAT('El Aval ', CONVERT(Par_AvalID, CHAR),
									  ' ya se Encuentra Asignado en esta Solicitud.');
			SET Var_Control  := 'solicitudCreditoID' ;
			LEAVE ManejoErrores;
		ELSE
			IF(Par_ClienteID != Entero_Cero)THEN
				SET Par_NumErr  := '004';
				SET Par_ErrMen  := CONCAT('El safilocale.cliente ', CONVERT(Par_ClienteID, CHAR),
									  ' ya se Encuentra Asignado como Aval en esta Solicitud.');
				SET Var_Control  := 'solicitudCreditoID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	IF(Var_SolCliID != Entero_Cero AND
		Var_SolCliID = Par_ClienteID )THEN

		SET Par_NumErr  := '017';
		SET Par_ErrMen  := CONCAT('El safilocale.cliente No Puede Asignarse el Mismo como Aval, ',
								  'safilocale.cliente No.: ', CONVERT(Par_ClienteID, CHAR) );
		SET Var_Control  := 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

    SET Aud_FechaActual     := NOW();

    /* =========== SP DE ALTA PARA AVALES POR SOLICITUD DE CREDITO ============ */

    IF(IFNULL(Par_SolCreditoID, Entero_Cero)) = Entero_Cero then
        SET Par_NumErr  := '001';
        SET Par_ErrMen  := 'La Solicitud de Credito esta Vacia.';
        SET Var_Control  := 'solicitudCreditoID' ;
        LEAVE ManejoErrores;
    END IF;

    SELECT Pro.RequiereAvales,  Pro.EsGrupal,   Pro.PerAvaCruzados, GrupoID,
           Sol.ProspectoID,     Sol.ClienteID
     INTO Var_ReqAval,          Var_EsGru,      Var_AvCruz,         Var_GrupoSolID,
           Var_SolProspeID,     Var_SolCliID
        FROM SOLICITUDCREDITO Sol,
             PRODUCTOSCREDITO Pro
        WHERE Sol.SolicitudCreditoID    = Par_SolCreditoID
          AND Sol.ProductoCreditoID     = Pro.ProducCreditoID;


    SET Var_ReqAval     := IFNULL(Var_ReqAval, Cadena_Vacia);
    SET Var_EsGru       := IFNULL(Var_EsGru, Cadena_Vacia);
    SET Var_AvCruz      := IFNULL(Var_AvCruz, Cadena_Vacia);
    SET Var_GrupoSolID  := IFNULL(Var_GrupoSolID, Entero_Cero);
    SET Var_SolProspeID := IFNULL(Var_SolProspeID, Entero_Cero);
    SET Var_SolCliID    := IFNULL(Var_SolCliID, Entero_Cero);

    SET Par_ClienteID   := IFNULL(Par_ClienteID, Entero_Cero);

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


    IF (Par_FechaRegistro = Fecha_Vacia) THEN
        SET Par_NumErr :='010';
        SET Par_ErrMen := CONCAT("La Fecha de Registro esta Vacia.");
        SET Var_Control:= 'solicitudCreditoID' ;
        LEAVE ManejoErrores;
    END IF;

    -- Valida que no se encuentre Asignado en la misma Solicitud
    IF(EXISTS(  SELECT SolicitudCreditoID
                    FROM AVALESPORSOLICI
                    WHERE SolicitudCreditoID  = Par_SolCreditoID
                      AND AvalID        = Par_AvalID
                      AND ClienteID     = Par_ClienteID))THEN

        IF( Par_AvalID != Entero_Cero )THEN
            SET Par_NumErr  := '004';
            SET Par_ErrMen  := CONCAT('El Aval ', CONVERT(Par_AvalID, CHAR),
                                      ' ya se Encuentra Asignado en esta Solicitud.');
            SET Var_Control := 'solicitudCreditoID' ;
            LEAVE ManejoErrores;
        ELSE
            IF( Par_AvalID != Entero_Cero AND Par_ClienteID != Entero_Cero)THEN
                SET Par_NumErr  := '004';
                SET Par_ErrMen  := CONCAT('El safilocale.cliente ', CONVERT(Par_ClienteID, CHAR),
                                      ' ya se Encuentra Asignado como Aval en esta Solicitud.');
                SET Var_Control  := 'solicitudCreditoID' ;
                    LEAVE ManejoErrores;
            END IF;
        END IF;
    END IF;

    IF(Var_SolCliID != Entero_Cero AND
        Var_SolCliID = Par_ClienteID )THEN

        SET Par_NumErr  := '017';
        SET Par_ErrMen  := CONCAT('El safilocale.cliente No Puede Asignarse el Mismo como Aval, ',
                                  'safilocale.cliente No.: ', CONVERT(Par_ClienteID, CHAR) );
        SET Var_Control := 'solicitudCreditoID' ;
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

                        IF( Var_SolEstatus = Sol_Inactiva or Var_SolEstatus = Sol_Autoriza or Var_SolEstatus = Sol_Liberada )THEN
                            IF(Var_GrupoID = Entero_Cero)THEN
                                SET Par_NumErr  := '005';
                                SET Par_ErrMen  := CONCAT("El Aval ", CONVERT(Par_AvalID, CHAR), " ya esta Asignado a la Solicitud: ",
                                                        CONVERT(Var_SolCredID, CHAR));
                                LEAVE CICLOAVALES;
                            ELSE
                                SET Par_NumErr  :=  '005';
                                SET Par_ErrMen  :=  CONCAT("El Aval ", CONVERT(Par_AvalID, CHAR), " ya esta Asignado a la Solicitud: ",
                                                        CONVERT(Var_SolCredID, CHAR), ", Grupo: ", CONVERT(Var_GrupoID, CHAR));
                                LEAVE CICLOAVALES;
                            END IF;
                        END IF;

                        SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
                        SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

                        IF( Var_CreEstatus  = Cre_Vigente or Var_CreEstatus  = Cre_Vencido )THEN
                            SET Par_NumErr  := '006';
                            SET Par_ErrMen  := CONCAT("El Aval ", CONVERT(Par_AvalID, CHAR), " ya esta Asignado al Credito: ",
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

                            IF( Var_SolEstatus = Sol_Inactiva or Var_SolEstatus = Sol_Autoriza or Var_SolEstatus = Sol_Liberada )THEN
                                IF(Var_CreEstatus = Cre_Vigente OR Var_CreEstatus = Cre_Vencido)THEN
                                    IF(Var_GrupoID = Entero_Cero)THEN
                                        SET Par_NumErr  := '007';
                                        SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR), " ya esta asignado como Aval a la Solicitud: ",
                                                                  CONVERT(Var_SolCredID, CHAR));
                                        LEAVE CICLOCLIENTES;
                                    ELSE
                                        SET Par_NumErr  := '007';
                                        SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR)," ya esta asignado como Aval a la Solicitud: ",
                                                                  CONVERT(Var_SolCredID, CHAR), ", Grupo: ", CONVERT(Var_GrupoID, CHAR));
                                        LEAVE CICLOCLIENTES;
                                    END IF;
                                END IF;
                            END IF;

                            SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
                            SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

                            IF( Var_CreEstatus  = Cre_Vigente or Var_CreEstatus  = Cre_Vencido )THEN
                                SET Par_NumErr  := '008';
                                SET Par_ErrMen  := CONCAT("El safilocale.cliente ", CONVERT(Par_ClienteID, CHAR),  " ya esta Asignado como Aval al Credito: ",
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

                            IF( Var_SolEstatus = Sol_Inactiva or Var_SolEstatus = Sol_Autoriza or Var_SolEstatus = Sol_Liberada )THEN
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

                            IF( Var_CreEstatus  = Cre_Vigente or Var_CreEstatus  = Cre_Vencido )THEN
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
                -- ----------------------------------------------------------------------
            END IF;  -- EndIf Par_ClienteID != Entero_Cero

        END IF;  -- EndIf Par_AvalID = Entero_Cero
    END IF; -- Var_AvCruz = No_AvCruzado

    /* Valida que el aval no sea un menor de edad */
    IF EXISTS (SELECT ClienteID
                    FROM CLIENTES
                    WHERE ClienteID = Par_ClienteID
                    AND EsMenorEdad = Var_SI)THEN
        SET Par_NumErr  := '016';
        SET Par_ErrMen  := 'El Aval No Debe ser Menor de Edad.';
        SET Var_Control  := 'clienteID' ;
        LEAVE ManejoErrores;
    END IF;

    SET Aud_FechaActual := CURRENT_TIMESTAMP();

    INSERT INTO AVALESPORSOLICI (
        `SolicitudCreditoID`,   `AvalID`,           `ClienteID`,            `ProspectoID`,      `Estatus`,
        `FechaRegistro`,        `EmpresaID`,        `Usuario`,              `FechaActual`,      `DireccionIP`,
        `ProgramaID`,           `Sucursal`,         `NumTransaccion`)
    VALUES (
        Par_SolCreditoID,       Par_AvalID,         Par_ClienteID,          Entero_Cero,        Est_Alta,
        Par_FechaRegistro,      Aud_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion );

    SET  Par_NumErr := 0;
    SET  Par_ErrMen := CONCAT("Aval Agregado Correctamente: ",CAST(Par_SolCreditoID AS CHAR));

END ManejoErrores;

IF(Par_Salida = Var_SI)THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$