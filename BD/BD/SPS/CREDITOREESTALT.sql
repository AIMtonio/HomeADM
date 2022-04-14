-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOREESTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOREESTALT`;
DELIMITER $$


CREATE PROCEDURE `CREDITOREESTALT`(
# ==================================================================================================================
# -------- SP QUE SE EJECUTA DESDE LA PANTALLA DE REESTRUCTURA DE CREDITO PARA RENOVAR UN CREDITO ------------
# ==================================================================================================================
    Par_ClienteID       INT(11),
    Par_LinCreditoID    INT(11),
    Par_ProduCredID     INT(11),
    Par_CuentaID        BIGINT(12),
    Par_Relacionado     BIGINT(12),
    Par_SolicCredID     BIGINT(20),
    Par_MontoCredito    DECIMAL(12,2),
    Par_MonedaID        INT(11),
    Par_FechaInicio     DATE,
    Par_FechaVencim     DATE,

    Par_FactorMora      DECIMAL(12,2),
    Par_CalcInterID     INT(11),
    Par_TasaBase        INT(11),
    Par_TasaFija        DECIMAL(12,4),
    Par_SobreTasa       DECIMAL(12,4),
    Par_PisoTasa        DECIMAL(12,2),
    Par_TechoTasa       DECIMAL(12,2),
    Par_FrecuencCap     CHAR(1),
    Par_PeriodCap       INT(11),
    Par_FrecuencInt     CHAR(1),

    Par_PeriodicInt     INT(11),
    Par_TPagCapital     VARCHAR(10),
    Par_NumAmortiza     INT(11),
    Par_FecInhabil      CHAR(1),
    Par_CalIrregul      CHAR(1),
    Par_DiaPagoInt      CHAR(1),
    Par_DiaPagoCap      CHAR(1),
    Par_DiaMesInt       INT(11),
    Par_DiaMesCap       INT(11),
    Par_AjFUlVenAm      CHAR(1),

    Par_AjuFecExiVe     CHAR(1),
    Par_NumTransacSim   BIGINT(20),
    Par_TipoFondeo      CHAR(1),
    Par_MonComApe       DECIMAL(12,2),
    Par_IVAComApe       DECIMAL(12,2),
    Par_ValorCAT        DECIMAL(12,4),
    Par_Plazo           VARCHAR(20),
    Par_TipoDisper      CHAR(1),
    Par_TipoCalInt      INT(11),
    Par_DestinoCreID    INT(11),

    Par_InstitFondeoID  INT(11),
    Par_LineaFondeo     INT(11),
    Par_NumAmortInt     INT(11),
    Par_MontoCuota      DECIMAL(12,2),
	Par_ClasiDestinCred CHAR(1),
	OUT Par_CreditoID	BIGINT(12),
    Par_Salida          CHAR(1),
	INOUT Par_NumErr    INT(11),
	INOUT Par_ErrMen    VARCHAR(400),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion	BIGINT(20)
		)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_CreditoID   	BIGINT(12);
DECLARE Var_UsuarioID   	INT;
DECLARE Var_SaldoCredAnteri DECIMAL(12,2);
DECLARE Var_EstatusCredAnt  CHAR(1);
DECLARE Var_NumDiasAtraOri  INT;
DECLARE Var_EstatusCrea     CHAR(1);
DECLARE Var_SaldoExigi      DECIMAL(12,2);
DECLARE Var_NumPagoSos      INT;
DECLARE Var_PeriodCap       INT;
DECLARE Var_EsReestructura  CHAR(1);
DECLARE Var_NumeroReest 	INT;
DECLARE Var_NumReestAnt     INT;
DECLARE Var_FechaRegistro   DATE;
DECLARE Var_UsuEstatus      CHAR(1);
DECLARE Var_TipoPrepago     CHAR (1);
DECLARE Var_ForCobroSegVida	CHAR(1);
DECLARE Var_DescSeguro		DECIMAL(12,2);
DECLARE Var_MontoSegOri		DECIMAL(12,2);
DECLARE Var_Control			VARCHAR(20);
DECLARE Var_FechaCobroComision DATE;			-- Fecha de cobro de la comision por apertura


-- Declaracion de Constantes
DECLARE Entero_Cero     INT;
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE Fecha_Vacia     DATE;
DECLARE Salida_NO       CHAR(1);
DECLARE Salida_SI       CHAR(1);
DECLARE Est_Vigente     CHAR(1);
DECLARE Est_Vencido     CHAR(1);
DECLARE Est_Pagado      CHAR(1);
DECLARE No_Regulariza   CHAR(1);
DECLARE No_EsReestruc   CHAR(1);
DECLARE Usu_Activo      CHAR(1);
DECLARE Num_PagRegula   INT;
DECLARE TipoCredito		CHAR(1);
DECLARE Est_Alta		CHAR(1);


-- Asignacion de Constantes
SET Var_ForCobroSegVida	:= '';
SET Var_DescSeguro		:= 0.00;
SET Var_MontoSegOri		:= 0.00;
SET Entero_Cero     := 0;               -- Entero en Cero
SET Cadena_Vacia    := '';              -- Cadena Vacia
SET Decimal_Cero    := 0.00;            -- Decimal Cero
SET Fecha_Vacia     := '1900-01-01';    -- Decimal Cero
SET Salida_NO       := 'N';             -- El store NO arroja un Resultado de Salida
SET Salida_SI       := 'S';             -- El store SI arroja un Resultado de Salida
SET Est_Vigente     := 'V';             -- Estatus del Credito: Vigente
SET Est_Vencido     := 'B';             -- Estatus del Credito: Vencido
SET Est_Pagado      := 'P';             -- Estatus del Credito: Pagado
SET No_Regulariza   := 'N';             -- La Reestructura no ha sido Regularizada
SET No_EsReestruc   := 'N';             -- El Producto de Credito no es para Reestructuras
SET Usu_Activo      := 'A';             -- Estatus del Usuario: Activo
SET Num_PagRegula   := 3;               -- Numero de Pagos Sostenidos para Regulacion segun CNVB
SET Par_TipoFondeo	:= "P";				-- corresponde con Recursos Propios
SET TipoCredito		:= 'O';				-- Tipo de credito Renovacion
SET Est_Alta		:= 'A';				-- Estatus de alta


ManejoErrores: BEGIN

    -- Inicializacion
    SET Var_CreditoID   		:= Entero_Cero;
    SET Par_NumErr      		:= Entero_Cero;
    SET Par_ErrMen      		:= Cadena_Vacia;
    SET Var_EstatusCrea 		:= Cadena_Vacia;
    SET Aud_Usuario     		:= IFNULL(Aud_Usuario, Entero_Cero);
    SET Var_SaldoExigi  		:= Entero_Cero;
    SET Var_NumPagoSos  		:= Entero_Cero;
    SET Var_NumReestAnt 		:= Entero_Cero;
    SET Var_NumeroReest 		:= Entero_Cero;
    SET Var_SaldoCredAnteri 	:= Entero_Cero;

    SELECT FechaSistema INTO Var_FechaRegistro FROM PARAMETROSSIS;
    SET Par_FechaInicio := Var_FechaRegistro;
    SET Var_UsuarioID   := Aud_Usuario;

    IF (Aud_Usuario = Entero_Cero) THEN
        SET Par_NumErr	:= 1;
        SET Par_ErrMen	:= CONCAT('El usuario que esta Reestructurando no Existe.');
		SET Var_Control	:= 'creditoID';
        LEAVE ManejoErrores;
    END IF;

    -- Calculo de los Dias de Atraso
    SELECT  ( DATEDIFF(Var_FechaRegistro,IFNULL(MIN(FechaExigible), Var_FechaRegistro)))
            INTO Var_NumDiasAtraOri
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID = Par_Relacionado
              AND Amo.Estatus != Est_Pagado
              AND Amo.FechaExigible <= Var_FechaRegistro;

    -- Consultamos el Credito Origen a Reestructurar
    SELECT  FUNCIONTOTDEUDACRE(Cre.CreditoID),  Cre.Estatus,    Cre.PeriodicidadCap
            INTO
            Var_SaldoCredAnteri,    Var_EstatusCredAnt, Var_PeriodCap
        FROM CREDITOS Cre,
             PRODUCTOSCREDITO Pro
        WHERE Cre.CreditoID = Par_Relacionado
          AND Cre.ProductoCreditoID = Pro.ProducCreditoID;

    SELECT  EsReestructura INTO Var_EsReestructura
        FROM PRODUCTOSCREDITO Pro
        WHERE Pro.ProducCreditoID   = Par_ProduCredID;

    SET Var_EstatusCredAnt  := IFNULL(Var_EstatusCredAnt, Cadena_Vacia);
    SET Var_EsReestructura  := IFNULL(Var_EsReestructura, Cadena_Vacia);
    SET Var_SaldoCredAnteri := IFNULL(Var_SaldoCredAnteri, Entero_Cero);
    SET Var_NumDiasAtraOri := IFNULL(Var_NumDiasAtraOri, Entero_Cero);

    IF(Var_EstatusCredAnt = Cadena_Vacia) THEN
        SET Par_NumErr	:= 3;
        SET Par_ErrMen	:= 'El Credito a Reestructurar no Existe.';
		SET Var_Control	:= 'relacionado';
        LEAVE ManejoErrores;
    END IF;
    -- Validar que cubre el Saldo adeudado
    IF (Par_MontoCredito != Var_SaldoCredAnteri ) THEN
        SET Par_NumErr	:= 4;
        SET Par_ErrMen	:= 'El Monto del Credito debe ser Igual al Saldo del Credito a Reestructurar.';
		SET Var_Control	:= 'montoCredito';
        LEAVE ManejoErrores;
    END IF;
    IF (Var_SaldoCredAnteri <= Entero_Cero) THEN
        SET Par_NumErr	:= 5;
        SET Par_ErrMen	:= 'El Credito a Reestructurar no Presenta Adeudos.';
		SET Var_Control	:= 'relacionado';
        LEAVE ManejoErrores;
    END IF;
    -- Validar que el producto Permite Reestructuras
    IF (Var_EsReestructura = No_EsReestruc) THEN
        SET Par_NumErr	:= 6;
        SET Par_ErrMen	:= 'El Producto de Credito no Permite Reestructuras.';
		SET Var_Control	:= 'producCreditoID';
        LEAVE ManejoErrores;
    END IF;
    IF(Var_EstatusCredAnt != Est_Vigente AND Var_EstatusCredAnt != Est_Vencido) THEN
        SET Par_NumErr	:= 7;
        SET Par_ErrMen	:= 'El Credito a Reestructurar debe estar Vigente o Vencido.';
		SET Var_Control	:= 'relacionado';
        LEAVE ManejoErrores;
    END IF;

    -- Validar el Usuario
    SELECT  Estatus INTO Var_UsuEstatus
        FROM USUARIOS
        WHERE UsuarioID = Var_UsuarioID;

    SET Var_UsuEstatus = IFNULL(Var_UsuEstatus, Cadena_Vacia);

    IF (Var_UsuEstatus != Usu_Activo) THEN
        SET Par_NumErr	:= 8;
        SET Par_ErrMen	:= CONCAT('El usuario que Captura: ', CONVERT(Var_UsuarioID, CHAR),
                                   ', No Existe o no Esta Activo.');
		SET Var_Control	:= 'creditoID';
        LEAVE ManejoErrores;
    END IF;
   IF(IFNULL(Par_DestinoCreID, Entero_Cero) =  Entero_Cero) THEN
        SET Par_NumErr	:= 9;
        SET Par_ErrMen	:= 'El Destino de Credito esta Vacio.';
		SET Var_Control	:= 'destinoCreID';
        LEAVE ManejoErrores;
    END IF;

    SET Var_TipoPrepago := ( SELECT TipoPrepago
                                    FROM PRODUCTOSCREDITO
                                     WHERE ProducCreditoID=Par_ProduCredID);

	SET Var_FechaCobroComision := (SELECT FNSUMADIASFECHA(Var_FechaRegistro,Par_PeriodCap));
	SET Var_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, 0, Aud_EmpresaID));


    -- Alta del Credito
    CALL CREDITOSALT (
        Par_ClienteID,      	Par_LinCreditoID,   	Par_ProduCredID,    	Par_CuentaID,       	TipoCredito,
		Par_Relacionado, 		Par_SolicCredID,    	Par_MontoCredito,   	Par_MonedaID,       	Par_FechaInicio,
		Par_FechaVencim, 		Par_FactorMora,     	Par_CalcInterID,    	Par_TasaBase,       	Par_TasaFija,
		Par_SobreTasa, 			Par_PisoTasa,       	Par_TechoTasa,      	Par_FrecuencCap,    	Par_PeriodCap,
		Par_FrecuencInt, 		Par_PeriodicInt,    	Par_TPagCapital,    	Par_NumAmortiza,    	Par_FecInhabil,
		Par_CalIrregul, 		Par_DiaPagoInt,     	Par_DiaPagoCap,     	Par_DiaMesInt,     		Par_DiaMesCap,
		Par_AjFUlVenAm, 		Par_AjuFecExiVe,    	Par_NumTransacSim,  	Par_TipoFondeo,     	Par_MonComApe,
		Par_IVAComApe, 			Par_ValorCAT,       	Par_Plazo,          	Par_TipoDisper,     	Cadena_Vacia,
		Par_TipoCalInt,   		Par_DestinoCreID,   	Par_InstitFondeoID, 	Par_LineaFondeo,    	Par_NumAmortInt,
		Par_MontoCuota, 		Decimal_Cero,       	Decimal_Cero,			Par_ClasiDestinCred,	Var_TipoPrepago,
		Par_FechaInicio,     	Var_ForCobroSegVida, 	Var_DescSeguro,			Var_MontoSegOri,		Cadena_Vacia,
        Cadena_Vacia,			Cadena_Vacia, 			Var_FechaCobroComision,	Cadena_Vacia,			Salida_NO,
        Var_CreditoID,     		Par_NumErr,       		Par_ErrMen,				Aud_EmpresaID,     		Aud_Usuario,
        Aud_FechaActual,     	Aud_DireccionIP,       	Aud_ProgramaID,    		Aud_Sucursal,       	Aud_NumTransaccion );

	SET Par_CreditoID := Var_CreditoID;

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

    SET Par_ErrMen  := CONCAT('Reestructura de Credito Agregada Exitosamente: ', CONVERT(Var_CreditoID, CHAR), '.');
	SET Var_Control	:= 'creditoID';


END ManejoErrores;  -- End del Handler de Errores


IF(Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
          Par_ErrMen 	AS ErrMen,
          Var_Control 	AS control,
          Var_CreditoID AS consecutivo;
END IF;

END TerminaStore$$