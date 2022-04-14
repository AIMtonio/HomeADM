-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWCANCELACREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWCANCELACREPRO`;
DELIMITER $$


CREATE PROCEDURE `CRWCANCELACREPRO`(
	Par_CreditoID		BIGINT(20),				-- ID del credito
	Par_Salida          CHAR(1), 				-- Salida si
	INOUT	Par_NumErr	INT(11),				-- Parametro numero error
	INOUT	Par_ErrMen	VARCHAR(400),			-- Parametro mensaje de error
    Aud_EmpresaID       INT(11),				-- Auditoria	

    Aud_Usuario         INT(11),				-- Auditoria
    Aud_FechaActual     DATETIME,				-- Auditoria
    Aud_DireccionIP     VARCHAR(15),			-- Auditoria
    Aud_ProgramaID      VARCHAR(50),			-- Auditoria
    Aud_Sucursal        INT(11),				-- Auditoria
    Aud_NumTransaccion  BIGINT(20)				-- Auditoria
)

TerminaStore: BEGIN
	

DECLARE Var_EstatusCre			CHAR(1);
DECLARE Var_EstatusCancela		CHAR(1);
DECLARE Var_EstatusFondeo		CHAR(1);
DECLARE Var_EstatusDescrip		CHAR(100);
DECLARE Error_Key				INT(11);
DECLARE VarSolicitudCre			BIGINT(20);
DECLARE VarControl 				VARCHAR(20);
DECLARE Var_SolFondeoID			BIGINT(20);
DECLARE	Var_CuentaAhoID			BIGINT(12);
DECLARE	Var_ClienteID			CHAR(12);
DECLARE	Var_SolicitudID			BIGINT(20);

DECLARE Cadena_Vacia	VARCHAR(300);
DECLARE Entero_Cero		INT;
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE Fecha_Vacia		DATE;
DECLARE Con_EstatusIn	CHAR(1);
DECLARE Con_EstatusAu	CHAR(1);
DECLARE Con_EnProceso	CHAR(1);
DECLARE Salida_NO		CHAR(1);
DECLARE Salida_SI		CHAR(1);
DECLARE Var_Control		CHAR(20);
DECLARE Act_Cancelar	INT; 
DECLARE Act_CancelaAmor	INT; 
DECLARE	TipoCredito 	CHAR(1);
DECLARE Var_CreditID	BIGINT;



SET Cadena_Vacia		:= '';
SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;
SET Fecha_Vacia			:= '1900-01-01';
SET Var_EstatusCancela	:= '';
SET Var_EstatusFondeo	:= '';
SET Var_EstatusDescrip	:= '';
SET	Con_EstatusIn		:= 'I';
SET Con_EstatusAu		:= 'A';
SET Con_EnProceso		:= 'F';
SET Error_Key			:= Entero_Cero;
SET VarControl 			:= '';
SET Var_SolFondeoID		:= '';
SET Var_CuentaAhoID		:= '';
SET Var_ClienteID		:= '';
SET Var_SolicitudID		:= '';
SET Salida_NO			:= 'N';
SET Salida_SI			:= 'S';
SET TipoCredito			:= 'C';
SET VarSolicitudCre		:= 0;
SET Act_Cancelar		:= 14;			
SET Act_CancelaAmor		:= 1;			
SET Var_CreditID		:= 0;


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = '999';
		SET Par_ErrMen = CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
						'estamos trabajando para resolverla. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-CRWCANCELACREPRO');	
		SET VarControl = 'SQLEXCEPTION' ; 
	END;


	
	IF(IFNULL( Par_CreditoID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := '001';
		SET Par_ErrMen  := 'No se introdujo un valor para el Credito';
		SET VarControl  := 'CreditoID' ; 
		LEAVE ManejoErrores;		
	END IF;
	
	SELECT 	CreditoID,		Estatus 
	INTO 	Var_CreditID,	Var_EstatusCre 
	FROM CREDITOS 
	WHERE CreditoID = Par_CreditoID;		
	
	SET Var_CreditID	:= IFNULL(Var_CreditID, Entero_Cero);
	SET Var_EstatusCre	:= IFNULL(Var_EstatusCre, Cadena_Vacia);

	IF(Var_CreditID = Cadena_Vacia) THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El Credito no existe';
			SET VarControl  := 'CreditoID' ; 
			LEAVE ManejoErrores;
	END IF;
			

	IF(Var_EstatusCre = Cadena_Vacia) THEN	
		SET Par_NumErr  := '003';
		SET Par_ErrMen  := 'No existe un estatus para el credito';
		SET VarControl  := 'creditoID' ; 
		LEAVE ManejoErrores;
	END IF;

	IF((Var_EstatusCre <> Con_EstatusIn) AND (Var_EstatusCre <> Con_EstatusAu)) THEN
		SET Par_NumErr  := '004';
		SET Par_ErrMen  := 'Solo es posible cancelar creditos Autorizados o 
		Inactivos, por lo tanto no es posible cancelar este credito';
		SET VarControl  := 'creditoID' ; 
		LEAVE ManejoErrores;	
	END IF;	

	CALL CREDITOSACT(
		Par_CreditoID,		Entero_Cero,		Fecha_Vacia,			Entero_Cero,		Act_Cancelar,
		Fecha_Vacia,		Fecha_Vacia,		Decimal_Cero,			Decimal_Cero,		Entero_Cero,
		Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,			Salida_NO,			Par_NumErr,
		Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
						
	IF(Par_NumErr <> Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	SELECT SolicitudCreditoID 
	INTO VarSolicitudCre
	FROM CREDITOS WHERE CreditoID = Par_CreditoID;
	SET VarSolicitudCre	:= IFNULL(VarSolicitudCre, Entero_Cero);


	IF(VarSolicitudCre != Entero_Cero ) THEN 

		CALL CRWCANCELASOLCREPRO(
			VarSolicitudCre,	TipoCredito,	Salida_NO,			Par_NumErr,			Par_ErrMen,
			Aud_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	
			Aud_Sucursal,		Aud_NumTransaccion);
			
		IF(Par_NumErr != Entero_Cero)THEN 
			LEAVE ManejoErrores;
		END IF; 
	END IF; 

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := CONCAT('Credito: ',CONVERT(Par_CreditoID,CHAR),' Cancelado.');
	SET VarControl  := 'creditoID' ; 

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen		 AS ErrMen,
			VarControl		 AS control,
			Par_CreditoID	 AS consecutivo;
END IF;

END TerminaStore$$
