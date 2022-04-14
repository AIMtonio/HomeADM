-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOSOLICITUDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOSOLICITUDPRO`;DELIMITER $$

CREATE PROCEDURE `FONDEOSOLICITUDPRO`(
	Par_SolicCredID		BIGINT(20),
	Par_ClienteID       INT(11),
	Par_CuentaAhoID	  	BIGINT(12),
	Par_MontoFondeo     DECIMAL(12,2),
	Par_TasaPasiva      DECIMAL(8,4),

	Par_Salida			CHAR(1),
	INOUT	Par_NumErr  INT(11),
	INOUT	Par_ErrMen  VARCHAR(400),
    /* Parametros de Auditoria */
	Par_EmpresaID       INT(11),
	Aud_Usuario			INT(11),

	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Var_PorceFondeo	DECIMAL(8,2);


DECLARE Entero_Cero		INT;
DECLARE Decimal_Cero	DECIMAL(12,4);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Var_MonedaBase	INT;
DECLARE Var_TipoFondID	INT;
DECLARE Var_FechaSis	DATE;
DECLARE Var_TasaActiva	DECIMAL(8,4);
DECLARE Var_MontoSolici	DECIMAL(12,2);
DECLARE Var_MontoFondea	DECIMAL(12,2);
DECLARE Var_TipoBloqID	INT;
DECLARE Var_DescripBlo	VARCHAR(50) ;
DECLARE Fecha_Vacia   	DATE;
DECLARE Mov_Bloqueo		CHAR(1);
DECLARE Salida_NO		CHAR(1);
DECLARE Estatus_Can		CHAR(1);
DECLARE NumAct_Alta		INT;
DECLARE ClienteInstit	INT;
DECLARE cuentaCli		INT;

SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;
SET Cadena_Vacia		:= '';
SET Mov_Bloqueo			:= 'B';
SET Estatus_Can 		:= 'C';
SET NumAct_Alta			:= 1;
SET Var_TipoFondID 		:= 1;
SET Var_TipoBloqID 		:= 7;
SET Fecha_Vacia			:= '1900-01-01';

SELECT 	FechaSistema, 	MonedaBaseID,	ClienteInstitucion
		INTO
		Var_FechaSis,	Var_MonedaBase,	ClienteInstit
	FROM PARAMETROSSIS;


SELECT TasaActiva,	MontoAutorizado, MontoFondeado	INTO Var_TasaActiva, 	Var_MontoSolici, Var_MontoFondea
	FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicCredID;
SET	Salida_NO		:= 'N';

SET Var_MontoSolici:= IFNULL(Var_MontoSolici,Entero_Cero);
SET Var_MontoFondea:= IFNULL(Var_MontoFondea,Entero_Cero);


SELECT Descripcion INTO Var_DescripBlo FROM TIPOSBLOQUEOS WHERE TiposBloqID = Var_TipoBloqID;

IF(IFNULL(Par_SolicCredID, Entero_Cero))= Entero_Cero THEN
	SELECT '001' AS NumErr,
		 'El numero de Solicitud de Credito esta Vacio.' AS ErrMen,
		 'SolicitudCreditoID' AS control,
		 IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
        SELECT '002' AS NumErr,
                 'El numero de Cliente esta vacio.' AS ErrMen,
                 'clienteID' AS control,
		 IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;
        LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_MontoFondeo, Decimal_Cero))= Decimal_Cero THEN
        SELECT '003' AS NumErr,
                 'El monto de fondeo esta vacio.' AS ErrMen,
                 'MontoFondeo' AS control,
		 IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;
        LEAVE TerminaStore;
END IF;


IF (Par_ClienteID != ClienteInstit) THEN
	IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
        SELECT '005' AS NumErr,
                 'Especifique Cuenta de Ahorro.' AS ErrMen,
                 'cuentaAhoID' AS control,
		 IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;
        LEAVE TerminaStore;
	END IF;
END IF;

-- Se valida que la cuenta pertenezca al cliente
SET cuentaCli := (SELECT ClienteID
					FROM CUENTASAHO
					WHERE ClienteID = Par_ClienteID
					AND CuentaAhoID = Par_CuentaAhoID);

IF (Par_ClienteID != ClienteInstit) THEN
	IF(IFNULL(cuentaCli, Entero_Cero))= Entero_Cero THEN
			SELECT '007' AS NumErr,
					 'El numero de Cuenta no pertenece al Cliente Indicado.' AS ErrMen,
					 'clienteID' AS control,
			 IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;
			LEAVE TerminaStore;
	END IF;
END IF;

IF (Var_MontoSolici >= Par_MontoFondeo AND Var_MontoSolici >=Var_MontoFondea)  THEN
	IF (Var_MontoSolici >=(Var_MontoFondea+Par_MontoFondeo)) THEN
		SET Var_PorceFondeo := ROUND(ROUND(IF(Var_MontoSolici > Entero_Cero,(Par_MontoFondeo/Var_MontoSolici),Entero_Cero),2) * 100,2);
	ELSE
		SELECT '006' AS NumErr,
		'El monto del Fondeo es mayor al solicitado.' AS ErrMen,
		'montoFondeo' AS control,Par_MontoFondeo AS consecutivo;
	LEAVE TerminaStore;
	END IF;
ELSE
	SELECT '006' AS NumErr,
		'El monto del Fondeo es mayor al solicitado.' AS ErrMen,
		'montoFondeo' AS control,Par_MontoFondeo AS consecutivo;
	LEAVE TerminaStore;
END IF;


CALL FONDEOSOLICITUDALT(
	Par_SolicCredID,	Par_ClienteID,	 Par_CuentaAhoID,		Var_FechaSis,			Par_MontoFondeo,
	Var_PorceFondeo, 	Var_MonedaBase, 	 Var_TasaActiva, 		Par_TasaPasiva,		Var_TipoFondID,
	Salida_NO,		Par_NumErr,		 Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	 Aud_ProgramaID,  	Aud_Sucursal,			Aud_NumTransaccion
);

IF (Par_ClienteID != ClienteInstit) THEN
	CALL BLOQUEOSPRO(Entero_Cero,         Mov_Bloqueo,	    Par_CuentaAhoID,	Var_FechaSis,
                     Par_MontoFondeo,	  Fecha_Vacia,      Var_TipoBloqID,     Var_DescripBlo,
                     Aud_NumTransaccion,  Cadena_Vacia,     Cadena_Vacia,   Salida_NO,
                    Par_NumErr, Par_ErrMen, Par_EmpresaID,		 Aud_Usuario,	      Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,  	  Aud_Sucursal,     Aud_NumTransaccion);
END IF;

SELECT FORMAT(ROUND(SUM(PorcentajeFondeo),2),2) INTO Var_PorceFondeo
 FROM  FONDEOSOLICITUD
 WHERE SolicitudCreditoID = Par_SolicCredID
 AND Estatus != Estatus_Can;



		SELECT '000' AS NumErr,
		    Par_ErrMen AS ErrMen,
		    'porcentaje' AS control,
			Par_SolicCredID AS consecutivo;

END TerminaStore$$