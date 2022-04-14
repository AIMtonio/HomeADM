-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAAMORTILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAAMORTILIS`;DELIMITER $$

CREATE PROCEDURE `ARRENDAAMORTILIS`(
# =====================================================================================
# -- STORED PROCEDURE PARA LISTAR LAS AMORTIZACIONES
# =====================================================================================
	Par_ArrendaID			BIGINT(12),			-- Numero de Arrendamiento ID
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de la lista

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_TotalCapital	DECIMAL(14,4);	-- Sumatoria de capital
	DECLARE Var_TotalInteres	DECIMAL(14,4);	-- Sumatoria de intereses
	DECLARE Var_TotalIva		DECIMAL(14,4);	-- sumatoria de Iva
	DECLARE Var_TotalPago		DECIMAL(14,4);	-- sumatoria total del pago
	DECLARE Var_TotalRenta		DECIMAL(14,4);	-- sumatoria total de la renta
	DECLARE Var_IVASucArrenda	DECIMAL(12,2);	-- Iva de la sucursal del arrendamiento.
	DECLARE Var_TotalPagoCuota	DECIMAL(14,4);	-- maximo del pago de la couta
	DECLARE Var_CtePagIva 		CHAR(1);		-- VARIABLE PARA  GUARDAR SU EL CLIENTE PAGA O NO IVA
	DECLARE Var_Cliente			INT(11);		-- 'Numero de Cliente al que se le da de alta el arrendamiento',
    DECLARE Var_SI 				CHAR(1);		-- Variable si
	DECLARE Var_NO 				CHAR(1);		-- Variable no
	DECLARE Var_AmortiPagada	DECIMAL(14,4);	-- sumatoria total de la amortizaciones pagadas

    -- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE	Decimal_Cero		DECIMAL(14,2);	-- Decimal cero
	DECLARE Lis_AmortiArrenda 	INT(11);		-- Lista de Amortizaciones por Arrendamiento ID

	DECLARE Est_DesInactivo		VARCHAR(50);	-- Descripcion de Estatus Inactivo
	DECLARE Est_DesVigente		VARCHAR(50);	-- Descripcion de Estatus Vigente
	DECLARE Est_DesPagado		VARCHAR(50);	-- Descripcion de Estatus Pagado
	DECLARE Est_DesCancelado	VARCHAR(50);	-- Descripcion de Estatus Cancelado
	DECLARE Est_DesVencido		VARCHAR(50);	-- Descripcion de Estatus Vencido
	DECLARE Est_DesAtrasado		VARCHAR(50);	-- Descripcion de Estatus Atrasado
	DECLARE Est_DesCastigado	VARCHAR(50);	-- Descripcion de Estatus Castigado

	DECLARE Est_Inactivo		CHAR(1);		-- Estatus Inactivo
	DECLARE Est_Vigente			CHAR(1);		-- Estatus Vigente
	DECLARE Est_Vencido			CHAR(1);		-- Estatus Vencido
	DECLARE Est_Pagado			CHAR(1);		-- Estatus Pagado
	DECLARE Est_Cancelado		CHAR(1);		-- Estatus Cancelado
	DECLARE Est_Atrasado		CHAR(1);		-- Estatus Atrasado
	DECLARE Est_Castigado		CHAR(1);		-- Estatus Castigado

	DECLARE Var_NoAplica		VARCHAR(50);	-- No Aplica
	DECLARE Lis_InfoPRPT 		INT(11);		-- Lista utilizada para el prpt.
	DECLARE	Var_Oficial			CHAR(1);		-- Direccion oficial
	DECLARE Lis_AmortiCarAbo 	INT(11);		-- Lista de Amortizaciones de los movimientos de cago y abono de arrendamiento

-- Asignacion de Listas
	SET Lis_AmortiArrenda		:= 1;				-- Valor lista 1
	SET Lis_InfoPRPT			:= 2;				-- Valor lista 2
	SET Lis_AmortiCarAbo		:= 3;				-- Valor lista 3

-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Valor de cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Valor de fecha vacia.
	SET	Entero_Cero				:= 0;				-- Valor de entero cero.
	SET	Decimal_Cero			:= 0.0;				-- Valor de decimal cero.

    SET Var_SI 					:= 'S';				-- Permite Salida SI
	SET Var_NO  				:= 'N';				-- Permite Salida NO

	SET Est_DesInactivo			:= 'INACTIVO';      -- Descripcion de Estatus Inactivo
	SET Est_DesVigente			:= 'VIGENTE';       -- Descripcion de Estatus Vigente
	SET Est_DesPagado			:= 'PAGADO';        -- Descripcion de Estatus Pagado
	SET Est_DesCancelado		:= 'CANCELADO';     -- Descripcion de Estatus Cancelado
	SET Est_DesVencido			:= 'VENCIDO';       -- Descripcion de Estatus Vencido
	SET Est_DesAtrasado			:= 'ATRASADO';      -- Descripcion de Estatus Atrasado
	SET Est_DesCastigado		:= 'CASTIGADO';     -- Descripcion de Estatus Castigado

	SET Est_Inactivo			:='I';              -- Valor de estatus Inactivo
	SET Est_Vigente				:='V';              -- Valor de estatus Vigente
	SET Est_Vencido				:='B';              -- Valor de estatus Vencido
	SET Est_Pagado				:='P';              -- Valor de estatus Pagado
	SET Est_Cancelado			:='C';              -- Valor de estatus Cancelado
	SET Est_Atrasado			:='A';              -- Valor de estatus Atrasado
	SET Est_Castigado			:='K';              -- Valor de estatus Castigado

	SET Var_NoAplica			:='NA';				-- Valor de NA
	SET	Var_Oficial				:= 'S';				-- Si es direccion oficial

	-- Valores por Default
	SET Par_ArrendaID			:= IFNULL(Par_ArrendaID,Entero_Cero);
	SET Par_NumLis				:= IFNULL(Par_NumLis,Entero_Cero);

	-- Se obtiene el IVA de la sucursal del arrendamiento. Tabla de sucursales (IVA)
	SELECT	sucurs.IVA, arrenda.ClienteID
		INTO	Var_IVASucArrenda, Var_Cliente
		FROM  ARRENDAMIENTOS AS arrenda
		INNER JOIN SUCURSALES AS sucurs ON sucurs.SucursalID = arrenda.SucursalID
		WHERE	arrenda.ArrendaID = Par_ArrendaID;

	SET Var_IVASucArrenda := IFNULL(Var_IVASucArrenda,Decimal_Cero);

	SELECT PagaIVA INTO Var_CtePagIva   FROM CLIENTES  WHERE ClienteID = Var_Cliente;

    IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Var_CtePagIva	:= Var_Si;
	END IF;

    IF (Var_CtePagIva = Var_No) THEN
			SET Var_IVASucArrenda	:= Decimal_Cero;
	END IF;
	-- Lista de amortizaciones. Lista: 1
	IF (Par_NumLis = Lis_AmortiArrenda) THEN

		SELECT	IFNULL(SUM(CapitalRenta),Decimal_Cero),		IFNULL(SUM(InteresRenta),Decimal_Cero),		IFNULL(SUM(IVARenta),Decimal_Cero),		IFNULL(SUM(Renta),Decimal_Cero),
				IFNULL(SUM(CapitalRenta + InteresRenta + IVARenta + Seguro + SeguroVida + ROUND(Seguro * Var_IVASucArrenda, 2) + ROUND(SeguroVida * Var_IVASucArrenda, 2)),Decimal_Cero)
		  INTO	Var_TotalCapital,   						Var_TotalInteres,  							Var_TotalIva,							Var_TotalRenta,
				Var_TotalPago
			FROM  ARRENDAAMORTI
			WHERE	ArrendaID = Par_ArrendaID;

		SELECT	IFNULL(SUM(CapitalRenta + InteresRenta + IVARenta + Seguro + SeguroVida + ROUND(Seguro * Var_IVASucArrenda, 2) + ROUND(SeguroVida * Var_IVASucArrenda, 2)),Decimal_Cero)
		  INTO	Var_AmortiPagada
			FROM  ARRENDAAMORTI
			WHERE	ArrendaID = Par_ArrendaID
				AND Estatus = Est_Pagado;

		SET Var_TotalPago := Var_TotalPago - Var_AmortiPagada;

		-- amortizaciones
		SELECT	amorti.ArrendaID,					amorti.ArrendaAmortiID,				amorti.FechaInicio,			amorti.FechaVencim,				amorti.FechaExigible,
				amorti.CapitalRenta,				amorti.InteresRenta,				amorti.Renta,				amorti.IVARenta,				amorti.SaldoInsoluto,
				amorti.Seguro,						amorti.SeguroVida,
				ROUND(amorti.Seguro * Var_IVASucArrenda, 2) AS IVASeguro,
				ROUND(amorti.SeguroVida * Var_IVASucArrenda, 2) AS IVASeguroVida,
				CASE amorti.Estatus
					WHEN Est_Pagado   THEN Decimal_Cero
					ELSE (amorti.CapitalRenta + amorti.InteresRenta + amorti.IVARenta + amorti.Seguro + amorti.SeguroVida + ROUND(amorti.Seguro * Var_IVASucArrenda, 2) + ROUND(amorti.SeguroVida * Var_IVASucArrenda, 2))
				END AS PagoTotal,
				Var_TotalCapital AS TotalCapital,	Var_TotalInteres AS TotalInteres, 	Var_TotalIva AS TotalIVA,	Var_TotalRenta AS TotalRenta,	Var_TotalPago AS TotalPago,
				CASE amorti.Estatus
					WHEN Est_Inactivo   THEN Est_DesInactivo
					WHEN Est_Atrasado 	THEN Est_DesAtrasado
					WHEN Est_Cancelado  THEN Est_DesCancelado
					WHEN Est_Vigente    THEN Est_DesVigente
					WHEN Est_Vencido    THEN Est_DesVencido
					WHEN Est_Pagado     THEN Est_DesPagado
					WHEN Est_Castigado  THEN Est_DesCastigado
					ELSE Var_NoAplica
				END AS Estatus
			FROM  ARRENDAAMORTI AS amorti
			WHERE	amorti.ArrendaID = Par_ArrendaID
			ORDER BY amorti.ArrendaAmortiID;
	END IF;


	-- Lista utilizada para el prpt Anexos. Lista:2
	IF (Par_NumLis = Lis_InfoPRPT) THEN
		-- Total de la renta
		SELECT	SUM(Renta), 	MAX(ROUND((CapitalRenta + InteresRenta + IVARenta + Seguro + SeguroVida + (Seguro * Var_IVASucArrenda) + (SeguroVida * Var_IVASucArrenda)),2)),SUM(CapitalRenta + InteresRenta + IVARenta + Seguro + SeguroVida + ROUND(Seguro * Var_IVASucArrenda, 2) + ROUND(SeguroVida * Var_IVASucArrenda, 2))
		  INTO	Var_TotalRenta,	Var_TotalPagoCuota,																																Var_TotalPago
			FROM  ARRENDAAMORTI
			WHERE	ArrendaID = Par_ArrendaID;

		SELECT	arrenda.ArrendaID,		amorti.ArrendaAmortiID,		arrenda.Plazo,			arrenda.MontoDeposito,			arrenda.FechaApertura,
				amorti.FechaVencim,		cli.PrimerNombre,			cli.SegundoNombre,		cli.TercerNombre,				cli.ApellidoPaterno,
				cli.ApellidoMaterno,	cli.NombreCompleto,			dir.DireccionCompleta,	arrenda.FechaUltimoVen,			Var_TotalRenta AS TotalRenta,
				FUNCIONNUMLETRAS(Var_TotalRenta) AS TotalRentaLetras,
				(amorti.CapitalRenta + amorti.InteresRenta + amorti.IVARenta + amorti.Seguro + amorti.SeguroVida + ROUND(amorti.Seguro * Var_IVASucArrenda, 2) + ROUND(amorti.SeguroVida * Var_IVASucArrenda, 2)) AS PagoTotal ,
				FUNCIONNUMLETRAS((amorti.CapitalRenta + amorti.InteresRenta + amorti.IVARenta + amorti.Seguro + amorti.SeguroVida + ROUND(amorti.Seguro * Var_IVASucArrenda, 2) + ROUND(amorti.SeguroVida * Var_IVASucArrenda, 2))) AS PagoTotalCuotaLetras,
				FUNCIONNUMLETRAS(arrenda.MontoDeposito) AS MontoDepositoLetras,
				FUNCIONNUMEROSLETRAS(arrenda.Plazo) AS PlazoLetras,
				Var_TotalPagoCuota AS TotalPagoCuota,
				FUNCIONNUMLETRAS(Var_TotalPagoCuota) AS TotalPagoCuotaLetras,
				Var_TotalPago AS TotalPago,
				FUNCIONNUMLETRAS(Var_TotalPago) AS TotalPagoLetras
			FROM  ARRENDAAMORTI AS amorti
			INNER JOIN ARRENDAMIENTOS AS arrenda ON arrenda.ArrendaID = amorti.ArrendaID
			INNER JOIN CLIENTES AS cli ON cli.ClienteID = arrenda.ClienteID
			LEFT JOIN DIRECCLIENTE AS dir ON dir.ClienteID = cli.ClienteID
			  AND	dir.Oficial = Var_Oficial
			WHERE	amorti.ArrendaID = Par_ArrendaID
			ORDER BY amorti.ArrendaAmortiID;
	END IF;

	-- Lista de amortizaciones. Lista: 3 para la pantalla de movimientos de carga y abono
	IF (Par_NumLis = Lis_AmortiCarAbo) THEN

		SELECT	IFNULL(SUM(CapitalRenta),Decimal_Cero),		IFNULL(SUM(InteresRenta),Decimal_Cero),		IFNULL(SUM(IVARenta),Decimal_Cero),		IFNULL(SUM(Renta),Decimal_Cero),
				IFNULL(SUM(CapitalRenta + InteresRenta + IVARenta + SaldoSeguro + MontoIVASeguro  + SaldoSeguroVida + MontoIVASeguroVida  + SaldoOtrasComis + MontoIVAComisi),Decimal_Cero)
		  INTO	Var_TotalCapital,   						Var_TotalInteres,  							Var_TotalIva,							Var_TotalRenta,
				Var_TotalPago
			FROM  ARRENDAAMORTI
			WHERE	ArrendaID = Par_ArrendaID;

		SELECT	IFNULL(SUM(CapitalRenta + InteresRenta + IVARenta + SaldoSeguro + MontoIVASeguro  + SaldoSeguroVida + MontoIVASeguroVida  + SaldoOtrasComis + MontoIVAComisi),Decimal_Cero)
		  INTO	Var_AmortiPagada
			FROM  ARRENDAAMORTI
			WHERE	ArrendaID = Par_ArrendaID
			  AND	Estatus = Est_Pagado;

		SET Var_TotalPago := Var_TotalPago - Var_AmortiPagada;

		-- amortizaciones
		SELECT	amorti.ArrendaID,					amorti.ArrendaAmortiID,			amorti.FechaInicio,			amorti.FechaVencim,				amorti.FechaExigible,
				amorti.CapitalRenta,				amorti.InteresRenta,			amorti.Renta,				amorti.IVARenta,				amorti.SaldoInsoluto,
				amorti.Seguro,						amorti.SeguroVida,
				MontoIVASeguro,
				MontoIVASeguroVida,
				CASE amorti.Estatus
					WHEN Est_Pagado THEN Decimal_Cero
					ELSE (amorti.CapitalRenta + amorti.InteresRenta + amorti.IVARenta + amorti.SaldoSeguro + amorti.MontoIVASeguro + amorti.SaldoSeguroVida + amorti.MontoIVASeguroVida + amorti.SaldoOtrasComis + amorti.MontoIVAComisi)
				END AS PagoTotal,
				Var_TotalCapital AS TotalCapital,	Var_TotalInteres AS TotalInteres, 	Var_TotalIva AS TotalIVA,	Var_TotalRenta AS TotalRenta,	Var_TotalPago AS TotalPago,
				CASE amorti.Estatus
					WHEN Est_Inactivo   THEN Est_DesInactivo
					WHEN Est_Atrasado 	THEN Est_DesAtrasado
					WHEN Est_Cancelado  THEN Est_DesCancelado
					WHEN Est_Vigente    THEN Est_DesVigente
					WHEN Est_Vencido    THEN Est_DesVencido
					WHEN Est_Pagado     THEN Est_DesPagado
					WHEN Est_Castigado  THEN Est_DesCastigado
					ELSE Var_NoAplica
				END AS Estatus,
				amorti.SaldoSeguro,					amorti.SaldoSeguroVida, 	amorti.SaldoOtrasComis,			MontoIVAComisi
			FROM  ARRENDAAMORTI AS amorti
			WHERE	amorti.ArrendaID = Par_ArrendaID
			ORDER BY amorti.ArrendaAmortiID;
	END IF;

	-- fin del sp
END TerminaStore$$