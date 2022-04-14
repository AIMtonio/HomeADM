-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOINVGARALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOINVGARALT`;DELIMITER $$

CREATE PROCEDURE `CREDITOINVGARALT`(
	Par_CreditoID			BIGINT(12),
	Par_InversionID			INT(11),
    INOUT Par_PolizaID      BIGINT(20),
	Par_MontoEnGar			DECIMAL(14,2),
	Par_Salida				CHAR(1),

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN

DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Salida_SI			CHAR(1);
DECLARE Salida_NO			CHAR(1);
DECLARE Est_Vigente			CHAR(1);
DECLARE SiRequiereGL		CHAR(1);
DECLARE TipoLiberar			CHAR(1);
DECLARE TipoAsignar			CHAR(1);
DECLARE NoAplicaReinversion	CHAR(5);
DECLARE Si_Genera			CHAR(1);

DECLARE VarControl			VARCHAR(50);
DECLARE Var_InversionID		INT;
DECLARE Var_CreditoCli		INT;
DECLARE Var_InversionCli	INT;
DECLARE Var_FechaVenCre		DATE;
DECLARE Var_FechaVenInv		DATE;
DECLARE Var_MontoCredito	DECIMAL(14,2);
DECLARE Var_MontoInversion	DECIMAL(14,2);
DECLARE Var_TotalGarInv		DECIMAL(14,2);
DECLARE Var_Consecutivo		INT;
DECLARE Var_FechaSistema	DATE;
DECLARE Var_Estatus			CHAR(1);
DECLARE Var_RequiereGL		CHAR(1);
DECLARE Var_Reinvertir		CHAR(5);
DECLARE Var_GeneraConta		CHAR(1);


SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;
SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Salida_SI			:= 'S';
SET Salida_NO			:= 'N';
SET Est_Vigente			:= 'N';
SET SiRequiereGL		:= 'S';
SET NoAplicaReinversion	:= 'N';
SET TipoLiberar			:= 'L';
SET TipoAsignar			:= 'A';
SET Si_Genera			:= 'S';


SET VarControl			:= 'invGarantiaID';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := '999';
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOINVGARALT');
			SET VarControl := 'sqlException' ;
		END;

	IF(IFNULL(Par_CreditoID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr     	:= 1;
			SET Par_ErrMen      := 'El Credito esta Vacio.' ;
			SET VarControl		:= 'creditoID';
			LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_InversionID,Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr     	:= 2;
		SET Par_ErrMen      := 'La Inversion esta Vacia.' ;
		SET VarControl 		:= 'inversionID';
		LEAVE ManejoErrores;
	END IF;

	SELECT ContabilidadGL INTO Var_GeneraConta
		FROM PARAMETROSSIS;

	SELECT	CR.ClienteID,		CR.FechaVencimien,		PC.Garantizado
	  INTO	Var_CreditoCli,		Var_FechaVenCre,		Var_RequiereGL
	FROM	CREDITOS			CR,
			PRODUCTOSCREDITO	PC
	WHERE	PC.ProducCreditoID	= CR.ProductoCreditoID
	 AND	CR.CreditoID		= Par_CreditoID;

	SELECT	ClienteID,			FechaVencimiento,	Estatus,		Reinvertir,		Monto
	 INTO	Var_InversionCli,	Var_FechaVenInv,	Var_Estatus,	Var_Reinvertir,	Var_MontoInversion
	FROM	INVERSIONES
	WHERE InversionID = Par_InversionID;

	SET Var_CreditoCli		:= IFNULL(Var_CreditoCli,Entero_Cero);
	SET Var_MontoInversion	:= IFNULL(Var_MontoInversion,Decimal_Cero);
	SET Var_InversionCli	:= IFNULL(Var_InversionCli,Entero_Cero);

	IF(IFNULL(Par_InversionID,Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr     	:= 3;
		SET Par_ErrMen      := 'La Inversion no Existe.' ;
		SET VarControl 		:= 'inversionID';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_RequiereGL != SiRequiereGL)THEN
		SET Par_NumErr     	:= 4;
		SET Par_ErrMen      := 'El Producto de Credito no Requiere Garantia Liquida.' ;
		SET VarControl 		:= 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_CreditoCli,Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr     	:= 5;
		SET Par_ErrMen      := 'El Credito no Existe.' ;
		SET VarControl 		:= 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (Var_InversionCli != Var_CreditoCli) THEN
		SET Par_NumErr	:= 6;
		SET Par_ErrMen	:= 'La Inversion No pertenece al Cliente.' ;
		SET VarControl	:= 'inversionID';
		LEAVE ManejoErrores;
	END IF;

	IF (Var_Estatus != Est_Vigente) THEN
		SET Par_NumErr	:= 7;
		SET Par_ErrMen	:= 'La Inversion No esta Vigente.' ;
		SET VarControl	:= 'inversionID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Var_FechaVenCre,Fecha_Vacia) =  Fecha_Vacia) THEN
		SET Par_NumErr	:= 8;
		SET Par_ErrMen	:='La Fecha de Vencimiento del Credito Es Incorrecta.' ;
		SET VarControl	:= 'Par_CreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Var_FechaVenInv,Fecha_Vacia)=  Fecha_Vacia) THEN
		SET Par_NumErr	:= 9;
		SET Par_ErrMen	:='La Fecha de Vencimiento de la Inversion es Incorrecta.' ;
		SET VarControl 	:= 'Par_InversionID';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_Reinvertir = NoAplicaReinversion) THEN
		IF (Var_FechaVenInv<Var_FechaVenCre) THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:='La Fecha de Vencimiento de la Inversion debe ser Mayor a la Fecha de Vencimiento de Credito.' ;
			SET VarControl  := 'Par_InversionID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SELECT	IFNULL(SUM(MontoEnGar),Decimal_Cero)
	 INTO 	Var_TotalGarInv
		FROM CREDITOINVGAR
		WHERE InversionID = Par_InversionID;
	SET Var_TotalGarInv	:= IFNULL(Var_TotalGarInv,Decimal_Cero);
	SET Var_TotalGarInv	:= (Var_TotalGarInv	+ Par_MontoEnGar);

	IF(Var_TotalGarInv > Var_MontoInversion)THEN
		SET Par_NumErr	:= 11;
		SET Par_ErrMen	:= 'El Monto a Garantizar mas el Monto Garantizado, no debe ser Mayor al Monto de la Inversion.' ;
		SET VarControl  := 'montoEnGar';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoEnGar,Decimal_Cero) <= Decimal_Cero)THEN
		SET Par_NumErr	:= 11;
		SET Par_ErrMen	:= 'El Monto a Garantizar debe ser Mayor a Cero.' ;
		SET VarControl  := 'Par_InversionID';
		LEAVE ManejoErrores;
	END IF;


	SELECT MontoCredito INTO Var_MontoCredito FROM CREDITOS WHERE CreditoID = Par_CreditoID;

	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Aud_FechaActual 	:= NOW();
	SET Var_Consecutivo		:= (SELECT IFNULL(MAX(CreditoInvGarID),Entero_Cero)+1 FROM CREDITOINVGAR);



	INSERT INTO CREDITOINVGAR (
		CreditoInvGarID,	CreditoID,		InversionID,		MontoEnGar,			FechaAsignaGar,
		EmpresaID,			Usuario,		FechaActual,		DireccionIP,		ProgramaID,
		Sucursal,			NumTransaccion)
	VALUES (
		Var_Consecutivo,	Par_CreditoID,	Par_InversionID,	Par_MontoEnGar,		Var_FechaSistema,
		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

	IF Var_GeneraConta= Si_Genera THEN

	CALL INVERRECLACONTAPRO(
		Par_InversionID,	Par_MontoEnGar,		TipoAsignar,		Par_PolizaID,		Salida_NO,
		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;
	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT("Inversion Recibida en Garantia Exitosamente: ", CONVERT(Par_InversionID, CHAR));
	SET VarControl := 'creditoID';
END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            VarControl AS control,
            Par_CreditoID AS consecutivo;
END IF;

END TerminaStore$$