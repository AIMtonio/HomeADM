-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREMORATOVENCPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREMORATOVENCPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCREMORATOVENCPRO`(

	Par_CreditoID		BIGINT,
	Par_AmortiCreID		INT(4),
	Par_FechaInicio		DATE,
	Par_FechaVencim		DATE,
	Par_CuentaAhoID		BIGINT,

	Par_ClienteID		BIGINT,
	Par_FechaOperacion	DATE,
	Par_FechaAplicacion	DATE,
	Par_Monto			DECIMAL(12,2),
	Par_IVAMonto		DECIMAL(12,2),

	Par_MonedaID		INT,
	Par_ProdCreditoID	INT,
	Par_Clasificacion	CHAR(1),
	Par_SubClasifID     INT,
	Par_SucCliente		INT,

	Par_Descripcion		VARCHAR(100),
	Par_Referencia		VARCHAR(50),
	Par_Poliza			BIGINT,
	Par_OrigenPago		CHAR(1),				-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
INOUT	Par_NumErr		INT(11),

INOUT	Par_ErrMen		VARCHAR(400),
INOUT	Par_Consecutivo	BIGINT,
	Par_EmpresaID		INT,
	Par_ModoPago		CHAR(1),
	Aud_Usuario			INT,

	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN


DECLARE Mov_AboConta		INT;
DECLARE Mov_CarConta		INT;
DECLARE Var_RegContaEPRC	CHAR(1);
DECLARE Var_DivideEPRC	  	CHAR(1);
DECLARE Var_EPRCAdicional	CHAR(1);
DECLARE Var_CreEstatus		CHAR(1);		-- Estatus de Credito
DECLARE Var_Control			CHAR(100);
DECLARE Var_Consecutivo		INT(11);

DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(12, 2);
DECLARE	AltaPoliza_NO		CHAR(1);
DECLARE	AltaPolCre_SI		CHAR(1);
DECLARE	AltaMovCre_SI		CHAR(1);
DECLARE	AltaMovCre_NO		CHAR(1);
DECLARE	AltaMovAho_NO		CHAR(1);
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Mov_Moratorio		INT;
DECLARE	Mov_IVAIntMora		INT;
DECLARE	Con_IntMoraVen		INT;
DECLARE	Con_IVAMora			INT;
DECLARE Con_Balance  		INT;
DECLARE Con_ResultEPRC		INT;
DECLARE	Con_BalIntere		INT;
DECLARE Con_PtePrinci		INT;
DECLARE Con_PteIntere		INT;
DECLARE	Con_ResIntere		INT;
DECLARE Con_BalAdiEPRC		INT;
DECLARE Con_PteAdiEPRC		INT;
DECLARE Con_ResAdiEPRC		INT;
DECLARE EPRC_Resultados		CHAR(1);
DECLARE SI_DivideEPRC		CHAR(1);
DECLARE NO_DivideEPRC		CHAR(1);
DECLARE NO_EPRCAdicional	CHAR(1);
DECLARE SI_EPRCAdicional	CHAR(1);
DECLARE Var_SalidaNo   		CHAR(1);
DECLARE Con_MoraVencidoSup	INT(11);	-- Concepto Contable: Interes Moratorio Vencido Suspendido
DECLARE Estatus_Suspendido	CHAR(1);	-- Estatus Suspendido


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.00;
SET	AltaPoliza_NO		:= 'N';
SET	AltaPolCre_SI		:= 'S';
SET	AltaMovCre_SI		:= 'S';
SET	AltaMovCre_NO		:= 'N';
SET	AltaMovAho_NO		:= 'N';
SET Nat_Cargo			:= 'C';
SET Nat_Abono			:= 'A';
SET	Mov_Moratorio		:= 16;
SET	Mov_IVAIntMora		:= 21;
SET	Con_IntMoraVen		:= 34;
SET	Con_IVAMora			:= 9;
SET Con_Balance			:= 17;
SET Con_ResultEPRC		:= 18;
SET Con_BalIntere		:= 36;
SET Con_ResIntere		:= 37;
SET Con_PtePrinci		:= 38;
SET Con_PteIntere		:= 39;
SET Con_BalAdiEPRC		:= 49;
SET Con_PteAdiEPRC		:= 50;
SET Con_ResAdiEPRC		:= 51;
SET EPRC_Resultados		:= 'R';
SET SI_DivideEPRC		:= 'S';
SET NO_DivideEPRC		:= 'N';
SET NO_EPRCAdicional	:= 'N';
SET SI_EPRCAdicional	:= 'S';
SET Var_SalidaNo		:= 'N';
SET Con_MoraVencidoSup	:= 118;		-- Concepto Contable: Interes Moratorio Vencido Suspendido
SET Estatus_Suspendido	:= 'S';		-- Estatus Suspendido

SET	Par_EmpresaID := IFNULL(Par_EmpresaID, 1);

SET Var_RegContaEPRC	:= (SELECT RegContaEPRC 			FROM PARAMSRESERVCASTIG WHERE EmpresaID = Par_EmpresaID);
SET Var_DivideEPRC		:= (SELECT DivideEPRCCapitaInteres	FROM PARAMSRESERVCASTIG WHERE EmpresaID = Par_EmpresaID);
SET Var_EPRCAdicional	:= (SELECT EPRCAdicional			FROM PARAMSRESERVCASTIG WHERE EmpresaID = Par_EmpresaID);
SET	Var_RegContaEPRC	:= IFNULL(Var_RegContaEPRC, EPRC_Resultados);
SET	Var_DivideEPRC		:= IFNULL(Var_DivideEPRC, NO_DivideEPRC);
SET	Var_EPRCAdicional	:= IFNULL(Var_EPRCAdicional, NO_EPRCAdicional);

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
               			 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREMORATOVENCPRO');
		SET Var_Control = 'sqlException' ;
	END;

	SELECT Estatus
		INTO Var_CreEstatus
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

IF (Par_Monto > Decimal_Cero) THEN

	IF (Var_CreEstatus = Estatus_Suspendido) THEN
			CALL CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,	Par_CuentaAhoID,	Par_ClienteID,		Par_FechaOperacion,
									Par_FechaAplicacion,	Par_Monto,			Par_MonedaID,		Par_ProdCreditoID,	Par_Clasificacion,
									Par_SubClasifID,		Par_SucCliente,		Par_Descripcion,	Par_Referencia,		AltaPoliza_NO,
									Entero_Cero,			Par_Poliza,			AltaPolCre_SI,		AltaMovCre_SI,		Con_MoraVencidoSup,
									Mov_Moratorio,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
									Par_OrigenPago,			Var_SalidaNo,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
									Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Var_CreEstatus != Estatus_Suspendido) THEN
			CALL CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,	Par_CuentaAhoID,	Par_ClienteID,		Par_FechaOperacion,
									Par_FechaAplicacion,	Par_Monto,			Par_MonedaID,		Par_ProdCreditoID,	Par_Clasificacion,
									Par_SubClasifID,		Par_SucCliente,		Par_Descripcion,	Par_Referencia,		AltaPoliza_NO,
									Entero_Cero,			Par_Poliza,			AltaPolCre_SI,		AltaMovCre_SI,		Con_IntMoraVen,
									Mov_Moratorio,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
									Par_OrigenPago,			Var_SalidaNo,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
									Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN

		IF(Var_DivideEPRC = NO_DivideEPRC) THEN
			SET	Mov_CarConta    := Con_Balance;
		ELSE
			SET	Mov_CarConta    := Con_BalIntere;
		END IF;
	ELSE
		SET	Mov_CarConta    := Con_BalAdiEPRC;
	END if;

	CALL CONTACREDITOSPRO (
		Par_CreditoID,			Par_AmortiCreID,    Par_CuentaAhoID,    Par_ClienteID,		Par_FechaOperacion,
        Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,		Par_ProdCreditoID,	Par_Clasificacion,
        Par_SubClasifID,    	Par_SucCliente,		Par_Descripcion,    Par_Referencia,     AltaPoliza_NO,
		Entero_Cero,			Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,		Mov_CarConta,
        Mov_Moratorio,      	Nat_Cargo,          AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
        Par_OrigenPago,			Var_SalidaNo,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
        Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
	IF(Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


	IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN

		IF(Var_DivideEPRC = NO_DivideEPRC) THEN

			IF(Var_RegContaEPRC = EPRC_Resultados) THEN
				SET	Mov_AboConta    := Con_ResultEPRC;
			ELSE
				SET	Mov_AboConta    := Con_PtePrinci;
			END IF;
		ELSE

			IF(Var_RegContaEPRC = EPRC_Resultados) THEN
				SET	Mov_AboConta    := Con_ResIntere;
			ELSE
				SET	Mov_AboConta    := Con_PteIntere;
			END IF;

		END IF;

	ELSE


		IF(Var_RegContaEPRC = EPRC_Resultados) THEN
			SET	Mov_AboConta    := Con_ResAdiEPRC;
		ELSE
			SET	Mov_AboConta    := Con_PteAdiEPRC;
		END IF;
	END IF;
	CALL CONTACREDITOSPRO (
		Par_CreditoID,			Par_AmortiCreID,    Par_CuentaAhoID,    Par_ClienteID,		Par_FechaOperacion,
        Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,		Par_ProdCreditoID,	Par_Clasificacion,
        Par_SubClasifID,    	Par_SucCliente,		Par_Descripcion,    Par_Referencia,     AltaPoliza_NO,
		Entero_Cero,			Par_Poliza,         AltaPolCre_SI,		AltaMovCre_NO,		Mov_AboConta,
        Mov_Moratorio,      	Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
        Par_OrigenPago,			Var_SalidaNo,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
        Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
	IF(Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;
END IF;

IF (Par_IVAMonto > Decimal_Cero) THEN
	CALL  CONTACREDITOSPRO (
        Par_CreditoID,      	Par_AmortiCreID,    Par_CuentaAhoID,    Par_ClienteID,		Par_FechaOperacion,
        Par_FechaAplicacion,    Par_IVAMonto,       Par_MonedaID,		Par_ProdCreditoID,	Par_Clasificacion,
        Par_SubClasifID,    	Par_SucCliente,     Par_Descripcion,    Par_Referencia,     AltaPoliza_NO,
        Entero_Cero,			Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Con_IVAMora,
        Mov_IVAIntMora,     	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,
        Par_OrigenPago,			Var_SalidaNo,		Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
        Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
	IF(Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;
END IF;

SET Par_NumErr	:= 0;
SET Par_ErrMen	:= 'Pago de Moratorio Vencido realizado Exitosamente.';
SET Var_Control := 'creditoID';
SET Var_Consecutivo := 0;

END ManejoErrores;

END TerminaStore$$