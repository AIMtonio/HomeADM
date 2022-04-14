
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWCANCELASOLCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWCANCELASOLCREPRO`;

DELIMITER $$

CREATE PROCEDURE `CRWCANCELASOLCREPRO`(

	Par_SolicCredID		BIGINT(20),			-- ID de la solicitud de credito
    Par_TipoCancel      CHAR(1),            -- Tipo de cancelacion S = Solicitud, C = Credito
	Par_Salida          CHAR(1),			-- Par salida
	INOUT	Par_NumErr	INT(11),			-- Numero de error o exito
	INOUT	Par_ErrMen	VARCHAR(400),		-- Mensaje de operacion

	Aud_EmpresaID		INT(11),			-- Auditoria
	Aud_Usuario         INT(11),            -- Auditoria
	Aud_FechaActual     DATETIME,      		-- Auditoria
	Aud_DireccionIP     VARCHAR(15),    	-- Auditoria
	Aud_ProgramaID      VARCHAR(150),    	-- Auditoria
	Aud_Sucursal        INT(11),            -- Auditoria
	Aud_NumTransaccion  BIGINT(20)      	-- Auditoria
)

TerminaStore: BEGIN


DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE BigInt_Cero		BIGINT;
DECLARE Entero_Cero		INT;
DECLARE Cadena_Vacia	CHAR(200);

DECLARE	Est_Cancelada	CHAR(1);
DECLARE	Est_ProcFondeo	CHAR(1);
DECLARE	TipoCredito 	CHAR(1);
DECLARE	TipoSolicitud  	CHAR(1);
DECLARE	Est_Desem		CHAR(1);
DECLARE	Est_Autorizado	CHAR(1);
DECLARE	Salida_SI 		CHAR(1);
DECLARE Salida_NO 		CHAR(1);
DECLARE Act_SolCan		INT(11);
DECLARE EstatusA		CHAR(1);
DECLARE Entero_Uno   	INT(11);
DECLARE Error_Key			INT(11);
DECLARE Sol_CreditoID		BIGINT(20);
DECLARE Credito_Estatus 	CHAR(1);


DECLARE VarSolFondeoID		BIGINT(20);
DECLARE VarControl 			VARCHAR(20);
DECLARE VarEstatus 			CHAR(1);
DECLARE Var_SolicitudCredID	BIGINT(20);
DECLARE Var_CreditoID		BIGINT(12);



DECLARE CURSORFONDEOSOLICITUD  CURSOR FOR
	SELECT SolFondeoID
		FROM CRWFONDEOSOLICITUD
		WHERE SolicitudCreditoID = Par_SolicCredID
		AND 	Estatus = Est_ProcFondeo;



SET Decimal_Cero 	:= 0.00;
SET BigInt_Cero 	:= 0;
SET Salida_SI 		:= 'S';
SET Salida_NO 		:= 'N';
SET Act_SolCan		:= 2;
SET	Cadena_Vacia	:= '';
SET Entero_Cero		:= 0;
SET Est_Cancelada	:= 'C';
SET Est_ProcFondeo	:= 'F';
SET Est_Autorizado	:= 'A';
SET Est_Desem		:= 'D';
SET	Entero_Uno		:= 1;
SET TipoCredito 	:= 'C';
SET TipoSolicitud  	:= 'S';
SET Error_Key		:= Entero_Cero;
SET Credito_Estatus := '';
SET EstatusA		:= 'A';
SET Par_NumErr := Entero_Cero;
SET Par_ErrMen := Cadena_Vacia;

SET Var_SolicitudCredID :=0;
SET VarSolFondeoID	:= 0;
SET VarControl 		:= '';
SET VarEstatus 		:= '';

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = '999';
		SET Par_ErrMen = CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
								 'estamos trabajando para resolverla. Disculpe las molestias que ',
								 'esto le ocasiona. Ref: SP-CANCELASOLCREWSPRO');
		SET VarControl = 'SQLEXCEPTION' ;
	END;

	SET Credito_Estatus:=(SELECT IFNULL(Estatus, Cadena_Vacia)
							FROM CREDITOS
							WHERE SolicitudCreditoID = Par_SolicCredID);

	IF(Credito_Estatus) <> Cadena_Vacia THEN
		IF(Credito_Estatus = EstatusA) THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'Solicitud sen encuentra ligada a un credito. Es necesario cancelar primero el Credito.';
			SET VarControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
	END IF;



	SET Var_SolicitudCredID := IFNULL(Par_SolicCredID,Entero_Cero);

	IF(Var_SolicitudCredID = Entero_Cero) THEN
		SET Par_NumErr  := '002';
		SET Par_ErrMen  := 'No se introdujo un valor para la Solicitud de Credito.';
		SET VarControl  := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	SELECT SolicitudCreditoID, Estatus,		CreditoID
	INTO  Sol_CreditoID, VarEstatus,		Var_CreditoID
	FROM SOLICITUDCREDITO
	WHERE SolicitudCreditoID = Var_SolicitudCredID;

	SET	Sol_CreditoID := IFNULL(Sol_CreditoID, Entero_Cero);
	SET VarEstatus	:= IFNULL(VarEstatus, Cadena_Vacia);

	IF(Sol_CreditoID = Entero_Cero ) THEN
		SET Par_NumErr  := '003';
		SET Par_ErrMen  := 'La Solicitud de Credito no existe.';
		SET VarControl  := 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	SET VarEstatus	:= IFNULL(VarEstatus,Cadena_Vacia);

	IF( Par_TipoCancel = TipoSolicitud) THEN
		IF( VarEstatus = Est_Cancelada) THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'La Solicitud se encuentra Cancelada.';
			SET VarControl  := 'estatus' ;
			LEAVE ManejoErrores;
		END IF;
		IF(VarEstatus = Est_Desem ) THEN
			SET Par_NumErr  := '005';
			SET Par_ErrMen  := 'La Solicitud se encuentra Desembolsada.';
			SET VarControl  := 'estatus' ;
			LEAVE ManejoErrores;
		END IF;


	END IF;

	IF( Par_TipoCancel = TipoCredito) THEN
		SELECT Estatus
		INTO VarEstatus
		FROM CREDITOS
		WHERE CreditoID = Var_CreditoID;
		IF(VarEstatus <> Est_Cancelada ) THEN
			SET Par_NumErr  := '006';
			SET Par_ErrMen  := 'Es necesario que el credito se encuentre cancelado.';
			SET VarControl  := 'estatus' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	UPDATE	SOLICITUDCREDITO SET
			MontoFondeado			= IFNULL(IFNULL(MontoFondeado,Entero_Cero) - Decimal_Cero,Entero_Cero),
			PorcentajeFonde			= IFNULL(IFNULL(PorcentajeFonde,Entero_Cero) - Decimal_Cero,Entero_Cero),
			NumeroFondeos			= IFNULL(IFNULL(NumeroFondeos,Entero_Cero) - Entero_Uno,Entero_Cero),

			EmpresaID				= Aud_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual 			= Aud_FechaActual,
			DireccionIP 			= Aud_DireccionIP,
			ProgramaID  			= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
	WHERE	SolicitudCreditoID	= Par_SolicCredID;



OPEN CURSORFONDEOSOLICITUD;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	CICLO: LOOP

	FETCH CURSORFONDEOSOLICITUD INTO
		VarSolFondeoID;


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := Cadena_Vacia;


		CALL CRWFONDEOSOLICITUDCAN(
			VarSolFondeoID,		Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero ) THEN
			LEAVE CICLO;
		END IF;

	END LOOP CICLO;

END;

CLOSE CURSORFONDEOSOLICITUD;

IF(Par_NumErr != Entero_Cero ) THEN
	LEAVE ManejoErrores;
ELSE
	SET Par_NumErr  := '000';
	SET Par_ErrMen  := CONCAT('Solicitud de Credito: ',CONVERT(Par_SolicCredID,CHAR),' Cancelada.');
	SET VarControl  := 'solicCredID' ;
	LEAVE ManejoErrores;
END IF;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen		 AS ErrMen,
			VarControl		 AS control,
			Par_SolicCredID	 AS consecutivo;
END IF;

END TerminaStore$$
