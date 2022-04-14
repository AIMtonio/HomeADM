-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONALT`;
DELIMITER $$


CREATE PROCEDURE `INVERSIONALT`(
-- ------------------------------------------------------------
--    SP PARA DAR DE ALTA LAS INVERSIONES PRINCIPAL
-- ------------------------------------------------------------
  Par_CuentaAhoID       	BIGINT(12),   		-- numero de cuenta del cliente
  Par_ClienteID       		INT(11),   			 -- numero del cliente
  Par_TipoInversionID     	INT(11),   		 	-- tipo de inversion a dar de alta
  Par_FechaInicio       	DATE,     			-- fecha de inicio
  Par_FechaVencimiento    	DATE,     			-- fecha de vencimiento de la inversion

  Par_Monto         		DECIMAL(12,2),  	-- monto de la inversion
  Par_Plazo         		INT(11),    		-- numero de dias de la  inversion
  Par_Tasa          		DECIMAL(8,4), 		-- tasa de la inversion
  Par_TasaISR         		DECIMAL(8,4), 		-- tasa del isr si se cobra
  Par_TasaNeta        		DECIMAL(8,4), 		-- tasa neta a cobrar

  Par_InteresGenerado		DECIMAL(12,2),  	-- interes que generara
  Par_InteresRecibir		DECIMAL(12,2),  	-- interes que recibira la final
  Par_InteresRetener		DECIMAL(12,2),  	-- interes irs si se le cobra
  Par_Reinvertir			VARCHAR(5),   		-- parametro para saber si se reinvierte
  Par_Usuario				INT(11),    		-- usuario que ejecuta la operacion

  Par_TipoAlta        		INT(11),    		-- tipo de alta
  Par_ReinversionId     	INT(11),   			-- numero de reinversion
  Par_MonedaID        		INT(11),			-- tipo de moneda de la inversion
  Par_Etiqueta        		VARCHAR(100), 		-- decripcion si lleva
  Par_Beneficiario          CHAR(1),    		-- Tipo de Beneficiario(Cuenta Socio o Propio de inversion),

	INOUT Par_Poliza      	BIGINT(20),   		-- poliza
  Par_Salida          		CHAR(1),    		-- Indica Salida
    INOUT Par_NumErr      	INT(11),    		-- INOUT Num_Err
  INOUT Par_ErrMen      	VARCHAR(400), 		-- INOUT ErrMen

    /* Parametros de Auditoria */
  Par_EmpresaID       		INT(11),
  Par_FechaActual       	DATETIME,
  Par_DireccionIP       	VARCHAR(15),
  Par_ProgramaID        	VARCHAR(50),
  Par_Sucursal        		INT(11),
  Par_NumeroTransaccion   	BIGINT(20)
      	)

TerminaStore: BEGIN

    /* DECLARACION DE VARIABLES */
	DECLARE Var_InversionID     	INT(11);      		-- variable para la inversion
	DECLARE Var_InversionMonto    	INT(11);     	 	-- variable para el monto de la inversion
	DECLARE VarStatusInversion   	CHAR(5);    	 	-- variable del estatus de la inversion
	DECLARE VarFechaVencimiento   	DATE;       		-- variable fecah de vencimiento de inversion
	DECLARE Var_MontoOriginal   	DECIMAL(12, 2);   	-- variable del monto oroginal de inversion

	DECLARE Var_InteresRecibir   	DECIMAL(12, 2);   	-- variable de los interes que geneo la inversion
	DECLARE Var_InteresGenerado   	DECIMAL(12, 2);   	-- variable de los intereses que geneo la inversion
	DECLARE InteresGeneradoMN   	DECIMAL(12, 2);  	-- interes generado en moneda nacional
	DECLARE Var_InteresRetener    	DECIMAL(12, 2);   	-- interes a retener
	DECLARE Var_PolizaID      		BIGINT(20);    	 	 -- numero de poliza

	DECLARE Var_Cue_Saldo     		DECIMAL(12, 2);   	-- saldo del cliente
	DECLARE Var_CueMoneda     		INT(11);      		-- moneda de la inversion
	DECLARE Var_CueEstatus      	CHAR(1);      		-- estatus del cliente
	DECLARE Var_CueClienteID    	BIGINT(20);     	-- cliente id
	DECLARE Var_MonTipoInv      	INT(11);      		-- variable tipo de inversion

	DECLARE Var_TasaISR       		DECIMAL(8, 4);    	-- tasa ISR que se cobra
	DECLARE Var_PagaISR       		CHAR(1);      		-- si paga isr
	DECLARE Var_DiasInversion   	DECIMAL(12,4);    	-- dias de la inversion
	DECLARE Var_MovIntere     		VARCHAR(4);     		-- movimiento contabel
	DECLARE Var_Provision     		DECIMAL(12, 2);   	-- saldo

	DECLARE Var_MonedaBase      	INT(11);      		-- moneda de la inversion a calcular
	DECLARE Var_TipCamCom     		DECIMAL(14,6);    	-- tipo de moneda de la inversion
	DECLARE Var_TipCamVen     		DECIMAL(8,4);   	-- no se usa
	DECLARE Var_Instrumento     	VARCHAR(20);    	-- id de la inversion
	DECLARE Var_CuentaStr     		VARCHAR(20);    	-- cuenta de la inversion

	DECLARE Var_IntGenOriginal    	DECIMAL(12, 2);   	-- interes generado de la inversion
	DECLARE Var_IntRetMN      		DECIMAL(12, 2);   	-- interes en moneda nacional
	DECLARE Cue_PagIntere       	CHAR(50);     		-- si se paga interes
	DECLARE Var_FechaSis      		DATE;       		-- fecha del sistema
	DECLARE Var_TotDispon     		DECIMAL(12, 2);  	-- valor del saldo disponible

	DECLARE Var_Estatus       		CHAR(1);      		-- estatus de la inversion
	DECLARE Cal_GATReal       		DECIMAL(12,2);    	-- valor del GAT generado
	DECLARE Var_SaldoProvision      DECIMAL(12,2);  	-- valor del saldo provison
	DECLARE Var_GatInfo       		DECIMAL(12,2);    	-- valor del Gat PARA INFORMACION
	DECLARE Var_ISR_pSocio      	CHAR(1);      		-- si se calcula por socio el ISR

	DECLARE Var_ISRReal       		DECIMAL(12,2);   	-- variable para ISR acumulado por dia
	DECLARE Var_MovPagInv     		VARCHAR(4);    		-- variable de movimientos contables
	DECLARE Var_MovIntExe     		VARCHAR(4);    		-- variable de movimientos contables
	DECLARE Var_MovIntGra     		VARCHAR(4);     		-- variable de movimientos contables
	DECLARE Var_MovRetenc     		VARCHAR(4);    		-- variable de movimientos contables

	DECLARE Var_Reinversion     	VARCHAR(4);    		-- variable para saber si se reinvierte
	DECLARE Var_ConInvCapi      	INT(11);     	 	-- variable de conceptos contables
	DECLARE Var_ConInvISR     		INT(11);      		-- variable de conceptos contables
	DECLARE Var_ConInvProv      	INT(11);      		-- variable de conceptos contables
	DECLARE Var_ConConInv     		INT(11);      		-- variable de conceptos contables

	DECLARE Var_ConConReinv     	INT(11);      		-- variable de conceptos contables
	DECLARE Var_ConAhoCapi      	INT(11);      		-- variable de conceptos contables
	DECLARE Var_DescriReinv     	VARCHAR(50);   		-- variable de la descripcion de la reinversion
	DECLARE Var_Referencia      	VARCHAR(50);    	-- variable de referencia de inversion
	DECLARE Var_NoImpresa     		CHAR(1);      		-- si esta impreso el pagare

	DECLARE Var_NumErr        		INT(11);
	DECLARE Var_ErrMen        		VARCHAR(400);
	DECLARE Var_InverFecIni     	DATE;       		-- variable fecha inicial de la inversion
	DECLARE Var_FechaISR      		DATE;      		 	-- variable fecha de inicio cobro isr por socio
	DECLARE Var_PlazoOriginal       INT(11);
	DECLARE Var_Control       		VARCHAR(50);
	DECLARE Var_EsMenorEdad     	CHAR(1);      		-- variable para obtener el valor si el cliente es menor de edad
	DECLARE Var_EstatusCli      	CHAR(1);      		-- Estatus del cliente
	DECLARE Var_InversionRenovada 	INT(11);      		-- variable para obtener si existe una reinversion duplicada
	DECLARE Var_TipoInstrumento   	INT;
	DECLARE Var_ValorUMA      		DECIMAL(12,4);
	DECLARE Var_TipoPersona     	CHAR(1);
	DECLARE Var_Tasa        		DECIMAL(12,2);    	-- Tasa de la inversion

	DECLARE Var_EstatusTipoInver	CHAR(2);			-- Estatus del Tipo Inversion
	DECLARE Var_Descripcion			VARCHAR(45);		-- Descripcion Tipo Inversion


  /* DECLARACION DE CONSTANTES */

    DECLARE Entero_Cero       	INT(11);      		-- etero cero
    DECLARE Entero_Uno        	INT(11);     		-- entero uno
    DECLARE Entero_Dos        	INT(11);      		-- entero dos
    DECLARE Entero_Tres       	INT(11);			-- entero tres
    DECLARE Entero_Cuatro     	INT(11);          	-- entero cuatro

    DECLARE Entero_Cinco      	INT(11);			-- entero cinco
    DECLARE Fecha_Vacia       	DATE;       		-- fecha vacia
    DECLARE Factor_Porcen     	DECIMAL(12,2);    	-- factor de porcentaje
    DECLARE Cadena_Vacia      	CHAR(1);      		-- cadena vacia
    DECLARE Decimal_Cero      	DECIMAL(12,2);    	-- DECIMAL cero

    DECLARE Alta_Inversion      INT(11);      		-- alta de inversion
    DECLARE Alta_ReInversion    INT(11);      		-- alta de reinversion
    DECLARE Pol_Automatica      CHAR(1);      		-- poliza automatica
    DECLARE AltPoliza_NO      	CHAR(1);			-- alta de poliza NO
    DECLARE Salida_NO       	CHAR(1);      		-- salida NO

    DECLARE StaAlta         	CHAR(1);      		-- alta sta
    DECLARE StaInvVigente     	CHAR(1);      		-- inversion vigente sta
    DECLARE StaInvPagada      	CHAR(1);      		-- inversion pagada sta
    DECLARE SI_PagaISR        	CHAR(1);      		-- SI paga isr
    DECLARE Nat_Cargo      	 	CHAR(1);      		-- cargo Nat

    DECLARE Nat_Abono       	CHAR(1);      		-- abono Nat
    DECLARE Ope_Interna       	CHAR(1);      		-- operacion interna
    DECLARE Tip_Venta       	CHAR(1);      		-- tipo de venta
    DECLARE Tip_Compra        	CHAR(1);      		-- tipo de compra
    DECLARE Tipo_Provision      CHAR(4);      		-- tipo de provision

    DECLARE Cue_PagIntExe       CHAR(50);     		-- pago interes excento
    DECLARE Cue_PagIntGra       CHAR(50);     		-- pago inversion interes gravado
    DECLARE Cue_RetInver        CHAR(50);     		-- retencion isr inversion
    DECLARE Mov_AhorroSI      	CHAR(1);      		-- movimiento ahorro SI
    DECLARE Mov_AhorroNO      	CHAR(1);      		-- movimiento ahorro NO

    DECLARE Var_SalMinDF      	DECIMAL(12,2);  	-- Salario minimo segun el df*/
    DECLARE Var_SalMinAn      	DECIMAL(12,2);  	-- Salario minimo anualizado segun el df*/
    DECLARE Cal_GAT         	DECIMAL(12,2);  	-- cal_gat
    DECLARE Bene_CtaSocio     	CHAR(1);    		-- Beneficiario de la cuenta socio --

    DECLARE Usuario         	CHAR(2);    		-- usuario
    DECLARE Bene_Inversion      CHAR(1);    		-- beneficiario de inversion
    DECLARE Inactivo        	CHAR(1);    		-- inactivo
    DECLARE MenorEdad       	CHAR(1);    		-- menor de edad
	DECLARE Estatus_Inactivo    CHAR(1); 			-- Estatus Inactivo

    DECLARE Var_FuncionHuella   	CHAR(1);    	-- funcion de la huella
    DECLARE Var_ReqHuellaProductos  CHAR(1);    	-- huella de productos
    DECLARE Huella_SI       		CHAR(1);    	-- huella SI
    DECLARE Var_CreditoAvalado    	BIGINT(12);   	-- credito avalado
    DECLARE SI_Isr_Socio            CHAR(1);    	-- Isr del socio SI

    DECLARE TipoPersonaHue      	CHAR(1);   		-- Tipo de huella de persona
	DECLARE ISRpSocio       		VARCHAR(10);  	-- ISR del socio
    DECLARE No_constante      		VARCHAR(10);  	-- constante NO
	DECLARE Salida_SI       		CHAR(1);
    DECLARE Var_SI          		CHAR(1);
	DECLARE Par_TipoRegisPantalla 	CHAR(1);
	DECLARE Est_Aplicado      		CHAR(1);
	DECLARE ValorUMA        		VARCHAR(15);
    DECLARE Per_Moral         		CHAR(1);
    DECLARE InstInversion     		INT(11);
    DECLARE Var_InvPagoPeriodico    CHAR(1);        -- variable que indica si las Inversiones seran de Pago Periodico

  /* ASIGNACION DE CONSTANTES */

    SET Entero_Cero         := 0;     	-- constante valor cero para settear
	SET Entero_Uno          := 1;     	-- constante valor uno para settear
    SET Entero_Dos          := 2;    	 -- constante valor dos para settear
    SET Entero_Tres         := 3;    	 -- constante valor tres para settear
    SET Entero_Cuatro       := 4;     	-- constante valor cuatro para settear

    SET Entero_Cinco        := 5;     	-- constante valor cinco para settear
    SET Cadena_Vacia        := '';      -- constante valor vacio para settear
    SET Decimal_Cero        := 0;     	-- constante valor cero con DECIMAL para settear
    SET Fecha_Vacia         := '1900-01-01';-- constante fecha  para settear
    SET Factor_Porcen       := 100.00;    -- constante valor 100  para operaciones

    SET Alta_Inversion		:= 1;     	-- constante para comparar si seda de alta una inversion
    SET Alta_ReInversion	:= 3;     	-- constante para saber si se da de alta una reinversion
    SET AltPoliza_NO        := 'N';     -- valor para comparar si no se dara de alta una poliza
    SET Salida_NO         	:= 'N';     -- constante para saber si tendra una salida
    SET Pol_Automatica      := 'A';     -- constante para saber si sera una poliza automatica

    SET StaAlta           	:= 'A';     -- si esta dada de alta la inversion
    SET StaInvVigente       := 'N';     -- constante para saber si la inversion esta vigente
    SET StaInvPagada        := 'P';     -- constante para saber si la inversion esta pagada
    SET SI_PagaISR          := 'S';     -- constante para comparar si se para ISR
    SET Nat_Cargo         	:= 'C';     -- constante para saber si es un movimiento de cargo

    SET Nat_Abono         	:= 'A';     -- constante para saber si es un movimiento de abono
    SET Var_NoImpresa       := 'N';     -- constate para saber si fue impreso
    SET Ope_Interna         := 'I';     -- concepto
    SET Tip_Venta         	:= 'V';     -- concepto
    SET Tip_Compra          := 'C';     -- concepto

    SET Var_MovPagInv       := '61';    -- concepto de inversion de la tabla TIPOSMOVSAHO
    SET Var_MovIntGra       := '62';    -- concepto de inversion de la tabla TIPOSMOVSAHO
    SET Var_MovIntExe       := '63';    -- concepto de inversion de la tabla TIPOSMOVSAHO
    SET Var_MovRetenc       := '64';    -- concepto de inversion de la tabla TIPOSMOVSAHO
    SET Var_Reinversion		:= '65';    -- concepto de inversion de la tabla TIPOSMOVSAHO

    SET Var_ConInvCapi      := 1;     -- concepto de inversion de la tabla CONCEPTOSINVER
    SET Var_ConInvISR       := 4;     -- concepto de inversion de la tabla CONCEPTOSINVER
    SET Var_ConInvProv      := 5;     -- concepto de inversion de la tabla CONCEPTOSINVER
    SET Var_ConAhoCapi      := 1;     -- concepto de cuentasaho
    SET Var_ConConInv       := 10;    -- concepto de cuentasaho

    SET Var_ConConReinv     := 11;      -- concepto de cuentasaho
    SET Tipo_Provision      := '100';   -- concepto
    SET Mov_AhorroSI        := 'S';     -- constantepara saber si es un movimiento de cuenta de ahorro
    SET Mov_AhorroNO        := 'N';     -- constantepara saber si es un movimiento de cuenta de ahorro
    SET Cue_PagIntExe       := 'Pago Inversion. Interes Exento'; -- concepto de cuentas

    SET Cue_PagIntGra       := 'Pago Inversion. Interes Gravado'; -- concepto de cuentas
    SET Cue_RetInver        := 'Retencion ISR Inversion';     -- concepto de cuentas
    SET Var_DescriReinv     := 'Reinversion Individual';      -- constante de descripcion de operacion
    SET Var_Referencia      := 'Rendimiento Inversion';       -- constante de descripcion de operacion
    SET Cal_GAT           	:= 0.00;    -- valor inicial de GAT

    SET Bene_CtaSocio       := 'S';     -- Beneficiario de la cuenta socio
    SET SI_Isr_Socio        := 'S';     -- si se paga ISR por socio
    SET Var_InversionID     := 0;     	-- iniciamos el id de inversion a 0
    SET VarStatusInversion	:= '';      -- iniciamos el estatus de inversion a vacio
    SET Var_MontoOriginal   := 0.0;     -- iniciamos el moto original de inversion a 0

    SET Var_InteresRecibir  := 0.0;     -- iniciamos el interes a recibir de inversion a 0
    SET Usuario           	:= '';      -- iniciamos el numero de usuario a 0
    SET Bene_Inversion      := 'I';     -- Beneficiario propio de la inversion

    SET Par_FechaActual		:= NOW(); 	-- optenemos la fecha actual
    SET Inactivo          	:= 'I';   	-- contante para saber si es un cliente inactivo
    SET MenorEdad         	:= "S";   	-- contante para saber si es un cliente menor de edad
    SET Huella_SI         	:= "S";   	-- contante para saber si es un cliente usa huella
    SET TipoPersonaHue		:= "C";   	-- constante del tipo de persona con huella

    SET ISRpSocio         	:= 'ISR_pSocio';	-- constante para isr por socio de PARAMGENERALES
    SET No_constante        := 'N';   			-- constante NO
    SET Salida_SI         	:= 'S';   			-- Salida: SI
    SET Var_SI            	:= 'S';   			-- Valor: SI

    SET Par_TipoRegisPantalla   := 'P';   		-- Proceso en pantalla
    SET Var_TipoInstrumento     := 13;    		-- Tipo de Instrumento Inversiones
	SET Est_Aplicado        	:= 'A';  		-- Estatus Aplicado
	SET ValorUMA				:= 'ValorUMABase'; 	-- valor a buscar de la uma
    SET Per_Moral         		:= 'M';
	SET InstInversion      		:=  13;      		-- Instrumento tipo inversion
    SET Estatus_Inactivo		:= 'I';

  ManejoErrores:BEGIN

  DECLARE EXIT HANDLER FOR SQLEXCEPTION

        BEGIN
      SET Par_NumErr = 999;
      SET Par_ErrMen = CONCAT(  'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                    'esto le ocasiona. Ref: SP-INVERSIONALT');
      SET Var_Control = 'SQLEXCEPTION' ;
    END;

        IF Par_ReinversionId <> Entero_Cero THEN
      IF  EXISTS ( SELECT InversionRenovada FROM INVERSIONES WHERE  InversionRenovada = Par_ReinversionId ) THEN
          SET Par_NumErr  := 019;
          SET Par_ErrMen  := CONCAT('Ocurrio un error, Intente otra vez.');
          SET Var_Control := 'inversionID';
          LEAVE ManejoErrores;
      END IF;
    END IF;


     -- SE OBTIENEN VALORES QUE SE OCUPARAN DE CLIENTES
    SELECT  EsMenorEdad,    Estatus,      TipoPersona
    INTO  Var_EsMenorEdad,  Var_EstatusCli,   Var_TipoPersona
      FROM  CLIENTES
      WHERE ClienteID = Par_ClienteID;

    SET Var_CreditoAvalado := (SELECT COUNT(CreditoID) FROM CREDITOINVGAR WHERE InversionID = Par_ReinversionId);

    IF(IFNULL(Var_EsMenorEdad, Cadena_Vacia) = Var_SI) THEN
      SET Par_NumErr  := 021;
      SET Par_ErrMen  := 'El Cliente es Menor de Edad' ;
      SET Var_Control := 'clienteID';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr  := 020;
      SET Par_ErrMen  := 'El Numero de Cliente esta Vacio' ;
      SET Var_Control := 'clienteID';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Var_EstatusCli, Cadena_Vacia) = Inactivo) THEN
      SET Par_NumErr  := 001;
      SET Par_ErrMen  := 'El Cliente se encuentra Inactivo' ;
      SET Var_Control := 'clienteID';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_CuentaAhoID, Entero_Cero) = Entero_Cero ) THEN
      SET Par_NumErr  := 001;
      SET Par_ErrMen  := 'El Numero Cuenta esta Vacio' ;
      SET Var_Control := 'cuentaAhoID';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Beneficiario,Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr  := 040;
      SET Par_ErrMen  := 'El Beneficiario a Considerar esta Vacio' ;
      SET Var_Control := 'beneficiario';
      LEAVE ManejoErrores;
    END IF;


    SELECT ValorParametro
      INTO Var_ISR_pSocio
        FROM PARAMGENERALES
          WHERE LlaveParametro=ISRpSocio;
    SET Var_ISR_pSocio  := IFNULL(Var_ISR_pSocio , No_constante);
    CALL SALDOSAHORROCON(Var_CueClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);

     IF(IFNULL(Var_CueEstatus, Cadena_Vacia) != StaAlta ) THEN
      SET Par_NumErr  := 002;
      SET Par_ErrMen  := 'La Cuenta no Existe o no Esta Activa' ;
      SET Var_Control := 'cuentaAhoID';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Var_CueClienteID, Entero_Cero) != Par_ClienteID) THEN
      SET Par_NumErr  := 003;
      SET Par_ErrMen  := 'La Cuenta no Pertenece al Cliente' ;
      SET Var_Control := 'cuentaAhoID';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Var_CueMoneda, Entero_Cero) != Par_MonedaID) THEN
      SET Par_NumErr  := 004;
      SET Par_ErrMen  := 'La Moneda no Corresponde con la Cuenta' ;
      SET Var_Control := 'cuentaAhoID';
      LEAVE ManejoErrores;
    END IF;

    IF(Par_TipoAlta = Alta_Inversion) THEN
      IF(IFNULL(Var_Cue_Saldo, Entero_Cero)) < Par_Monto THEN
        SET Par_NumErr  := 005;
        SET Par_ErrMen  := 'Saldo Insuficiente en la Cuenta del Cliente' ;
        SET Var_Control := 'cuentaAhoID';
        LEAVE ManejoErrores;
      END IF;
    END IF;


    SELECT  MonedaId, 		Estatus,				Descripcion
    INTO Var_MonTipoInv,	Var_EstatusTipoInver,	Var_Descripcion
      FROM  CATINVERSION
        WHERE TipoInversionID  = Par_TipoInversionID;

    IF(IFNULL( Var_MonTipoInv, Entero_Cero) = Entero_Cero) THEN
      SET Par_NumErr  := 006;
      SET Par_ErrMen  := 'El Tipo de Inversion no Existe' ;
      SET Var_Control := 'tipoInversionID';
      LEAVE ManejoErrores;
    END IF;

    IF(Var_MonTipoInv != Var_CueMoneda) THEN
      SET Par_NumErr  := 007;
      SET Par_ErrMen  := 'La Moneda de la Inversion no Corresponde con la Cuenta' ;
      SET Var_Control := 'tipoInversionID';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaInicio, Fecha_Vacia)) = Fecha_Vacia THEN
      SET Par_NumErr  := 008;
      SET Par_ErrMen  := 'La Fecha de Inicio esta Vacia' ;
      SET Var_Control := 'fechaInicio';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL( Par_FechaVencimiento, Fecha_Vacia)) = Fecha_Vacia THEN
      SET Par_NumErr  := 009;
      SET Par_ErrMen  := 'La Fecha de Vencimiento esta Vacia' ;
      SET Var_Control := 'fechaVencimiento';
      LEAVE ManejoErrores;
    END IF;

    SET Par_Plazo := DATEDIFF(Par_FechaVencimiento, Par_FechaInicio);

    IF(IFNULL(Par_Plazo, Entero_Cero)) <= Entero_Cero THEN
      SET Par_NumErr  := 010;
      SET Par_ErrMen  := 'Plazo en Dias Incorrecto' ;
      SET Var_Control := 'plazoOriginal';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Monto , Decimal_Cero) = Decimal_Cero) THEN
      SET Par_NumErr  := 011;
      SET Par_ErrMen  := 'El Monto de Inversion esta Vacio' ;
      SET Var_Control := 'monto';
      LEAVE ManejoErrores;
    END IF;

     SELECT FuncionHuella,    ReqHuellaProductos,   DiasInversion,    MonedaBaseID, FechaSistema,
        SalMinDF
      INTO Var_FuncionHuella, Var_ReqHuellaProductos, Var_DiasInversion,  Var_MonedaBase, Var_FechaSis,
        Var_SalMinDF
    FROM PARAMETROSSIS;

    IF (Var_FuncionHuella = Huella_SI AND Var_ReqHuellaProductos=Huella_SI) THEN
      IF NOT EXISTS(SELECT * FROM HUELLADIGITAL Hue WHERE Hue.TipoPersona=TipoPersonaHue AND Hue.PersonaID=Par_ClienteID) THEN
        SET Par_NumErr  := 012;
        SET Par_ErrMen  := 'El Cliente no tiene Huella Registrada' ;
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
      END IF;
    END IF;



    /* Se consulta para saber si el cliente paga o no ISR
        y se obtiene el valor de TasaISR*/
    SELECT  Suc.TasaISR,  PagaISR
      INTO  Var_TasaISR,  Var_PagaISR
        FROM  CLIENTES Cli,
            SUCURSALES Suc
          WHERE   Cli.ClienteID = Par_ClienteID
            AND   Suc.SucursalID = Cli.SucursalOrigen;

    IF(IFNULL(Var_PagaISR, Cadena_Vacia) = Cadena_Vacia )THEN
      SET Par_NumErr  := 012;
      SET Par_ErrMen  := 'Error al Consultar si el Cliente Paga ISR' ;
      SET Var_Control := 'clienteID';
      LEAVE ManejoErrores;
    END IF;


    SET Var_DiasInversion := IFNULL(Var_DiasInversion , Entero_Cero);
    SET Var_SalMinDF    := IFNULL(Var_SalMinDF , Decimal_Cero);
    SET Var_TasaISR     := IFNULL(Var_TasaISR , Decimal_Cero);
    SET Par_Tasa      := ROUND(FUNCIONTASA(Par_TipoInversionID, Par_Plazo , Par_Monto),Entero_Cuatro);

    IF(Par_Tasa<Entero_Cero) THEN
      SET Par_Tasa  := Entero_Cero;
    END IF;

    IF(IFNULL(Par_Tasa , Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr  := 013;
      SET Par_ErrMen  := 'No Existe una Tasa para el Plazo y Monto Especificados' ;
      SET Var_Control := 'tasaNeta';
      LEAVE ManejoErrores;
    END IF;

    IF(Par_TipoAlta = Alta_Inversion) THEN
      IF(Var_EstatusTipoInver = Estatus_Inactivo) THEN
        SET Par_NumErr	:=	014;
        SET Par_ErrMen	:=	CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
        SET Var_Control	:=	'tipoInversionID';
        LEAVE ManejoErrores;
      END IF;
    END IF;

    IF(Par_TipoAlta = Alta_ReInversion) THEN
      IF(Var_EstatusTipoInver = Estatus_Inactivo) THEN
        SET Par_NumErr  :=  015;
        SET Par_ErrMen  :=  CONCAT('No se puede reinvertir debido a que el Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
        SET Var_Control :=  'tipoInversionID';
        LEAVE ManejoErrores;
      END IF;
    END IF;

        SELECT ValorParametro
      INTO Var_ValorUMA
      FROM PARAMGENERALES
    WHERE LlaveParametro=ValorUMA;


    SET Par_TasaNeta := ROUND(Par_Tasa - Par_TasaISR, Entero_Cuatro);

    SET Par_InteresGenerado := ROUND((Par_Monto * Par_Plazo * Par_Tasa) / (Factor_Porcen * Var_DiasInversion), Entero_Dos);

    SET Var_SalMinAn := Var_SalMinDF * Entero_Cinco * Var_ValorUMA; /* Salario minimo General Anualizado*/

    /* SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
        * entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
        * si no es CERO */

    /* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
    /* Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna. */
    IF (Var_PagaISR = SI_PagaISR) THEN
      IF( Par_Monto > Var_SalMinAn OR Var_TipoPersona = Per_Moral)THEN
        IF(Var_TipoPersona = Per_Moral)THEN
          SET Par_InteresRetener := ROUND((Par_Monto * Par_Plazo * Par_TasaISR) / (Factor_Porcen * Var_DiasInversion), Entero_Dos);
        ELSE
          SET Par_InteresRetener := ROUND(((Par_Monto-Var_SalMinAn) * Par_Plazo * Par_TasaISR) / (Factor_Porcen * Var_DiasInversion), Entero_Dos);
                END IF;

      ELSE
        SET Par_InteresRetener := Decimal_Cero;
      END IF;
    ELSE
      SET Par_InteresRetener := Decimal_Cero;
    END IF;

    SET Par_InteresRecibir := ROUND(Par_InteresGenerado - Par_InteresRetener, Entero_Dos);

     IF(IFNULL( Par_InteresGenerado, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr  := 014;
      SET Par_ErrMen  := 'El Interes Generado esta Vacio' ;
      SET Var_Control := 'interesGenerado';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_InteresRecibir ,Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr  := 015;
      SET Par_ErrMen  := 'El Interes a Recibir esta Vacio' ;
      SET Var_Control := 'interesRecibir';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Usuario, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr  := 016;
      SET Par_ErrMen  := 'El Usuario No esta Logeado' ;
      SET Var_Control := 'inversionID';
      LEAVE ManejoErrores;
    END IF;

    IF(Var_FechaSis != Par_FechaInicio)THEN
      SET Par_NumErr  := 017;
      SET Par_ErrMen  := 'La Fecha de Inicio es Incorrecta' ;
      SET Var_Control := 'inversionID';
      LEAVE ManejoErrores;
    END IF;

     IF (IFNULL(Var_CreditoAvalado, Entero_Cero) != Entero_Cero)THEN
      SET Par_NumErr  := 018;
      SET Par_ErrMen  := 'No se puede Reinvertir la Inversion porque esta Comprometida con un Credito que No esta Liquidado' ;
      SET Var_Control := 'inversionID';
      LEAVE ManejoErrores;
    END IF;



    IF(Par_TipoAlta = Alta_Inversion) THEN


      SET Cal_GAT := FUNCIONCALCTAGATINV(Par_FechaVencimiento,Par_FechaInicio,Par_Tasa);

      -- Calculo del GAT REAL tomando como parametro el GAT Nominal
      SET Cal_GATReal := FUNCIONCALCGATREAL(Cal_GAT,(SELECT InflacionProy AS ValorGatHis
        FROM INFLACIONACTUAL
          WHERE FechaActualizacion =
                    (SELECT MAX(FechaActualizacion)
                      FROM INFLACIONACTUAL)));

      SET Var_GatInfo := (SELECT IFNULL(TAS.GatInformativo,Entero_Cero) FROM TASASINVERSION TAS
                  INNER JOIN DIASINVERSION  DIA ON DIA.TipoInversionID = TAS.TipoInversionID AND TAS.DiaInversionID =DIA.DiaInversionID
                  INNER JOIN MONTOINVERSION MON ON  MON.TipoInversionID =TAS.TipoInversionID AND TAS.MontoInversionID = MON.MontoInversionID
                    WHERE TAS.TipoInversionID = Par_TipoInversionID
                      AND (Par_Plazo >= DIA.PlazoInferior AND Par_Plazo <= DIA.PlazoSuperior)
                      AND (Par_Monto >= MON.PlazoInferior AND Par_Monto <= MON.PlazoSuperior)
                      LIMIT 1);

      SET Var_InversionID := (SELECT IFNULL(MAX(InversionID), Entero_Cero) + Entero_Uno FROM INVERSIONES);

            IF  EXISTS ( SELECT InversionID FROM INVERSIONES WHERE  InversionID = Var_InversionID ) THEN
        SELECT SLEEP(1000);
                SET Var_InversionID := (SELECT IFNULL(MAX(InversionID), Entero_Cero) + Entero_Uno FROM INVERSIONES);
        /*
                SET Par_NumErr  := 019;
        SET Par_ErrMen  := CONCAT('No se pudo concretar la operacion. Intente nuevamente.');
        SET Var_Control := 'grabar';
        LEAVE ManejoErrores;*/
      END IF;

      INSERT INTO INVERSIONES(
		InversionID,			CuentaAhoID,			ClienteID,			TipoInversionID,		FechaInicio,
		FechaVencimiento,		Monto,					Plazo,				Tasa,					TasaISR,
		TasaNeta,				InteresGenerado,		InteresRecibir,		InteresRetener,			Estatus,
		UsuarioID,				Reinvertir,				EstatusImpresion,	InversionRenovada,		MonedaID,
		Etiqueta,				SaldoProvision,			ValorGat,			Beneficiario,			ValorGatReal,
		FechaVenAnt,			GatInformativo,			PlazoOriginal,		SucursalOrigen,			EmpresaID,
		Usuario,				FechaActual,			DireccionIP,		ProgramaID,				Sucursal,
		NumTransaccion)
      VALUES(
		Var_InversionID,		Par_CuentaAhoID,		Par_ClienteID,		Par_TipoInversionID,	Par_FechaInicio,
		Par_FechaVencimiento,	Par_Monto,				Par_Plazo,			Par_Tasa,				Par_TasaISR,
		Par_TasaNeta,			Par_InteresGenerado,	Par_InteresRecibir,	Par_InteresRetener,		StaAlta,
		Par_Usuario,			Par_Reinvertir,			Var_NoImpresa,		Entero_Cero,			Par_MonedaID,
		Par_Etiqueta,			Entero_Cero,			Cal_GAT,			Par_Beneficiario,		Cal_GATReal,
		Fecha_Vacia,			Var_GatInfo,			Par_Plazo,			Par_Sucursal,			Par_EmpresaID,
		Par_Usuario,			Par_FechaActual,		Par_DireccionIP,	Par_ProgramaID,			Par_Sucursal,
		Par_NumeroTransaccion);

    END IF;

    --  ALTA REINVERSION.
    IF(Par_TipoAlta = Alta_ReInversion)THEN
      SELECT
        FechaISR
          INTO
            Var_FechaISR
              FROM PARAMETROSSIS;


      SELECT
          Estatus,      FechaVencimiento,   Monto,        InteresGenerado,    FechaInicio,
          InteresRecibir,   InteresRetener,       SaldoProvision,   ISRReal
        INTO
           VarStatusInversion,  VarFechaVencimiento,  Var_MontoOriginal,  Var_InteresGenerado,Var_InverFecIni,
           Var_InteresRecibir,  Var_InteresRetener,   Var_Provision,    Var_ISRReal
        FROM INVERSIONES
          WHERE InversionID = Par_ReinversionId;

      IF(IFNULL(VarStatusInversion, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 014;
        SET Par_ErrMen  := 'La Inversion a Renovar no Existe' ;
        SET Var_Control := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      IF(VarStatusInversion != StaInvVigente )THEN
        SET Par_NumErr  := 015;
        SET Par_ErrMen  := 'La Inversion a Renovar no esta Vigente' ;
        SET Var_Control := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

    -- ============================== ISR POR CLIENTE ======================================================

        CALL CALCULOISRINSTPRO(
          Var_FechaSis,   Par_ClienteID,    Par_TipoRegisPantalla,  Salida_NO,      Par_NumErr,
          Par_ErrMen,     Par_EmpresaID,    Par_Usuario,      Par_FechaActual,  Par_DireccionIP,
          Par_ProgramaID,   Par_Sucursal,   Par_NumeroTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;

    -- ==============================FIN ISR POR CLIENTE======================================================

      IF (Var_ISR_pSocio=SI_Isr_Socio) THEN
        CALL SOCIOSISRPRO(
          Par_FechaInicio,    Salida_NO,      Entero_Uno,     Par_ClienteID,    Par_ReinversionId,
          Var_NumErr,       Var_ErrMen,     Par_EmpresaID,    Par_Usuario,      Par_FechaActual,
          Par_DireccionIP,      Par_ProgramaID,   Par_Sucursal,     Par_NumeroTransaccion);
      END IF;

      SELECT
        ISRReal
        INTO
           Var_ISRReal
        FROM INVERSIONES
          WHERE InversionID = Par_ReinversionId;

      SET Var_InteresRecibir  := IFNULL(Var_InteresRecibir, Entero_Cero);
      SET Var_InteresGenerado := IFNULL(Var_InteresGenerado, Entero_Cero);
      SET Var_InteresRetener  := IFNULL(Var_InteresRetener, Entero_Cero);
      SET Var_Cue_Saldo   := IFNULL(Var_Cue_Saldo, Entero_Cero);
      SET Var_Provision := IFNULL(Var_Provision, Entero_Cero);
      SET Var_ISRReal   := IFNULL(Var_ISRReal, Entero_Cero);
      SET Var_FechaISR  := IFNULL(Var_FechaISR, Par_FechaInicio);
      IF (Var_ISR_pSocio=SI_Isr_Socio AND Var_InverFecIni>=Var_FechaISR) THEN
        SET Var_InteresRetener  :=  FNTOTALISRCTE(Par_ClienteID,Var_TipoInstrumento,Par_ReinversionId);
        SET Var_InteresRecibir  :=  Var_InteresGenerado-Var_ISRReal;
        SET Par_Monto     :=  Var_MontoOriginal + Var_InteresGenerado - Var_InteresRetener;
      END IF;

      SET Var_TotDispon := Var_Cue_Saldo + Var_MontoOriginal + Var_InteresGenerado - Var_InteresRetener;
      SET Var_TotDispon := ROUND(Var_TotDispon, Entero_Dos);

      IF(Var_TotDispon< Par_Monto) THEN
        SET Par_NumErr  := 016;
        SET Par_ErrMen  := 'Saldo Insuficiente en la Cuenta del Cliente' ;
        SET Var_Control := 'monto';
        LEAVE ManejoErrores;
      END IF;

      CALL CONTAINVERSIONPRO(
        Par_ReinversionId,      Par_EmpresaID,    Par_FechaInicio,  Var_MontoOriginal,  Var_MovPagInv,
        Var_ConConReinv,    Var_ConInvCapi,     Var_ConAhoCapi,   Nat_Abono,      AltPoliza_NO,
        Mov_AhorroSI,     Par_Poliza,     Par_CuentaAhoID,  Par_ClienteID,    Par_MonedaID,
        Par_Usuario,      Par_FechaActual,  Par_DireccionIP,  Par_ProgramaID,   Par_Sucursal,
        Par_NumeroTransaccion );

      IF (Var_InteresRetener = Entero_Cero) THEN
        SET Var_MovIntere   := Var_MovIntExe;
        SET Cue_PagIntere := Cue_PagIntExe;
      ELSE
        SET Var_MovIntere   := Var_MovIntGra;
        SET Cue_PagIntere := Cue_PagIntGra;
      END IF;

      SET Var_IntGenOriginal := Var_InteresGenerado;

      IF (Var_InteresGenerado > Entero_Cero) THEN
        CALL CONTAINVERSIONPRO(
          Par_ReinversionId,    Par_EmpresaID,    Par_FechaInicio,  Var_InteresGenerado,    Cadena_Vacia,
          Var_ConConReinv,    Var_ConInvProv,   Entero_Cero,    Nat_Cargo,          AltPoliza_NO,
          Mov_AhorroNO,     Par_Poliza,     Par_CuentaAhoID,  Par_ClienteID,        Par_MonedaID,
          Par_Usuario,      Par_FechaActual,  Par_DireccionIP,  Par_ProgramaID,       Par_Sucursal,
          Par_NumeroTransaccion);

        CALL INVERSIONESMOVALT(
          Par_ReinversionId,    Par_NumeroTransaccion,  Par_FechaInicio,    Tipo_Provision,   Var_InteresGenerado,
          Nat_Abono,        Var_DescriReinv,    Par_MonedaID,     Par_Poliza,     Par_EmpresaID,
          Par_Usuario,      Par_FechaActual,    Par_DireccionIP,    Par_ProgramaID,   Par_Sucursal,
          Par_NumeroTransaccion);
      END IF;

      SET Var_Instrumento := CONVERT(Par_ReinversionId, CHAR);

      CALL CUENTASAHOMOVALT(
        Par_CuentaAhoID,    Par_NumeroTransaccion,    Par_FechaInicio,    Nat_Abono,    Var_InteresGenerado,
        Cue_PagIntere,      Var_Instrumento,      Var_MovIntere,      Par_EmpresaID,  Par_Usuario,
        Par_FechaActual,    Par_DireccionIP,      Par_ProgramaID,     Par_Sucursal, Par_NumeroTransaccion);

      SET Var_CuentaStr := CONVERT(Par_CuentaAhoID, CHAR);


      CALL POLIZAAHORROPRO(
        Par_Poliza,     Par_EmpresaID,    Par_FechaInicio,  Par_ClienteID,      Var_ConAhoCapi,
        Par_CuentaAhoID,  Par_MonedaID,   Entero_Cero,    Var_IntGenOriginal,   Cue_PagIntere,
        Var_CuentaStr,    Par_Usuario,    Par_FechaActual,  Par_DireccionIP,    Par_ProgramaID,
        Par_Sucursal,   Par_NumeroTransaccion);

      SET Var_Tasa  :=(SELECT Tasa FROM INVERSIONES WHERE InversionID = Par_ReinversionId);
      SET Var_Tasa  :=IFNULL(Var_Tasa,Decimal_Cero);

      -- Registro de informacion para el Calculo del Interes Real para Inversiones
      CALL CALCULOINTERESREALALT (
         Par_ClienteID,     Par_FechaInicio,    InstInversion,    Par_ReinversionId,  Var_MontoOriginal,
         Var_InteresGenerado, Var_InteresRetener,   Var_Tasa,     Var_InverFecIni,  VarFechaVencimiento,
         Par_EmpresaID,     Par_Usuario,      Par_FechaActual,    Par_DireccionIP,  Par_ProgramaID,
         Par_Sucursal,      Par_NumeroTransaccion);

      IF (Var_InteresRetener > Entero_Cero) THEN

        CALL CUENTASAHOMOVALT(
          Par_CuentaAhoID,  Par_NumeroTransaccion,    Par_FechaInicio,    Nat_Cargo,        Var_InteresRetener,
          Cue_RetInver,   Var_Instrumento,      Var_MovRetenc,      Par_EmpresaID,      Par_Usuario,
          Par_FechaActual,  Par_DireccionIP,      Par_ProgramaID,     Par_Sucursal,     Par_NumeroTransaccion);

        CALL POLIZAAHORROPRO(
          Par_Poliza,     Par_EmpresaID,      Par_FechaInicio,    Par_ClienteID,      Var_ConAhoCapi,
          Par_CuentaAhoID,  Par_MonedaID,   Var_InteresRetener,   Entero_Cero,      Cue_RetInver,
          Var_CuentaStr,      Par_Usuario,    Par_FechaActual,    Par_DireccionIP,    Par_ProgramaID,
          Par_Sucursal,   Par_NumeroTransaccion);

        IF (Var_MonedaBase != Par_MonedaID) THEN

          SELECT  TipCamComInt INTO Var_TipCamCom
            FROM MONEDAS
              WHERE MonedaId = Par_MonedaID;

          SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, Entero_Dos);

          CALL COMVENDIVISAALT(
            Par_MonedaID,   Par_NumeroTransaccion,    Par_FechaInicio,    Var_InteresRetener,   Var_TipCamCom,
            Ope_Interna,    Tip_Compra,         Var_Instrumento,    Var_Referencia,     Var_DescriReinv,
            Par_Poliza,     Par_EmpresaID,        Par_Usuario,      Par_FechaActual,    Par_DireccionIP,
            Par_ProgramaID,   Par_Sucursal,       Par_NumeroTransaccion);
        ELSE
          SET Var_IntRetMN := Var_InteresRetener;
        END IF;


        CALL CONTAINVERSIONPRO(
          Par_ReinversionId,    Par_EmpresaID,    Par_FechaInicio,  Var_IntRetMN,   Cadena_Vacia,
          Var_ConConReinv,    Var_ConInvISR,    Entero_Cero,    Nat_Abono,      AltPoliza_NO,
          Mov_AhorroNO,     Par_Poliza,     Par_CuentaAhoID,  Par_ClienteID,    Var_MonedaBase,
          Par_Usuario,      Par_FechaActual,  Par_DireccionIP,  Par_ProgramaID,   Par_Sucursal,
          Par_NumeroTransaccion);

      END IF;


      UPDATE INVERSIONES SET
        Estatus      = StaInvPagada,
        EmpresaID      = Par_EmpresaID,
        Usuario      = Par_Usuario,
        FechaActual    = Par_FechaActual,
        DireccionIP    = Par_DireccionIP,
        ProgramaID     = Par_ProgramaID,
        Sucursal     = Par_Sucursal,
        NumTransaccion   = Par_NumeroTransaccion
        WHERE InversionID = Par_ReinversionId;

    -- ============================== ACTUALIZA EL COBROISR ======================================================

    UPDATE COBROISR isr SET
      Estatus = Est_Aplicado
    WHERE ClienteID     = Par_ClienteID
      AND ProductoID    = Par_ReinversionId
      AND InstrumentoID = Var_TipoInstrumento;

    -- ==============================          FIN           ======================================================


      SET Var_InversionID := (SELECT IFNULL(MAX(InversionID), Entero_Cero) + Entero_Uno FROM INVERSIONES);

            IF  EXISTS ( SELECT InversionID FROM INVERSIONES WHERE  InversionID = Var_InversionID ) THEN
          SELECT SLEEP(1000);
                    SET Var_InversionID := (SELECT IFNULL(MAX(InversionID), Entero_Cero) + Entero_Uno FROM INVERSIONES);
                    /*
                    SET Par_NumErr  := 019;
          SET Par_ErrMen  := CONCAT('No se pudo concretar la operacion. Intente nuevamente.');
          SET Var_Control := 'inversionID';
          LEAVE ManejoErrores;*/
      END IF;

      SET Cal_GAT := FUNCIONCALCTAGATINV(Par_FechaVencimiento,Par_FechaInicio,Par_Tasa);

      SET Var_GatInfo := (SELECT IFNULL(TAS.GatInformativo,Entero_Cero) FROM TASASINVERSION TAS
                  INNER JOIN DIASINVERSION  DIA ON DIA.TipoInversionID = TAS.TipoInversionID AND TAS.DiaInversionID =DIA.DiaInversionID
                  INNER JOIN MONTOINVERSION MON ON  MON.TipoInversionID =TAS.TipoInversionID AND TAS.MontoInversionID = MON.MontoInversionID
                    WHERE TAS.TipoInversionID = Par_TipoInversionID
                      AND (Par_Plazo >= DIA.PlazoInferior AND Par_Plazo <= DIA.PlazoSuperior)
                      AND (Par_Monto >= MON.PlazoInferior AND Par_Monto <= MON.PlazoSuperior)
                      LIMIT 1);
      IF (Par_Monto=(Var_MontoOriginal+Par_InteresRecibir)) THEN
        SET Par_Monto := Par_Monto- Var_InteresRetener;
      END IF;

      SET Var_PlazoOriginal := (SELECT PlazoOriginal FROM INVERSIONES
      WHERE InversionID = Par_ReinversionID);


      INSERT INTO INVERSIONES (
		InversionID,			CuentaAhoID,			ClienteID,			TipoInversionID,		FechaInicio,
		FechaVencimiento,		Monto,					Plazo,				Tasa,					TasaISR,
		TasaNeta,				InteresGenerado,		InteresRecibir,		InteresRetener,			Estatus,
		UsuarioID,				Reinvertir,				EstatusImpresion,	InversionRenovada,		MonedaID,
		Etiqueta,				SaldoProvision,			ValorGat,			Beneficiario,			FechaVenAnt,
		GatInformativo,			PlazoOriginal,			SucursalOrigen,		EmpresaID,				Usuario,
		FechaActual,			DireccionIP,			ProgramaID,			Sucursal,				NumTransaccion)
      VALUES (
		Var_InversionID,		Par_CuentaAhoID,		Par_ClienteID,		Par_TipoInversionID,	Par_FechaInicio,
		Par_FechaVencimiento,	Par_Monto,				Par_Plazo,			Par_Tasa,				Var_TasaISR,
		Par_TasaNeta,			Par_InteresGenerado,	Par_InteresRecibir,	Par_InteresRetener,		StaInvVigente,
		Par_Usuario,			Par_Reinvertir,			Var_NoImpresa,		Par_ReinversionId,		Par_MonedaID,
		Par_Etiqueta,			Entero_Cero,			Cal_GAT,			Par_Beneficiario,		Fecha_Vacia,
		Var_GatInfo,			Par_Plazo,				Par_Sucursal,		Par_EmpresaID,			Par_Usuario,
		Par_FechaActual,		Par_DireccionIP,		Par_ProgramaID,		Par_Sucursal,			Par_NumeroTransaccion);
            SET Var_InvPagoPeriodico:= (SELECT InvPagoPeriodico FROM PARAMETROSSIS WHERE EmpresaID = Entero_Uno);
      SET Var_InvPagoPeriodico := IFNULL(Var_InvPagoPeriodico, No_constante);

      IF (Var_InvPagoPeriodico = Var_Si) THEN
        CALL INVPERIODICAALT (
          Var_InversionID,        Salida_NO,           Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
          Par_Usuario,        Par_FechaActual,  Par_DireccionIP,        Par_ProgramaID,     Par_Sucursal,
          Par_NumeroTransaccion
          );

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
      END IF;

      CALL CONTAINVERSIONPRO(
        Var_InversionID,  Par_EmpresaID,    Par_FechaInicio,  Par_Monto,    Var_Reinversion,
        Var_ConConReinv,  Var_ConInvCapi,   Var_ConAhoCapi,   Nat_Cargo,    AltPoliza_NO,
        Mov_AhorroSI,   Par_Poliza,     Par_CuentaAhoID,  Par_ClienteID,  Par_MonedaID,
        Par_Usuario,    Par_FechaActual,  Par_DireccionIP,  Par_ProgramaID, Par_Sucursal,
        Par_NumeroTransaccion);

      END IF;

            IF(Par_Beneficiario = Bene_CtaSocio) THEN
        CALL BENEFICIARIOSINVERALT(
          Entero_Cero,  Var_InversionID,  Par_ClienteID,  Cadena_Vacia,     Cadena_Vacia,
          Cadena_Vacia, Cadena_Vacia,     Cadena_Vacia,   Cadena_Vacia,     Fecha_Vacia,
          Entero_Cero,    Entero_cero,      Cadena_Vacia,   Cadena_Vacia,     Cadena_Vacia,
          Cadena_Vacia,   Entero_Cero,      Cadena_Vacia,   Entero_Cero,      Cadena_Vacia,
          Fecha_Vacia,    Fecha_Vacia ,     Cadena_Vacia,   Cadena_Vacia,     Cadena_Vacia,
          Cadena_Vacia,   Entero_Cero,      Decimal_Cero, Par_Beneficiario, Salida_NO,
          Par_NumErr,     Par_ErrMen,     Par_EmpresaID,  Par_Usuario,    Par_FechaActual,
          Par_DireccionIP,Par_ProgramaID,   Par_Sucursal,   Par_NumeroTransaccion);

      END IF;

      IF(Par_TipoAlta = Alta_Inversion) THEN
        IF (Par_Beneficiario = Bene_Inversion)THEN
          SET Par_NumErr  := Entero_Cero;
          SET Par_ErrMen  := CONCAT("Inversion Agregada Exitosamente: ", CONVERT(Var_InversionID, CHAR), "<br>", "No Olvide Capturar los Beneficiarios de la Inversion");
          SET Var_Control := 'inversionID';
        ELSE
          SET Par_NumErr  := Entero_Cero;
          SET Par_ErrMen  := CONCAT("Inversion Agregada Exitosamente: ", CONVERT(Var_InversionID, CHAR) );
          SET Var_Control := 'inversionID';
        END IF;
      END IF;

      IF(Par_TipoAlta = Alta_ReInversion)THEN
        IF (Par_Beneficiario = Bene_Inversion)THEN
          SET Par_NumErr  := Entero_Cero;
          SET Par_ErrMen  := CONCAT("Inversion Reinvertida Exitosamente: ", CONVERT(Var_InversionID, CHAR), "<br>",
                              "No Olvide Capturar los Beneficiarios de la Inversion");
          SET Var_Control := 'inversionID';
        ELSE
          SET Par_NumErr  := Entero_Cero;
          SET Par_ErrMen  := CONCAT("Inversion Reinvertida Exitosamente: ", CONVERT(Var_InversionID, CHAR) );
          SET Var_Control := 'inversionID';
        END IF;
      END IF;



  END ManejoErrores;

    IF(Par_Salida = Salida_SI)THEN
    SELECT  Par_NumErr    AS NumErr,
        Par_ErrMen    AS ErrMen,
        Var_Control   AS control,
        Var_InversionID AS consecutivo;

  END IF;

END TerminaStore$$