-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACREDITOVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACREDITOVAL`;DELIMITER $$

CREATE PROCEDURE `CANCELACREDITOVAL`(
# ===========================================================
# --------- SP PARA LA VALIDACION DEL CIERRE GENERAL---------
# ===========================================================
	Par_CreditoID		BIGINT(12),		# Numero de Credito
    Par_Salida          CHAR(1),		# Salida S:SI N:NO
	INOUT Par_NumErr	INT(11),		# Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	# Mensaje de Error

	# Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
    DECLARE Var_FechaExigible	DATE;			# Fecha Exigible
    DECLARE Var_FechaSistema    DATE;			# Fecha del Sistema
    DECLARE Var_NumMovCred      INT(11);		# Numero de Movimientos del Credito
    DECLARE Var_EstatusCred		CHAR(1);		# Estatus del Credito
    DECLARE Var_TipoCredito		CHAR(1);		# Tipo de Credito
    DECLARE Var_EjecutaCierre	CHAR(1);		# Indica si el cierre esta ejecutandose
    DECLARE Var_EjecutaCobAut	CHAR(1);		# Indica si la cobranza automatica se esta ejecutando
	DECLARE Var_Control			VARCHAR(100);	# Variable de control
    DECLARE Var_FechaDesembolso	DATE;


	-- Declaracion de Constantes
	DECLARE SalidaSI				CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12,2);

    DECLARE Est_Vigente				CHAR(1);
    DECLARE Tipo_Nuevo				CHAR(1);
    DECLARE Cons_NO					CHAR(1);
    DECLARE Cons_SI					CHAR(1);


	-- Asignacion de Constantes
	SET SalidaSI					:= 'S';		-- Salida SI
	SET Entero_Cero					:= 0;		-- Entero Cero
	SET Cadena_Vacia				:= '';		-- Caden Vacia
	SET Decimal_Cero				:= 0.0;		-- DECIMAL Cero

    SET Est_Vigente					:= 'V';		-- Estatus Vigente
    SET Tipo_Nuevo					:= 'N';		-- Tipo de Credito: Nuevo
	SET Cons_NO						:= 'N';		-- Constante NO
    SET Cons_SI						:= 'S';		-- Constante SI

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CANCELACREDITOVAL');
				SET Var_Control := 'sqlexception';
			END;

	SELECT	FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;
	SET Var_FechaExigible := (SELECT FechaExigible FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID AND AmortizacionID = 1);

	# Consulta General
	SELECT Estatus,	TipoCredito,	FechaInicio INTO Var_EstatusCred, Var_TipoCredito,	Var_FechaDesembolso
    FROM CREDITOS WHERE CreditoID = Par_CreditoID;

	# SE EVALUA QUE LA FECHA DE CANCELACION SEA MENOR A LA FECHA DEL SISTEMA
	IF(Var_FechaSistema >= Var_FechaExigible ) THEN
		SET Par_NumErr  := 1;
		SET Par_ErrMen  := 'No es posible realizar la cancelacion de credito debido a que ya se encuentra en una fecha igual
						o posterior a su primer fecha de exigibilidad.';
		LEAVE ManejoErrores;
	END IF;

	# SE EVALUA SI EL CREDIO FUE DESEMBOLSADO UN MES ANTERIOR.
	IF (MONTH(Var_FechaSistema) != MONTH(Var_FechaDesembolso))THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen := 'No es posible realizar la cancelacion de credito porque fue desembolsado en meses anteriores.';
			LEAVE ManejoErrores;
	END IF;

    -- SE VALIDA QUE EL CREDITO NO HAYA RECIBIDO PAGOS
	SELECT COUNT(Mov.CreditoID) INTO Var_NumMovCred
    FROM CREDITOSMOVS Mov
    WHERE Mov.CreditoID = Par_CreditoID
    AND Mov.Descripcion = 'PAGO DE CREDITO';

	SET Var_NumMovCred  := IFNULL(Var_NumMovCred, Entero_Cero);

	IF(Var_NumMovCred != Entero_Cero) THEN
		SET Par_NumErr	:= 3;
		SET Par_ErrMen	:= 'El Credito Presenta Movimientos de Pago.';
		LEAVE ManejoErrores;
	END IF;

   # SE EVALUA EL ESTATUS DEL CREDITO
	IF(Var_EstatusCred != Est_Vigente) THEN
		SET Par_NumErr  := 4;
		SET Par_ErrMen  := 'El Credito no esta Vigente.';
		LEAVE ManejoErrores;
	END IF;

    # sE EVALUA QUE EL CREDITO NO HAYA TENIDO TRATAMIENTO (Reestructuras, Renovaciones y Reacreditamiento)
	IF(Var_TipoCredito != Tipo_Nuevo) THEN
		SET Par_NumErr  := 5;
		SET Par_ErrMen  := 'No se puede Cancelar un Credito que ya tuvo Tratamiento.';
		LEAVE ManejoErrores;
	END IF;

    -- VALIDAMOS SI YA SE ESTA REALIZANDO EL CIERRE
	SET Var_EjecutaCierre := (SELECT ValorParametro
									FROM PARAMGENERALES
										WHERE LlaveParametro = 'EjecucionCierreDia');

	IF(Var_EjecutaCierre = Cons_SI )THEN
		SET Par_NumErr	:= 6;
		SET Par_ErrMen	:= 'No es posible ejecutar este proceso. El Cierre de día está en ejecución.';
		LEAVE ManejoErrores;
	END IF;


     -- VALIDAMOS SI YA SE ESTA EJECUTANDO LA COBRANZA AUTOMATICA
	SET Var_EjecutaCobAut := (SELECT ValorParametro
									FROM PARAMGENERALES
										WHERE LlaveParametro = 'EjecucionCobAut');

	IF(Var_EjecutaCobAut = Cons_SI )THEN
		SET Par_NumErr	:= 7;
		SET Par_ErrMen	:= 'No es posible ejecutar este proceso. La Cobranza Automatica está en ejecucion.';
		LEAVE ManejoErrores;
	END IF;


	END ManejoErrores;
		IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					'creditoID' AS control,
					Par_CreditoID AS consecutivo;
		END IF;


END TerminaStore$$