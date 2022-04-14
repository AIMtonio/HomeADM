-- ---------------------------------------------------------------------------------
-- Routine DDL   SP PARA WEB SERVICE
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOSOLICITUDCAN
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONDEOSOLICITUDCAN`;
DELIMITER $$


CREATE PROCEDURE `CRWFONDEOSOLICITUDCAN`(
    Par_SolFondeoID     BIGINT(20),

	Par_Salida          CHAR(1),
	INOUT	Par_NumErr	INT,
	INOUT	Par_ErrMen	VARCHAR(800),

	Par_EmpresaID       INT(11),
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)

TerminaStore: BEGIN


DECLARE Var_NuePorFondeo    DECIMAL(8,6);
DECLARE Var_MontoPorFon     DECIMAL(12,2);
DECLARE Var_FechaSis        DATE;
DECLARE Var_BloqueoID       INT(11);
DECLARE Var_NumErr          INT;
DECLARE Var_ErrMen          VARCHAR(400);
DECLARE VarControl          VARCHAR(30);
DECLARE VarConsecutivo      VARCHAR(30);

DECLARE Var_SolicCredID     BIGINT(20);
DECLARE Var_ClienteID       INT(11);
DECLARE Var_CuentaAhoID     BIGINT(12);
DECLARE Var_MontoFondeo     DECIMAL(12,2);
DECLARE Var_PorceFondeo     DECIMAL(12,2);



DECLARE Entero_Cero		INT;
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Decimal_Cero	DECIMAL(12,4);
DECLARE Var_TipoBloqID	INT;
DECLARE Var_DescripBlo	VARCHAR(50) ;
DECLARE Fecha_Vacia   	DATE;
DECLARE Mov_Bloqueo		CHAR(1);
DECLARE Mov_Desbloq		CHAR(1);
DECLARE Salida_NO		CHAR(1);
DECLARE Salida_SI		CHAR(1);
DECLARE Estatus_Can		CHAR(1);
DECLARE NumAct_Can		INT;
DECLARE Nat_Bloqueo		CHAR(1);


SET Entero_Cero     := 0;
SET Cadena_Vacia    := '';
SET Decimal_Cero    := 0.0;
SET Mov_Bloqueo     := 'B';
SET Mov_Desbloq     := 'D';
SET NumAct_Can      := 2;
SET Var_TipoBloqID  := 7;
SET Fecha_Vacia     := '1900-01-01';
SET Salida_NO       := 'N';
SET Estatus_Can     := 'C';
SET Salida_SI       := 'S';
SET Nat_Bloqueo     := 'B';
SET Var_NumErr      := 0;
SET Var_ErrMen      := '';
SET VarControl      := '';
SET VarConsecutivo  :='';


SET Aud_FechaActual	:= NOW();
SET Var_NuePorFondeo    := Entero_Cero;

SET Var_DescripBlo := (SELECT Descripcion
						FROM TIPOSBLOQUEOS
						WHERE TiposBloqID = Var_TipoBloqID);

SET Var_FechaSis	:= (SELECT FechaSistema
							FROM PARAMETROSSIS);

SET Var_SolicCredID	:= (SELECT SolicitudCreditoID
							FROM CRWFONDEOSOLICITUD
							WHERE SolFondeoID = Par_SolFondeoID);
SET Var_ClienteID	:= (SELECT ClienteID
							FROM CRWFONDEOSOLICITUD
							WHERE SolFondeoID = Par_SolFondeoID);
SET Var_CuentaAhoID := (SELECT CuentaAhoID
							FROM CRWFONDEOSOLICITUD
							WHERE SolFondeoID = Par_SolFondeoID);
SET Var_MontoFondeo	:= (SELECT MontoFondeo
							FROM CRWFONDEOSOLICITUD
							WHERE SolFondeoID = Par_SolFondeoID);
SET Var_PorceFondeo	:= (SELECT PorcentajeFondeo
							FROM CRWFONDEOSOLICITUD
							WHERE SolFondeoID = Par_SolFondeoID);

SET Var_SolicCredID := IFNULL(Var_SolicCredID, Entero_Cero);
SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);
SET Var_MontoFondeo := IFNULL(Var_MontoFondeo, Entero_Cero);
SET Var_PorceFondeo := IFNULL(Var_PorceFondeo, Entero_Cero);



ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := '999';
		SET Par_ErrMen := CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
								 'estamos trabajando para resolverla. Disculpe las molestias que ',
								 'esto le ocasiona. Ref: CRWFONDEOSOLICITUDCAN');
		SET VarControl := 'SQLEXCEPTION' ;
	END;


IF(Var_SolicCredID = Entero_Cero) THEN
	SET Par_NumErr  := '001';
	SET Par_ErrMen  := 'La Solicitud de Inversion No Existe.';
	SET VarControl  := 'SolicitudCreditoID' ;
	SET Var_NuePorFondeo:=IFNULL(Var_NuePorFondeo,Entero_Cero);
	LEAVE ManejoErrores;
END IF;

IF(Var_ClienteID = Entero_Cero ) THEN
	SET Par_NumErr  := '002';
	SET Par_ErrMen  := 'El numero de Cliente Inversionista esta Vacio.';
	SET VarControl  := 'clienteID' ;
	SET Var_NuePorFondeo:=IFNULL(Var_NuePorFondeo,Entero_Cero);
    LEAVE ManejoErrores;
END IF;

IF(Var_CuentaAhoID = Entero_Cero) THEN
	SET Par_NumErr  := '003';
	SET Par_ErrMen  := 'La Cuenta de Ahorro del Inversionista esta Vacia.';
	SET VarControl  := 'cuentaAhoID';
	SET Var_NuePorFondeo:=IFNULL(Var_NuePorFondeo,Entero_Cero);
	LEAVE ManejoErrores;
END IF;

IF(Var_MontoFondeo = Decimal_Cero) THEN
    SET Par_NumErr  := '004';
	SET Par_ErrMen  := 'El monto de Inversion esta vacio.' ;
	SET VarControl  := 'MontoFondeo';
	SET Var_NuePorFondeo:=IFNULL(Var_NuePorFondeo,Entero_Cero);
    LEAVE ManejoErrores;
END IF;


CALL CRWFONDEOSOLICITUDACT(
    Par_SolFondeoID,    Var_SolicCredID,    Var_ClienteID,  Var_CuentaAhoID,    Var_MontoFondeo,
    NumAct_Can,         Salida_NO,          Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
);

SET Var_NuePorFondeo	:= (SELECT format(ROUND(SUM(PorcentajeFondeo),2),2)
							FROM  CRWFONDEOSOLICITUD
							WHERE SolicitudCreditoID = Var_SolicCredID
							  AND Estatus != Estatus_Can);

	-- Se actualiza los valores de la solicitud de credito
	UPDATE	SOLICITUDCREDITO SET
			MontoFondeado			= IFNULL(MontoFondeado,Entero_Cero) + Var_MontoFondeo,
			PorcentajeFonde			= IFNULL(PorcentajeFonde,Entero_Cero) + Var_NuePorFondeo,
			NumeroFondeos			= IFNULL(NumeroFondeos,Entero_Cero),

			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
	WHERE	SolicitudCreditoID	=	Var_SolicCredID;



SET Var_BloqueoID	:=(SELECT	Blo.BloqueoID
                        FROM CRWFONDEOSOLICITUD Sol,
                               BLOQUEOS Blo
                            WHERE Sol.SolFondeoID = Par_SolFondeoID
                            AND Sol.SolFondeoID	= Blo.Referencia
                            AND Blo.TiposBloqID     = Var_TipoBloqID
                            AND Blo.NatMovimiento   = Nat_Bloqueo
                            AND IFNULL(Blo.FolioBloq, Entero_Cero) = Entero_Cero
                            AND Sol.CuentaAhoID     = Blo.CuentaAhoID
                            AND MontoBloq			= Var_MontoFondeo);


CALL BLOQUEOSPRO(
    Var_BloqueoID,  Mov_Desbloq,        Var_CuentaAhoID,    Var_FechaSis,       Var_MontoFondeo,
    Var_FechaSis,   Var_TipoBloqID,     Var_DescripBlo,     Par_SolFondeoID,    Cadena_Vacia,
    Cadena_Vacia,   Salida_NO,          Var_NumErr,         Var_ErrMen,         Par_EmpresaID,
    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
    Aud_NumTransaccion  );


IF(Var_NumErr != Entero_Cero) THEN
	LEAVE ManejoErrores;
END IF;

SET Var_MontoPorFon 	:= (SELECT IFNULL((MontoSolici - MontoFondeado), Entero_Cero)
								FROM SOLICITUDCREDITO
								WHERE SolicitudCreditoID = Var_SolicCredID);

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := CONCAT('La Solicitud de Fondeo: ',CONVERT(Par_SolFondeoID,CHAR),' Cancelada.');
	SET VarControl  := Var_MontoPorFon ;
	SET VarConsecutivo := Var_NuePorFondeo;
	LEAVE ManejoErrores;


END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen		 AS ErrMen,
			VarControl		 AS control,
			Var_NuePorFondeo AS consecutivo;
END IF;


END TerminaStore$$
