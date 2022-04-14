-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREPDAWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREPDAWSALT`;
DELIMITER $$

CREATE PROCEDURE `SOLICITUDCREPDAWSALT`(
-- --------------------------------------------------------------------------------
-- -----------STORED PARA DAR ALTA SOLICITUDES DE CREDITO WS PARA PDA--------------
-- --------------------------------------------------------------------------------

	Par_ClienteID       	        INT,             # ID del cliente solicitante
	Par_MontoSolic      	        DECIMAL(12,2),   # Monto solicitado
	Par_FechaReg        	        DATE,            # Fecha en qque se realizo el registro
	Par_DestinoCre      	    	INT,			 # destino del credito
	Par_Dispersion              	CHAR(1),         # Tipo de Dispercion del credito
    Par_TipPago                 	CHAR(1),         # Tipo de pago de capital
    Par_NumCuota                	INT,             # Numero de cuotas

	Par_PlazoID         	    	INT,             # Id del plazo a pagar
	Par_FecuenciaCap                CHAR(1),         # Frecuencia Capital
    Par_FecuenciaInt                CHAR(1),         # Frecuencia de Interes
    Par_Folio_Pda		        	VARCHAR(20),     # Folio generado por el PDA (Por ahora no utilizado)
    Par_Id_Usuario              	VARCHAR(100),    # ID del usuario
	Par_Clave			        	VARCHAR(45),     # Contraseña del usuario
	Par_Dispositivo		        	VARCHAR(40),     # Dispositivo del que se genera el movimiento (Por ahora no utilizado)

/* Parametros de auditoria*/
	Par_EmpresaID       	    	INT(11),
	Aud_Usuario        		    	INT(11),
	Aud_FechaActual     	    	DATETIME,
	Aud_DireccionIP    		    	VARCHAR(15),
	Aud_ProgramaID      	    	VARCHAR(50),
	Aud_Sucursal        	    	INT(11),
	Aud_NumTransaccion  	    	BIGINT(20)

		)
TerminaStore: BEGIN

/* Declaracion de Constantes*/
DECLARE Var_CicBaseCli			INT;
DECLARE Var_NumCreditos			INT;
DECLARE ProductoCred			INT;
DECLARE Var_Control				CHAR(15);
DECLARE Var_SolicitudCre		BIGINT(20);
DECLARE PagoSemanal				CHAR(1);	-- Pago Semanal (S)
DECLARE PagoCatorcenal			CHAR(1);	-- Pago Catorcenal (C)
DECLARE PagoQuincenal			CHAR(1);	-- Pago Quincenal (Q)
DECLARE PagoMensual				CHAR(1);	-- Pago Mensual (M)
DECLARE PagoPeriodo				CHAR(1);	-- Pago por periodo (P)
DECLARE PagoBimestral			CHAR(1);	-- PagoBimestral (B)
DECLARE PagoTrimestral			CHAR(1);	-- PagoTrimestral (T)
DECLARE PagoTetrames			CHAR(1);	-- PagoTetraMestral (R)
DECLARE PagoSemestral			CHAR(1);	-- PagoSemestral (E)
DECLARE PagoAnual				CHAR(1);	-- PagoAnual (A)
DECLARE FrecSemanal				INT;		-- frecuencia semanal en dias
DECLARE FrecCator				INT;		-- frecuencia Catorcenal en dias
DECLARE FrecQuin				INT;		-- frecuencia en dias quincena
DECLARE FrecMensual				INT;		-- frecuencia mensual
DECLARE FrecBimestral			INT;		-- Frecuencia en dias Bimestral
DECLARE FrecTrimestral			INT;		-- Frecuencia en dias Trimestral
DECLARE FrecTetrames			INT;		-- Frecuencia en dias TetraMestral
DECLARE FrecSemestral			INT;		-- Frecuencia en dias Semestral
DECLARE FrecAnual				INT;		-- frecuencia en dias Anual
DECLARE	ConSic_TipoBuro			CHAR(2);		-- Consulta tipo buro
DECLARE ConSic_TipoCirculo		CHAR(2);		-- Consulta tipo circulo
DECLARE Con_TipoBuro			CHAR(1);
/*  Declaracion de constantes para el alta de Solicitud de Credito para PDA */
DECLARE Var_CodigoResp		    INT(1);
DECLARE Var_CodigoRespEx        INT(1);
DECLARE Var_CodigoDesc		    VARCHAR(100);
DECLARE Var_FechaAutoriza	    VARCHAR(20);
DECLARE Var_TipoMoneda          INT;             # TIPO DE MONEDA
DECLARE Var_TipoDisper          CHAR(1);         # TIPO DE DISPERSION
DECLARE Var_TipoCalInt          INT(11);         # TIPO CALCULO INTERES
DECLARE Var_CalcInteres	        INT;	         # CALCULO INTERES
DECLARE Var_TipoPagCap          CHAR(1);         # TIPO PAGO CAPITAL
DECLARE Var_DiaPagCap           CHAR(1);         # DIA DE PAGO
DECLARE Var_SobreTasa           DECIMAL(12,4);
DECLARE Var_PisoTasa           	DECIMAL(12,4);
DECLARE Var_TechoTasa           DECIMAL(12,4);
DECLARE Var_PorcGarLiq         	DECIMAL(12,4);

DECLARE Var_CalIrreg       		CHAR(1);         # CALENDARIO IRREGULAR
DECLARE Var_AjFUlVenAm      	CHAR(1);         # AJUSTAR FECHA ULTIMA AMORTIZACION S = SI
DECLARE Var_TipoFondeo 			CHAR(1);         # TIPO DE FONDEO RECURSOS PROPIOS O INST FONDEO
DECLARE Var_InstitFondeo    	INT(11);
DECLARE Var_InstitNominaID		INT(11);
DECLARE Var_LineaFondeo     	INT(11);
DECLARE Var_Grupo           	INT(11);
DECLARE Var_TipoIntegr      	INT(11);
DECLARE Var_MontoSegVida    	DECIMAL(12,2);
DECLARE Var_ForCobroSegVida 	CHAR(1);
DECLARE Var_Relacionado     	BIGINT(12);

DECLARE Var_AporCliente     	DECIMAL(12,2);
DECLARE Var_FechInhabil    		CHAR(1);          # dia habil siguiente
DECLARE Var_AjuFecExiVe     	CHAR(1);          # constante N=no que no se ajuste la fecha exigible a la de vencimiento
DECLARE Var_DiaMesInter     	INT;
DECLARE Var_DiaMesCap       	INT;
DECLARE Var_DiaPagInt       	CHAR(1);          # constante F= Último dia del mes DiaPagoCap
DECLARE Var_TasaBase    		DECIMAL(12,4);    # consulta producto constante tipo CalcInteres es Fijo
DECLARE Var_FolioCtrl			VARCHAR(20);
DECLARE Var_HorarioVeri			VARCHAR(20);
DECLARE Var_TipoCredito			CHAR(1);

DECLARE Var_Spei                CHAR(1);
DECLARE Var_Efectivo            CHAR(1);
DECLARE Var_Cheque              CHAR(1);
DECLARE Var_OrdPago             CHAR(1);

DECLARE Var_Creci               CHAR(1);
DECLARE Var_Igual               CHAR(1);

DECLARE Entero_Cero     		INT;
DECLARE Decimal_Cero    		DECIMAL(12,2);
DECLARE Cadena_Vacia    		CHAR(1);
DECLARE Fecha_Vacia     		DATE;
DECLARE Par_NumErr		        INT(11);
DECLARE Par_ErrMen      		VARCHAR(400);
DECLARE SalidaNO        		CHAR(1);
DECLARE SalidaSI        		CHAR(1);
DECLARE Var_ClienteReg			INT;
DECLARE Estatus_Activo  		CHAR(1);		   # Eestatus Activo
DECLARE Var_Promotor            INT;               # Promotor Actual de cliente
DECLARE Var_SucursalOri         INT;               # Sucursal del cliente
DECLARE Var_Frecuencias         VARCHAR(200);      # Frecuencias
DECLARE Var_Plazo               VARCHAR(750);      # Plazo a pagar
DECLARE Var_Dispersiones        VARCHAR(100);      # Tipo de dispersion
DECLARE Var_TipoPago			VARCHAR(15);       # Tipo de pago de capital
DECLARE Var_Garantizado			CHAR(1);
DECLARE Var_CalificaCli			CHAR(1);
DECLARE Var_PeriodoCap			INT(11);
DECLARE Var_PeriodoInt			INT(11);
DECLARE Var_IgualCalInt         CHAR(1);          # Si hay o No Igualdad en el calendario de Interes y Capital
DECLARE Var_IgualCalSI			CHAR(1);
DECLARE Var_IgualCalNO			CHAR(1);
DECLARE Var_Aniversario			CHAR(1);
DECLARE Var_FechaSistema		DATE;
DECLARE Var_DescuSeguro			DECIMAL(12,2);
DECLARE Var_MontoSegOrig 		DECIMAL(12,2);
DECLARE Var_MontoSeguroCuota	DECIMAL(12,2);		# Monto a cobrar por seguro por cuota por temporal ira en 0 ya que solo es para ZAFY este campo
DECLARE Var_TipoConsultaSIC		CHAR(2);			-- TIPO CONSULTA SIC
DECLARE Var_FechaCobroComision 	DATE;		-- Fecha de cobro de la comision por apertura

/* asignacion de constantes */
SET	Var_CodigoResp	    		:=   0;
SET	Var_CodigoDesc	   			:=  'Transaccion Rechazada';
SET Var_FechaAutoriza   		:=   CONCAT(CURRENT_DATE,'T',CURRENT_TIME);

SET Var_TipoMoneda				:=	 1 ;      		    # PESOS MEXICANOS
SET Var_TipoDisper      		:=  'S';       			# SPEI
SET Var_TipoCalInt      		:=   1 ;       			# SALDOS INSOLUTOS
SET Var_CalcInteres  			:=   1 ;       			# TASA FIJA
SET Var_TipoPagCap      		:=  'C';       			# CRECIENTES
SET Var_DiaPagCap       		:=  'A';       			# POR ANIVERSARIO
SET Var_SobreTasa       		:=   0 ;
SET Var_PisoTasa        		:=   0 ;
SET Var_TechoTasa       		:=	 0 ;
SET Var_InstitNominaID  		:=	 0 ;
SET Var_PorcGarLiq	    		:=	 0 ;

SET Var_CalIrreg        		:=  'N';        		# NO
SET Var_AjFUlVenAm      		:=  'N';        		# NO
SET Var_TipoFondeo 				:=  'P';        		# RECURSOS PROPIOS
SET Var_InstitFondeo 			:=   0 ;
SET Var_LineaFondeo 			:=   0 ;
SET Var_Grupo		    		:=   0 ;
SET Var_TipoIntegr   			:=   0 ;
SET Var_MontoSegVida    		:=   0 ;
SET Var_ForCobroSegVida 		:=   '';
SET Var_FolioCtrl				:=   '';
SET Var_HorarioVeri				:=   '';
SET Var_Relacionado				:=   0 ;

SET PagoSemanal					:= 'S'; -- PagoSemanal
SET PagoCatorcenal				:= 'C'; -- PagoCatorcenal
SET PagoQuincenal				:= 'Q'; -- PagoQuincenal
SET PagoMensual					:= 'M'; -- PagoMensual
SET PagoPeriodo					:= 'P'; -- PagoPeriodo
SET PagoBimestral				:= 'B'; -- PagoBimestral
SET PagoTrimestral				:= 'T'; -- PagoTrimestral
SET PagoTetrames				:= 'R'; -- PagoTetraMestral
SET PagoSemestral				:= 'E'; -- PagoSemestral
SET PagoAnual					:= 'A'; -- PagoAnual
SET FrecSemanal					:= 7;	-- frecuencia semanal en dias
SET FrecCator					:= 14;	-- frecuencia Catorcenal en dias
SET FrecQuin					:= 15;	-- frecuencia en dias de quincena
SET FrecMensual					:= 30;	-- frecuencia mesual
SET FrecBimestral				:= 60;	-- Frecuencia en dias Bimestral
SET FrecTrimestral				:= 90;	-- Frecuencia en dias Trimestral
SET FrecTetrames				:= 120;	-- Frecuencia en dias TetraMestral
SET FrecSemestral				:= 180;	-- Frecuencia en dias Semestral
SET FrecAnual					:= 360;	-- frecuencia en dias Anual

SET Var_Spei                    :=  'S';         		 # Dispercion por spei
SET Var_Efectivo                :=  'E';          		 # Dispercion en efectivo
SET Var_Cheque                  :=  'C';          		 # Dispercion por cheque
SET Var_OrdPago                 :=  'O';                 # Dispercion por orden

SET Var_Creci                   :=  'C';                 # Tipo de Pago Creciente
SET Var_Igual                   :=  'I';                 # Tipo de Pago Igual

SET Var_AporCliente 			:=   0 ;
SET Var_FechInhabil 			:=  'S';          		 # S= SI para dia habil siguiente
SET Var_AjuFecExiVe 			:=  'S';                 # S= SI que si se ajuste la fecha exigible a la de vencimiento
SET Var_DiaMesInter    		 	:=   0 ;	             # constante 0
SET Var_DiaMesCap       		:=   0 ;
SET Var_DiaPagInt				:=  'A';                 # Por Aniversario
SET Var_TasaBase   				:=   0 ;                 # consulta producto
SET Var_TipoCredito				:=  'N';                 # CREDITO NUEVO
SET Estatus_Activo 				:=  'A';
SET Var_Plazo                   :=  '5,6,4,7,8';
SET Var_Frecuencias             :=  'S,C,Q,M,B,T,R,E,A,P,U';
SET Var_Dispersiones            :=  'S,C,E';
SET Var_TipoPago                :=  'C,I';
SET Var_IgualCalSI				:=	'S';
SET Var_IgualCalNO				:=	'N';


SET Entero_Cero     			:=   0 ;
SET Decimal_Cero    			:=   0.0;
SET Fecha_Vacia     			:=  '1900-01-01';
SET Cadena_Vacia    			:=  '' ;
SET SalidaSI        			:=  'S';
SET SalidaNO        			:=  'N';

SET Par_NumErr  				:=    0;
SET Par_ErrMen  				:=   '';
SET Var_Aniversario				:=   'A';

SET Var_DescuSeguro				:= 0.0;
SET Var_MontoSegOrig 			:= 0.0;
SET ConSic_TipoBuro				:= 'BC';				-- Consulta SIC buro
SET ConSic_TipoCirculo			:= 'CC';				-- Consulta SIC Circulo
SET Con_TipoBuro				:= 'B';					-- Tipo buro

SET Aud_FechaActual     		:= NOW();

SET Var_SucursalOri  := (SELECT SucursalOrigen
							FROM CLIENTES
							WHERE ClienteID = Par_ClienteID);

SET Var_FechaSistema	:=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);


ManejoErrores:BEGIN
/* -------------------------------------Validaciones----------------------------------- */

IF NOT EXISTS(SELECT UsuarioID
		FROM USUARIOS
		WHERE Clave = Par_Id_Usuario
		AND Contrasenia = Par_Clave
        AND Estatus = Estatus_Activo)THEN
	SET Par_NumErr         :=   2;
    SET Par_ErrMen         :=  'El usuario no existe.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

	SET Var_TipoConsultaSIC	:= (SELECT ConBuroCreDefaut FROM PARAMETROSSIS LIMIT 1);

    IF(IFNULL(Var_TipoConsultaSIC, Cadena_Vacia)= Cadena_Vacia) THEN
		SET Var_TipoConsultaSIC	:= Cadena_Vacia;
    ELSE
		IF (Var_TipoConsultaSIC = Con_TipoBuro)THEN
			SET Var_TipoConsultaSIC := ConSic_TipoBuro;
		ELSE
			SET Var_TipoConsultaSIC := ConSic_TipoCirculo;
        END IF;
    END IF;


SET ProductoCred	:= (SELECT ProducCreditoID
							FROM PARAMGENERALES
							INNER JOIN PRODUCTOSCREDITO ON ProducCreditoID = ValorParametro
							WHERE LlaveParametro = 'ProdCredWSPDA');

IF(IFNULL(ProductoCred,Entero_Cero) = Entero_Cero) THEN
	SET Par_NumErr         :=   3;
    SET Par_ErrMen         :=   'El Producto de Credito no esta parametrizado.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;


SET Var_IgualCalInt  :=(SELECT IguaCalenIntCap
							FROM CALENDARIOPROD cal
							WHERE  cal.ProductoCreditoID = ProductoCred);


/* Valida que el Usuario se el promotor actual del cliente*/
SET Var_Promotor :=	(SELECT PromotorID FROM PROMOTORES Pro
						INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Pro.UsuarioID
						WHERE Usu.Clave = Par_Id_Usuario
							AND Usu.Contrasenia = Par_Clave);

IF NOT EXISTS(SELECT Cli.PromotorActual
		   FROM PROMOTORES Pro
		   INNER JOIN CLIENTES Cli
		   ON Cli.PromotorActual = Pro.PromotorID
		   WHERE PromotorActual = Var_Promotor
		   AND Cli.ClienteID = Par_ClienteID)THEN
	SET Par_NumErr         :=   4;
	SET Par_ErrMen         :=  'El usuario no es el promotor del cliente.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_ClienteID, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_NumErr         :=   5;
	SET Par_ErrMen         :=  'El cliente esta vacio.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_MontoSolic, Entero_Cero)) = Entero_Cero THEN
	SET Par_NumErr         :=   6;
	SET Par_ErrMen         :=  'El Monto es cero.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_FechaReg, Fecha_Vacia)) = Fecha_Vacia THEN
	SET Par_NumErr         := 7;
	SET Par_ErrMen         := 'La Fecha esta vacia.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_DestinoCre, Entero_Cero)) = Entero_Cero THEN
	SET Par_NumErr         :=   8;
	SET Par_ErrMen         :=  'El destino de credito esta vacio.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

# Destino de Credito
SET Par_DestinoCre:=(SELECT DestinoCreID
						FROM DESTINOSCREDPROD
						WHERE ProductoCreditoID = ProductoCred
						AND DestinoCreID = Par_DestinoCre);

SET Par_DestinoCre:=IFNULL(Par_DestinoCre,Entero_Cero);

IF(IFNULL(Par_DestinoCre, Entero_Cero)) = Entero_Cero THEN
	SET Par_NumErr         :=   8;
	SET Par_ErrMen         :=  'El Destino de Credito Seleccionado no Corresponde con el Producto por su Clasificacion';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;


IF(IFNULL(Par_Dispersion, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_NumErr         :=   9;
	SET Par_ErrMen         :=   'La dispercion esta vacia.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_TipPago, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_NumErr         := 10;
	SET Par_ErrMen         := 'El Tipo de Pago esta vacio.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_NumCuota, Entero_Cero)) = Entero_Cero THEN
	SET Par_NumErr         := 11;
	SET Par_ErrMen         := 'El número de cuotas esta vacio.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;



IF(IFNULL(Par_PlazoID, Entero_Cero)) = Entero_Cero THEN
	SET Par_NumErr         := 13;
	SET Par_ErrMen         := 'El Plazo esta vacio.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_FecuenciaCap, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_NumErr         :=   14;
	SET Par_ErrMen         :=  'La frecuencia Capital esta vacia.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;


IF(IFNULL(Par_FecuenciaInt, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_NumErr         := 15;
	SET Par_ErrMen         := 'La frecuencia de Interes esta vacia.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_Id_Usuario,Cadena_Vacia))= Cadena_Vacia THEN
	SET Par_NumErr         :=  16;
	SET Par_ErrMen         :=  'El Usuario esta vacio.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_Clave,Cadena_Vacia))= Cadena_Vacia THEN
	SET Par_NumErr         :=   17;
	SET Par_ErrMen         :=   'La clave del Usuario esta vacia.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;


/* Validacion del Destino*/

IF NOT EXISTS(SELECT DestinoCreID FROM DESTINOSCREDITO
	   WHERE DestinoCreID = Par_DestinoCre)THEN
	SET Par_NumErr         :=   18;
	SET Par_ErrMen         :=   'El Destino no existe.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

/* Validacion de tipo de dispercion */

IF LOCATE(Par_Dispersion, Var_Dispersiones) = 0 THEN
	SET Par_NumErr         :=   19;
	SET Par_ErrMen     	   :=   'El Tipo de Dispersion no existe.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

/* Validacion de tipo de pago */

IF LOCATE(Par_TipPago, Var_TipoPago) = 0 THEN
	SET Par_NumErr			:= 20;
	SET Par_ErrMen			:= 'El Tipo de Pago no existe.';
	SET Var_CodigoResp		:=	0;
	SET Var_CodigoDesc		:= Par_ErrMen;
	LEAVE ManejoErrores;
END IF;


/* Validacion para Plazos*/
IF NOT EXISTS(SELECT PlazoID FROM CALENDARIOPROD
				WHERE ProductoCreditoID = ProductoCred
				AND LOCATE(Par_PlazoID, PlazoID))THEN
				SET Par_NumErr         := 21;
				SET Par_ErrMen     	   := 'El plazo no aplica para este producto de credito.';
				SET Var_CodigoResp     :=	0;
				SET Var_CodigoDesc     :=  	Par_ErrMen;
			  LEAVE ManejoErrores;
			END IF;

/* Valida las frecuencias*/
IF LOCATE(Par_FecuenciaCap, Var_Frecuencias) = 0 THEN
	SET Par_NumErr         :=   22;
	SET Par_ErrMen     	   :=  'La Frecuencia de Capital es incorrecta.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;

IF LOCATE(Par_FecuenciaInt, Var_Frecuencias) = 0 THEN
	SET Par_NumErr         :=   23;
	SET Par_ErrMen         :=  'La Frecuencia de Interes es incorrecta.';
	SET Var_CodigoResp     :=	0;
	SET Var_CodigoDesc     :=  	Par_ErrMen;
	LEAVE ManejoErrores;
END IF;



IF EXISTS(SELECT DiaPagoCapital FROM CALENDARIOPROD
				WHERE ProductoCreditoID = ProductoCred
				   AND LOCATE(DiaPagoCapital, 'A,I,D'))THEN
	SET Var_DiaMesCap := (SELECT DAY(FechaSistema) FROM PARAMETROSSIS);
END IF;


IF EXISTS(SELECT DiaPagoInteres FROM CALENDARIOPROD
				WHERE ProductoCreditoID = ProductoCred
				   AND LOCATE(DiaPagoInteres, 'A,I,D'))THEN
	SET Var_DiaMesInter := (SELECT DAY(FechaSistema) FROM PARAMETROSSIS);
END IF;

/* se obtiene si el cliemte requiere garantia liquida*/
SET Var_Garantizado := (SELECT Garantizado
						FROM PRODUCTOSCREDITO
						  WHERE ProducCreditoID = ProductoCred);

IF(Var_Garantizado = 'S')THEN
	SET Var_CalificaCli	:= (SELECT CalificaCredito
								FROM CLIENTES
								WHERE ClienteID = Par_ClienteID);
	/* Obtiene el porcentaje de garantia liquida que requiere */
	SET Var_PorcGarLiq	:=(SELECT Porcentaje
								FROM ESQUEMAGARANTIALIQ
								WHERE ProducCreditoID = ProductoCred
								AND	Clasificacion	=  Var_CalificaCli
								AND LimiteInferior <= Par_MontoSolic
								AND LimiteSuperior >= Par_MontoSolic);
END IF;

/* Se asigna un valor para la periodicidad de Capital -----------*/
CASE Par_FecuenciaCap
	WHEN PagoSemanal	THEN SET Var_PeriodoCap	:=  FrecSemanal;
	WHEN PagoCatorcenal	THEN SET Var_PeriodoCap	:=  FrecCator;
	WHEN PagoQuincenal	THEN SET Var_PeriodoCap	:=  FrecQuin;
	WHEN PagoMensual	THEN SET Var_PeriodoCap	:=  FrecMensual;
	WHEN PagoPeriodo	THEN SET Var_PeriodoCap :=  Entero_Cero;
	WHEN PagoBimestral	THEN SET Var_PeriodoCap	:=  FrecBimestral;
	WHEN PagoTrimestral	THEN SET Var_PeriodoCap	:=  FrecTrimestral;
	WHEN PagoTetrames	THEN SET Var_PeriodoCap	:=  FrecTetrames;
	WHEN PagoSemestral	THEN SET Var_PeriodoCap	:=  FrecSemestral;
	WHEN PagoAnual		THEN SET Var_PeriodoCap	:=  FrecAnual;
END CASE;
/* Se asigna un valor para la periodicidad de Interes -----------*/
CASE Par_FecuenciaInt
	WHEN PagoSemanal	THEN SET Var_PeriodoInt	:=  FrecSemanal;
	WHEN PagoCatorcenal	THEN SET Var_PeriodoInt	:=  FrecCator;
	WHEN PagoQuincenal	THEN SET Var_PeriodoInt	:=  FrecQuin;
	WHEN PagoMensual	THEN SET Var_PeriodoInt	:=  FrecMensual;
	WHEN PagoPeriodo	THEN SET Var_PeriodoInt :=  Entero_Cero;
	WHEN PagoBimestral	THEN SET Var_PeriodoInt	:=  FrecBimestral;
	WHEN PagoTrimestral	THEN SET Var_PeriodoInt	:=  FrecTrimestral;
	WHEN PagoTetrames	THEN SET Var_PeriodoInt	:=  FrecTetrames;
	WHEN PagoSemestral	THEN SET Var_PeriodoInt	:=  FrecSemestral;
	WHEN PagoAnual		THEN SET Var_PeriodoInt	:=  FrecAnual;
END CASE;



-- =====SE VALIDA LAS FECUENCIAS EN LA IGUALDAD DE CALENDARIO DE INTERES Y CAPITAL=====
IF(Par_TipPago = Var_Creci)THEN
		IF(Par_FecuenciaCap != Par_FecuenciaInt)THEN
			SET Par_NumErr         :=  26;
			SET Par_ErrMen         := 'Las Frecuencias deben ser Iguales.';
			SET Var_CodigoResp     :=	0;
			SET Var_CodigoDesc     :=  Par_ErrMen;
		LEAVE ManejoErrores;
		END IF;

ELSE

	IF(Var_IgualCalInt = Var_IgualCalSI)THEN
		IF(Par_FecuenciaCap != Par_FecuenciaInt)THEN
			SET Par_NumErr         :=  27;
			SET Par_ErrMen         := 'Las Frecuencias deben ser Iguales.';
			SET Var_CodigoResp     :=	0;
			SET Var_CodigoDesc     :=  Par_ErrMen;
		LEAVE ManejoErrores;
			END IF;
		END IF;
END IF;

-- SE OBTIENE EL DIA DE PAGO DE CAPITAL Y DE INTERES
SELECT		DiaPagoCapital, DiaPagoInteres
	INTO	Var_DiaPagCap,	Var_DiaPagInt
FROM	CALENDARIOPROD
WHERE	ProductoCreditoID = ProductoCred;

SET Var_DiaPagCap	:= IFNULL(Var_DiaPagCap, Var_Aniversario);
SET Var_DiaPagInt	:= IFNULL(Var_DiaPagInt, Var_Aniversario);

-- ==========================================================================
-- NUMERO DE CICLO DEL CLIENTE

-- Verificando el numero de Creditos del Cliente
SELECT COUNT(CreditoID) INTO Var_NumCreditos
    FROM CREDITOS Cre
    WHERE Cre.ClienteID		= Par_ClienteID
      AND Cre.ProductoCreditoID =  ProductoCred
      AND ( Cre.Estatus   = 'V' -- VIGENTE
       OR   Cre.Estatus   = 'P');-- PAGADO

-- Se le suma un uno, por si el cliente no tiene creditos o experiencia con la institucion
-- Entonces decimos que es su 1er ciclo el credito que esta Solicitando
SET Var_NumCreditos := IFNULL(Var_NumCreditos, Entero_Cero) + 1;

-- Ciclo Inicial del Cliente
SELECT  CicloBase INTO Var_CicBaseCli
	FROM CICLOBASECLIPRO Cib
	WHERE Cib.ClienteID = Par_ClienteID
	  AND Cib.ProductoCreditoID = ProductoCred;

SET Var_CicBaseCli := IFNULL(Var_CicBaseCli, Entero_Cero);
SET Var_NumCreditos := Var_NumCreditos + Var_CicBaseCli;
SET Var_MontoSeguroCuota := Entero_Cero;

# Se suman los dias correspondientes a la frecuencia,
SET Var_FechaCobroComision := (SELECT FNSUMADIASFECHA(Var_FechaSistema,Var_PeriodoCap));
SET Var_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, 0, Par_EmpresaID));

/* ----------- Llama al store para dar de alta una solicitud de Credito --------- */


CALL SOLICITUDCREDITOALT (
	Entero_Cero, 	     Par_ClienteID,	 	ProductoCred,       	Par_FechaReg,			Var_Promotor,
	Var_TipoCredito, 	 Var_NumCreditos,	Var_Relacionado,    	Var_AporCliente,		Var_TipoMoneda,
	Par_DestinoCre,  	 Cadena_Vacia,    	Var_SucursalOri,    	Par_MontoSolic,			Par_PlazoID,
	Decimal_Cero,  	     Decimal_Cero, 	    Decimal_Cero,       	Par_Dispersion,			Var_CalcInteres,
	Var_TasaBase,    	 Entero_Cero,    	Var_SobreTasa,      	Var_PisoTasa,			Var_TechoTasa,
	Var_FechInhabil, 	 Var_AjuFecExiVe, 	Var_CalIrreg,	    	Var_AjFUlVenAm,			Par_TipPago,
	Par_FecuenciaInt,  	 Par_FecuenciaCap,  Var_PeriodoInt,			Var_PeriodoCap,			Var_DiaPagInt,
	Var_DiaPagCap,    	 Var_DiaMesInter, 	Var_DiaMesCap,      	Par_NumCuota,			Entero_Cero,
	Decimal_Cero,        Cadena_Vacia, 	    Var_TipoCalInt,     	Var_TipoFondeo,			Var_InstitFondeo,
	Var_LineaFondeo,  	 Par_NumCuota,   	Decimal_Cero,       	Var_Grupo,				Var_TipoIntegr,
	Fecha_Vacia,     	 Var_FechaSistema,	Var_MontoSegVida,   	Var_ForCobroSegVida,	Cadena_Vacia,
	Entero_Cero,	     Var_FolioCtrl,		Var_HorarioVeri,		Var_PorcGarLiq,			Var_FechaSistema,
	Var_DescuSeguro,	 Var_MontoSegOrig,	Cadena_Vacia,           Entero_Cero,			Var_TipoConsultaSIC,
    Cadena_Vacia,		 Cadena_Vacia,		Var_FechaCobroComision,	Entero_Cero,			Entero_Cero,
    Decimal_Cero,		 Decimal_Cero,		Entero_Cero,    		Entero_Cero,			Cadena_Vacia,
    Entero_Cero,		 Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
    Entero_Cero,		 Entero_Cero,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
    Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,
    SalidaNO,	    	 Par_NumErr,		Par_ErrMen,				Par_EmpresaID,		 	Aud_Usuario,
    Aud_FechaActual,     Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,      		Aud_NumTransaccion);

SET Entero_Cero  := 0;
IF(IFNULL(Par_NumErr,Entero_Cero) != Entero_Cero) THEN
	SET Var_CodigoDesc	:= Par_ErrMen;
	SET Var_CodigoResp	:= 0;
	LEAVE ManejoErrores;
ELSE
	SET Var_CodigoResp		:= 1;
	SET Var_CodigoDesc		:= 'Transaccion Aceptada';
END IF;

 SET Var_SolicitudCre:= (SELECT IFNULL(MAX(SolicitudCreditoID),Entero_Cero)
							FROM SOLICITUDCREDITO
							WHERE ClienteID = Par_ClienteID );


END ManejoErrores;


# =========================== LANZA VALORES DE RESPUESTA ===========================
IF (Var_CodigoResp = Entero_Cero)THEN

		  SELECT Var_CodigoResp 	  	    AS CodigoResp,
				 Var_CodigoDesc         	AS CodigoDesc,
				 'false' 				    AS EsValido,
				 Entero_Cero				AS FolioSol;
ELSE

          SELECT Var_CodigoResp 	  	    AS CodigoResp,
				 Var_CodigoDesc         	AS CodigoDesc,
				 'true' 				    AS EsValido,
				 Var_SolicitudCre	 	 	AS FolioSol;
END IF;

END TerminaStore$$