-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODUCTOSCREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS PRODUCTOSCREDITOALT;
DELIMITER $$

CREATE PROCEDURE `PRODUCTOSCREDITOALT`(
 # -- SP PARA DAR DE ALTA PRODUCTOS DE CREDITO ---  #
  Par_ProducCreditoID       INT(11),		-- Numero de producto de credito
  Par_Descripcion           VARCHAR(100),	-- Descripcion del producto de credito
  Par_Caracteristicas       TEXT,			-- Caracteristicas del producto de credito
  Par_CobraIVAInteres       CHAR(1),		-- Indica si cobra IVA de interes
  Par_CobraIVAMora          CHAR(1),		-- Indica si cobra IVA de los moratorios

  Par_CobraFaltaPago        CHAR(1),		-- Indica si cobra comision por falta de pago
  Par_CobraMora             CHAR(1),		-- Indica si cobra moratorios
  Par_FactorMora            DECIMAL(12,2),	-- Indica el dactor moratorio
  Par_TipoPersona           CHAR(1),		-- Tipo de Persona
  Par_ManejaLinea           CHAR(1),		-- Indica si el producto maneja linea

  Par_ReqObligadosSolidarios CHAR(1),		-- Indica si se requiere obligados solidarios
  Par_PerObligadosCruzados	CHAR(1),		-- Indica si se permite Obligados Solidarios Cruzados
  Par_ReqConsultaSIC		CHAR(1),
  Par_EsRevolvente          CHAR(1),		-- Indica si el producto de credito es revolvete
  Par_EsGrupal              CHAR(1),		-- Indica si es un producto de credito grupal

  Par_RequiereGarantia      CHAR(1),		-- Indica si requiere garantia
  Par_RequiereAvales        CHAR(1),		-- Indica si requiere avales
  Par_GraciaFaltaPago       INT(11),		-- Dias gracia por falta de pago
  Par_GraciaMoratorios      INT(11),		-- Dias de gracia por moratorios
  Par_MontoMinimo           DECIMAL(12,2),	-- Monto minimo

  Par_MontoMaximo           DECIMAL(12,2),	-- Monto maximo
  Par_DiasSuspesion         INT(11),		-- Dias de suspension
  Par_EsReestructura        CHAR(1),		-- Indica si el producto de credito permite reestructuras/renovaciones

  Par_EsAutomatico          CHAR(1),		-- Indica si el producto de credito es automatico
  Par_Clasificacion         INT(11),		-- Indica su clasificacion
  Par_MargenPagIgual        INT(4),			-- Indica el margen a considerar para pagos iguales
  Par_TipComXaper           CHAR(1),		-- Tipo de comision por apertura
  Par_MonComXaper           DECIMAL(12,2),	-- Monto de la comision por apertura

  Par_AhoVoluntario         CHAR(1),		-- Ahorro voluntario
  Par_PorcAhoVol            DECIMAL(10,2),	-- Porcentaje de ahorro voluntario
  Par_Tipo                  CHAR(1),		-- Tipo
  Par_FormaComAper          CHAR(1),		-- Forma de cobro de comision por apertura
  Par_CalcInter             CHAR(1),		-- Calculo de interes

  Par_TipoContratoBC        VARCHAR(5),		-- Tipo de contrato para Buro de Credito
  Par_TipoCalInt            INT(11),		-- Tipo de calculo de interes
  Par_TipoGeneraInteres     CHAR(1),		-- Tipo de calculo de interes: (Tipo de Monto Original (Saldos Globales)): I.- Iguales  D.- Dias Transcurridos
  Par_InstitutFondID        INT(11),		-- Institucion de fondeo
  Par_MaxIntegrantes        INT(11),		-- Numero maximo de integrantes
  Par_MinIntegrantes        INT(11),		-- Numero minimo de integrantes

  Par_PerRomGrup            CHAR(1),		-- Indica si permite el rompimiento de grupo
  Par_RIniCicGrup           INT(11),		-- Rango inicial ciclo grupal
  Par_RFinCicGrup           INT(11),		-- Rango final ciclo final
  Par_RelGaraCred           DECIMAL(12,4),	-- Relacion garantia credito
  Par_PerAvaCruz            CHAR(1),		-- Permite avales cruzados

  Par_PerGarCruz            CHAR(1),		-- Permite garantias cruzadas
  Par_RegRECA               VARCHAR(100),	-- Registro RECA
  Par_FechaIns              DATE,			-- Fecha de Inscripcion
  Par_NomCom                VARCHAR(100),	-- Nombre comercial
  Par_TipoCred              VARCHAR(50),  	-- Tipo de credito

  Par_MinMujSol             INT(11),		-- Numero minimo de mujeres solteras
  Par_MaxMujSol             INT(11),		-- Numero maximo de mujeres solteras
  Par_MinMuj                INT(11),		-- Numero minimo de mujeres
  Par_MaxMuj                INT(11),		-- Numero maximo de mujeres
  Par_MinHom                INT(11),		-- Numero minimo de hombres

  Par_MaxHom                INT(11),		-- Numero maximo de hombres
  Par_TasPonGru             CHAR(1),		-- Tasa ponderada grupal
  Par_reqSeguroVida         CHAR(1),  		-- Indica si requiere seguro de vida
  Par_factorRiesgoSeg       DECIMAL(12,6),	-- Factor de riesgo del seguro
  Par_tipoPagoSeguro        CHAR(1),		-- Tipo de pago de seguro

  Par_descuentoSeguro       DECIMAL(12,2),	-- Descuento de seguro
  Par_montoPolSegVida       DECIMAL(12,2),	-- Monto de la poliza de seguro
  Par_TipCobComMorato       CHAR(1),		-- Tipo de cobro de moratorios
  Par_DiasPasoAtraso        INT(11),		-- Dias paso a atraso
  Par_ValidaCapConta        CHAR(1),		-- Valida capital contable

  Par_PorcMaxCapConta       DECIMAL(8,2),	-- Porcentaje maximo de capital contable
  Par_ProrrateoPago         CHAR(1),		-- Indica si prorratea el pago
  Par_ProyInteresPagAde     CHAR(1),		-- Indica si proyecta el interes por pagos adelantados
  Par_PermitePrepago        CHAR(1),		-- Indica si permite prepagos
  Par_ProductoNomina        CHAR(2), 		-- Indica si es un producto de nomina

  Par_ModificarPrepago      CHAR(1),		-- Indica si se modifica el prepago base
  Par_TipoPrepago           CHAR(1), 		-- Tipo de prepago
  Par_AutorizaComite        CHAR(1),		-- Autorizacion de comite
  Par_TipoContratoCCID      VARCHAR(2),		-- Tipo de contrato
  Par_CalculoRatios         CHAR(1),		-- Indica si requiere el calculo de ratios

  Par_AfectaContable        CHAR(1),		-- Indica si tiene afectacion contable
  Par_InicioAfuturo         CHAR(1),		-- Inicio del credito posterior al desembolso
  Par_DiasMaximo            INT(11),		-- Dias maximo de inicio del credito posterior al desembolso
  Par_Modalidad             CHAR(1),		-- Modalidad del seguro de vida
  Par_CantidadAvales        INT(11),		-- Cantidad de avales

  Par_IntercambiaAvales     CHAR(1),		-- Indica si requiere intercambio de avales
  Par_PermiteAutSolPros     CHAR(1),		-- Indica si permite la autorizacion de solicitud por prospecto
  Par_RequiereReferencias	CHAR(1),		-- Indica si requiere referencias
  Par_MinReferencias		INT(11),		-- Indica el numero minimo de referencias requeridas
  Par_CobraSeguroCuota		CHAR(1),		-- Cobra seguro por cuota

  Par_CobraIVASeguroCuota	CHAR(1),		-- Cobra IVA por seguro por cuotaseguro por cuota
  Par_ClaveRiesgo           CHAR(1),		-- Clave de Riesgo PLD A.- Alto , B.- Bajo
  Par_ClaveCNBV				VARCHAR(10),	-- Clave CNBV del Tipo de Producto
  Par_RequiereCheckList		CHAR(1),		-- Indica si el Producto de Credito requiere CheckList
  Par_PermiteConsolidacion	CHAR(1),		-- Indica si permite Consolidacion;

  Par_InstruDispersion		CHAR(1),		-- Indica si necesita instrucciones de dispersión.
  Par_TipoAutomatico		CHAR(1),		-- Especifica si el producto de crédito es automático sobre I:Inversion, A:Ahorro

  Par_PorcMaximo			DECIMAL(12,2),	-- Porcentaje para calcular el monto maximo al otorgar el credito
  Par_FinanciamientoRural	CHAR(1),		-- Especifica si se realizara la evaluacion del numero de habitantes.
  Par_ParticipaSpei		    CHAR(1),		-- Especifica si el producto de Credito maneja SPEI
  Par_ProductoClabe		    CHAR(3),		-- Clabe SPEI de 3 digitos para el producto de CREDITO
  Par_DiasAtrasoMin			INT(11),		-- Numero de Dias Minimo de Atraso para poder realizar el castigo Masivo

  Par_CobraAccesorios		CHAR(1),		-- Indica si cobra Accesorios
  Par_CobraComAnual			CHAR(1),		-- Indica si cobra comision anual
  Par_TipoComAnual			CHAR(1),		-- Indica el tipo de comision anual
  Par_ValorComAnual			DECIMAL(12,2),	-- Indica el valor por la comison anual
  Par_RequiereAnalisiCre    CHAR(1),		-- Indica si el credito requiere analisis
  Par_ReqConsolidacionAgro  CHAR(1),		-- Indica si Requiere Consolidacion para Creditos Agro
  Par_FechaDesembolso  		CHAR(1),		-- Indica Si requiere Modificar la Fecha de Desembolso
  Par_ValidaConyuge			CHAR(1),		-- Indica Si requiere Datos del Conyuge

  Par_Salida                CHAR(1),		-- Parametro de salida
  INOUT Par_NumErr          INT(11),  		-- Numero de error
  INOUT Par_ErrMen          VARCHAR(400),	-- Mensaje de error

  -- Parametros de Auditoria
  Par_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
  Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
  Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
  Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
  Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
  Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
  Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore :BEGIN

	-- Declaracion de variables
	DECLARE Var_AvalesCruzados    	CHAR(1);  #Almacena SI permite o NO Avales Cruzados
	DECLARE Var_CantidadAvales    	INT(11);  #Almacena la Cantidad de Avales
	DECLARE Var_IntercambiaAvales 	CHAR(1);  #Almacena SI permite o NO Inercambio de Avales

	DECLARE Var_PerGarCruz        	CHAR(1);  #Almacena SI permite o NO Garantias Cruzadas
	DECLARE Var_RelGaraCred       	INT(11);  #Almacena la Relacion Garantias Credito
	DECLARE Var_Control           	VARCHAR(100);
	DECLARE Var_NumProductos	  	INT(11);		-- Almacena los productos que tienen la misma clave SPEI
	DECLARE Var_NumPlazas		  	INT(11);		-- Almacena las plazas que tienen la misma clave SPEI
	DECLARE Var_CobraAccesoriosGen	CHAR(1);		-- Valor del Cobro de Accesorios

	-- Declaracion de constantes

	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Entero_Cero     		INT;
    DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE ProductoCred    		INT(11);
	DECLARE SiEsGrupal      		CHAR(1);
	DECLARE NoEsGrupal      		CHAR(1);
	DECLARE PrepagoSI       		CHAR(1);
	DECLARE PrepagoNO       		CHAR(1);
	DECLARE Var_NO         			CHAR(1);
	DECLARE AfectaSI        		CHAR(1);
	DECLARE AfectaNO        		CHAR(1);
	DECLARE ReqSegVida     			CHAR(1);
	DECLARE Deduccion       		CHAR(1);   		# tipo de pago Deduccion
	DECLARE Anticipado      		CHAR(1);  		# tipo de pago Anticipado/Adelantado
	DECLARE ModUnica        		CHAR(1);  		# modalidad de pago de seguro de vida unico
	DECLARE MinIntegrantes  		INT(4);   		# Numero minimo de integrantes que debe tener un grupo de credito
	DECLARE ReqObligadosSolidarios  CHAR(1);
	DECLARE PerObligadosCruzados	CHAR(1);
    DECLARE ReqConsultaSIC			CHAR(1);
    DECLARE ValorSI     			CHAR(1);  		# Almacena SI = S
	DECLARE ValorNO     			CHAR(1); 		# Almacena NO = N
	DECLARE ValorIND    			CHAR(1); 	 	# Almacena INDISTINTO = I
	DECLARE Var_Agro				CHAR(1);		# Almacena Si el producto de Credito es Agro
	DECLARE Llave_CobraAccesorios	VARCHAR(100);	# Llave para consulta el valor de Cobro de Accesorios
	DECLARE CobroPorcentaje			CHAR(1);		# Especifica Forma de Cobro Porcentaje
	DECLARE CienPorciento			DECIMAL(12,2);	# Indica Cien Por Ciento
	DECLARE TipoCalculoMontoOriginal	INT(11);	-- Tipo de Calculo de Interes por el Monto Original (Saldos Globales)
	DECLARE TipoMontoIguales			CHAR(1);	-- Tipo de Monto Original (Saldos Globales): I.- Iguales
	DECLARE TipoMontoDiasTrans			CHAR(1);	-- Tipo de Monto Original (Saldos Globales): D.- Dias Transcurridos
	DECLARE CuotasProyectadas			CHAR(1);	-- Tipo de Prepago de Pago Cuotas Completas Proyectadas

	-- Asignacion de Constantes
	SET Estatus_Activo  		:= 'A';
	SET Cadena_Vacia    		:= '';
	SET Fecha_Vacia     		:= '1900-01-01';
	SET Entero_Cero   			:= 0;
    SET Decimal_Cero			:= 0.00;
	SET SiEsGrupal      		:= 'S';
	SET NoEsGrupal      		:='N';
	SET PrepagoSI       		:='S';
	SET PrepagoNO       		:='N';
	SET Var_NO         		 	:='N';
	SET AfectaSI        		:='S';
	SET AfectaNO        		:='N';
	SET ReqSegVida      		:='S';
	SET Deduccion       		:= 'D';
	SET Anticipado      		:= 'A';
	SET ModUnica        		:= 'U';
	SET MinIntegrantes 		 	:= 2;
	SET ValorSI         		:= 'S';
	SET ValorNO         		:= 'N';
	SET ValorIND        		:= 'I';
    SET PerObligadosCruzados    := 'S';
	SET ReqObligadosSolidarios  := 'S';
    SET ReqConsultaSIC  		:= 'S';
	SET Llave_CobraAccesorios	:= 'CobraAccesorios'; -- Llave para Cobro de Accesorios
	SET CobroPorcentaje			:= 'P';		-- Especifica Forma de Cobro Porcentaje
	SET CienPorciento			:= 100.00;		-- Indica Cien por Cierto de Porcentaje
	SET TipoCalculoMontoOriginal := 2;
	SET TipoMontoIguales		:= 'I';
	SET TipoMontoDiasTrans		:= 'D';
	SET CuotasProyectadas		:= 'P';

     -- Se obtiene el valor de si se realiza o no el cobro de accesorios
	SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
	SET Var_CobraAccesoriosGen := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);

	SET Par_TipComXaper         := IFNULL(Par_TipComXaper, Cadena_Vacia);
	SET Par_MonComXaper         := IFNULL(Par_MonComXaper, Entero_Cero);
	SET Par_FormaComAper        := IFNULL(Par_FormaComAper, Cadena_Vacia);
	SET Par_reqSeguroVida       := IFNULL(Par_reqSeguroVida, Cadena_Vacia);
	SET Par_factorRiesgoSeg     := IFNULL(Par_factorRiesgoSeg, Entero_Cero);
	SET Par_tipoPagoSeguro      := IFNULL(Par_tipoPagoSeguro, Cadena_Vacia);
	SET Par_descuentoSeguro     := IFNULL(Par_descuentoSeguro, Entero_Cero);
	SET Par_montoPolSegVida     := IFNULL(Par_montoPolSegVida, Entero_Cero);
	SET Par_PermiteAutSolPros   := IFNULL(Par_PermiteAutSolPros,   Cadena_Vacia);
	SET Par_ReqObligadosSolidarios := IFNULL(Par_ReqObligadosSolidarios,ValorNO);
    SET Par_PerObligadosCruzados := IFNULL(Par_PerObligadosCruzados,Cadena_Vacia);
    SET Par_ReqConsultaSIC		 := IFNULL(Par_ReqConsultaSIC,ValorNo);
	SET Par_CobraAccesorios		 := IFNULL(Par_CobraAccesorios,ValorNo);
	SET Par_ReqConsolidacionAgro 	:= IFNULL(Par_ReqConsolidacionAgro, ValorNO);
	SET Par_FechaDesembolso			:= IFNULL(Par_FechaDesembolso, ValorNO);


	ManejoErrores: BEGIN

	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
	    BEGIN
	        SET Par_NumErr := 999;
	        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
	                 'esto le ocasiona. Ref: SP-PRODUCTOSCREDITOALT');
	        SET Var_Control := 'SQLEXCEPTION' ;
	    END;



	  IF(IFNULL(Par_ProducCreditoID, Entero_Cero)) = Entero_Cero THEN
	  SET Par_NumErr      := '1';
	    SET Par_ErrMen    := 'El Producto de Credito cero No es Valido.';
	    SET Var_Control   := 'producCreditoID';

	    LEAVE ManejoErrores;
	  END IF;

	  IF(IFNULL(Par_CalcInter, Cadena_Vacia)) = Cadena_Vacia THEN
	  SET Par_NumErr      := '2';
	    SET Par_ErrMen    := 'El Calculo de Intereses esta Vacio.';
	    SET Var_Control   := 'calcInteres';

	    LEAVE ManejoErrores;
	  END IF;

	  IF (Par_EsGrupal = SiEsGrupal) THEN
	  IF( IFNULL(Par_PerRomGrup,Cadena_Vacia) = Cadena_Vacia)THEN
	    SET Par_NumErr    := '3';
	    SET Par_ErrMen    := 'Especificar Rompimiento de Grupo.';
	    SET Var_Control   := 'perRompimGrup';

	    LEAVE ManejoErrores;
	  END IF;

	    IF( IFNULL(Par_RIniCicGrup,Entero_Cero) = Entero_Cero )THEN
	    SET Par_NumErr    := '4';
	    SET Par_ErrMen    := 'Rango de Inicio del Ciclo.';
	    SET Var_Control   := 'raIniCicloGrup';

	    LEAVE ManejoErrores;
	    END IF;

	    IF(IFNULL(Par_MaxIntegrantes,Entero_Cero) = Entero_Cero)THEN
	    SET Par_NumErr    := '5';
	    SET Par_ErrMen    := 'Especifica Maximo de Integrantes.';
	    SET Var_Control   := 'maxIntegrantes';

	    LEAVE ManejoErrores;
	    END IF;

	    IF(IFNULL(Par_MinIntegrantes,Entero_Cero) = Entero_Cero)THEN
	    SET Par_NumErr    := '6';
	    SET Par_ErrMen    := 'Especifica Minimo de Integrantes.';
	    SET Var_Control   := 'minimoIntegrantes';

	    LEAVE ManejoErrores;

	    ELSE

	    IF(Par_MinIntegrantes < MinIntegrantes) THEN
	      SET Par_NumErr    := '7';
	      SET Par_ErrMen    := CONCAT('El Minimo de Integrantes debe ser Mayor o Igual a ',MinIntegrantes,'.');
	      SET Var_Control   := 'minimoIntegrantes';

	      LEAVE ManejoErrores;
	    END IF;
	  END IF;
	  END IF;

	  IF (Par_PermitePrepago=PrepagoSI) THEN
	     IF(IFNULL(Par_TipoPrepago,Cadena_Vacia)) = Cadena_Vacia THEN
	    SET Par_NumErr    := '8';
	    SET Par_ErrMen    := 'Especifica el Tipo de Prepago.';
	    SET Var_Control   := 'tipoPrepago';

	    LEAVE ManejoErrores;
	  END IF;
	  END IF;

	  IF(IFNULL(Par_InicioAfuturo,Cadena_Vacia) = Cadena_Vacia)THEN
		  SET Par_NumErr    := '9';
		  SET Par_ErrMen    := 'Especifica Si permite Inicio del Credito Posterior al Desembolso.';
		  SET Var_Control   := 'inicioAfuturo';
		  LEAVE ManejoErrores;
	  ELSE
	  IF(Par_InicioAfuturo = AfectaSI) THEN
	        IF(IFNULL(Par_DiasMaximo,Entero_Cero) = Entero_Cero)THEN
	      SET Par_NumErr    := '10';
	      SET Par_ErrMen    := 'Especifica Los DIAS Maximo de Desembolso Anticipado.';
	      SET Var_Control   := 'diasMaximo';

	      LEAVE ManejoErrores;
	        END IF;
	  ELSE
	        SET Par_DiasMaximo = Entero_Cero;
	  END IF;
	  END IF;

	  IF(Par_reqSeguroVida = ReqSegVida)THEN
	    IF(IFNULL(Par_Modalidad,Cadena_Vacia) = Cadena_Vacia)THEN
	    SET Par_NumErr    := '11';
	    SET Par_ErrMen    := 'Especifica Modalidad.';
	    SET Var_Control   := 'modalidad';

	    LEAVE ManejoErrores;
	  END IF;

	  IF(Par_Modalidad = ModUnica)THEN
	    IF(IFNULL(Par_tipoPagoSeguro,Cadena_Vacia))= Cadena_Vacia THEN
	      SET Par_NumErr    := '12';
	      SET Par_ErrMen    := 'El Tipo de Pago del Seguro esta vacio.';
	      SET Var_Control   := 'tipoPagoSeguro';

	            LEAVE ManejoErrores;
	     END IF;

	    IF(IFNULL(Par_factorRiesgoSeg,Entero_Cero))= Entero_Cero THEN
	      SET Par_NumErr    := '13';
	      SET Par_ErrMen    := 'El Factor de Riesgo del Seguro esta vacio.';
	      SET Var_Control   := 'factorRiesgoSeg';

	            LEAVE ManejoErrores;
	        END IF;


	    IF(Par_tipoPagoSeguro = Deduccion || Par_tipoPagoSeguro = Anticipado)THEN
	      IF(IFNULL(Par_descuentoSeguro,Entero_Cero))= Entero_Cero THEN
	        SET Par_NumErr    := '14';
	        SET Par_ErrMen    := 'El Descuento del Seguro esta vacio.';
	        SET Var_Control   := 'descuentoSeguro';

	        LEAVE ManejoErrores;
	      END IF;
	    END IF;


	    IF(IFNULL(Par_montoPolSegVida,Entero_Cero))= Entero_Cero THEN
	      SET Par_NumErr    := '15';
	      SET Par_ErrMen    := 'El Monto de Poliza del Seguro esta vacio.';
	      SET Var_Control   := 'montoPolSegVida';

	      LEAVE ManejoErrores;
	        END IF;

	    END IF;
	  END IF;

	  # ------ AJUSTES PROCESO VALIDACION AVALES ------
	  IF(IFNULL(Par_RequiereAvales, Cadena_Vacia) = Cadena_Vacia)THEN
		  SET Par_NumErr    := '16';
		  SET Par_ErrMen    := 'Indique Si Requiere Avales.';
		  SET Var_Control   := 'requiereAvales';

		  LEAVE ManejoErrores;

	  #--SI REQUIERE AVALES
	  ELSEIF(Par_RequiereAvales = ValorSI || Par_RequiereAvales = ValorIND)THEN

	    #--AVALES CRUZADOS
	    IF(IFNULL(Par_PerAvaCruz, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr    := '17';
			SET Par_ErrMen    := 'Indique Si Permite Avales Cruzados.';
			SET Var_Control   := 'perAvaCruzados';

			LEAVE ManejoErrores;
	    ELSEIF(Par_PerAvaCruz = ValorSI)THEN

			IF(Par_CantidadAvales < 1)THEN
				SET Par_NumErr    := '18';
				SET Par_ErrMen    := 'Cantidad de Avales debe ser minimo 1.';
				SET Var_Control   := 'cantidadAvales';

				LEAVE ManejoErrores;
	      ELSE
	        SET Var_AvalesCruzados  := Par_PerAvaCruz;
	        SET Var_CantidadAvales  := Par_CantidadAvales;
	      END IF;
	    ELSEIF(Par_PerAvaCruz = ValorNO)THEN
	      SET Var_AvalesCruzados  := Par_PerAvaCruz;
	      SET Var_CantidadAvales  := Par_CantidadAvales;
	    END IF;

	    #--INTERCAMBIO AVALES
	    IF(IFNULL(Par_IntercambiaAvales, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr    := '19';
			SET Par_ErrMen    := 'Indique Si Permite Intercambiar Avales.';
			SET Var_Control   := 'intercambioAvalesRatioNo';

			LEAVE ManejoErrores;
	    ELSE
	    #SI NO VIENE VACIA
	      SET Var_IntercambiaAvales := Par_IntercambiaAvales;
	    END IF;

	  #-- NO REQUIERE AVALES
	  ELSEIF(Par_RequiereAvales = ValorNO)THEN
	    SET Var_AvalesCruzados    := 'N';
	    SET Var_CantidadAvales    := 0;
	    SET Var_IntercambiaAvales := 'N';

	  END IF;
	  # ------ FIN AJUSTES PROCESO VALIDACION AVALES ------

	  # ------ AJUSTES GARANTIA ------
	  IF(IFNULL(Par_RequiereGarantia, Cadena_Vacia) = Cadena_Vacia)THEN
	  SET Par_NumErr    := '20';
	  SET Par_ErrMen    := 'Indique Si Requiere Garantia.';
	  SET Var_Control   := 'requiereGarantia';

	  LEAVE ManejoErrores;
	  ELSEIF(Par_RequiereGarantia = ValorSI || Par_RequiereGarantia = ValorIND)THEN
	    #GARANTIA CRUZADA
	    IF(IFNULL(Par_PerGarCruz, Cadena_Vacia) = Cadena_Vacia)THEN
	    SET Par_NumErr    := '21';
	    SET Par_ErrMen    := 'Indique Si Permite Garantias Cruzadas.';
	    SET Var_Control   := 'perGarCruzadas';

	    LEAVE ManejoErrores;
	    #si permite GARANTIA CRUZADA
	    # no permite GARANTIA CRUZADA
	    ELSE
	      SET Var_PerGarCruz    := Par_PerGarCruz;
	    END IF;

	    ##RELACION GRANTIA CREDITO
	    IF(IFNULL(Par_RelGaraCred, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr    := '22';
			SET Par_ErrMen    := 'Indique Relacion Garantia Credito.';
			SET Var_Control   := 'relGarantCred';

			LEAVE ManejoErrores;
	    ELSEIF(Par_RelGaraCred < 0.0001)THEN
			SET Par_NumErr    := '23';
			SET Par_ErrMen    := 'Relacion Garanti­a Credito mayor 0.';
			SET Var_Control   := 'relGarantCred';

			LEAVE ManejoErrores;
	    ELSE
	      SET Var_RelGaraCred   := Par_RelGaraCred;
	    END IF;

	  ELSEIF(Par_RequiereGarantia = ValorNO)THEN
	    SET Var_PerGarCruz      := 'N';
	    SET Var_RelGaraCred     := 0;

	  END IF;

	  # ------ FIN AJUSTES GARANTIA ------

	  # ----- PERMITE AUTORIZACION DE SOLICITUD POR PROSPECTO --------
	  IF(Par_PermiteAutSolPros = Cadena_Vacia ) THEN
	  	SET Par_NumErr    := '24';
	    SET Par_ErrMen    := 'Indique si Permite Autorizacion por Prospecto.';
	    SET Var_Control   := 'sipermiteAutProspecto';
	    LEAVE ManejoErrores;
	  END IF;
	  # ----- FIN PERMITE AUTORIZACION DE SOLICITUD POR PROSPECTO --------
       # ----- VALIDACION SI REQUIERE REFERENCIAS--------
	  IF(Par_RequiereReferencias = Cadena_Vacia ) THEN
			SET Par_NumErr    := 25;
			SET Par_ErrMen    := 'Indique si Requiere Referencias.';
			SET Var_Control   := 'requiereReferencias';
			LEAVE ManejoErrores;
        ELSE
			IF(Par_RequiereReferencias=ValorSi AND IFNULL(Par_MinReferencias,Entero_Cero)=Entero_Cero) THEN
				SET Par_NumErr    := 26;
				SET Par_ErrMen    := 'Indique el Minimo de Referencias.';
				SET Var_Control   := 'minReferencias';
				LEAVE ManejoErrores;
            END IF;
	  END IF;
	  # ----- FIN VALIDACION SI REQUIERE REFERENCIAS --------
		IF(IFNULL(Par_CobraSeguroCuota,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr    := 27;
			SET Par_ErrMen    := 'Indique si Cobra Seguro por Cuota.';
			SET Var_Control   := 'cobraSeguroCuota';
			LEAVE ManejoErrores;
            ELSE
				IF(Par_CobraSeguroCuota = 'S') THEN
					IF(IFNULL(Par_CobraIVASeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
						SET Par_NumErr    := 28;
						SET Par_ErrMen    := 'Indique si Cobra IVA por Seguro por Cuota.';
						SET Var_Control   := 'cobraIVASeguroCuota';
						LEAVE ManejoErrores;
					END IF;
                END IF;
		END IF;
		# ---- SI NIVEL DE RIESGO PLD NO VIENE VACIA
		IF(Par_ClaveRiesgo = Cadena_Vacia ) THEN
			SET Par_NumErr    := 29;
			SET Par_ErrMen    := 'Indique el Nivel de Riesgo PLD.';
			SET Var_Control   := 'nivelRiesgo';
			LEAVE ManejoErrores;
	   END IF;

		# ----- VALIDACION SI REQUIERE CHECKLIST --------
		IF(Par_RequiereCheckList = Cadena_Vacia) THEN
			SET Par_NumErr    := 30;
			SET Par_ErrMen    := 'Indique si Requiere CheckList.';
			SET Var_Control   := 'requiereCheckList';
			LEAVE ManejoErrores;
		END IF;
		# ----- FIN VALIDACION SI REQUIERE CHECKLIST --------

		# ---- VALIDACIONES DE CREDITOS AUTOMATICOS
		IF(Par_EsAutomatico = ValorSI) THEN

			IF(IFNULL(Par_TipoAutomatico, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr    := 31;
				SET Par_ErrMen    := 'Especifique Tipo Automatico.';
				SET Var_Control   := 'tipoAutomatico';
				LEAVE ManejoErrores;
		   END IF;

           IF(IFNULL(Par_PorcMaximo, Decimal_Cero) = Decimal_Cero ) THEN
				SET Par_NumErr    := 32;
				SET Par_ErrMen    := 'Especifique Porcentaje Maximo.';
				SET Var_Control   := 'porcMaximo';
				LEAVE ManejoErrores;
		   END IF;

        END IF;

		IF(Par_EsGrupal = NoEsGrupal)THEN

			SET Par_MinMujSol     :=0;
			SET Par_MaxMujSol     :=0;
			SET Par_MinMuj        :=0;
			SET Par_MaxMuj        :=0;
			SET Par_MinHom        :=0;
			SET Par_MaxHom        :=0;
			SET Par_TasPonGru     :=0;

		END IF;

		IF(IFNULL(Par_FinanciamientoRural, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr    := 33;
			SET Par_ErrMen    := 'Especifique Financiamiento Rural.';
			SET Var_Control   := 'tipoAutomatico';
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(EsAgropecuario,ValorSI) INTO Var_Agro
        FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProducCreditoID;

        IF(Var_Agro <> ValorSI) THEN

			IF(IFNULL(Par_ParticipaSpei, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr    := 34;
				SET Par_ErrMen    := 'Especifique si Participa en SPEI.';
				SET Var_Control   := 'participaSpei';
				LEAVE ManejoErrores;
			END IF;

			SET Par_ProductoClabe := IFNULL(Par_ProductoClabe, Cadena_Vacia);

			IF(Par_ParticipaSpei = ValorSI) THEN

				-- se verifica que la cuenta clabe introducida no sea la misma que otro producto
				SELECT COUNT(ProducCreditoID) INTO Var_NumProductos
				FROM PRODUCTOSCREDITO
				WHERE ProductoCLABE = Par_ProductoClabe AND
					  ProducCreditoID <> Par_ProducCreditoID ;

				IF(IFNULL(Var_NumProductos, Entero_Cero) <> Entero_Cero) THEN
					SET Par_NumErr    := 35;
					SET Par_ErrMen    := 'El numero de CLABE SPEI pertenece a otro Producto de Credito.';
					SET Var_Control   := 'productoClabe';
					LEAVE ManejoErrores;
				END IF;

				-- se verifica que la cuenta clabe introducida no sea la misma que el de una plaza
				SELECT COUNT(PlazaID) INTO Var_NumPlazas
				FROM PLAZAS
				WHERE PlazaCLABE = Par_ProductoClabe;

				IF(IFNULL(Var_NumPlazas, Entero_Cero) <> Entero_Cero) THEN
					SET Par_NumErr    := 36;
					SET Par_ErrMen    := 'El numero de CLABE SPEI pertenece a una Plaza.';
					SET Var_Control   := 'productoClabe';
					LEAVE ManejoErrores;
				END IF;

			END IF;
		END IF;

        # Si el valor del parametro CobraAccesorios esta prendido, se realizan validaciones.
		IF(Var_CobraAccesoriosGen = ValorSI) THEN
			IF(IFNULL(Par_CobraAccesorios, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr    := 37;
				SET Par_ErrMen    := 'Especifique si Cobra Accesorios.';
				SET Var_Control   := 'cobraAccesorios2';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_ManejaLinea=ValorSi)THEN
			IF(IFNULL(Par_CobraComAnual,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr 	:= 38;
				SET Par_ErrMen	:= 'Especifique Si Cobra Comision Anual.';
				SET Var_Control	:= 'cobraComAnual';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_CobraComAnual=ValorSi)THEN
				IF(IFNULL(Par_TipoComAnual,Cadena_Vacia)=Cadena_Vacia)THEN
					SET Par_NumErr	:= 39;
					SET Par_ErrMen	:= 'Especifique el Tipo de comision Anual.';
					SET Var_Control	:= 'tipoComAnual';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_ValorComAnual,Decimal_Cero)=Decimal_Cero)THEN
					SET Par_NumErr	:= 40;
					SET Par_ErrMen	:= 'Especifique el Valor de la Comision Anual.';
					SET Var_Control	:= 'valorComAnual';
					LEAVE ManejoErrores;
				ELSEIF(Par_TipoComAnual=CobroPorcentaje AND Par_ValorComAnual>CienPorciento)THEN
					SET Par_NumErr	:= 41;
					SET Par_ErrMen	:= 'El Porcentaje Para la Comision Anual es Incorrecto.';
					SET Var_Control	:= 'valorComAnual';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET Par_TipoCalInt := IFNULL(Par_TipoCalInt, Entero_Cero);
		SET Par_TipoGeneraInteres := IFNULL(Par_TipoGeneraInteres, TipoMontoIguales);

		IF( Par_TipoCalInt = Entero_Cero ) THEN
			SET Par_NumErr	:= 042;
			SET Par_ErrMen	:= 'Especifique el Tipo de Calculo de Interes.';
			SET Var_Control	:= 'tipoCalInteres';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoCalInt = TipoCalculoMontoOriginal) THEN

			-- Validacion si el Tipo de Calculo es Monto Original
			IF( Par_TipoGeneraInteres = Cadena_Vacia)THEN
				SET Par_NumErr	:= 043;
				SET Par_ErrMen	:= 'Especifique el Tipo de Generacion de Interes';
				SET Var_Control	:= 'tipoGeneraInteres';
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para verificar que el tipo de Calculo sea lo parametrizado
			IF( Par_TipoGeneraInteres NOT IN (TipoMontoIguales, TipoMontoDiasTrans) )THEN
				SET Par_NumErr	:= 044;
				SET Par_ErrMen	:= 'Especifique un Tipo de Generacion de Interes valido';
				SET Var_Control	:= 'tipoGeneraInteres';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Var_Agro = ValorNO)THEN

			IF(IFNULL(Par_RequiereAnalisiCre, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr     := 045;
				SET Par_ErrMen    := 'La opcion de Requiere Analisis està vacia.';
				SET Var_Control   := 'requiereAnalisiCre';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_RequiereAnalisiCre <> ValorNO) THEN
				IF(Par_RequiereAnalisiCre <> ValorSI)THEN
				SET Par_NumErr     := 046;
				SET Par_ErrMen    := 'La opcion Requiere Analisis  de Credito es incorrecta';
				SET Var_Control   := 'requiereAnalisiCre';
				LEAVE ManejoErrores;
				END IF;

			END IF;

			IF(Par_RequiereAnalisiCre <> ValorSI) THEN
				IF(Par_RequiereAnalisiCre <> ValorNO)THEN
				SET Par_NumErr     := 046;
				SET Par_ErrMen    := 'La opcion Requiere Analisis  de Credito es incorrecta';
				SET Var_Control   := 'requiereAnalisiCre';
				LEAVE ManejoErrores;
				END IF;

			END IF;

			IF (Par_PermiteConsolidacion <> ValorSI) THEN
				IF (Par_PermiteConsolidacion <> ValorNO) THEN
					SET Par_NumErr	:= 047;
					SET Par_ErrMen	:= 'La opcion Permite Consolidacion es incorrecta';
					SET Var_Control	:= 'permiteConsolidacion';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_InstruDispersion <> ValorSI) THEN
				IF (Par_InstruDispersion <> ValorNO) THEN
					SET Par_NumErr	:= 048;
					SET Par_ErrMen	:= 'La opcion Instrucciones de dispersión es incorrecta';
					SET Var_Control	:= 'instruDispersion';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		ELSE
			SET Par_RequiereAnalisiCre := ValorNO;
			SET Par_PermiteConsolidacion := ValorNO;
			SET Par_InstruDispersion := ValorNO;
		END IF;

		IF (Par_PermitePrepago=PrepagoSI AND Par_TipoPrepago = CuotasProyectadas AND Par_TipoCalInt != TipoCalculoMontoOriginal) THEN
			SET Par_NumErr     := 049;
			SET Par_ErrMen    := 'El valor asignado para Tipo de Prepago es Incorrecto.';
			SET Var_Control   := 'tipoPrepago';
			LEAVE ManejoErrores;
		END IF;

		-- Consolidacion para Creditos Agro
		IF( Par_ReqConsolidacionAgro NOT IN (ValorSI, ValorNO)) THEN
			SET Par_NumErr	:= 049;
			SET Par_ErrMen	:= 'La Opcion Permite Consolidacion Agro es incorrecta';
			SET Var_Control	:= 'reqConsolidacionAgro';
			LEAVE ManejoErrores;
		END IF;

		-- Consolidacion para Creditos Agro Fecha Desembolso
		IF( Par_FechaDesembolso NOT IN (ValorSI, ValorNO)) THEN
			SET Par_NumErr	:= 050;
			SET Par_ErrMen	:= 'La Opcion Fecha Desembolso es incorrecta.';
			SET Var_Control	:= 'fechaDesembolso';
			LEAVE ManejoErrores;
		END IF;


		IF( Par_ReqConsolidacionAgro = ValorNO ) THEN
			SET Par_FechaDesembolso := ValorNO;
		END IF;

	  SET Par_ClaveCNBV	:= IFNULL(Par_ClaveCNBV,Cadena_Vacia);

	  SET Aud_FechaActual := NOW();
	  INSERT INTO PRODUCTOSCREDITO (
	    ProducCreditoID,        Descripcion,        	Caracteristicas,      		CobraIVAInteres,    		CobraIVAMora,
	    CobraFaltaPago,         CobraMora,          	FactorMora,           		TipoPersona,       			ManejaLinea,
	    EsRevolvente,           EsGrupal,           	RequiereGarantia,     		RequiereAvales,     		GraciaFaltaPago,
	    GraciaMoratorios,       MontoMinimo,        	MontoMaximo,          		DiasSuspesion,      		EsReestructura,
	    EsAutomatico,           ClasifRegID,        	MargenPagIgual,       		TipoComXapert,      		MontoComXapert,
	    AhoVoluntario,          PorcAhoVol,         	Tipo,                 		ForCobroComAper,    		CalcInteres,
	    TipoContratoBCID,       TipoCalInteres,			TipoGeneraInteres,			InstitutFondID,				MaxIntegrantes,
	    MinIntegrantes,			PerRompimGrup,			RaIniCicloGrup,				RaFinCicloGrup,				RelGarantCred,
	    PerAvaCruzados,			PerGarCruzadas,			RegistroRECA,				FechaInscripcion,			NombreComercial,
	    TipoCredito,			MinMujeresSol,			MaxMujeresSol,				MinMujeres,					MaxMujeres,
	    MinHombres,				MaxHombres,				TasaPonderaGru,				ReqSeguroVida,				TipoPagoSeguro,
	    FactorRiesgoSeguro,		DescuentoSeguro,		MontoPolSegVida,			TipCobComMorato,			DiasPasoAtraso,
	  	ValidaCapConta,			PorcMaxCapConta,		ProrrateoPago,				ProyInteresPagAde,			PermitePrepago,
	  	ProductoNomina,			ModificarPrepago,		TipoPrepago,				AutorizaComite,				TipoContratoCCID,
	    CalculoRatios,			Garantizado,			AfectacionContable,			InicioAfuturo,				DiasMAximo,
	    Modalidad,				CantidadAvales,			IntercambiaAvales,			PermiteAutSolPros,			RequiereReferencias,
	    ReqObligadosSolidarios, PerObligadosCruzados,	ReqConsultaSIC,				EmpresaID,					MinReferencias,
        CobraSeguroCuota,		CobraIVASeguroCuota,	ClaveRiesgo,				ClaveCNBV,					RequiereCheckList,
        PerConsolidacion,		ReqInsDispersion,		TipoAutomatico,				PorcentajeMaximo,			FinanciamientoRural,
        ParticipaSpei,			ProductoCLABE,			RequiereAnalisiCre,			DiasAtrasoMin,				CobraAccesorios,
        CobraComAnual,			TipoComAnual,			valorComAnual,				ReqConsolidacionAgro,		FechaDesembolso,
        ValidaConyuge,			Usuario,				FechaActual,				DireccionIP,				ProgramaID,
        Sucursal,				NumTransaccion)

	   VALUES (
	    Par_ProducCreditoID,		Par_Descripcion,		Par_Caracteristicas,    	Par_CobraIVAInteres,    	Par_CobraIVAMora,
	    Par_CobraFaltaPago,     	Par_CobraMora,          Par_FactorMora,         	Par_TipoPersona,        	Par_ManejaLinea,
	    Par_EsRevolvente,       	Par_EsGrupal,           Par_RequiereGarantia,   	Par_RequiereAvales,     	Par_GraciaFaltaPago,
	    Par_GraciaMoratorios,   	Par_MontoMinimo,        Par_MontoMaximo,        	Par_DiasSuspesion,     	 	Par_EsReestructura,
	    Par_EsAutomatico,       	Par_Clasificacion,      Par_MargenPagIgual,     	Par_TipComXaper,        	Par_MonComXaper,
	    Par_AhoVoluntario,      	Par_PorcAhoVol,         Par_Tipo,               	Par_FormaComAper,       	Par_CalcInter,
	    Par_TipoContratoBC,     	Par_TipoCalInt,			Par_TipoGeneraInteres,		Par_InstitutFondID,			Par_MaxIntegrantes,
	    Par_MinIntegrantes,			Par_PerRomGrup,			Par_RIniCicGrup,			Par_RFinCicGrup,			Var_RelGaraCred,
	    Var_AvalesCruzados,			Var_PerGarCruz,			Par_RegRECA,				Par_FechaIns,				Par_NomCom,
	    Par_TipoCred,				Par_MinMujSol,			Par_MaxMujSol,				Par_MinMuj,					Par_MaxMuj,
	    Par_MinHom,					Par_MaxHom,				Par_TasPonGru,				Par_reqSeguroVida,			Par_tipoPagoSeguro,
	    Par_factorRiesgoSeg,		Par_descuentoSeguro,	Par_montoPolSegVida,		Par_TipCobComMorato,		Par_DiasPasoAtraso,
	    Par_ValidaCapConta ,		Par_PorcMaxCapConta,	Par_ProrrateoPago,			Par_ProyInteresPagAde,		Par_PermitePrepago,
	    Par_ProductoNomina, 		Par_ModificarPrepago,	Par_TipoPrepago,			Par_AutorizaComite,			Par_TipoContratoCCID,
	    Par_CalculoRatios,			Var_NO,					Par_AfectaContable,			Par_InicioAfuturo,			Par_DiasMaximo,
	    Par_Modalidad,				Var_CantidadAvales,		Var_IntercambiaAvales,		Par_PermiteAutSolPros,		Par_RequiereReferencias,
	    Par_ReqObligadosSolidarios,	Par_PerObligadosCruzados, Par_ReqConsultaSIC,		Par_EmpresaID,				Par_MinReferencias,
	    Par_CobraSeguroCuota,		Par_CobraIVASeguroCuota,Par_ClaveRiesgo,			Par_ClaveCNBV,				Par_RequiereCheckList,
        Par_PermiteConsolidacion,	Par_InstruDispersion,	Par_TipoAutomatico,			Par_PorcMaximo,				Par_FinanciamientoRural,
	    Par_ParticipaSpei,			Par_ProductoClabe,		Par_RequiereAnalisiCre,		Par_DiasAtrasoMin,			Par_CobraAccesorios,
	    Par_CobraComAnual,			Par_TipoComAnual,		Par_ValorComAnual,			Par_ReqConsolidacionAgro,	Par_FechaDesembolso,
	    Par_ValidaConyuge,			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
        Aud_Sucursal,				Aud_NumTransaccion);

	  SET Par_NumErr    := '0';
	  SET Par_ErrMen    := CONCAT("Producto de Credito Agregado Exitosamente: ",CONVERT(Par_ProducCreditoID,CHAR));
	  SET Var_Control   := 'producCreditoID';

END ManejoErrores;

 IF(Par_Salida = ValorSI)THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_ProducCreditoID AS consecutivo;
 END IF;
END TerminaStore$$