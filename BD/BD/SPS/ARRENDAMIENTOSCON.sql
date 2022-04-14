-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAMIENTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAMIENTOSCON`;DELIMITER $$

CREATE PROCEDURE `ARRENDAMIENTOSCON`(
-- STORED PROCEDURE PARA LA CONSULTA DE ARRENDAMIENTOS
	Par_ArrendaID			BIGINT(12),				-- Id del arrendamiento
	Par_NumCon				TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID			INT(11),				-- Id de la empresa
	Aud_Usuario				INT(11),				-- Usuario
	Aud_FechaActual			DATETIME,				-- Fecha actual
	Aud_DireccionIP 		VARCHAR(15),			-- Direccion IP
	Aud_ProgramaID 			VARCHAR(50),			-- Id del programa
	Aud_Sucursal 			INT(11),				-- Numero de sucursal
	Aud_NumTransaccion 		BIGINT(20)				-- Numero de transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);			-- Constante de entero cero
	DECLARE Con_Principal	INT(11);			-- Consulta principal
	DECLARE Decimal_Cero	DECIMAL(14,4);		-- Decimal cero
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena vacia

	--  Declaracion de Constantes. Cardinal Sistemas Inteligentes
	DECLARE Con_Generales			INT(11);		-- Consulta para la pantalla de pago de arrendamiento.
	DECLARE Con_Producto			INT(11);		-- Consulta para el detalle de producto de arrendamiento.
	DECLARE Est_DesGenerado			VARCHAR(50);	-- Descripcion de Estatus Generado
	DECLARE Est_DesAutorizado		VARCHAR(50);	-- Descripcion de Estatus Autorizado
	DECLARE Est_DesCancelado		VARCHAR(50);	-- Descripcion de Estatus Cancelado
	DECLARE Est_DesVigente			VARCHAR(50);	-- Descripcion de Estatus Vigente
	DECLARE Est_DesVencido			VARCHAR(50);	-- Descripcion de Estatus Vencido
	DECLARE Est_DesPagado			VARCHAR(50);	-- Descripcion de Estatus Pagado

	DECLARE Est_Generado			CHAR(1);		-- Estatus Generado
	DECLARE Est_Autorizado			CHAR(1);		-- Estatus Autorizado
	DECLARE Est_Cancelado			CHAR(1);		-- Estatus Cancelado
	DECLARE Est_Vigente				CHAR(1);		-- Estatus Vigente
	DECLARE Est_Vencido				CHAR(1);		-- Estatus Vencido
	DECLARE Est_Pagado				CHAR(1);		-- Estatus Pagado

	DECLARE Con_NumArrenda			INT(11);		-- Consulta por ArrendamientoID para la pantalla de pagare de arrendamiento).
	DECLARE EstatusPagado			CHAR(1);		-- Estatus pagado de tabla de arrendamiento
	DECLARE Fecha_Vacia     		DATE;

	DECLARE Var_NoAplica			VARCHAR(50);	-- No Aplica
	DECLARE Var_TipoFinanciero		VARCHAR(50);	-- Descripcion del tipo de arrendamiento Financiero
	DECLARE Var_TipoPuro			VARCHAR(50);	-- Descripcion del tipo de arrendamiento Puro
	DECLARE Var_Financiero			CHAR(1);		-- Tipo de arrendamiento Financiero
	DECLARE Var_Puro				CHAR(1);		-- Tipo de arrendamiento Puro

	DECLARE Var_FecActual			DATE;			-- Fecha Actual del sistema
	DECLARE Var_FechaVencim			DATE;			-- Fecha de vencimiento del arrendamiento
	DECLARE Var_diasFaltaPago 	 	INT(11);		-- Dias para el proximo pago
	DECLARE Var_FecProxPago			DATE;			-- Fecha del proximo pago

	DECLARE Var_Contado				INT(11);		-- Tipo de pago de contado
	DECLARE Var_Financiado			INT(11);		-- Tipo de pago financiado
	DECLARE Var_DesContado			VARCHAR(50);	-- Descripcion del tipo de pago de contado
	DECLARE Var_DesFinanciado		VARCHAR(50);	-- Descripcion del tipo de pago financiado
	DECLARE Var_Frecuencia			CHAR(1);		-- Frecuencia de pago o periodicidad

	DECLARE Var_DesFrecuencia		VARCHAR(50);	-- Descripcion de la frecuencia de pago o periodicidad
	DECLARE Var_DiaPagoFinMes		CHAR(1);		-- Dia de pago Fin de mes
	DECLARE Var_DiaPagoAniver		CHAR(1);		-- Dia de pago Aniversario
	DECLARE Var_DesPagoFinMes		VARCHAR(50);	-- Descripcion dia de pago Fin de mes
	DECLARE Var_DesPagoAniver		VARCHAR(50);	-- Descripcion dia de pago Aniversario

	DECLARE Var_SucCliente			INT(11);		-- Numero de sucursal del cliente del arrendamiento

    DECLARE Var_MontoSegAnual		DECIMAL(14, 4);	-- Monto de Seguro Anual
	DECLARE Var_MontoSegVidaAnual	DECIMAL(14, 4);	-- Monto del Seguro de Vida Anual
	DECLARE Var_TipoSegAnual		CHAR(1);		-- Tipo del seguro anual (financido o de contado)
    DECLARE Var_TipoSegVidaAnual	CHAR(1);		-- Tipo del seguro de vida anual (financido o de contado)

	DECLARE Est_PagImpresoNo		CHAR(1);		-- Estado cuando el pagara no ha sido impreso
	DECLARE Con_PagareImpreso		INT(11);		-- Consulta cuando el pagara ya fue impreso

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero cero
	SET Con_Principal		:= 1;				-- Consulta por llave primaria
	SET Decimal_Cero		:= 0.0000;			-- Decimal cero
	SET Cadena_Vacia		:= ''; 				-- Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01'; 	-- Fecha vacia

	-- Asignacion de Constantes. Cardinal Sistemas Inteligentes
	SET Con_NumArrenda		:= 2;				-- Lista 2.
	SET Est_DesGenerado		:= 'GENERADO';		-- Descripcion para estatus arrendamiento Generado
	SET Est_DesAutorizado	:= 'AUTORIZADO';	-- Descripcion para estatus arrendamiento Autorizado
	SET Est_DesCancelado	:= 'CANCELADO';		-- Descripcion para estatus arrendamiento Cancelado
	SET Est_DesVigente		:= 'VIGENTE';		-- Descripcion para estatus arrendamiento Vigente
	SET Est_DesVencido		:= 'VENCIDO';		-- Descripcion para estatus arrendamiento Vencido
	SET Est_DesPagado		:= 'PAGADO';		-- Descripcion para estatus arrendamiento Pagado

	SET Est_Generado		:='G';				-- Estatus arrendamiento Generado
	SET Est_Autorizado		:='A';				-- Estatus arrendamiento Autorizado
	SET Est_Cancelado		:='C';				-- Estatus arrendamiento Cancelado
	SET Est_Vigente			:='V';				-- Estatus arrendamiento Vigente
	SET Est_Vencido			:='B';				-- Estatus arrendamiento Vencido
	SET Est_Pagado			:='P';				-- Estatus arrendamiento Pagado

	SET Var_NoAplica		:='NA';				-- Valor No aplica
	SET Var_TipoFinanciero	:='FINANCIERO';		-- Variable de arrendamiento financiado
	SET Var_TipoPuro		:='PURO';			-- Variable de arrendamiento puro
	SET Var_Financiero		:='F';				-- Tipo de arrendamiento financiado
	SET Var_Puro			:='P';				-- Tipo de arrendamiento puro

	SET Con_Generales       := 3; 				-- Consulta general usada en la pantalla de pago
	SET EstatusPagado   	:= 'P';				-- Estatus pagado
	SET Con_Producto		:= 4; 				-- Consulta para el detalle de producto

	SET Var_DesFinanciado	:='FINANCIADO';		-- Variable de arrendamiento financiado
	SET Var_DesContado		:='CONTADO';		-- Variable de arrendamiento contado
	SET Var_Financiado		:= 2;				-- Tipo de pago financiado
	SET Var_Contado			:= 1;				-- Tipo de pago Contado
	SET Var_Frecuencia		:= 'M';				-- Frecuencia

	SET Var_DesFrecuencia	:= 'MENSUAL';		-- Descripcion Fecuencia mensual
	SET Var_DiaPagoFinMes	:= 'F';				-- Dia de Pago Fin de mes
	SET Var_DiaPagoAniver	:= 'A';				-- Dia de Pago Aniversario
	SET Var_DesPagoFinMes	:= 'FIN DE MES';	-- Descripcion Fin de mes
	SET Var_DesPagoAniver	:= 'ANIVERSARIO';	-- Descripcion Aniversario

	SET Est_PagImpresoNo	:= 'N';				-- Estatus N = pagara no impreso
	SET	Con_PagareImpreso	:= 5;				-- Consulta 5 de estatus de impresion de pagare

	SELECT	FechaSistema
	  INTO	Var_FecActual
		FROM	PARAMETROSSIS;

	SELECT	cli.SucursalOrigen
	  INTO	Var_SucCliente
		FROM ARRENDAMIENTOS arrenda
		INNER JOIN CLIENTES cli	ON	arrenda.ClienteID	= cli.ClienteID
		WHERE	arrenda.ArrendaID	= Par_ArrendaID;


	-- CONSULTA PRINCIPAL
	IF(Con_Principal = Par_NumCon)THEN
		SELECT	ArrendaID,				LineaArrendaID,				ClienteID, 				NumTransacSim, 				TipoArrenda,
				MonedaID,				ProductoArrendaID,			MontoArrenda,			IVAMontoArrenda, 			MontoEnganche,
				IVAEnganche,			PorcEnganche,  				MontoFinanciado,		SeguroArrendaID,			TipoPagoSeguro,
				MontoSeguroAnual,		SeguroVidaArrendaID,		TipoPagoSeguroVida,		MontoSeguroVidaAnual,		MontoResidual,
				FechaRegistro,			FechaApertura, 				FechaPrimerVen,			FechaUltimoVen,				FechaLiquida,
				Plazo,					FrecuenciaPlazo, 			TasaFijaAnual,			MontoRenta, 				MontoSeguro,
				MontoSeguroVida,		CantRentaDepo,				MontoDeposito,			IVADeposito,				MontoComApe,
				IVAComApe, 				OtroGastos, 				IVAOtrosGastos,			TotalPagoInicial,			TipCobComMorato,
				FactorMora,				CantCuota,  				MontoCuota, 			Estatus,					SucursalID,
				UsuarioAlta,			UsuarioAutoriza, 			FechaAutoriza, 			FechaTraspasaVen,			FechaRegulariza,
				UsuarioCancela, 		FechaCancela,  				MotivoCancela, 			SaldoCapVigente, 			SaldoCapAtrasad,
				SaldoCapVencido, 		MontoIVACapital,			SaldoInteresVigent,		SaldoInteresAtras,			SaldoInteresVen,
				MontoIVAInteres, 		SaldoSeguro, 				MontoIVASeguro,			SaldoSeguroVida,			MontoIVASeguroVida,
				SaldoMoratorios,		MontoIVAMora,				SaldComFaltPago, 		MontoIVAComFalPag,			SaldoOtrasComis,
				MontoIVAComisi,			DiaPagoProd, 				PagareImpreso,			FechaInhabil,				TipoPrepago,
				EsRenAnticipada,		TipRenAdelanta,				NumRenAdelantada,		RentasAdelantadas,			IVARenAdelanta,
				RentaAnticipada,		IVARentaAnticipa
		FROM ARRENDAMIENTOS
		WHERE ArrendaID =  Par_ArrendaID;
	END IF;

	-- Consulta: 2 por ArrendamientoID para la pantalla de Pagare de Arrendamiento. Cardinal Sistemas Inteligentes
	IF(Par_NumCon = Con_NumArrenda) THEN
		SELECT		arrenda.MontoSeguroAnual,	arrenda.MontoSeguroVidaAnual,	arrenda.TipoPagoSeguro,	arrenda.TipoPagoSeguroVida
			INTO	Var_MontoSegAnual,			Var_MontoSegVidaAnual,			Var_TipoSegAnual, 		Var_TipoSegVidaAnual
				FROM ARRENDAMIENTOS AS arrenda
                WHERE	arrenda.ArrendaID = Par_ArrendaID;

        IF(Var_TipoSegAnual = Var_Financiado)THEN
			SET Var_MontoSegAnual	:= Entero_Cero;
		END IF ;

		IF(Var_TipoSegVidaAnual = Var_Financiado)THEN
			SET Var_MontoSegVidaAnual	:=  Entero_Cero;
		END IF ;

		SELECT	arrenda.ArrendaID,			arrenda.ClienteID,				cli.NombreCompleto AS Cliente,		arrenda.ProductoArrendaID,			proArrenda.NombreCorto,
				CASE arrenda.Estatus
					WHEN Est_Generado   THEN Est_DesGenerado
					WHEN Est_Autorizado THEN Est_DesAutorizado
					WHEN Est_Cancelado  THEN Est_DesCancelado
					WHEN Est_Vigente    THEN Est_DesVigente
					WHEN Est_Vencido    THEN Est_DesVencido
					WHEN Est_Pagado     THEN Est_DesPagado
					ELSE Var_NoAplica
				END AS Estatus,
				CASE arrenda.TipoArrenda
					WHEN Var_Financiero  THEN Var_TipoFinanciero
					WHEN Var_Puro 		 THEN Var_TipoPuro
					ELSE Var_NoAplica
				END AS TipoArrenda,
				CASE arrenda.TipoPagoSeguro
					WHEN Var_Contado    THEN Var_DesContado
					WHEN Var_Financiado THEN Var_DesFinanciado
					ELSE Var_NoAplica
				END AS TipoPagoSeguro,
				CASE arrenda.TipoPagoSeguroVida
					WHEN Var_Contado    THEN Var_DesContado
					WHEN Var_Financiado THEN Var_DesFinanciado
					ELSE Var_NoAplica
				END AS TipoPagoSeguroVida,
				CASE arrenda.DiaPagoProd
					WHEN Var_DiaPagoFinMes THEN Var_DesPagoFinMes
					WHEN Var_DiaPagoAniver THEN Var_DesPagoAniver
					ELSE Var_NoAplica
				END AS DiaPagoProd,
				CASE arrenda.FrecuenciaPlazo
					WHEN Var_Frecuencia THEN Var_DesFrecuencia
					ELSE Var_NoAplica
				END AS FrecuenciaPlazo,
				Var_MontoSegAnual AS MontoSeguroAnual,		arrenda.SeguroArrendaID,						arrenda.SeguroVidaArrendaID,	arrenda.MontoArrenda,			arrenda.MontoEnganche,
				arrenda.PorcEnganche,						Var_MontoSegVidaAnual AS MontoSeguroVidaAnual,	arrenda.MontoFinanciado,		arrenda.MontoResidual,			arrenda.FechaApertura,
				arrenda.FechaPrimerVen,						arrenda.FechaUltimoVen,							arrenda.Plazo,					arrenda.TasaFijaAnual,			arrenda.MontoCuota,
				arrenda.FechaInhabil,						arrenda.IVAEnganche,							arrenda.MontoComApe,			arrenda.IVAComApe,				arrenda.CantRentaDepo,
				arrenda.MontoDeposito,						arrenda.IVADeposito,							arrenda.MontoSeguro,			arrenda.MontoSeguroVida,		arrenda.TotalPagoInicial,
				arrenda.EsRenAnticipada,					arrenda.TipRenAdelanta,							arrenda.NumRenAdelantada,		arrenda.RentasAdelantadas,		arrenda.IVARenAdelanta,
				arrenda.RentaAnticipada,					arrenda.IVARentaAnticipa,
				IFNULL(seguro.Descripcion,Var_NoAplica) AS SegDescri,
				IFNULL(segvida.Descripcion,Var_NoAplica)AS SegVidaDescri,
				(arrenda.OtroGastos + arrenda.IVaOtrosGastos) AS PlacasTenencia
			FROM ARRENDAMIENTOS AS arrenda
			INNER JOIN CLIENTES AS cli ON cli.ClienteID = arrenda.ClienteID
			INNER JOIN PRODUCTOARRENDA AS proArrenda ON proArrenda.ProductoArrendaID = arrenda.ProductoArrendaID
			LEFT JOIN ARRASEGURADORA AS seguro ON seguro.AseguradoraID = arrenda.SeguroArrendaID
			LEFT JOIN ARRASEGURADORA AS segvida ON segvida.AseguradoraID = arrenda.SeguroVidaArrendaID
			WHERE	arrenda.ArrendaID = Par_ArrendaID;
	END IF;
	-- Fin consulta.  Cardinal Sistemas Inteligentes

	-- Consulta de arrendamientos, Utilizada en las Pantalla de Pago de Arrendamiento.
	-- No.Consulta: 3
	IF(Par_NumCon = Con_Generales) THEN
		-- Se asigna a la variable fecha de vencimiento la fecha mas antigua no pagada
		SELECT MIN(FechaExigible) INTO Var_FechaVencim
			FROM ARRENDAAMORTI
			WHERE	ArrendaID     = Par_ArrendaID
			  AND	FechaExigible <= Var_FecActual
			  AND	Estatus       != EstatusPagado;

		SET Var_FechaVencim := IFNULL(Var_FechaVencim, Fecha_Vacia);

		IF(Var_FechaVencim != Fecha_Vacia) THEN
			SET Var_diasFaltaPago   := DATEDIFF(Var_FecActual, Var_FechaVencim);
		ELSE
			SET Var_diasFaltaPago   := Entero_Cero;
		END IF;

		IF(Var_diasFaltaPago >Entero_Cero ) THEN
			SET Var_FecProxPago := Var_FecActual;
		ELSE
			SELECT MIN(FechaVencim) INTO Var_FecProxPago
				FROM ARRENDAAMORTI
				WHERE ArrendaID   = Par_ArrendaID
				  AND FechaVencim > Var_FecActual
				  AND Estatus     != EstatusPagado;
		END IF;

		SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);

		SELECT	arrenda.ArrendaID,			arrenda.ClienteID,			cli.NombreCompleto,					arrenda.LineaArrendaID,				arrenda.ProductoArrendaID,
				arrenda.MonedaID,			mon.Descripcion,			Var_diasFaltaPago AS DiasFaltaPago,	arrenda.SucursalID,					arrenda.FechaApertura,
				Var_FecProxPago AS FechaProxPago,
				CASE arrenda.Estatus
					WHEN Est_Generado   THEN Est_DesGenerado
					WHEN Est_Autorizado THEN Est_DesAutorizado
					WHEN Est_Cancelado  THEN Est_DesCancelado
					WHEN Est_Vigente    THEN Est_DesVigente
					WHEN Est_Vencido    THEN Est_DesVencido
					WHEN Est_Pagado     THEN Est_DesPagado
				END AS Estatus,
				FORMAT(arrenda.TasaFijaAnual,4) AS TasaFijaAnual,
				prod.NombreCorto AS NombreProd
			FROM	ARRENDAMIENTOS arrenda
			INNER JOIN	CLIENTES cli	ON	arrenda.ClienteID = cli.ClienteID
			INNER JOIN	MONEDAS mon		ON	arrenda.MonedaID = mon.MonedaId
			INNER JOIN  PRODUCTOARRENDA	prod	ON	arrenda.ProductoArrendaID = prod.ProductoArrendaID
			WHERE arrenda.ArrendaID = Par_ArrendaID
			  AND	(arrenda.Estatus	= Est_Vigente
			  OR	 arrenda.Estatus	= Est_Vencido
			  OR	 arrenda.Estatus	= Est_Pagado);

	END IF;

	-- Consulta de arrendamiento. Utilizada en las Pantalla de Autorizacion de Arrendamiento. No.Consulta: 4. Cardinal Sistemas Inteligentes
	IF(Par_NumCon = Con_Producto)THEN
		SELECT	arrenda.ArrendaID,			arrenda.ClienteID,			cli.NombreCompleto AS NombreCliente,	arrenda.ProductoArrendaID,	prod.NombreCorto,
				arrenda.FechaAutoriza,		arrenda.UsuarioAutoriza,	usu.NombreCompleto AS NombreUsuario,	arrenda.MontoArrenda,		arrenda.IVAMontoArrenda,
				arrenda.FechaApertura,		arrenda.MontoEnganche,		arrenda.MontoSeguroAnual,				arrenda.Plazo,				arrenda.MontoFinanciado,
				CASE arrenda.FrecuenciaPlazo WHEN Var_Frecuencia THEN Var_DesFrecuencia END AS FrecuenciaPlazo,
				CASE arrenda.TipoPagoSeguro WHEN Var_Contado THEN Var_DesContado WHEN Var_Financiado THEN Var_DesFinanciado ELSE Var_NoAplica END AS TipoPagoSeguro,
				CASE arrenda.DiaPagoProd WHEN Var_DiaPagoFinMes THEN Var_DesPagoFinMes WHEN Var_DiaPagoAniver THEN Var_DesPagoAniver END AS DiaPagoProd,
				CASE arrenda.Estatus WHEN Est_Generado THEN Est_DesGenerado WHEN Est_Autorizado THEN Est_DesAutorizado WHEN Est_Cancelado THEN Est_DesCancelado WHEN Est_Vigente THEN Est_DesVigente WHEN Est_Vencido THEN Est_DesVencido WHEN Est_Pagado THEN Est_DesPagado END AS Estatus
			FROM ARRENDAMIENTOS AS arrenda
			INNER JOIN CLIENTES			AS cli	ON arrenda.ClienteID = cli.ClienteID
			INNER JOIN PRODUCTOARRENDA	AS prod	ON arrenda.ProductoArrendaID = prod.ProductoArrendaID
			LEFT  JOIN USUARIOS			AS usu	ON arrenda.UsuarioAutoriza = usu.UsuarioID
			WHERE	ArrendaID = Par_ArrendaID;
	END IF;

	-- Consulta: 5, estatus de impresion de pagare de Arrendamiento. Cardinal Sistemas Inteligentes
	IF(Par_NumCon = Con_PagareImpreso) THEN
		SELECT	ArrendaID,	PagareImpreso
			FROM ARRENDAMIENTOS
			WHERE	ArrendaID = Par_ArrendaID;
	END IF;
	-- Fin consulta.  Cardinal Sistemas Inteligentes

END TerminaStore$$