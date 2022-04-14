-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOSOLICITUDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOSOLICITUDALT`;
DELIMITER $$

CREATE PROCEDURE `FONDEOSOLICITUDALT`(
    Par_SolicCredID     BIGINT(20),
    Par_ClienteID       INT(11),
    Par_CuentaAhoID     BIGINT(12),
    Par_FechaRegistro   DATE,
    Par_MontoFondeo     DECIMAL(12,2),
    Par_PorceFondeo     DECIMAL(10,6),
    Par_MonedaID        INT(11),
    Par_TasaActiva      DECIMAL(8,4),
    Par_TasaPasiva      DECIMAL(8,4),
    Par_TipoFond        INT(11),

    Par_Salida          CHAR(1),
	INOUT Par_NumErr    INT,
	INOUT Par_ErrMen    VARCHAR(400),
    Par_EmpresaID       INT(11),

    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN


/* Declaracion de Variables */
DECLARE Var_Consecutivo     INT;
DECLARE Var_PorceFondeo     DECIMAL(8,2);
DECLARE Var_ProdInvKuboID	INT;
DECLARE Var_SolFondeoID		INT;
DECLARE ClienteInstit	INT;
DECLARE CuentaInst BIGINT(12);

/* Declaracion de Constantes */
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL (12,2);
DECLARE NumConsecutivo		INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Nace_Estatus		CHAR(1);
DECLARE TipoFondKubo		INT;
DECLARE SalidaSI			CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE NumAct_Alta			INT;
DECLARE NumAct_Act			INT;
DECLARE NombreProceso   	VARCHAR(16);


/* Asignacion de Constantes */
SET NumConsecutivo  := 1;
SET Nace_Estatus    := 'F';
SET Entero_Cero     := 0;
SET Cadena_Vacia    := '';
SET Decimal_Cero    := 0.0;
SET TipoFondKubo    := 3;
SET SalidaSI        := 'S';
SET	SalidaNO		:= 'N';
SET NumAct_Alta     := 1;
SET NumAct_Act		:= 5;

SET	NombreProceso	:= 'SOLICITUDFONDEO'; -- Nombre del proceso que dispara el escalamiento

SET 	Par_NumErr		:= 0;
SET 	Par_ErrMen		:= '';
SET 	Var_Consecutivo	:= 0;


SELECT 	ClienteInstitucion,CuentaInstituc
		INTO
		ClienteInstit,  CuentaInst
	FROM PARAMETROSSIS;


IF(IFNULL(Par_SolicCredID, Entero_Cero))= Entero_Cero THEN
        SELECT '001' AS NumErr,
                 'El numero de solicitud de credito esta vacio.' AS ErrMen,
                 'solicitudCreditoID' AS control,NumConsecutivo AS consecutivo;
        LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
        SELECT '002' AS NumErr,
                 'El numero de Cliente esta vacio.' AS ErrMen,
                 'clienteID' AS control,NumConsecutivo AS consecutivo;
        LEAVE TerminaStore;
END IF;


IF(IFNULL(Par_MontoFondeo, Decimal_Cero))= Decimal_Cero THEN
        SELECT '003' AS NumErr,
                 'El monto de fondeo esta vacio.' AS ErrMen,
                 'MontoFondeo' AS control,NumConsecutivo AS consecutivo;
        LEAVE TerminaStore;
END IF;

IF(Par_ClienteID != ClienteInstit) THEN

	IF(IFNULL(Par_TasaPasiva, Decimal_Cero))= Decimal_Cero THEN
        SELECT '004' AS NumErr,
                 'La Tasa Pasiva esta vacia.' AS ErrMen,
                 'TasaPasiva' AS control, NumConsecutivo AS consecutivo;
        LEAVE TerminaStore;
	END IF;
END IF;

IF(Par_ClienteID != ClienteInstit) THEN
	IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
        SELECT '005' AS NumErr,
                 'Especifique Cuenta de Ahorro.' AS ErrMen,
                 'cuentaAhoID' AS control,NumConsecutivo AS consecutivo;
        LEAVE TerminaStore;
	END IF;
END IF;

IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN
        SELECT '006' AS NumErr,
                 'Especifique Moneda de la cuenta.' AS ErrMen,
                 'monedaID' AS control,NumConsecutivo AS consecutivo;
        LEAVE TerminaStore;
END IF;



	IF EXISTS(SELECT ClienteID
				FROM FONDEOSOLICITUD
				WHERE SolicitudCreditoID = Par_SolicCredID AND ClienteID= ClienteInstit)THEN

 SET Par_CuentaAhoID:= CuentaInst;
	UPDATE FONDEOSOLICITUD SET
	ClienteID		   = Par_ClienteID,
	CuentaAhoID		   = Par_CuentaAhoID,
	FechaRegistro	   = Par_FechaRegistro,
	MontoFondeo 	   = MontoFondeo + Par_MontoFondeo,
	PorcentajeFondeo   = PorcentajeFondeo + Par_PorceFondeo,
	MonedaID 		   = Par_MonedaID,
	TasaActiva 		   = Par_TasaActiva,
	TasaPasiva 		   = Par_TasaPasiva,
	TipoFondeadorID	   = Par_TipoFond,
	Usuario			   = Aud_Usuario,
	FechaActual		   = Aud_FechaActual,
	DireccionIP    	   = Aud_DireccionIP,
	ProgramaID     	   = Aud_ProgramaID,
	Sucursal		   = Aud_Sucursal,
	NumTransaccion	   = Aud_NumTransaccion
	WHERE SolicitudCreditoID = Par_SolicCredID AND ClienteID= ClienteInstit;

		-- Actualizamos la Solicitud de Credito (opcion no aumente el numero de fondeos)
	CALL SOLICITUDCREDITOACT(
				    Par_SolicCredID,	Par_MontoFondeo,	Par_PorceFondeo, 	Decimal_Cero,		Decimal_Cero,
                    Decimal_Cero,		NumAct_Act,   		Entero_Cero,		Entero_Cero,    	Cadena_Vacia,
                    Decimal_Cero,		Cadena_Vacia,		Decimal_Cero,		SalidaNO,			Par_NumErr,
                    Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,		Aud_Sucursal,	 	Aud_NumTransaccion);

    ELSE

	-- Producto DEFAULT del Inversiones Kubo
	SELECT ProdInvKuboDefault INTO Var_ProdInvKuboID
		FROM PARAMETROSSIS;

	SET NumConsecutivo	:= (SELECT IFNULL(MAX(Consecutivo),Entero_Cero) + 1
							FROM FONDEOSOLICITUD
							WHERE SolicitudCreditoID = Par_SolicCredID);

 CALL FOLIOSAPLICAACT(
		'FONDEOSOLICITUD',	Var_SolFondeoID );




	IF(Par_ClienteID = ClienteInstit) THEN
		SET Par_CuentaAhoID:= CuentaInst;
    END IF;
	INSERT INTO FONDEOSOLICITUD	(
						SolFondeoID,	  SolicitudCreditoID, Consecutivo,    	  ClienteID,      CuentaAhoID,
						FechaRegistro,	  MontoFondeo,        PorcentajeFondeo,   MonedaID,       Estatus,
						TasaActiva,		  TasaPasiva,         TipoFondeadorID,    ProdInvKuboID,  EmpresaID,
						Usuario,   		  FechaActual,        DireccionIP,        ProgramaID,     Sucursal,
						NumTransaccion	)
				VALUES (
						Var_SolFondeoID,	Par_SolicCredID,    NumConsecutivo,     Par_ClienteID,      Par_CuentaAhoID,
						Par_FechaRegistro,  Par_MontoFondeo,    Par_PorceFondeo,    Par_MonedaID,       Nace_Estatus,
						Par_TasaActiva,     Par_TasaPasiva,     Par_TipoFond,       Var_ProdInvKuboID,  Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
						Aud_NumTransaccion);

	-- Actualizamos la Solicitud de Credito
	CALL SOLICITUDCREDITOACT(
				    Par_SolicCredID,    Par_MontoFondeo,    Par_PorceFondeo,    Decimal_Cero,       Decimal_Cero,
                    Decimal_Cero,		NumAct_Alta,        Entero_Cero,        Entero_Cero,        Cadena_Vacia,
                    Decimal_Cero,		Cadena_Vacia,		Decimal_Cero,		SalidaNO,			Par_NumErr,
                    Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,    
                    Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion);
	END IF;



	-- Llamada al proceso de deteccion de nivel de riesgo del cliente, modulo PLD
	CALL DETESCALAINTPLDPRO (
						  Var_SolFondeoID,	NumConsecutivo,	NombreProceso,	Entero_Cero,SalidaNO,		 Par_NumErr,
						  Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual, Aud_DireccionIP,
						  Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);


	IF(Par_NumErr = Entero_Cero OR Par_NumErr = 502)THEN
		IF(Par_Salida = SalidaSI )THEN
			SELECT '000' AS NumErr,
			 "Solicitud de Fondeo Agregada" AS ErrMen,
			 'porcentaje' AS control,
			  NumConsecutivo AS consecutivo;
		END IF;
		IF(Par_Salida = SalidaNO )THEN
			SET Par_NumErr := '000';
			SET	Par_ErrMen := "Solicitud de Fondeo Agregada";
		END IF;
	 END IF;

	IF(Par_NumErr != Entero_Cero OR Par_NumErr != 502)THEN
			IF(Par_Salida = SalidaSI )THEN
				SELECT Par_NumErr AS NumErr,
				 CONCAT("Solicitud de Fondeo Agregada, ",Par_ErrMen) AS ErrMen,
				 'porcentaje' AS control,
				  NumConsecutivo AS consecutivo;
			END IF;

		IF(Par_Salida = SalidaNO )THEN
			SET 	Par_NumErr := Par_NumErr;
			SET	Par_ErrMen := CONCAT("Solicitud de Fondeo Agregada, ",Par_ErrMen);
		END IF;
   END IF;



END TerminaStore$$