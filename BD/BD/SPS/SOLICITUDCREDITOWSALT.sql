-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOWSALT`;
DELIMITER $$

CREATE PROCEDURE `SOLICITUDCREDITOWSALT`(
	Par_ProspectoID     	BIGINT(20),
	Par_ClienteID       	BIGINT,
	Par_ProduCredID     	INT,
	Par_FechaReg        	DATE,
	Par_Promotor        	INT,
	Par_DestinoCre      	INT,			-- no esta definido crear un destino para banca
	Par_Proyecto        	VARCHAR(500),
	Par_SucursalID      	INT, -- depende de los parametros
	Par_MontoSolic      	DECIMAL(12,2),

	Par_PlazoID         	INT,
	Par_FactorMora      	DECIMAL(8,4), -- se obtiene de la tabla de parametrosBanca
	Par_ComApertura     	DECIMAL(12,4), -- se obtiene de consulta producto
	Par_IVAComAper      	DECIMAL(12,4), -- se obtiene consulta producto
	Par_TasaFija        	DECIMAL(12,4), -- se obtiene consulta producto
	Par_Frecuencia      	CHAR(1),	-- dependen del campo en pantalla frecuencia
	Par_Periodicidad    	INT, -- dependen del plazo es el numero de dias mensual=30 semanal=7...
	Par_NumAmorti       	INT,  -- se calcula de lo que se selecciona de plazo y frecuencia
	Par_NumTransacSim   	BIGINT(20),	-- para el simulador
	Par_CAT             	DECIMAL(12,4),

	Par_CuentaClabe       	CHAR(18),
	Par_MontoCuota        	DECIMAL(12,2), -- lo regresa el cotizador
	Par_FechaVencim       	DATE,
	Par_FechaInicio       	DATE,
	Par_ClasiDestinCred   	CHAR(1), -- depende del destino de credito puede ser C, O, H
	Par_InstitNominaID 	  	INT(11),
	Par_NegocioAfiliadoID 	INT(11),
	Par_NumCreditos       	INT, -- numero de creditos

	Par_Salida          	CHAR(1),
	INOUT Par_NumErr    	INT(11),
	INOUT Par_ErrMen    	VARCHAR(400),

	Par_EmpresaID       	INT(11),
	Aud_Usuario        		INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP    		VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore: BEGIN
-- Declaracion de variables para el alta de Solicitud de Credito en Banca en Linea
DECLARE Var_Control		   	CHAR(15);
DECLARE Var_SolicitudCre   	BIGINT(20);
DECLARE Var_TipoConsultaSIC	CHAR(2);		-- TIPO CONSULTA SIC
DECLARE Var_FechaSistema	DATE;			-- Fecha del sistema
DECLARE Var_FechaCobroComision DATE;		-- Fecha de cobro de la comision por apertura

-- Declaracion de constantes para el alta de Solicitud de Credito en Banca en Linea
DECLARE Var_TipoMoneda      INT;     -- TIPO DE MONEDA
DECLARE Var_TipoDisper      CHAR(1); -- TIPO DE DISPERSION
DECLARE Var_TipoCalInt      INT(11); -- TIPO CALCULO INTERES
DECLARE Var_CalcInteres	    INT;	 -- CALCULO INTERES
DECLARE Var_TipoPagCap      CHAR(1); -- TIPO PAGO CAPITAL
DECLARE Var_DiaPagCap       CHAR(1); -- DIA DE PAGO
DECLARE Var_SobreTasa       DECIMAL(12,4);
DECLARE Var_PisoTasa        DECIMAL(12,4);
DECLARE Var_TechoTasa       DECIMAL(12,4);
DECLARE Var_PorcGarLiq       DECIMAL(12,4);

DECLARE Var_CalIrreg        CHAR(1); -- CALENDARIO IRREGULAR
DECLARE Var_AjFUlVenAm      CHAR(1); -- AJUSTAR FECHA ULTIMA AMORTIZACION S = SI
DECLARE Var_TipoFondeo 		CHAR(1); -- TIPO DE FONDEO RECURSOS PROPIOS O INST FONDEO
DECLARE Var_InstitFondeo    INT(11);
DECLARE Var_InstitNominaID	INT(11);
DECLARE Var_LineaFondeo     INT(11);
DECLARE Var_Grupo           INT(11);
DECLARE Var_TipoIntegr      INT(11);
DECLARE Var_MontoSegVida    DECIMAL(12,2);
DECLARE Var_ForCobroSegVida CHAR(1);
DECLARE Var_Relacionado     BIGINT(12);

DECLARE Var_AporCliente     DECIMAL(12,2);
DECLARE Var_FechInhabil     CHAR(1);  -- dia habil siguiente
DECLARE Var_AjuFecExiVe     CHAR(1); -- constante N=no que no se ajuste la fecha exigible a la de vencimiento
DECLARE Var_DiaMesInter     INT;
DECLARE Var_DiaMesCap       INT;
DECLARE Var_DiaPagInt       CHAR(1); -- constante F= Ultimo dia del mes DiaPagoCap
DECLARE Var_TasaBase    	DECIMAL(12,4); -- consulta producto constante tipo CalcInteres es Fijo
DECLARE Var_FolioCtrl		VARCHAR(20);
DECLARE Var_HorarioVeri		VARCHAR(20);
DECLARE Var_TipoCredito		CHAR(1);

DECLARE Entero_Cero     	INT;
DECLARE Decimal_Cero    	DECIMAL(12,2);
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE SalidaNO        	CHAR(1);
DECLARE SalidaSI        	CHAR(1);
DECLARE Var_ClienteReg		INT;
DECLARE Estatus_Activo  	CHAR(1);		-- estatus Activo
DECLARE	ConSic_TipoBuro		CHAR(2);		-- Consulta tipo buro
DECLARE ConSic_TipoCirculo	CHAR(2);		-- Consulta tipo circulo
DECLARE Con_TipoBuro		CHAR(1);

DECLARE Var_DescuSeguro		DECIMAL(12,2);
DECLARE Var_MontoSegOrig 	DECIMAL(12,2);


-- Asignacion de constantes para Banca en Linea
SET Var_TipoMoneda		:=	1 ;  -- PESOS MEXICANOS
SET Var_TipoDisper      := 'S';  -- SPEI
SET Var_TipoCalInt      :=  1 ;  -- SALDOS INSOLUTOS
SET Var_CalcInteres  	:=  1 ;  -- TASA FIJA
SET Var_TipoPagCap      := 'C';  -- CRECIENTES
SET Var_DiaPagCap       := 'F';  -- FIN DE MES
SET Var_SobreTasa       :=  0 ;
SET Var_PisoTasa        :=  0 ;
SET Var_TechoTasa       :=	0 ;
SET Var_InstitNominaID  :=	0 ;
SET Var_PorcGarLiq		  :=	0 ;

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

SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
			         'esto le ocasiona. Ref: SP-SOLICITUDCREDITOWSALT');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;


SET Var_TipoConsultaSIC	:= (SELECT ConBuroCreDefaut FROM PARAMETROSSIS LIMIT 1);
SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

    IF(IFNULL(Var_TipoConsultaSIC, Cadena_Vacia)= Cadena_Vacia) THEN
		SET Var_TipoConsultaSIC	:= Cadena_Vacia;
    ELSE
		IF (Var_TipoConsultaSIC = Con_TipoBuro)THEN
			SET Var_TipoConsultaSIC := ConSic_TipoBuro;
		ELSE
			SET Var_TipoConsultaSIC := ConSic_TipoCirculo;
        END IF;
    END IF;

IF(IFNULL(Par_NegocioAfiliadoID,Entero_Cero)<> Entero_Cero &&
		 (IFNULL(Par_ClienteID,Entero_Cero)<> Entero_Cero)) THEN

  SET Var_ClienteReg := (SELECT ClienteID
					   FROM NEGAFILICLIENTE
					   WHERE NegocioAfiliadoID=Par_NegocioAfiliadoID
					   AND ClienteID=Par_ClienteID LIMIT 1);

		IF(IFNULL(Var_ClienteReg,Entero_Cero)=Entero_Cero) THEN
		# SI NO REGRESA ALGUN VALOR INSERTA EN NEGAFILICLIENTE

				CALL NEGAFILICLIENTEALT (
					Par_NegocioAfiliadoID,  Par_ClienteID,		Par_ProspectoID,    SalidaNO,         Par_NumErr,
					Par_ErrMen,             Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,  Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,  		Aud_NumTransaccion
					);
		END IF; # FIN INSERTA EN NEGAFILICLIENTE

 ELSE IF((IFNULL(Par_InstitNominaID,Entero_Cero)<> Entero_Cero) &&
		(IFNULL(Par_ClienteID,Entero_Cero)<> Entero_Cero)) THEN

		SET Var_ClienteReg := (SELECT ClienteID
							 FROM NOMINAEMPLEADOS
							 WHERE InstitNominaID=Par_InstitNominaID
							 AND ClienteID=Par_ClienteID LIMIT 1);

		IF(IFNULL(Var_ClienteReg,Entero_Cero)=Entero_Cero)THEN # SI NO REGRESA ALGUN VALOR INSERTA EN NOMINAEMPLEADOS

				 CALL NOMINAEMPLEADOSALT(
					Par_InstitNominaID,    	Par_ClienteID,		Par_ProspectoID,   	Entero_Cero,		Entero_Cero,
					Entero_Cero,			Cadena_Vacia,		Entero_Cero,	   	Cadena_Vacia,		Fecha_Vacia,
					Cadena_Vacia,			SalidaNO,         	Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,       		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	    Aud_Sucursal,
					Aud_NumTransaccion);

	    END IF; # FIN INSERTA EN NOMINAEMPLEADOS
	 END IF;
 END IF;

	IF ifnull(Par_Promotor,Entero_Cero) = Entero_Cero then
		select PromotorActual into Par_Promotor from CLIENTES where ClienteID = Par_ClienteID;
	end if;
    set Par_Promotor := ifnull(Par_Promotor,Entero_Cero);

    # Se suman los dias correspondientes a la frecuencia,
	SET Var_FechaCobroComision := (SELECT FNSUMADIASFECHA(Var_FechaSistema,Par_Periodicidad));
    SET Var_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, 0, Par_EmpresaID));

# Llama al store para dar de alta una solicitud de Crédito
CALL SOLICITUDCREDITOALT (
	Par_ProspectoID, 	 	Par_ClienteID,	 	Par_ProduCredID,  		Par_FechaReg,    		Par_Promotor,
	Var_TipoCredito, 	 	Par_NumCreditos,	Var_Relacionado,  		Var_AporCliente, 		Var_TipoMoneda,
	Par_DestinoCre,  	 	Par_Proyecto,    	Par_SucursalID,   		Par_MontoSolic,  		Par_PlazoID,
	Par_FactorMora,  	 	Par_ComApertura, 	Par_IVAComAper,   		Var_TipoDisper,  		Var_CalcInteres,
	Var_TasaBase,    	 	Par_TasaFija,    	Var_SobreTasa,    		Var_PisoTasa,    		Var_TechoTasa,
	Var_FechInhabil, 	 	Var_AjuFecExiVe, 	Var_CalIrreg,	  		Var_AjFUlVenAm,			Var_TipoPagCap,
	Par_Frecuencia,  	 	Par_Frecuencia,  	Par_Periodicidad, 		Par_Periodicidad, 		Var_DiaPagInt,
	Var_DiaPagCap,    	 	Var_DiaMesInter, 	Var_DiaMesCap,    		Par_NumAmorti,   		Par_NumTransacSim,
	Par_CAT,          	 	Par_CuentaClabe, 	Var_TipoCalInt,   		Var_TipoFondeo,  		Var_InstitFondeo,
	Var_LineaFondeo,  	 	Par_NumAmorti,   	Par_MontoCuota,   		Var_Grupo,       		Var_TipoIntegr,
	Par_FechaVencim,  	 	Par_FechaInicio,	Var_MontoSegVida, 		Var_ForCobroSegVida, 	Par_ClasiDestinCred,
	Par_InstitNominaID,	 	Var_FolioCtrl,		Var_HorarioVeri,  		Var_PorcGarLiq,	   		Par_FechaInicio,
	Var_DescuSeguro,	 	Var_MontoSegOrig,	Cadena_Vacia,           Entero_Cero,			Var_TipoConsultaSIC,
    Cadena_Vacia,			Cadena_Vacia,    	Var_FechaCobroComision,	Entero_Cero,			Entero_Cero,
    Decimal_Cero,			Decimal_Cero,		Entero_Cero,			Entero_Cero,			Cadena_Vacia,
    Entero_Cero,			Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
    Entero_Cero,			Entero_Cero,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
    Entero_Cero,			Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,
    Par_Salida,       		Par_NumErr,			Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
    Aud_FechaActual,  		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,           Aud_NumTransaccion);



		IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
		ELSE
        -- Cambiar el Mensaje a moostrar
			set Par_ErrMen := concat(Par_ErrMen,'<br> Un Ejecutivo se comunicará con usted para darle seguimiento. ');
		END IF;

SET Var_SolicitudCre:= (SELECT IFNULL(MAX(SolicitudCreditoID),Entero_Cero)
                        FROM SOLICITUDCREDITO);


IF(Var_SolicitudCre != Entero_Cero) THEN
#Llama al store para dar de alta en la tabla que guarda las solicitudes de Banca en Linea
	CALL SOLICITUDCREDITOBEALT(
		Var_SolicitudCre,  	  	Par_ClienteID,  	Par_ProspectoID, 	 Par_InstitNominaID,
		Par_NegocioAfiliadoID, 	Cadena_Vacia,		Par_Salida, 	  	 Par_ErrMen,
		Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,	     Aud_FechaActual,
		Aud_DireccionIP, 		Aud_ProgramaID,     Aud_Sucursal,        Aud_NumTransaccion
		);
ELSE
	SELECT '018' AS NumErr,
	'Error en el Alta de la Solicitud de Crédito. Ref: SP-SOLICITUDCREDITOBEALT' AS ErrMen,
	'Var_SolicitudCre' AS control,
	 Entero_Cero AS consecutivo;
LEAVE TerminaStore;
END IF;


END ManejoErrores; #fin del manejador de errores

    IF (Par_Salida = SalidaSI) THEN
        SELECT Par_NumErr   AS NumErr,
               Par_ErrMen   AS ErrMen,
               'solicitudCreditoID'  AS control,
			   Var_SolicitudCre AS consecutivo;
    END IF;

END TerminaStore$$