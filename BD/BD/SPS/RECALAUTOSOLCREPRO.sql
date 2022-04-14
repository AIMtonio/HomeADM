-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RECALAUTOSOLCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RECALAUTOSOLCREPRO`;
DELIMITER $$


CREATE PROCEDURE `RECALAUTOSOLCREPRO`(
# SP DE RECALCULO DE TASA DE INTERES, GARANTIA LIQUIDA, COMISION POR APERTURA Y SEGURO DE VIDA
    Par_SolicitudCreditoID  	BIGINT(20),		# ID de la solicitud de credito
	Par_MontoAutoriza 			DECIMAL(14,2),	# Monto autorizado en pantalla
	Par_SucursalCte				INT(11),		# Sucursal del cliente
    Par_Salida              	CHAR(1),
    INOUT Par_NumErr       	 	INT(11),

    INOUT Par_ErrMen   			VARCHAR(400),
	# Valores de salida
    INOUT Par_ComApertura   	DECIMAL(12,2),	# Monto de comision por apertura recalculado
    INOUT Par_IVAComApertura    DECIMAL(12,2),	# Monto de iva por comision por apertura recalculada
    INOUT Par_TasaFija			DECIMAL(12,4),	# Nueva tasa de interes
    INOUT Par_MontoSeguro   	DECIMAL(12,2),	# Nueva monto de seguro de vida recalculado

    INOUT Par_MontoGarLiq   	DECIMAL(12,2),	# Nuevo monto de garantia liquida recalculado
    INOUT Par_MontoAutorizado	DECIMAL(14,2),	# Monto de capital autorizado (Monto original)
	INOUT Par_PorcGarLiq		DECIMAL(14,2),	# Porcentaje de garantia liquida que se cobrara
	/* Parametros de Auditoria */
    Par_EmpresaID           	INT(11),
    Aud_Usuario             	INT(11),

    Aud_FechaActual         	DATETIME,
    Aud_DireccionIP				VARCHAR(15),
    Aud_ProgramaID          	VARCHAR(50),
    Aud_Sucursal            	INT(11),
    Aud_NumTransaccion      	BIGINT(20)
		)

TerminaStore: BEGIN

	# ---------- Declaracion de variables  -----------
	DECLARE Var_ProducCreditoID		INT;			 -- ID del producto de credito
	DECLARE Var_ClienteID			INT;			 -- ID del cliente
    DECLARE Var_ForCobroComAper		CHAR(1);   		 -- Forma de cobro de la comision por apertura (deduccion, anticipado, financiado)
	DECLARE Var_TipoComXapert		CHAR(1);  		 -- Tipo de cobro por comision por apertura (monto/porcentaje)
	DECLARE Var_MontoComXapert		DECIMAL(12,2);	 -- Monto a cobrar por comision por apertura
	DECLARE Var_MontoMinimo      	DECIMAL(12,2);	 -- Monto minimo permitido por el producto de credito
	DECLARE Var_MontoMaximo        	DECIMAL(12,2);	 -- Monto maximo permitido por el producto de credito
	DECLARE Var_ReqSeguroVida  		CHAR(1); 		 -- Requiere seguro de vida
	DECLARE Var_TipoPagoSeguro     	CHAR(1);		 -- Forma de cobro de seguro de vida del producto cred: Ancipado, deduccion, otro, financiado
	DECLARE Var_FactorRiesgoSeguro 	DECIMAL(12,6);	 -- Factor de riesgo para calculo de cobro de seguro de vida
	DECLARE Var_DescuentoSeguro    	DECIMAL(12,6);	 -- porcentaje Descuento al cobro de seguro de vida
	DECLARE Var_ProspectoID         INT;			 -- ID del prospecto
	DECLARE Var_EsGrupal			CHAR(1); 		 -- Indica si el producto es grupal
	DECLARE Var_TasaPonderaGru		CHAR(1); 		 -- Indica si pordera la Tasa tasa en el grupo grupal
	DECLARE Var_RequiereGarLiq		CHAR(1); 		 -- Indica si requiere garantia liquida
	DECLARE Var_PlazoID 			VARCHAR(20);	 -- Plazo de la solicitud de credito
	DECLARE Var_ModalidadSegVid		CHAR(1); 		 -- Tipo de cobro de seguro de vida (unico/esquemas)
	DECLARE Var_ForCobroSegVida		CHAR(1);   		 -- Forma de cobro de seguro de vida de la solicitud de credito: Ancipado, deduccion, otro, financiado
	DECLARE Var_EsquemaSeguroID		INT;			 -- ID del esquema de seguro de vida
	DECLARE Var_PagaIVA				CHAR(1); 		 -- Indica si el cliente/ prospecto paga iva
	DECLARE Var_SucursalCte  		INT;			 -- Suursal de cliente/prospecto
	DECLARE Var_CalifCliente		CHAR(1); 		 -- Calificacion de cliente/prospecto
	DECLARE Var_IVASucCli       	DECIMAL(12,2);   -- IVA  de la sucursal del cliente
	DECLARE Var_MontoBase			DECIMAL(14,2);	 -- Monto base (monto original)
	DECLARE Var_NumeroDias			INT(10);		 -- Numero dias(del plazo) para el calculo de seguro de vida
	DECLARE Var_PorcentajeGarLiq	DECIMAL(12,4);	 -- Pocentaje de garantia liquida
	DECLARE Var_GrupoID				INT(11);		 -- ID del grupo al que pertenece la solicitud de credito (Si esta es grupal)
	DECLARE Var_CicloCliente		INT(10);		 -- Ciclo del cliente para un producto de credito
	DECLARE Var_CicloGrupal			INT(10);		 -- Ciclo ponderado grual para un producto de credito
	DECLARE Var_NumCiclos			INT(10);		 -- Numero de ciclos
	DECLARE Var_TasaFija			DECIMAL(12,4);   -- Tasa Fija de interes
	DECLARE Var_MontoSeguroNeto		DECIMAL(20,16);	 -- Monto de seguro de vida sin descuento
	DECLARE	Var_CalcInteres			INT(11);		 -- ID Formula Calculo de Intereses (FORMTIPOCALINT)
	DECLARE	Var_InstitucionNominaID	INT(11);
	DECLARE Var_NivelID				INT(11);		 -- Nivel del crédito (NIVELCREDITO).
    DECLARE	Var_ConvenioNominaID	BIGINT UNSIGNED; -- ID Convenio Nomina


	# ---------- Declaracion de constantes  ----------
	DECLARE Entero_Cero   		INT;				-- Entero en cero
	DECLARE Entero_Uno			INT;				-- Constante uno
	DECLARE Decimal_Cero   		DECIMAL(12,2); 	 	-- Decimal cero
	DECLARE Cadena_Vacia  		CHAR(1);			-- cadena vacia
	DECLARE Fecha_Vacia   		DATE;				-- fecha vacia
	DECLARE SalidaNO			CHAR(1);			-- indica no salida
	DECLARE SalidaSI			CHAR(1);			-- Indica salida
	DECLARE SiPagaIVA			CHAR(1);			-- indica si paga iva
	DECLARE NoPagaIVA			CHAR(1);			-- indica que no paga iva
	DECLARE CalifNoAsignada		CHAR(1);			-- Calificacion no asignada
	DECLARE ModalidadEsquema	CHAR(1);			-- Modalidad esquema: T
	DECLARE TipoComMonto    	CHAR(1);			-- Comision por apertura por Monto
	DECLARE TipoComPorcentaje  	CHAR(1);			-- Comision por apertura por porcentaje
	DECLARE ReqSeguroVida		CHAR(1);			-- Si requiere seguros de vida
	DECLARE PagoFinanciado		CHAR(1);			-- Forma de pago F: Financiado
	DECLARE RequiereGarLiq		CHAR(1);			-- Requiere garantia liquida S= si
	DECLARE Grupal_SI			CHAR(1);			-- Es un producto de credito grupal S= Si
	DECLARE PonderaTasa_SI		CHAR(1);			-- Si el producto de credito pondera la tasa en un grupo de creditos S = si
	DECLARE	TasaFijaID			INT(11);			-- ID de la formula para tasa fija (FORMTIPOCALINT)

	DECLARE Var_NCobraComAper		CHAR(1);			-- Variable para almacenar si convenio cobra comisión por apertura
	DECLARE Var_NManejaEsqConvenio	CHAR(1);			-- Variable para almacenar si convenio maneja esquemas de cobro de comisión por apertura
	DECLARE Var_NEsqComApertID		INT(11);			-- Variable para almacenar ID de esquema de cobro de comisión por apertura del convenio
	DECLARE Var_NTipoComApert		CHAR(1);			-- Variable para almacenar Tipo de cobro de comision por apertura del esquema del convenio
	DECLARE Var_NFormCobroComAper	CHAR(1);			-- Variable para almacenar Forma de cobro de comision por apertura del esquema por convenio
	DECLARE Var_NValor				DECIMAL(12,4);		-- Variable para almacenar el valor de comisión por apertura del esquema por convenio

	# ---------- Asignacion de Constantes  ------------
	SET Entero_Cero     	:= 0;
	SET Entero_Uno			:= 1;
	SET Decimal_Cero    	:= 0.0;
	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET SalidaNO        	:= 'N';
	SET SalidaSI        	:= 'S';
	SET SiPagaIVA       	:= 'S';
	SET NoPagaIVA       	:= 'N';
	SET CalifNoAsignada		:= 'N';
	SET ModalidadEsquema	:= 'T';
	SET TipoComMonto    	:= 'M';
	SET TipoComPorcentaje  	:= 'P';
	SET ReqSeguroVida		:= 'S';
	SET PagoFinanciado		:= 'F';
	SET RequiereGarLiq		:= 'S';
	SET Grupal_SI			:= 'S';
	SET PonderaTasa_SI		:= 'S';
	SET TasaFijaID			:= 1;


	# ---- Inicializacion de Parametros de Retorno ----
	SET Par_NumErr      	:= Entero_Cero;
	SET Par_ErrMen      	:= Cadena_Vacia;
	SET Par_ComApertura   	:= Decimal_Cero;
    SET Par_IVAComApertura  := Decimal_Cero;
    SET Par_TasaFija		:= IFNULL(Par_TasaFija,Decimal_Cero);
    SET Par_MontoSeguro   	:= Decimal_Cero;
    SET Par_MontoGarLiq   	:= Decimal_Cero;
    SET Par_MontoAutorizado	:= Decimal_Cero;
    SET Par_PorcGarLiq		:= Decimal_Cero;

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-RECALAUTOSOLCREPRO');
		END;

	# ================ SE OBTIENES LOS VALORES Y CONDICIONES NECESARIOS PARA REALIZAR LOS CALCULOS ==================
	SELECT  Sol.ProductoCreditoID,  	Sol.ClienteID,      	Pro.ForCobroComAper,    	Pro.TipoComXapert,			Pro.MontoComXapert,
			Pro.MontoMinimo,        	Pro.MontoMaximo,        Pro.ReqSeguroVida,  		Pro.TipoPagoSeguro,     	Pro.FactorRiesgoSeguro,
			Pro.DescuentoSeguro,    	Sol.ProspectoID,        Pro.EsGrupal,				Pro.TasaPonderaGru,			Pro.Garantizado,
			Sol.PlazoID, 				Pro.Modalidad,			Sol.ForCobroSegVida,		Pro.EsquemaSeguroID,		Pro.CalcInteres,
			CASE WHEN (Sol.ClienteID >Entero_Cero )	THEN  Cte.PagaIVA 		 ELSE SiPagaIVA END,
			CASE WHEN (Sol.ClienteID >Entero_Cero)	THEN IFNULL(Cte.SucursalOrigen,Cte.Sucursal) ELSE Pros.Sucursal END,
			CASE WHEN (Sol.ClienteID >Entero_Cero) 	THEN Cte.CalificaCredito ELSE Pros.CalificaProspecto END,
            Sol.InstitucionNominaID, IFNULL(Sol.ConvenioNominaID,Entero_Cero)
	INTO
			Var_ProducCreditoID,		Var_ClienteID,  		Var_ForCobroComAper,     	Var_TipoComXapert,			Var_MontoComXapert,
			Var_MontoMinimo,    		Var_MontoMaximo,  		Var_ReqSeguroVida,    		Var_TipoPagoSeguro,			Var_FactorRiesgoSeguro,
			Var_DescuentoSeguro,       	Var_ProspectoID, 		Var_EsGrupal,      			Var_TasaPonderaGru,			Var_RequiereGarLiq,
			Var_PlazoID,    			Var_ModalidadSegVid,	Var_ForCobroSegVida,		Var_EsquemaSeguroID,		Var_CalcInteres,
			Var_PagaIVA,				Var_SucursalCte,		Var_CalifCliente,
            Var_InstitucionNominaID,	Var_ConvenioNominaID
	FROM SOLICITUDCREDITO Sol
		INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID = Sol.ProductoCreditoID
		LEFT JOIN  CLIENTES Cte	 ON Cte.ClienteID = Sol.ClienteID
		LEFT JOIN PROSPECTOS Pros ON Pros.ProspectoID	= Sol.ProspectoID
	WHERE Sol.SolicitudCreditoID = Par_SolicitudCreditoID
		AND Sol.ProductoCreditoID = Pro.ProducCreditoID;

			#Validaciones de esquemas para comision apertura y mora por convneio de nómina
			IF(IFNULL(Var_InstitucionNominaID, Entero_Cero) > Entero_Cero AND IFNULL(Var_ConvenioNominaID, Entero_Cero) > Entero_Cero) THEN

			#Verifica si el convenio cobra comisión por apertura e interes moratorio;
				SELECT CobraComisionApert INTO Var_NCobraComAper FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Var_ConvenioNominaID;
			#Busca esquemas configurados para comision apertura
				IF(Var_NCobraComAper = 'S') THEN

					SELECT 	EsqComApertID,		ManejaEsqConvenio
					INTO 	Var_NEsqComApertID,	Var_NManejaEsqConvenio
					FROM 	ESQCOMAPERNOMINA
					WHERE 	InstitNominaID 		= Var_InstitucionNominaID
					AND		ProducCreditoID		= Var_ProducCreditoID
					LIMIT 1;

					IF(Var_NManejaEsqConvenio = 'S') THEN
						SELECT 		FormCobroComAper,			TipoComApert,			Valor
						INTO 		Var_NFormCobroComAper,		Var_NTipoComApert,		Var_NValor
						FROM	COMAPERTCONVENIO
						WHERE		EsqComApertID = Var_NEsqComApertID
						AND		(ConvenioNominaID = Var_ConvenioNominaID OR ConvenioNominaID = Entero_Cero)
						AND 	PlazoID = Var_PlazoID
						AND		MontoMin <= Par_MontoAutoriza
						AND		MontoMax >= Par_MontoAutoriza LIMIT 1;

						IF( IFNULL(Var_NFormCobroComAper, Cadena_Vacia) = Cadena_Vacia OR	IFNULL(Var_NTipoComApert, Cadena_Vacia) = Cadena_Vacia) THEN
									SET Par_NumErr	:= 008;
									SET Par_ErrMen	:= 'No existe esquema configurado para comisión por apertura, empresa-convenio-plazo-monto';
									LEAVE ManejoErrores;
						ELSE
							SET Var_TipoComXapert := Var_NTipoComApert;
							SET Var_ForCobroComAper := Var_NFormCobroComAper;
							SET Var_MontoComXapert := Var_NValor;
						END IF;
					END IF;

				END IF;
			END IF;


	# ------------- Inicializacion de Variables --------------
	SET Var_ClienteID		:= IFNULL(Var_ClienteID,Entero_Cero );
	SET Var_ProspectoID 	:= IFNULL(Var_ProspectoID, Entero_Cero);
	SET Var_PagaIVA 		:= IFNULL(Var_PagaIVA, Cadena_Vacia);
	SET Var_CalifCliente	:= IFNULL(Var_CalifCliente, CalifNoAsignada);
	SET	Var_RequiereGarLiq	:= IFNULL(Var_RequiereGarLiq, Cadena_Vacia);
	SET Var_MontoBase		:= Par_MontoAutoriza;
	SET Var_CicloCliente	:= Entero_Cero;
    SET Var_CicloGrupal		:= Entero_Cero;




	# Se obtienen los valores cuando el seguro de vida esta parametrizado por esquemas de cobro
	IF(Var_ModalidadSegVid = ModalidadEsquema) THEN
		SELECT  IFNULL(Var_EsquemaSeguroID, Entero_Cero),
				TipoPagoSeguro,				FactorRiesgoSeguro,			DescuentoSeguro
		INTO    Var_EsquemaSeguroID,
				Var_TipoPagoSeguro, 		Var_FactorRiesgoSeguro, 	Var_DescuentoSeguro
		FROM   ESQUEMASEGUROVIDA
		WHERE ProducCreditoID = Var_ProducCreditoID
			   AND TipoPagoSeguro = Var_ForCobroSegVida;
	END IF;


	# si el cliente paga IVA se obtiene el IVA de la sucursal
	IF(Var_PagaIVA = SiPagaIVA) THEN
			SET Var_IVASucCli :=( SELECT  IVA FROM SUCURSALES WHERE SucursalID = Var_SucursalCte);
	ELSE
		SET Var_IVASucCli := Entero_Cero;
	END IF;

	# Si La comision por apertura se cobra por porcentaje se busca el equivalente en decimal
	IF(Var_TipoComXapert = TipoComPorcentaje) THEN
		SET Var_MontoComXapert 	:= Var_MontoComXapert/100;
	ELSE
		SET Par_ComApertura	:= Var_MontoComXapert;
		IF(Var_PagaIVA = SiPagaIVA) THEN
			SET Par_IVAComApertura := IFNULL(Var_MontoComXapert * Var_IVASucCli, Decimal_Cero);
			SET Var_MontoComXapert	:= Var_MontoComXapert + Par_IVAComApertura;
		ELSE
			SET Par_IVAComApertura := Decimal_Cero;
			SET Var_MontoComXapert	:= Var_MontoComXapert;
		END IF;

	END IF;

	# se busca el equivalente en decimal del descuento para el seguro de vida
	SET Var_DescuentoSeguro := Var_DescuentoSeguro/100;




	# ==================================== SE CALCULA EL MONTO BASE (monto original) =======================================
	# CASO 1: El producto de credito cobra seguro de vida
	IF(Var_ReqSeguroVida = ReqSeguroVida) THEN
		SET Var_NumeroDias := (SELECT Dias FROM CREDITOSPLAZOS WHERE PlazoID = Var_PlazoID);

		#CASO 1.1: Tanto el seguro de vida como la comision por apertura se cobra de forma Financiada
		IF(Var_TipoPagoSeguro = PagoFinanciado AND Var_ForCobroComAper = PagoFinanciado)THEN
				# Caso 1.1.1 La comision por apertura se cobra por porcentaje
				IF(Var_TipoComXapert = TipoComPorcentaje) THEN
						SET Var_MontoBase := Par_MontoAutoriza /
											  (Entero_Uno + Var_MontoComXapert + (Var_MontoComXapert * Var_IVASucCli) +
												   (   (Var_FactorRiesgoSeguro / 7) * Var_NumeroDias *
															(Entero_Uno - Var_DescuentoSeguro)
												   )
											   );
				# Caso 1.1.2 La comision por apertura se cobra por monto
				ELSE IF(Var_TipoComXapert = TipoComMonto) THEN
						SET Par_MontoAutoriza := Par_MontoAutoriza - Var_MontoComXapert;
						SET Var_MontoBase 	  := Par_MontoAutoriza /
													  (Entero_Uno +
														   (   (Var_FactorRiesgoSeguro / 7) * Var_NumeroDias *
																	(Entero_Uno - Var_DescuentoSeguro)
														   )
													   );
					 END IF;

				END IF;


		# CASO 1.2: Solo el seguro de vida se cobra de forma Financiada
		ELSE IF(Var_TipoPagoSeguro = PagoFinanciado)THEN
					SET Var_MontoBase := Par_MontoAutoriza /
									  (Entero_Uno +
										   (   (Var_FactorRiesgoSeguro / 7) * Var_NumeroDias *
													(Entero_Uno - Var_DescuentoSeguro)
										   )
									   );

			 # CASO 1.3: Solo la comision por apertura se cobra de forma Financiada
			 ELSE IF (Var_ForCobroComAper = PagoFinanciado)THEN
						# Caso 1.3.1 La comision por apertura se cobra por porcentaje
						IF(Var_TipoComXapert = TipoComPorcentaje) THEN
								SET Var_MontoBase := Par_MontoAutoriza /
														(Entero_Uno + Var_MontoComXapert + (Var_MontoComXapert * Var_IVASucCli) );

						# Caso 1.3.2 La comision por apertura se cobra por monto
						ELSE IF(Var_TipoComXapert = TipoComMonto) THEN
								SET Var_MontoBase := Par_MontoAutoriza - Var_MontoComXapert;
							 END IF;

						END IF;

				  END IF; # Fin de caso 1.3
			 END IF; # Fin caso 1.2
		END IF; # Fin de caso 1.1


	# CASO 2: El producto No cobra seguro
	ELSE
		# Caso 2.1 Solo cobra comision apertura de forma Financiada
		IF (Var_ForCobroComAper = PagoFinanciado)THEN
				# Caso 2.1.1 La comision por apertura se cobra por porcentaje
				IF(Var_TipoComXapert = TipoComPorcentaje) THEN
						SET Var_MontoBase := Par_MontoAutoriza /
												(Entero_Uno + Var_MontoComXapert + (Var_MontoComXapert * Var_IVASucCli) );

				# Caso 2.1.2 La comision por apertura se cobra por monto
				ELSE IF(Var_TipoComXapert = TipoComMonto) THEN
						SET Var_MontoBase := Par_MontoAutoriza - Var_MontoComXapert;
					 END IF;

				END IF;

		 END IF; # Fin Caso 2
	END IF; # Fin de Caso 1

	SET Par_MontoAutorizado	:= Var_MontoBase;





	# ========================= SE CALCULA LA COMISION POR APERTURA + IVA POR COMISION POR APERTURA ===========================
	IF(Var_TipoComXapert = TipoComPorcentaje) THEN
		SET Par_ComApertura := Var_MontoBase * Var_MontoComXapert;

		IF (Var_PagaIVA = SiPagaIVA) THEN
			SET Par_IVAComApertura := Par_ComApertura * Var_IVASucCli;
		ELSE
			SET Par_IVAComApertura := Decimal_Cero;
		END IF;

	ELSE IF(Var_TipoComXapert = TipoComMonto) THEN
			SET Par_ComApertura := Var_MontoComXapert - Par_IVAComApertura; # Se le resta el iva xq al principio ya se le habia sumado para poder calcular el monto original
		 END IF;
	END IF;

	# Si la forma de cobro de comision por apertura es por Financiamiento  (incrementa el monto base de credito)
	IF (Var_ForCobroComAper = PagoFinanciado)THEN
		IF(Var_TipoComXapert = TipoComPorcentaje) THEN
			SET Par_MontoAutorizado := Par_MontoAutorizado + Par_ComApertura + Par_IVAComApertura;
		ELSE # Si es por monto
			SET Par_MontoAutorizado := Par_MontoAutorizado + Par_ComApertura + Par_IVAComApertura;
		END IF;
	END IF;





	# =========================================== CALCULO DEL MONTO DE SEGURO DE VIDA ===========================================
	IF(Var_ReqSeguroVida = ReqSeguroVida) THEN
		SET Var_NumeroDias := (SELECT Dias FROM CREDITOSPLAZOS WHERE PlazoID = Var_PlazoID);

		SET Var_MontoSeguroNeto := (Var_FactorRiesgoSeguro / 7) * (Var_MontoBase * Var_NumeroDias);
	 	SET Par_MontoSeguro := Var_MontoSeguroNeto - (Var_MontoSeguroNeto * Var_DescuentoSeguro);
	END IF;

	# Si la forma de cobro del Seguro es por Financiamiento  (incrementa el monto de credito)
	IF(Var_TipoPagoSeguro = PagoFinanciado)THEN
		SET Par_MontoAutorizado := Par_MontoAutorizado + Par_MontoSeguro;
	END IF;





	# =============================================== CALCULO DE GARANTIA LIQUIDA =================================================
	IF(Var_RequiereGarLiq = RequiereGarLiq) THEN

		SELECT Porcentaje INTO Var_PorcentajeGarLiq
		FROM ESQUEMAGARANTIALIQ
		WHERE ProducCreditoID = Var_ProducCreditoID
			  AND LimiteInferior <= Par_MontoAutorizado
			  AND LimiteSuperior >= Par_MontoAutorizado
			  AND Clasificacion = Var_CalifCliente
		LIMIT 1;

		SET Var_PorcentajeGarLiq = IFNULL(Var_PorcentajeGarLiq, -1);

		# Verifica que exista una esquema de Garantia Liquida para el monto de la Solicitud
		IF(Var_PorcentajeGarLiq < Decimal_Cero ) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= CONCAT('No Existe un Esquema de Garantia Liquida para las Condiciones de la Solicitud.');
			LEAVE ManejoErrores;
		END IF;

		SET Par_PorcGarLiq	:= Var_PorcentajeGarLiq;
		SET Par_MontoGarLiq := (Par_MontoAutorizado * Var_PorcentajeGarLiq ) / 100;

	END IF;







	# ============================================= CALCULO DE LA TASA DE INTERES ==================================================
	IF(Var_EsGrupal = Grupal_SI) THEN
		SET Var_GrupoID  := IFNULL((SELECT GrupoID FROM INTEGRAGRUPOSCRE WHERE SolicitudCreditoID = Par_SolicitudCreditoID), Entero_Cero);
	END IF;


	# Consultamos el Numero de Ciclos(Creditos) que ha tenido del mismo producto que sera unos de los inputs para el Esquema de Tasas
	CALL CRECALCULOCICLOPRO(
		Var_ClienteID,      	Var_ProspectoID,    Var_ProducCreditoID,    Var_GrupoID,    	Var_CicloCliente,
		Var_CicloGrupal, 		SalidaNO,           Par_EmpresaID,      	Aud_Usuario,    	Aud_FechaActual,
		Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,       	Aud_NumTransaccion  );


	IF(Var_EsGrupal = Grupal_SI AND Var_TasaPonderaGru = PonderaTasa_SI) THEN
		SET Var_NumCiclos   := Var_CicloGrupal;
	ELSE
		SET Var_NumCiclos   := Var_CicloCliente;
	END IF;

	# Verifica que exista una tasa de interes para el monto de la Solicitud
	CALL ESQUEMATASACALPRO(
		Par_SucursalCte,    Var_ProducCreditoID,    Var_NumCiclos,      Par_MontoAutorizado, 	Var_CalifCliente,
		Var_TasaFija,       Var_PlazoID,			Var_InstitucionNominaID,Var_ConvenioNominaID,Var_NivelID,
		SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
        Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	    	Aud_NumTransaccion  );

	SET Var_TasaFija    := IFNULL(Var_TasaFija, Decimal_Cero);

	IF(Var_TasaFija <= Decimal_Cero ) THEN
		-- Si el calculo de los intereses es por tasa fija
		IF(Var_CalcInteres=TasaFijaID)THEN
			SET Par_ErrMen := 'No Existe un Esquema de Tasas para las Condiciones de la Solicitud.';
		ELSE -- Si es por tasa Variable
			SET Par_ErrMen := 'No Existe una Tasa Base Registrada para el Mes Anterior.';
		END IF;
		SET Par_NumErr := 5;
		LEAVE ManejoErrores;
	END IF;

	# ================= VALIDA QUE EL MONTO AUTORIZADO ESTE DENTRO DE LOS LIMITES PERMITIDOS POR EL PRODUCTO DE CREDITO =================
	IF(Par_MontoAutorizado < Var_MontoMinimo ) THEN
		SET Par_NumErr := 6;
		SET	Par_ErrMen := CONCAT('El Monto de la Solicitud ',CONVERT(Par_SolicitudCreditoID, CHAR) ,' No Debe ser Menor a ', CONVERT(Var_MontoMinimo, CHAR(20)));
		LEAVE ManejoErrores;
	END IF;

	IF(Par_MontoAutorizado > Var_MontoMaximo ) THEN
		SET Par_NumErr := 7;
		SET	Par_ErrMen := CONCAT('El Monto de la Solicitud ',CONVERT(Par_SolicitudCreditoID, CHAR) ,'  No Debe ser Mayor a ', CONVERT(Var_MontoMaximo, CHAR(20)));
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := 'Informacion Actualizada Exitosamente.';

END ManejoErrores;

IF(Par_Salida = SalidaSI)THEN
	SELECT  Par_NumErr 		AS NumErr,
            Par_ErrMen 		AS ErrMen,
            Cadena_Vacia 	AS Control,
            Entero_Cero 	AS Consecutivo;
END IF;

END TerminaStore$$