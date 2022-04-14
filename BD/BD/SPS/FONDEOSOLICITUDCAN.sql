-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOSOLICITUDCAN
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOSOLICITUDCAN`;
DELIMITER $$

CREATE PROCEDURE `FONDEOSOLICITUDCAN`(
	Par_SolicCredID		    BIGINT(20),
	Par_ClienteID       	INT(11),
	Par_CuentaAhoID	  	    BIGINT(12),
	Par_MontoFondeo     	DECIMAL(12,2),

	Par_EmpresaID       	INT(11),
	Aud_Usuario			    INT,
	Aud_FechaActual		    DATETIME,
	Aud_DireccionIP		    VARCHAR(15),
	Aud_ProgramaID		    VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion	    BIGINT
)
TerminaStore: BEGIN


DECLARE Var_PorceFondeo	    DECIMAL(8,6);
DECLARE Var_MontoPorFon	    DECIMAL(12,2);
DECLARE Var_FechaSis		DATE;


DECLARE Entero_Cero		    INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Decimal_Cero		DECIMAL(12,4);
DECLARE Var_TipoBloqID	    INT;
DECLARE Var_DescripBlo	    VARCHAR(50) ;
DECLARE Fecha_Vacia   	    DATE;
DECLARE Mov_Bloqueo		    CHAR(1);
DECLARE Mov_Desbloq		    CHAR(1);
DECLARE Salida_NO			CHAR(1);
DECLARE SalidaSI			CHAR(1);
DECLARE Estatus_Can		    CHAR(1);
DECLARE NumAct_Can		    INT;
DECLARE Par_NumErr		    INT;
DECLARE Par_ErrMen		    VARCHAR(400);

SET Entero_Cero		    := 0;
SET Cadena_Vacia		:= '';
SET Decimal_Cero		:= 0.0;
SET Mov_Bloqueo		    := 'B';
SET Mov_Desbloq		    := 'D';
SET NumAct_Can	 	    := 2;
SET Var_TipoBloqID 	    := 7;
SET Fecha_Vacia		    := '1900-01-01';
SET	Salida_NO		    := 'N';
SET Estatus_Can 		:= 'C';
SET	SalidaSI			:= 'S';
SET Par_NumErr		    := 0;
SET Par_ErrMen		    := '';

SELECT Descripcion INTO Var_DescripBlo FROM TIPOSBLOQUEOS WHERE TiposBloqID = Var_TipoBloqID;
SELECT FechaSistema 	INTO Var_FechaSis FROM PARAMETROSSIS;


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
                 'clienteID' AS control,NumConsecutivo AS consecutivo,
		 IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;
        LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
        SELECT '003' AS NumErr,
                 'Especifique Cuenta de Ahorro.' AS ErrMen,
                 'cuentaAhoID' AS control,NumConsecutivo AS consecutivo,
		 IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;
        LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_MontoFondeo, Decimal_Cero))= Decimal_Cero THEN
        SELECT '004' AS NumErr,
                 'El monto de fondeo esta vacio.' AS ErrMen,
                 'MontoFondeo' AS control,NumConsecutivo AS consecutivo,
		 IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;
        LEAVE TerminaStore;
END IF;


IF(NOT EXISTS(SELECT SolicitudCreditoID
			FROM FONDEOSOLICITUD
			WHERE SolicitudCreditoID = Par_SolicCredID)) THEN
	SELECT '005' AS NumErr,
		 'El Numero de Solicitud no existe no existe.' AS ErrMen,
		 'solicitudCreditoID' AS control,
		 IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;
	LEAVE TerminaStore;
END IF;

CALL FONDEOSOLICITUDACT(
					    Par_SolicCredID,	Par_ClienteID,	 Par_CuentaAhoID,		Par_MontoFondeo,		NumAct_Can,
	                    Salida_NO,		    Par_EmpresaID,	 Aud_Usuario,		 	Aud_FechaActual,		Aud_DireccionIP,
	                    Aud_ProgramaID,  	Aud_Sucursal,	 Aud_NumTransaccion
);

SELECT format(ROUND(SUM(PorcentajeFondeo),2),2) INTO Var_PorceFondeo
 FROM  FONDEOSOLICITUD
 WHERE SolicitudCreditoID = Par_SolicCredID
 AND Estatus != Estatus_Can;

CALL SOLICITUDCREDITOACT(	Par_SolicCredID,	Par_MontoFondeo,	Var_PorceFondeo,	Decimal_Cero,       Decimal_Cero,
							Decimal_Cero,		NumAct_Can,		    Entero_Cero,	    Entero_Cero,		Cadena_Vacia,
                            Decimal_Cero,		Cadena_Vacia,		Decimal_Cero,		Salida_NO,			Par_NumErr,
                            Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario,	    Aud_FechaActual,    Aud_DireccionIP,
                            Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

CALL BLOQUEOSPRO(
				Entero_Cero,            Mov_Desbloq,		Par_CuentaAhoID,	Var_FechaSis,
                Par_MontoFondeo,		Fecha_Vacia,        Var_TipoBloqID,	    Var_DescripBlo,
                Aud_NumTransaccion,	    Cadena_Vacia,       Cadena_Vacia,       Salida_NO,
                Par_NumErr,             Par_ErrMen,	        Par_EmpresaID,      Aud_Usuario,
                Aud_FechaActual,	    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

SELECT format(ROUND(SUM(PorcentajeFondeo),2),2) INTO Var_PorceFondeo
 FROM  FONDEOSOLICITUD
 WHERE SolicitudCreditoID = Par_SolicCredID
 AND Estatus != Estatus_Can;

SELECT IFNULL((MontoSolici - MontoFondeado), Entero_Cero) INTO Var_MontoPorFon
	FROM SOLICITUDCREDITO
	WHERE SolicitudCreditoID = Par_SolicCredID;


SELECT '000' AS NumErr,
    'Solicitud de Fondeo fue Cancelada.' AS ErrMen,
     Var_MontoPorFon AS control,
	IFNULL(Var_PorceFondeo,Entero_Cero) AS consecutivo;


END TerminaStore$$