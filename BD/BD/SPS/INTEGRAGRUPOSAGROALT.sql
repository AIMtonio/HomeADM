-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSAGROALT`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPOSAGROALT`(
/*SP PARA DAR DE ALTA INTEGRANTES DE GRUPOS AGRO*/
    Par_GrupoID            INT(11),    		-- Identificador del grupo
    Par_SolicitudCredID    INT(11),    		-- Identificador de la solicitud
    Par_ClienteID          INT(11),    		-- Identificador del cliente
    Par_ProspectoID        INT(11),    		-- Identificador del prospecto
    Par_FechaRegistro      DATETIME,    	-- Fecha de registro

    Par_Salida             CHAR(1),     	-- Indica la salida de datos
    INOUT Par_NumErr       INT(11),      	-- numero de error
    INOUT Par_ErrMen       VARCHAR(400),	-- mensaje de error

    Par_EmpresaID          INT(11),     	-- Auditoria
    Aud_Usuario            INT(11),     	-- Auditoria
    Aud_FechaActual        DATETIME,    	-- Auditoria

    Aud_DireccionIP        VARCHAR(15), 	-- Auditoria
    Aud_ProgramaID         VARCHAR(50), 	-- Auditoria
    Aud_Sucursal           INT(11),     	-- Auditoria
    Aud_NumTransaccion     BIGINT(20)   	-- Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_EstGrupo          CHAR(1);        -- Estatus del grupo
	DECLARE Var_Control           VARCHAR(100);   -- variable de control
	DECLARE Var_SolEstatus        CHAR(1);        -- estatus de la solicitud de credito
	DECLARE Var_NombreGrupo       VARCHAR(150);   -- producto de credito de la solicitud
	DECLARE Var_SolGrupal         CHAR(1);     	  -- Indica si es una solicitud grupal
	DECLARE Var_IntSolCreID       BIGINT;         -- Id de la solicitud del integrante
	DECLARE Var_IntGrupoID        INT;            -- Id del grupo
	DECLARE Var_ClienteID         INT;            -- id del cliente
	DECLARE Var_ProspectoID       INT;            -- id del prospecto
	DECLARE Var_IntEstatus        CHAR(1);        -- Estatus del integrante
	DECLARE Var_IntMonSol         DECIMAL(14,2);  -- monto de solicitud
	DECLARE Var_NumIntegra        INT;            -- Numero de integrantes
	DECLARE Var_NoSolicitudes     INT;            -- numero de ciclo
	DECLARE Var_PonderaCiclo      CHAR(1);        -- ponderado para el ciclo
    DECLARE Var_Ciclo			  INT(11);		  -- CICLO
	DECLARE Var_SolProducCre	  INT(11);		  -- producto de la solicitud
    DECLARE Var_CicloGrupo		  INT(11);		  -- Ciclo del grupo
	-- Variables para conocer el numero de integrantes
	DECLARE Var_TotalInteg        INT;      -- Total de integrantes
	DECLARE Var_MaxIntegrantes    INT;      -- maximo de integrantes del grupo
	DECLARE Var_MinIntegrantes    INT;      -- minimo de integrantes de grupo

	--  Declaracion de Constamtes
	DECLARE Entero_Cero           INT(11);
	DECLARE Cadena_Vacia          CHAR(1);
	DECLARE Decimal_Cero          DECIMAL(12,2);
	DECLARE SalidaSI              CHAR(1);
	DECLARE Constante_No          CHAR(1);
	DECLARE Gru_Cerrado           CHAR(1);
	DECLARE Gru_NoIniciado        CHAR(1);
	DECLARE Est_Activo            CHAR(1);
	DECLARE Sol_Autoriza          CHAR(1);
	DECLARE Es_Grupal             CHAR(1);
	DECLARE Sol_Desembol          CHAR(1);
	DECLARE Entero_Uno            INT(11);
	DECLARE Cargo_Integrante	  INT(11);
    DECLARE Sol_Cancelada         CHAR(1);

	-- Asignacion de Constamtes
	SET Entero_Cero     	:= 0;              -- Entero Cero
	SET Cadena_Vacia    	:= '';             -- Cadena Vacia
	SET Decimal_Cero    	:= 0.00;           -- DECIMAL Cero
	SET SalidaSI        	:= 'S';            -- Salida Si
	SET Constante_No    	:= 'N';            -- Salida No
	SET Gru_Cerrado     	:= 'C';            -- Estatus del Grupo: Cerrado
	SET Gru_NoIniciado  	:= 'N';            -- Estatus del Grupo: No Iniciado
	SET Est_Activo      	:= 'A';            -- Estatus Inactivo
	SET Sol_Autoriza    	:= 'A';            -- Solicitud Autorizada
	SET Es_Grupal       	:= 'S';            -- Si es Grupal
	SET Sol_Desembol    	:= 'D';            -- Estatus de la Solicitud: Desembolsada
	SET Entero_Uno    		:= 1;              -- Entero Uno
	SET Cargo_Integrante 	:= 4;
    SET Sol_Cancelada   	:= 'C';               -- Estatus de la Solicitud: Cancelada

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					 'Disculpe las molestias que esto le ocasiona. Ref: SP-INTEGRAGRUPOSAGROALT');
		SET Var_Control := 'SQLEXCEPTION' ;
	END;

		SET Par_GrupoID         	:= IFNULL(Par_GrupoID, Entero_Cero);
		SET Par_SolicitudCredID  := IFNULL(Par_SolicitudCredID, Entero_Cero);
	    SET Var_MaxIntegrantes   := 999;

		IF(Par_GrupoID = Entero_Cero ) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Grupo esta Vacio.';
			SET Var_Control  := 'grupoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_SolicitudCredID = Entero_Cero ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'La Solicitud de Credito esta Vacia';
			SET Var_Control  := 'solicitudCreditoID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT EstatusCiclo INTO Var_EstGrupo
			FROM GRUPOSCREDITO
		WHERE GrupoID = Par_GrupoID;

		SET Var_EstGrupo:= IFNULL(Var_EstGrupo, Cadena_Vacia);

		IF(Var_EstGrupo = Gru_Cerrado OR Var_EstGrupo = Gru_NoIniciado)THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := CONCAT('El Grupo ', Par_GrupoID,' debe estar Abierto para Asignar Integrantes');
			SET Var_Control  := 'grupoID' ;
			LEAVE ManejoErrores;
		END IF;

		SET Par_ClienteID   := IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_ProspectoID := IFNULL(Par_ProspectoID, Entero_Cero);

		SELECT  Sol.Estatus,  Sol.ProductoCreditoID	INTO	Var_SolEstatus, Var_SolProducCre
			FROM SOLICITUDCREDITO Sol
		WHERE Sol.SolicitudCreditoID = Par_SolicitudCredID;

        SET Var_SolEstatus  := IFNULL(Var_SolEstatus, Cadena_Vacia);

		IF (Var_SolEstatus = Sol_Cancelada OR Var_SolEstatus = Sol_Desembol) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := CONCAT('La Solicitud ', CONVERT(Par_SolicitudCredID, CHAR),' esta Cancelada o Desembolsada.');
			SET Var_Control  := 'grupoID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT COUNT(SolicitudCreditoID) INTO Var_NoSolicitudes
			FROM INTEGRAGRUPOSCRE
		WHERE SolicitudCreditoID=Par_SolicitudCredID;

		SELECT NombreGrupo INTO Var_NombreGrupo
			FROM INTEGRAGRUPOSCRE     Inte
		LEFT JOIN GRUPOSCREDITO Gru ON Inte.GrupoID = Gru.GrupoID
			WHERE Inte.SolicitudCreditoID = Par_SolicitudCredID
				AND Estatus = Est_Activo  LIMIT 1;

		SET Var_NombreGrupo :=IFNULL(Var_NombreGrupo,Cadena_Vacia);

		IF(IFNULL(Var_NoSolicitudes,Entero_Cero)>=Entero_Uno) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := CONCAT('La Solicitud ', CONVERT(Par_SolicitudCredID, CHAR),' ya se Encuentra Integrada a otro Grupo.');
			LEAVE ManejoErrores;
		END IF;

		IF(Var_NombreGrupo != Cadena_Vacia)THEN
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := CONCAT('La Solicitud ', CONVERT(Par_SolicitudCredID, CHAR), ' Se encuentra Integrada en el Grupo ', Var_NombreGrupo);
			LEAVE ManejoErrores;
		END IF;

		--  VALIDAR NUMERO DE INTEGRANTES PERMITIDOS POR PRODUCTO DE CREDITO
         SELECT COUNT(SolicitudCreditoID) INTO Var_TotalInteg
			FROM INTEGRAGRUPOSCRE
		WHERE GrupoID=Par_GrupoID;

		IF(Var_TotalInteg>Var_MaxIntegrantes)THEN
			SET Par_NumErr   := 7;
			SET Par_ErrMen   := 'Se ha Alcanzado el Numero Maximo de Integrantes para el Grupo.';
			SET Var_Control  := 'solicitudCreditoID' ;
			LEAVE ManejoErrores;
		END IF;

        -- ciclos
        -- Calculo del Ciclo(No de Creditos del mismo Producto), el individual y el del Grupo Ponderado
		SET Var_Ciclo := IFNULL(Var_Ciclo, Entero_Cero);
		SET Var_CicloGrupo := IFNULL(Var_CicloGrupo, Entero_Cero);

		CALL CRECALCULOCICLOPRO(
			Par_ClienteID,     	Par_ProspectoID,    Var_SolProducCre,   Par_GrupoID,    Var_Ciclo,
			Var_CicloGrupo,     Constante_No,       Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
			Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


		INSERT INTO INTEGRAGRUPOSCRE(
			GrupoID,          SolicitudCreditoID,   ClienteID,     ProspectoID,  	Estatus,
			ProrrateaPago,    FechaRegistro,        Ciclo,         Cargo,			EmpresaID,
            Usuario,		  FechaActual,      	DireccionIP,   ProgramaID,   	Sucursal,
            NumTransaccion)
		VALUES(
			Par_GrupoID,        Par_SolicitudCredID, 	Par_ClienteID,  	Par_ProspectoID,    Est_Activo,
			Constante_No,       Par_FechaRegistro,      Var_Ciclo,      	Cargo_Integrante,	Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,    	Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,
            Aud_NumTransaccion);

	   SET   Par_NumErr := Entero_Cero;
	   SET   Par_ErrMen := 'Integrantes Asignados Correctamente';

		UPDATE SOLICITUDCREDITO SET
			GrupoID = Par_GrupoID
		WHERE SolicitudCreditoID = Par_SolicitudCredID;

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$