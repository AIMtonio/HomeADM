-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANSOLICITUDCREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANSOLICITUDCREDITOALT`;
DELIMITER $$
CREATE PROCEDURE `BANSOLICITUDCREDITOALT`(
	-- SP que realiza el alta de una solicitud de credito.

	Par_ClienteID       	INT(11),			-- Indica el ID del cliente.
	Par_ProduCredID     	INT(11),			-- Indica el ID del producto de credito.
	Par_FechaReg        	DATE,				-- Indica la fecha de registro del credito.
	Par_Promotor        	INT(11),			-- Indica el promotor.
	Par_DestinoCre      	INT(11),			-- Indica el destino del credito.
	Par_Proyecto        	VARCHAR(500),		-- Parametro de proyecto
	Par_SucursalID      	INT(11),			-- Parametro que indica el ID de la sucursal.
	Par_MontoSolic      	DECIMAL(12,2),		-- Parametro que indica el monto solicitado.

	Par_PlazoID         	INT(11),			-- Indica el ID del plazo.
	Par_FactorMora      	DECIMAL(8,4),		-- Indica el factor moratorio
	Par_ComApertura     	DECIMAL(12,4),		-- Indica el monto de la comision por apertura.
	Par_IVAComAper      	DECIMAL(12,4),		-- Indica el monto del iva por comision de apertura.
	Par_TasaFija        	DECIMAL(12,4),		-- Indica la tasa fija.
	Par_Frecuencia      	CHAR(1),			-- Parametro que indica la frecuencia.
	Par_Periodicidad    	INT(11),			-- Indica la periodicidad
	Par_NumAmorti       	INT(11),			-- Indica el numero de amortizacion.
	Par_NumTransacSim   	BIGINT(20),			-- Indica el numero de transaccion del simulador.
	Par_CAT             	DECIMAL(12,4),		-- Indica la comision anual total.

	Par_CuentaClabe       	CHAR(18),			-- Indica la clabe de la cuenta.
	Par_MontoCuota        	DECIMAL(12,2),		-- Indica el monto de la cuota.
	Par_FechaVencim       	DATE,				-- Indica la fecha de vencimiento.
	Par_FechaInicio       	DATE,				-- Indica la fecha de inicio.
	Par_ClasiDestinCred   	CHAR(1),			-- Depende del destino de credito puede ser C, O, H
	Par_InstitNominaID 	  	INT(11),			-- Indica el ID de la institucion de nomina.
	Par_NegocioAfiliadoID 	INT(11),			-- Indica el ID del negocio afiliado.
	Par_NumCreditos       	INT(11), 			-- Indica los numeros de creditos.

	Par_Salida          	CHAR(1),
	INOUT Par_NumErr    	INT(11),
	INOUT Par_ErrMen    	VARCHAR(400),

	Aud_EmpresaID		    INT(11),			-- Parametro de Auditoria
    Aud_UsuarioID		    INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP		    VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		    VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumeroTransaccion	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables para el alta de Solicitud de Credito en Banca en Linea
	DECLARE Var_Control		   			CHAR(15);
	DECLARE Var_SolicitudCre   			BIGINT(20);
	DECLARE Var_TipoConsultaSIC			CHAR(2);		-- TIPO CONSULTA SIC
	DECLARE Var_FechaSistema			DATE;			-- Fecha del sistema
	DECLARE Var_FechaCobroComision 		DATE;		-- Fecha de cobro de la comision por apertura

	-- Declaracion de constantes para el alta de Solicitud de Credito en Banca en Linea
	DECLARE Var_TipoMoneda      		INT;     -- TIPO DE MONEDA
	DECLARE Var_TipoDisper      		CHAR(1); -- TIPO DE DISPERSION
	DECLARE Var_TipoCalInt      		INT(11); -- TIPO CALCULO INTERES
	DECLARE Var_CalcInteres	    		INT;	 -- CALCULO INTERES
	DECLARE Var_TipoPagCap      		CHAR(1); -- TIPO PAGO CAPITAL
	DECLARE Var_DiaPagCap       		CHAR(1); -- DIA DE PAGO
	DECLARE Var_SobreTasa       		DECIMAL(12,4);
	DECLARE Var_PisoTasa        		DECIMAL(12,4);
	DECLARE Var_TechoTasa       		DECIMAL(12,4);
	DECLARE Var_PorcGarLiq       		DECIMAL(12,4);

	DECLARE Var_CalIrreg        		CHAR(1); -- CALENDARIO IRREGULAR
	DECLARE Var_AjFUlVenAm      		CHAR(1); -- AJUSTAR FECHA ULTIMA AMORTIZACION S = SI
	DECLARE Var_TipoFondeo 				CHAR(1); -- TIPO DE FONDEO RECURSOS PROPIOS O INST FONDEO
	DECLARE Var_InstitFondeo    		INT(11);
	DECLARE Var_InstitNominaID			INT(11);
	DECLARE Var_LineaFondeo     		INT(11);
	DECLARE Var_Grupo           		INT(11);
	DECLARE Var_TipoIntegr      		INT(11);
	DECLARE Var_MontoSegVida    		DECIMAL(12,2);
	DECLARE Var_ForCobroSegVida 		CHAR(1);
	DECLARE Var_Relacionado     		BIGINT(12);

	DECLARE Var_AporCliente     		DECIMAL(12,2);
	DECLARE Var_FechInhabil     		CHAR(1);  -- dia habil siguiente
	DECLARE Var_AjuFecExiVe     		CHAR(1); -- constante N=no que no se ajuste la fecha exigible a la de vencimiento
	DECLARE Var_DiaMesInter     		INT;
	DECLARE Var_DiaMesCap       		INT;
	DECLARE Var_DiaPagInt       		CHAR(1); -- constante F= Ultimo dia del mes DiaPagoCap
	DECLARE Var_TasaBase    			DECIMAL(12,4); -- consulta producto constante tipo CalcInteres es Fijo
	DECLARE Var_FolioCtrl				VARCHAR(20);
	DECLARE Var_HorarioVeri				VARCHAR(20);
	DECLARE Var_TipoCredito				CHAR(1);

	DECLARE Entero_Cero     			INT;
	DECLARE Decimal_Cero    			DECIMAL(12,2);
	DECLARE Cadena_Vacia    			CHAR(1);
	DECLARE Fecha_Vacia     			DATE;
	DECLARE SalidaNO        			CHAR(1);
	DECLARE SalidaSI        			CHAR(1);
	DECLARE Var_ClienteReg				INT;
	DECLARE Estatus_Activo  			CHAR(1);		-- estatus Activo
	DECLARE	ConSic_TipoBuro				CHAR(2);		-- Consulta tipo buro
	DECLARE ConSic_TipoCirculo			CHAR(2);		-- Consulta tipo circulo
	DECLARE Con_TipoBuro				CHAR(1);

	DECLARE GarantiaLiqSI    			CHAR(1);
	DECLARE GarantiaLiqNO    			CHAR(1);

	DECLARE Var_DescuSeguro				DECIMAL(12,2);
	DECLARE Var_MontoSegOrig 			DECIMAL(12,2);

    DECLARE ConstanteN						CHAR(1);
    DECLARE ConstanteT						CHAR(1);


	-- Asignacion de constantes para Banca en Linea
	SET Var_TipoMoneda		:=	1 ;  -- PESOS MEXICANOS
	SET Var_TipoDisper      := 'E';  -- EFECTIVO
	SET Var_TipoCalInt      :=  1 ;  -- SALDOS INSOLUTOS
	SET Var_CalcInteres  	:=  1 ;  -- TASA FIJA
	SET Var_TipoPagCap      := 'C';  -- CRECIENTES
	SET Var_DiaPagCap       := 'F';  -- FIN DE MES
	SET Var_SobreTasa       :=  0 ;
	SET Var_PisoTasa        :=  0 ;
	SET Var_TechoTasa       :=	0 ;
	SET Var_InstitNominaID  :=	0 ;
	SET Var_PorcGarLiq		:=	0 ;

	SET Var_CalIrreg        := 'N'; -- NO
	SET Var_AjFUlVenAm      := 'S'; -- SI
	SET Var_TipoFondeo 		:= 'P'; -- RECURSOS PROPIOS
	SET Var_InstitFondeo 	:=  0 ;
	SET Var_LineaFondeo 	:=  0 ;
	SET Var_Grupo		    :=  0 ;
	SET Var_TipoIntegr   	:=  0 ;
	SET Var_MontoSegVida    :=  0 ;
	SET Var_ForCobroSegVida :=  '';
	SET Var_FolioCtrl		:=  '';
	SET Var_HorarioVeri		:=  '';
	SET Var_Relacionado		:=  0 ;

	SET Var_AporCliente 	:=  0 ;
	SET Var_FechInhabil 	:= 'S'; -- S= SI para dia habil siguiente
	SET Var_AjuFecExiVe 	:= 'N'; --  N= NO que no se ajuste la fecha exigible a la de vencimiento
	SET Var_DiaMesInter     :=  0 ;	-- constante 0
	SET Var_DiaMesCap       :=  0 ;
	SET Var_DiaPagInt		:=  0 ;
	SET Var_TasaBase   		:=  0 ; -- consulta producto
	SET Var_TipoCredito		:= 'N'; -- CREDITO NUEVO
	SET Estatus_Activo 		:= 'A';

	SET Entero_Cero     	:=  0 ;
	SET Decimal_Cero    	:= 0.0;
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Cadena_Vacia    	:= '' ;
	SET SalidaSI        	:= 'S';
	SET SalidaNO        	:= 'N';

	SET Var_DescuSeguro		:= 0.0;
	SET Var_MontoSegOrig 	:= 0.0;

	SET ConSic_TipoBuro		:= 'BC';			-- Consulta SIC buro
	SET ConSic_TipoCirculo	:= 'CC';			-- Consulta SIC Circulo
	SET Con_TipoBuro		:= 'B';				-- Tipo buro


	SET	GarantiaLiqSI		:= 'S';
	SET	GarantiaLiqNO		:= 'N';

    SET ConstanteN			:= 'N';
    SET ConstanteT			:= 'T';

	SET Aud_FechaActual := NOW();

	ManejoErrores: BEGIN


		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := 999;
					SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				         'esto le ocasiona. Ref: SP-BANSOLICITUDCREDITOALT');
					SET Var_Control := 'SQLEXCEPTION' ;
				END;


		SET Var_TipoConsultaSIC	:= (SELECT ConBuroCreDefaut FROM PARAMETROSSIS LIMIT 1);
		SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		IF(IFNULL(Var_TipoConsultaSIC, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_TipoConsultaSIC	:= Cadena_Vacia;
	    ELSE
			IF (Var_TipoConsultaSIC = Con_TipoBuro)THEN
				SET Var_TipoConsultaSIC := ConSic_TipoBuro;
			ELSE
				SET Var_TipoConsultaSIC := ConSic_TipoCirculo;
	        END IF;
	    END IF;

		 IF IFNULL(Par_Promotor, Entero_Cero) = Entero_Cero THEN
		 	SELECT PromotorActual INTO Par_Promotor FROM CLIENTES WHERE ClienteID = Par_ClienteID;
		 END IF;

		 SET Par_Promotor := IFNULL(Par_Promotor, Entero_Cero);

		 SET Var_FechaCobroComision := (SELECT FNSUMADIASFECHA(Var_FechaSistema, Par_Periodicidad));
		 SET Var_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, 0, Aud_EmpresaID));

		 SET Par_Proyecto			:= "PRESTAMO PERSONAL";

		 SET Aud_UsuarioID := Par_Promotor;
		 SET Aud_EmpresaID := 1;
		 SET Aud_Sucursal := Par_SucursalID;

		CALL SOLICITUDCREDITOALT(
				Entero_Cero,			Par_ClienteID,			Par_ProduCredID,			Par_FechaReg,			Par_Promotor,
				Var_TipoCredito,		Par_NumCreditos,		Var_Relacionado,			Var_AporCliente,		Var_TipoMoneda,
				Par_DestinoCre,			Par_Proyecto,			Par_SucursalID,				Par_MontoSolic,			Par_PlazoID,
				Par_FactorMora,			Par_ComApertura,		Par_IVAComAper,				Var_TipoDisper,			Var_CalcInteres,
				Var_TasaBase,			Par_TasaFija,			Var_SobreTasa,				Var_PisoTasa,			Var_TechoTasa,
				Var_FechInhabil,		Var_AjuFecExiVe,		Var_CalIrreg,				Var_AjFUlVenAm,			Var_TipoPagCap,
				Par_Frecuencia,			Par_Frecuencia,			Par_Periodicidad,			Par_Periodicidad,		Var_DiaPagInt,
				Var_DiaPagCap,			Var_DiaMesInter,		Var_DiaMesCap,				Par_NumAmorti,			Par_NumTransacSim,
				Par_CAT,				Par_CuentaClabe,		Var_TipoCalInt,				Var_TipoFondeo,			Var_InstitFondeo,
				Var_LineaFondeo,		Par_NumAmorti,			Par_MontoCuota,				Var_Grupo,				Var_TipoIntegr,
				Par_FechaVencim,		Par_FechaInicio,		Entero_Cero,			    ConstanteN,				Par_ClasiDestinCred,
				Par_InstitNominaID,		Var_FolioCtrl,			Var_HorarioVeri,			Var_PorcGarLiq,			Par_FechaInicio,
				Entero_Cero,			Entero_Cero,		    ConstanteT,				    Entero_Cero,			Var_TipoConsultaSIC,
				Cadena_Vacia,			Cadena_Vacia,			Fecha_Vacia,				Entero_Cero,			Entero_Cero,
				Entero_Cero,			Decimal_Cero,			Entero_Cero,				Entero_Cero,			Cadena_Vacia,
				Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,				Cadena_Vacia,			Cadena_Vacia,
				Entero_Cero,			Entero_Cero,			ConstanteN,					ConstanteN,				ConstanteN,
				Entero_Cero,			ConstanteN,				ConstanteN,					ConstanteN,
				SalidaNO,				Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,			Aud_UsuarioID,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumeroTransaccion
		);


		IF(Par_NumErr != Entero_Cero) THEN
                LEAVE ManejoErrores;
		ELSE
			SET Par_ErrMen := CONCAT(Par_ErrMen,'  Un Ejecutivo se comunicará con usted para darle seguimiento.');
		END IF;

		SET Var_SolicitudCre := (SELECT IFNULL(MAX(SolicitudCreditoID), Entero_Cero)
                        			FROM SOLICITUDCREDITO);

	END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT Par_NumErr   AS NumErr,
               Par_ErrMen   AS ErrMen,
               'solicitudCreditoID'  AS control,
			   Var_SolicitudCre AS consecutivo;
    END IF;

END TerminaStore$$
