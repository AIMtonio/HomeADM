-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBAVALESPORSOLWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBAVALESPORSOLWSALT`;DELIMITER $$

CREATE PROCEDURE `CRCBAVALESPORSOLWSALT`(
	-- === SP para realizar alta de avales por solicitud de credito por WS para CREDICLUB =====
	Par_SolCreditoID    BIGINT(20),		-- ID de la Solicitud de credito
	Par_ClienteID       INT(11),		-- ID del Cliente
	Par_Estatus         CHAR(1),        -- Estatus del Aval asociado a una Solicitud A: Alta, U: Autorizado

	Par_Salida			CHAR(1), 		-- Indica mensaje de Salida
	INOUT Par_NumErr	INT(11),		-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Descripcion de Error

	Par_EmpresaID		INT(11),		-- Parametro de Auditoria
	Aud_Usuario			INT(11),		-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal		INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema    DATETIME;		-- Fecha de Sistema
    DECLARE Var_NumIntGrupo	    INT(11);		-- Numero de Integrantes del Grupo
    DECLARE Var_GrupoSolID  	INT(11);		-- Numero del Grupo Integrantes
    DECLARE Var_Solicitud		BIGINT(20);		-- Numero de Solicitud
    DECLARE Var_ClienteID		INT(11);		-- Numero del Cliente

	DECLARE Var_Consecutivo     BIGINT(12);     -- Consecutivo
    DECLARE	Var_GrupoID			INT(11);		-- Numero del Grupo

	-- Declaracion de Constantes
	DECLARE Entero_Cero     	INT(11);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Est_Autorizado  	CHAR(1);
    DECLARE SalidaSI        	CHAR(1);

    DECLARE SalidaNO        	CHAR(1);
    DECLARE Entero_Uno			INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero     	:= 0;       -- Entero en Cero
	SET Cadena_Vacia    	:= '';      -- Cadena Vacia
	SET Decimal_Cero    	:= 0.00;    -- DECIMAL en Cero
	SET Est_Autorizado  	:= 'U';     -- Estatus de la Asignacion del Aval: Autorizado
    SET SalidaSI        	:= 'S';     -- El store SI arroja un SELECT de Salida

    SET SalidaNO        	:= 'N';     -- El store NO arroja un SELECT de Salida
	SET Entero_Uno			:= 1;		-- Entero Uno

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBAVALESPORSOLWSALT');
			END;

        -- Se obtiene la Fecha del Sistema
		SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);

        -- Asignacion de variables
		SET Var_Consecutivo     := Entero_Cero;

        IF(IFNULL(Par_SolCreditoID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'La Solicitud de Credito esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

        SELECT IFNULL(GrupoID,Entero_Cero) INTO Var_GrupoSolID
		FROM INTEGRAGRUPOSCRE
		WHERE SolicitudCreditoID   = Par_SolCreditoID;

        -- Se crea tabla temporal para integrantes del grupo
        DROP TABLE IF EXISTS TMPINTEGRANTESGRUPO;
		CREATE TEMPORARY TABLE TMPINTEGRANTESGRUPO(
			SolicitudGrupID   		INT AUTO_INCREMENT,
            SolicitudCreditoID      BIGINT(20),
			ClienteID       		INT(11),
			GrupoID         		INT(11),
			PRIMARY KEY (SolicitudGrupID));

		CREATE INDEX IDX_INTGRUP_1 ON TMPINTEGRANTESGRUPO(SolicitudCreditoID,ClienteID);

        -- Se inserta en la tabla temporal los integrantes del grupo
        INSERT INTO TMPINTEGRANTESGRUPO(
				SolicitudGrupID,	SolicitudCreditoID,		ClienteID,		GrupoID)
         SELECT Var_Consecutivo,	SolicitudCreditoID,		ClienteID,		GrupoID
			FROM INTEGRAGRUPOSCRE
		 WHERE GrupoID = Var_GrupoSolID;

		SET Var_NumIntGrupo		:= (SELECT MAX(SolicitudGrupID) FROM TMPINTEGRANTESGRUPO WHERE GrupoID = Var_GrupoSolID);
        SET Var_NumIntGrupo   	:= IFNULL(Var_NumIntGrupo,Entero_Cero);


        SET Aud_FechaActual := NOW();
        SET Par_Estatus		:= Est_Autorizado;

        -- Se realiza el ciclo para el registro se asignacion de avales
        WHILE (Var_NumIntGrupo > Entero_Cero)  DO
			SELECT SolicitudCreditoID,	ClienteID, GrupoID INTO Var_Solicitud,	Var_ClienteID,  Var_GrupoID
				FROM TMPINTEGRANTESGRUPO WHERE SolicitudGrupID = Var_NumIntGrupo;

				IF(Var_ClienteID <> Par_ClienteID)THEN
					SET Var_ClienteID  := (SELECT ClienteID FROM TMPINTEGRANTESGRUPO WHERE GrupoID = Var_GrupoID AND ClienteID = Par_ClienteID);
				END IF;

				IF(Var_ClienteID = Par_ClienteID) THEN
				  SET Var_ClienteID  := Var_ClienteID;
				END IF;

                SET Var_ClienteID 	:= IFNULL(Var_ClienteID,Entero_Cero);

				INSERT INTO AVALESPORSOLICI (
					SolicitudCreditoID,   	AvalID,       		ClienteID,    			ProspectoID,  		Estatus,
					TipoRelacionID,			TiempoDeConocido,
                    FechaRegistro,        	EmpresaID,    		Usuario,      			FechaActual,  		DireccionIP,
					ProgramaID,           	Sucursal,     		NumTransaccion)
				 VALUES(
					Var_Solicitud,			Entero_Cero,		Var_ClienteID,			Entero_Cero,		Par_Estatus,
                    Entero_Cero,			Entero_Cero,
					Var_FechaSistema,       Par_EmpresaID,  	Aud_Usuario,    		Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID,         Aud_Sucursal,   	Aud_NumTransaccion);

				SET Var_Solicitud       := Entero_Cero;
				SET Var_ClienteID     	:= Entero_Cero;
				SET Var_GrupoID     	:= Entero_Cero;
				SET Var_NumIntGrupo  	:= Var_NumIntGrupo - Entero_Uno;

		END WHILE;

		SET  Par_NumErr := Entero_Cero;
		SET  Par_ErrMen := 'Avales Agregados Exitosamente.';

		DROP TEMPORARY TABLE IF EXISTS TMPINTEGRANTESGRUPO;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen;
	END IF;

END TerminaStore$$