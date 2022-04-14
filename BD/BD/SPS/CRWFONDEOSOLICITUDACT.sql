
-- ---------------------------------------------------------------------------------
-- Routine DDL SP PARA WEB SERVICE
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOSOLICITUDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONDEOSOLICITUDACT`;

DELIMITER $$
CREATE PROCEDURE `CRWFONDEOSOLICITUDACT`(
    Par_SolFondeoID     BIGINT(20),
    Par_SolicCredID     BIGINT(20),
    Par_ClienteID       INT(11),
    Par_CuentaAhoID     BIGINT(12),
    Par_MontoFondeo     DECIMAL(12,2),
    Par_NumAct          TINYINT UNSIGNED,
    Par_Salida          CHAR (1),

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)

TerminaStore: BEGIN


DECLARE Var_Estatus     CHAR(1);


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Decimal_Cero    DECIMAL (12,4);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Act_Cancelar    INT;
DECLARE Estatus_Can     CHAR(1);
DECLARE Salida_SI       CHAR(1);


SET Cadena_Vacia        := '';
SET Decimal_Cero        := 0.0;
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Act_Cancelar        := 2;
SET Estatus_Can         := 'C';
SET Salida_SI           := 'S';


SET Aud_FechaActual := NOW();
SET Par_SolFondeoID := IFNULL(Par_SolFondeoID, Entero_Cero);

SET Var_Estatus := (SELECT Estatus
                        FROM CRWFONDEOSOLICITUD
                        WHERE SolFondeoID = Par_SolFondeoID);

SET Var_Estatus := IFNULL(Var_Estatus, Cadena_Vacia);

IF(IFNULL(Par_SolicCredID, Entero_Cero))= Entero_Cero THEN
	SELECT '001' AS NumErr,
		 'El numero de Solicitud de Credito esta Vacio.' AS ErrMen,
		 'SolicitudCreditoID' AS control,
		 Entero_Cero AS consecutivo;
	LEAVE TerminaStore;
END IF;


IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
        SELECT '002' AS NumErr,
                 'El numero de Cliente esta vacio.' AS ErrMen,
                 'clienteID' AS control,NumConsecutivo AS consecutivo,
		 Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
        SELECT '003' AS NumErr,
                 'Especifique Cuenta de Ahorro.' AS ErrMen,
                 'cuentaAhoID' AS control,NumConsecutivo AS consecutivo,
		 Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
END IF;

IF(Var_Estatus = Cadena_Vacia)THEN
        SELECT '004' AS NumErr,
                 'La Solicitud de Inversion no Existe.' AS ErrMen,
                 'cuentaAhoID' AS control,NumConsecutivo AS consecutivo,
		 Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
END IF;

IF(Par_NumAct = Act_Cancelar) THEN
	IF(Var_Estatus = Estatus_Can) THEN
		SELECT '005' AS NumErr,
			 'La Solicitud de Fondeo ya se encuentra Cancelada.' AS ErrMen,
			 'SolicitudCreditoID' AS control,
		 Entero_Cero AS consecutivo;
		LEAVE TerminaStore;
	END IF;

    UPDATE CRWFONDEOSOLICITUD SET
        Estatus  		= Estatus_Can,
        EmpresaID		= Aud_EmpresaID,
        Usuario			= Aud_Usuario,
        FechaActual 		= Aud_FechaActual,
        DireccionIP 		= Aud_DireccionIP,
        ProgramaID  		= Aud_ProgramaID,
        Sucursal			= Aud_Sucursal,
        NumTransaccion	= Aud_NumTransaccion

    WHERE SolFondeoID = Par_SolFondeoID;

	IF (Par_Salida = Salida_SI) THEN
		SELECT '000' AS NumErr ,
		  'Solicitud de Fondeo Cancelada' AS ErrMen,
		  'Par_SolicCredID' AS control,
		 Entero_Cero AS consecutivo;
	END IF;

END IF;


END TerminaStore$$
