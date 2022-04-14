-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREGENAMORTIZAAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREGENAMORTIZAAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `CREGENAMORTIZAAGROPRO`(
	/*SP QUE SE LLAMA EN EL PROCESO DEL PAGARE DE CREDITOS AGROPECUARIOS, DA DE ALTA LAS AMORTIZACIONES DEL CREDITO ACTIVO
	Y CREDITO PASIVO ACTUALIZA EL ESTATUS DE CREDITO DEL PAGARE*/
	Par_CreditoID			BIGINT(12),			# ID del credito
	Par_FecMinist			DATE,				# Fecha de desembolso
	Par_FechaInicioAmor		DATE,				# Fecha de inicio de las amortizaciones
	Par_TipoPrepago			CHAR(1),			# Tipo de prepago
	Par_Salida				CHAR(1),			# Salida S:Si N:No

	INOUT Par_NumErr		INT(11),			# Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_EstCredito		CHAR(1);		-- Estatus del Credito
	DECLARE Var_FecInicio		DATE;			-- Fecha de inicio del credito
	DECLARE Var_FecTermin		DATE;			-- Fecha Fin del Credito
	DECLARE Var_Monto			DECIMAL(12,2);	-- Variables para el Simulador
	DECLARE Var_TasaFija		DECIMAL(12,4);	-- Tasa Fija
	DECLARE Var_PeriodCap		INT(11);		-- Periodo Capital
	DECLARE Var_PeriodInt		INT(11);		-- Periodo Interes
	DECLARE Var_FrecCap			CHAR(1);		-- Frecuencia Capital
	DECLARE Var_FrecInter		CHAR(1);		-- Frecuencia de Interes
	DECLARE Var_DiaPagCap		CHAR(1);		-- Dia pago Capital
	DECLARE Var_DiaPagIn		CHAR(1);		-- Dia pago Interes
	DECLARE Var_DiaMesCap		INT(11);		-- Dia mes Capital
	DECLARE Var_DiaMesIn		INT(11);		-- Dia mes Interes
	DECLARE Var_FechaIni		DATE;			-- Fecha de Inicio
	DECLARE Var_FechInha		CHAR(1);		-- Fecha inhabil
	DECLARE Var_NumAmorti		INT(11);		-- Numero de Amortizacion
	DECLARE Var_AjFeUlVA		CHAR(1);		-- Ajusta Fecha Ultima Amortizacion
	DECLARE Var_AjFecExV		CHAR(1);		-- Ajusta Fecha Vencimiento
	DECLARE Var_CalcInter		INT(11);		-- Calculo de Interes
	DECLARE Var_TipoPagCap		CHAR(1);		-- Tipo de Pago Capital
	DECLARE Var_Producto		INT(11);		-- Tipo de Producto de Credito
	DECLARE Var_Cliente			INT(11);		-- Numero de Cliente
	DECLARE Var_MonComA			DECIMAL(12,4);	-- monto Acomulado
	DECLARE Var_FechaSis		DATE;			-- Fecha de Sistema
	DECLARE Var_Dia				INT(11);		-- Dia
	DECLARE Var_Cuenta			BIGINT(12);		-- Cuenta del Credito
	DECLARE Var_MontoCre		DECIMAL(12,2);	-- Monto del Credito
	DECLARE Var_TipoCalIn		INT(11);		-- Tipo de Calculo Interes
	DECLARE Var_NumAmoInt		INT(11);		-- Numero de Amortizaciones de Interes
	DECLARE Var_Cuotas			INT(11);		-- Numero de Cuotas
	DECLARE Var_CuotasInt		INT(11);		-- Numero de Cuotas de Interes
	DECLARE Var_NumDias			INT(10);		-- Numero de Dias
	DECLARE Var_SalidaFecha		DATE;			-- Fecha de Salida
	DECLARE Var_EsHabil			CHAR(1);		-- Es dia Habil
	DECLARE varControl 		 	CHAR(20);		-- almacena el elmento que es incorrecto
	DECLARE Var_Garantia 		DECIMAL(12,2); 	-- Almacena el valor de la garantia liquida
	DECLARE Var_EsAgropecuario 	CHAR(1);		-- Tipo de Credito Agro

	#SEGUROS -------------------------------------------------------------------------------
	DECLARE Var_CobraSeguroCuota CHAR(1);			-- Cobra Seguro por cuota
	DECLARE Var_CobraIVASeguroCuota CHAR(1);		-- Cobra IVA seguro por cuota
	DECLARE Var_MontoSeguroCuota DECIMAL(12,2);		-- Cobra seguro por cuota el credito


	DECLARE Var_TasaBase		INT(11);		-- Tasa Base de credito
	DECLARE Var_ValorTasa		DECIMAL(12,4);	-- Valor de la tasa
	DECLARE Var_SobreTasa		DECIMAL(12,4);	-- Sobre tasa del Credito
	DECLARE Var_TasaBPuntos 	DECIMAL(12,4); -- Variable para la tasa base mas puntos

	-- Valores a enviar al simulador
	DECLARE	Par_ValorCAT		DECIMAL(14,4);-- Valor del Cat
	DECLARE	Par_NumTransSim		BIGINT(10);	-- Numero de Transaccion de Simulacion
	DECLARE	Var_NumCuotas		INT(11);	-- Numero de Cuotas de Capital
	DECLARE	Var_NumCuotInt		INT(11);	-- Numero de Cuotas de Interes
	DECLARE	Par_MontoCuo		DECIMAL(14,4);-- Monto de la Cuota
	DECLARE	Par_FechaVen		DATE;		-- Fecha de Vencimiento
	DECLARE	Var_NumTransacSim	BIGINT(20);	-- Numero de Transaccion de Simulacion

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;		-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);	-- Constante Entero Cero
	DECLARE Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
	DECLARE Cre_Autorizado		CHAR(1);	-- Estatus del Credito Autorizado
	DECLARE Cre_Inactivo		CHAR(1);	-- Estatus del Credito Inactivo
	DECLARE Cre_Procesado		CHAR(1);	-- Estatus del Credito Procesado
	DECLARE SalidaNO			CHAR(1);	-- Constante Salida NO
	DECLARE SalidaSI			CHAR(1);	-- Constante Salida SI
	DECLARE TasFija				INT(11);	-- Tasa Fija
	DECLARE PagCrecientes		CHAR(1);	-- Tipo de Pago Creciente
	DECLARE PagIguales			CHAR(1);	-- Tipo de Pago Iguales
	DECLARE PagLibres			CHAR(1);	-- Pagos Libres
	DECLARE FrecMensual			CHAR(1);	-- Frecuencia Mensual
	DECLARE DiaAniversario		CHAR(1);	-- Dia Aniversario
	DECLARE Act_CreditoAmor		INT(11);	-- Tipo de Actualizacion del Credito: Amortizaciones
	DECLARE Var_SI				CHAR(1);	-- Variable Constante SI
	DECLARE TipoCalIntGlo		INT(11);	-- Tipo de Calculo Interes Globales
	DECLARE Var_Aniversario		CHAR(1);	-- dia de pago por ANIVERSARIO
	DECLARE Var_DiaDelMes		CHAR(1);	-- dia de pago por DIA DEL MES
	DECLARE Var_Indistinto		CHAR(1);	-- dia de pago por INDISTINTO
	DECLARE Var_Capital			CHAR(1);	-- Monto de Capital
	DECLARE Var_Interes			CHAR(1);	-- Monto de Interes
	DECLARE Var_CapInt			CHAR(1);	-- Monto de Capital mas Interes
	DECLARE Var_MontoSeguro		DECIMAL(12,2);-- Monto de Seguro
	DECLARE NoHabil				CHAR(1);	-- Dia No Habil
	DECLARE CalendarioNormal	INT(11);	-- Calendario Normal
	DECLARE Con_SI 				CHAR(1);	-- Constante SI
	DECLARE Con_NO 				CHAR(1);	-- Constante NO
    DECLARE Var_SaldoRenovar	DECIMAL(16,2);
    DECLARE Var_SolicitudCreditoID BIGINT(20);
	DECLARE Var_Relacionado		BIGINT(20);

	-- Asignacion de Constantes
	SET Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero		:= 0;			-- Entero en Cero
	SET Cadena_Vacia	:= '';			-- String o Cadena Vacia
	SET Cre_Autorizado	:= 'A';			-- Estatus del Credito Autorizado
	SET Cre_Inactivo	:= 'I';			-- Estatus del Credito Inactivo o Recien Creado
	SET Cre_Procesado	:= 'M';			-- Estatus del Credito Procesado(Procesado en el Monitor de Creditos)
	SET SalidaNO		:= 'N';			-- El store NO Genera Salida
	SET SalidaSI		:= 'S';			-- El store SI Genera Salida
	SET TasFija			:= 1;			-- TasaFija
	SET PagCrecientes	:= 'C';			-- Pago de capital crecientes
	SET PagIguales		:= 'I';			-- Pago de capital iguales
	SET PagLibres		:= 'L';			-- Pagos de capital Libre
	SET FrecMensual		:= 'M';			-- Frecuencia de Pagos: Mensual
	SET DiaAniversario	:= 'A';			-- Dia de Pago en Mensuales: Aniversario
	SET Act_CreditoAmor	:= 2; 			-- Tipo de Actualizacion del Credito: Amortizaciones
	SET Var_SI			:= 'S';			-- Constante SI
	SET TipoCalIntGlo	:= 2;			-- tipo calculo interes Monto Original (Saldos Globales)
	SET Var_Aniversario	:= 'A';			-- Dia de pago ANIVERSARIO
	SET Var_DiaDelMes	:= 'D';			-- dia de pago por DIA DEL MES
	SET Var_Indistinto	:= 'I';			-- dia de pago por INDISTINTO
	SET Var_Capital		:= 'C';
	SET Var_Interes		:= 'I';
	SET Var_CapInt		:= 'G';
	SET NoHabil			:= 'N';
	SET CalendarioNormal := 1;
	SET Con_SI 			:= 'S';
	SET Con_NO 			:= 'N';

	SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);

	SET Par_NumErr		:= Entero_Cero;
	SET Par_ErrMen		:= "";
	SET Par_ValorCAT	:= 0.0;
	SET Par_NumTransSim	:= Entero_Cero;
	SET Var_NumCuotas	:= 0;
	SET Var_NumCuotInt	:= 0;


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREGENAMORTIZAAGROPRO');
			SET varControl := 'sqlexception';
		END;

		-- obtencion de valores a enviar al simulador
		SELECT
			MontoCredito,		TasaFija,			PeriodicidadCap,	PeriodicidadInt,	FrecuenciaCap,
			FrecuenciaInt,		DiaPagoCapital,		DiaPagoInteres,		DiaMesCapital,		DiaMesInteres,
			FechaInicio,		FechaInhabil,		NumAmortizacion, 	AjusFecUlVenAmo,	AjusFecExiVen,
			CalcInteresID,		TipoPagoCapital,	ProductoCreditoID,	ClienteID,			MontoComApert,
			CuentaID,			MontoCredito,		TipoCalInteres,		NumAmortInteres,	Estatus,
			NumTransacSim, 		TasaBase, 			SobreTasa, 			CobraSeguroCuota, CobraIVASeguroCuota,
			MontoSeguroCuota,	EsAgropecuario
			INTO
			Var_Monto,			Var_TasaFija,		Var_PeriodCap,		Var_PeriodInt,		Var_FrecCap,
			Var_FrecInter,		Var_DiaPagCap,		Var_DiaPagIn,		Var_DiaMesCap,		Var_DiaMesIn,
			Var_FechaIni,		Var_FechInha,		Var_NumAmorti,		Var_AjFeUlVA,		Var_AjFecExV,
			Var_CalcInter,		Var_TipoPagCap,		Var_Producto,		Var_Cliente,		Var_MonComA,
			Var_Cuenta,			Var_MontoCre,		Var_TipoCalIn,		Var_NumAmoInt,		Var_EstCredito,
			Var_NumTransacSim,	Var_TasaBase,		Var_SobreTasa,		Var_CobraSeguroCuota, Var_CobraIVASeguroCuota,
			Var_MontoSeguroCuota,Var_EsAgropecuario
			FROM	CREDITOS
				WHERE CreditoID = Par_CreditoID;

		SET Var_CobraSeguroCuota	:= IFNULL(Var_CobraSeguroCuota, 'N');
		SET Var_CobraIVASeguroCuota	:= IFNULL(Var_CobraIVASeguroCuota, 'N');
		SET Var_MontoSeguroCuota	:= IFNULL(Var_MontoSeguroCuota, Entero_Cero);

		IF(Var_EstCredito != Cre_Autorizado AND Var_EstCredito != Cre_Inactivo AND Var_EstCredito != Cre_Procesado) THEN
			SET Par_NumErr := 1;
			SET	Par_ErrMen := CONCAT('El Credito ', CONVERT(Par_CreditoID, CHAR),' No esta Autorizado o Activo.');
			SET varControl := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FecMinist,Fecha_Vacia)) = Fecha_Vacia THEN
				SET Par_NumErr	:=2;
				SET Par_ErrMen	:='La Fecha de Desembolso esta Vacia.';
				SET varControl 	:= 'fechaMinistrado';
				LEAVE ManejoErrores;
			ELSE
			-- Verifica que la fecha de desembolso NO sea un dia ihabil
			CALL DIASFESTIVOSCAL(
				Par_FecMinist,			Entero_Cero,			Var_SalidaFecha,		Var_EsHabil,		Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Var_EsHabil = NoHabil)THEN
				SET Par_NumErr	:= 3;
				SET Par_ErrMen	:='La Fecha de Desembolso es Dia Inhabil.';
				SET varControl	:= 'fechaMinistrado';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF( IFNULL(Var_EsAgropecuario, Con_SI) = Con_NO ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('El Cr&eacute;dito ', CONVERT(Par_CreditoID, CHAR),' No es de tipo Agropecuario.');
			SET varControl	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT SolicitudCreditoID INTO Var_SolicitudCreditoID  FROM CREDITOS WHERE CreditoID = Par_CreditoID;
		SELECT Relacionado INTO Var_Relacionado FROM SOLICITUDCREDITO WHERE SolicitudCreditoID =  Var_SolicitudCreditoID; 

		SET Var_SolicitudCreditoID := IFNULL(Var_SolicitudCreditoID,Entero_Cero);
		SET Var_Relacionado	:= IFNULL(Var_Relacionado,Entero_Cero);

		SELECT  FNTOTALADEUDORENOVACION(Var_Relacionado) INTO Var_SaldoRenovar;
		SET Var_SaldoRenovar  := IFNULL(Var_SaldoRenovar, Entero_Cero);

		IF(Var_Monto < Var_SaldoRenovar) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= CONCAT('El Monto del Credito ',FORMAT(Var_Monto,2),' es Menor al Total del Adeudo ',FORMAT(Var_SaldoRenovar,2),' del Credito a Renovar.');
			LEAVE ManejoErrores;
		END IF;

		-- ========================== inicia la simulacion de amortizaciones ==============================
		-- Valida el dia de pago del capital, puede ser por ANIVERSARIO, INDISTINTO O DIA DEL MES.
		CASE Var_DiaPagCap
			WHEN Var_Aniversario	THEN SET Var_DiaMesCap	:= DAY(Par_FechaInicioAmor);
			WHEN Var_DiaDelMes		THEN SET Var_DiaMesCap	:= IFNULL(Var_DiaMesCap, DAY(Par_FechaInicioAmor));
			WHEN Var_Indistinto		THEN SET Var_DiaMesCap	:= IFNULL(Var_DiaMesCap, DAY(Par_FechaInicioAmor));
			ELSE SET Var_DiaMesCap	:= DAY(Par_FechaInicioAmor);
		END CASE ;

		-- Valida el dia de pago del interes, puede ser por ANIVERSARIO, INDISTINTO O DIA DEL MES.
		CASE Var_DiaPagIn
			WHEN Var_Aniversario	THEN SET Var_DiaMesIn	:= DAY(Par_FechaInicioAmor);
			WHEN Var_DiaDelMes		THEN SET Var_DiaMesIn	:= IFNULL(Var_DiaMesIn, DAY(Par_FechaInicioAmor));
			WHEN Var_Indistinto		THEN SET Var_DiaMesIn	:= IFNULL(Var_DiaMesIn, DAY(Par_FechaInicioAmor));
			ELSE SET Var_DiaMesIn	:= DAY(Par_FechaInicioAmor);
		END CASE ;

		IF(Var_CalcInter = TasFija ) THEN
			SELECT AporteCliente INTO Var_Garantia FROM CREDITOS WHERE CreditoID = Par_CreditoID;
			CASE Var_TipoPagCap
				WHEN PagLibres THEN
					CALL PAGAMORLIBPRO(
						Var_NumTransacSim,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					SET Par_NumTransSim := Var_NumTransacSim;
					SELECT ValorCAT INTO Par_ValorCAT FROM CREDITOS WHERE CreditoID = Par_CreditoID;
				ELSE
					SELECT ValorCAT INTO Par_ValorCAT FROM CREDITOS WHERE CreditoID = Par_CreditoID;
			END CASE ;
		END IF; -- fin if(Var_CalcInter = TasFija ) THEN

		-- verifica que no hubo error en la simulacion
		IF(Par_NumErr != Entero_Cero ) THEN
			SET varControl 	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF; -- fin if(Par_NumErr != Entero_Cero )


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen	:= Cadena_Vacia;

		-- llama al sp que Graba las amortizaciones temporales en la tabla de amortizaciones definitivas
		CALL AMORTICREDITOAGROALT (
			Par_CreditoID,		Par_NumTransSim,	Var_Cliente,		Var_Cuenta,			Var_MontoCre,
			CalendarioNormal,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		-- verifica que no exista ningun error al dar de alta las amortizaciones
		IF(Par_NumErr != Entero_Cero ) THEN
			SET varControl 	:= 'creditoID';

			-- Elimina amortizaciones temporales si no se trata de un pago de capital libre
			IF(Var_TipoPagCap != PagLibres) THEN
				DELETE
					FROM TMPPAGAMORSIM
					WHERE NumTransaccion= Par_NumTransSim;
			END IF;
			LEAVE ManejoErrores;
		END IF; -- fin if(Par_NumErr != Entero_Cero )


		IF(Par_NumErr = Entero_Cero ) THEN

			-- Elimina amortizaciones temporales si no se trata de un pago de capital libre
			IF(Var_TipoPagCap != PagLibres) THEN
				DELETE
					FROM TMPPAGAMORSIM
					WHERE NumTransaccion= Par_NumTransSim;
			ELSE
				SET Var_Cuotas		:= (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Capital OR Tmp_CapInt = Var_CapInt) AND NumTransaccion=Par_NumTransSim);
				SET Var_CuotasInt	:= (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Interes OR Tmp_CapInt = Var_CapInt) AND NumTransaccion=Par_NumTransSim);
				UPDATE CREDITOS SET
					NumAmortizacion	= Var_Cuotas,
					NumAmortInteres	= Var_CuotasInt
				WHERE CreditoID = Par_CreditoID;
			END IF;

			UPDATE CREDITOS SET
				FechaInicio 	= Par_FechaInicioAmor,
				DiaMesCapital	= Var_DiaMesCap,
				DiaMesInteres	= Var_DiaMesIn,
				FechaInicioAmor = Par_FechaInicioAmor
			WHERE CreditoID = Par_CreditoID;

			SELECT
				MIN(FechaInicio), 	MAX(FechaVencim)
				INTO
				Var_FecInicio,		Var_FecTermin
				FROM AMORTICREDITOAGRO WHERE CreditoID= Par_CreditoID;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := Cadena_Vacia;
			CALL CREDITOSACT(
				Par_CreditoID,			Par_NumTransSim,	Fecha_Vacia,		Entero_Cero,		Act_CreditoAmor,
				Par_FecMinist,			Var_FecTermin,		Par_ValorCAT,	 	Entero_Cero,		Entero_Cero,
				Cadena_Vacia,			Par_TipoPrepago,    Entero_Cero,		SalidaNO,			Par_NumErr,
				Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal, 		Aud_NumTransaccion);

			-- Actualiza la Fecha Inicio y Fecha de Vencimiento en la tabla SEGUROVIDA
			SET Aud_FechaActual := NOW();
			UPDATE SEGUROVIDA Seg
				INNER JOIN CREDITOS Cre
				ON(Seg.CreditoID = Cre.CreditoID)
			SET Seg.FechaInicio 		= Var_FecInicio,
				Seg.FechaVencimiento 	= Var_FecTermin,

				Seg.EmpresaID 			= Aud_EmpresaID,
				Seg.Usuario				= Aud_Usuario,
				Seg.FechaActual 		= Aud_FechaActual,
				Seg.DireccionIP 		= Aud_DireccionIP,
				Seg.ProgramaID 			= Aud_ProgramaID,
				Seg.Sucursal			= Aud_Sucursal,
				Seg.NumTransaccion		= Aud_NumTransaccion
			WHERE Seg.CreditoID 		= Par_CreditoID
					AND Cre.Estatus IN (Cre_Inactivo,Cre_Autorizado, Cre_Procesado);

			-- verifica que no exista nungun error al actualizar el credito
			IF(Par_NumErr != Entero_Cero ) THEN
				SET varControl 	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF; -- fin if(Par_NumErr = Entero_Cero )


		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Pagar&eacute; de Cr&eacute;dito Grabado Exitosamente: ', Par_CreditoID);
		SET varControl 	:= 'exportarPDF';
	END ManejoErrores; -- End del Handler de Errores


	 IF (Par_Salida = SalidaSI) THEN
		SELECT CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				varControl 		AS control,
				Entero_Cero 	AS consecutivo;
	 END IF;

END TerminaStore$$