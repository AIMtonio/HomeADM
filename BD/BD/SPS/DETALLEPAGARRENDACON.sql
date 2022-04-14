-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGARRENDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPAGARRENDACON`;DELIMITER $$

CREATE PROCEDURE `DETALLEPAGARRENDACON`(
	-- SP que consulta en la tabla DETALLEPAGARRENDA los detalles del pago de las amortizaciones
	Par_ArrendaID		BIGINT(12),				-- Id del arrendamiento
	Par_FechaPago		DATE,					-- Fecha de Pago
	Par_NumCon			TINYINT UNSIGNED,		-- Numero de consulta

	Par_EmpresaID		INT(11),				-- Id de la empresa
	Aud_Usuario			INT(11),				-- Usuario
	Aud_FechaActual		DATETIME,				-- Fecha actual
	Aud_DireccionIP		VARCHAR(15),			-- Direccion IP
	Aud_ProgramaID		VARCHAR(50),			-- Id del programa
	Aud_Sucursal		INT(11),				-- Numero de sucursal
	Aud_NumTransaccion	BIGINT(20)				-- Numero de transaccion
)
BEGIN
	-- Declaracion de variables
	DECLARE Var_FecActual		DATE;			-- Fecha Actual del sistema
	DECLARE Var_TotalArrenda	DECIMAL(14,4);	-- Total del Arrendamiento
	DECLARE Var_TotAtrasado 	DECIMAL(14,4);	-- Total
	DECLARE Var_MontoExigible	DECIMAL(14,4);	-- Monto exigible del daa
	DECLARE Var_SaldoCapital	DECIMAL(14,4);	-- Saldo del capital
	DECLARE Var_FechaExigible	DATE;			-- Fecha Exigible
	DECLARE Var_AmortizacionID	INT(11);		-- Numero de la amortizacion
	DECLARE Var_PoxFecPago		VARCHAR(20);	-- Proxima fecha de pago
	DECLARE Var_TArrendamiento	VARCHAR(30);	-- Variable para el total del arrendamiento
	DECLARE Var_MontoPxoxPag	VARCHAR(30);	-- Monto del proximo pago
	DECLARE Var_IVASucurs		DECIMAL(14,4);	-- IVA aplicado al arrendamiento
	DECLARE	Var_SucCliente		INT(11);		-- Sucursal del cliente
    DECLARE Var_ProdID			INT(4);			-- Id del producto
    DECLARE Var_NomProd			VARCHAR(30);	-- Nombre del producto de arrendamiento
	DECLARE Var_CtePagIva 		CHAR(1);		-- VARIABLE PARA  GUARDAR SU EL CLIENTE PAGA O NO IVA
	DECLARE Var_SI 				CHAR(1);		-- Variable si
	DECLARE Var_NO 				CHAR(1);		-- Variable no
	DECLARE Var_Cliente			INT(11);		-- 'Numero de Cliente al que se le da de alta el arrendamiento',

	-- Declaracion de constantes
	DECLARE	Pago_Efectivo		CHAR(1);		-- Forma de pago efectivo
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena vacia
	DECLARE	Fecha_Vacia			DATE;			-- Constante de fecha vacia
	DECLARE	Entero_Cero			INT(11);		-- Constante para entero cero
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Constante para decimal cero
	DECLARE	Con_RepTicket		INT(11);		-- Consulta para el reporte del ticket
	DECLARE	Est_Pagado			CHAR(1);		-- Estatus pagado

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Entero cero
	SET Decimal_Cero		:= 0.00;			-- Decimal Cero
	SET	Con_RepTicket 		:= 1;				-- Consulta para el Reporte ticket
	SET	Pago_Efectivo		:= 'E';				-- Pago efectivo
	SET	Est_Pagado			:= 'P';				-- Estatus pagado
	SET Var_SI 				:= 'S';				-- Permite Salida SI
	SET Var_NO  			:= 'N';				-- Permite Salida NO

	SELECT	cli.SucursalOrigen,	arrenda.ClienteID
		INTO	Var_SucCliente,	Var_Cliente
		FROM ARRENDAMIENTOS	arrenda
		INNER JOIN CLIENTES	cli ON arrenda.ClienteID = cli.ClienteID
		WHERE arrenda.ArrendaID = Par_ArrendaID;

	SELECT	FechaSistema
		INTO	Var_FecActual
		FROM	PARAMETROSSIS;

	SET	Var_IVASucurs	:= IFNULL((	SELECT	IVA
										FROM	SUCURSALES
										WHERE	SucursalID = Var_SucCliente),  Entero_Cero);

	SELECT PagaIVA INTO Var_CtePagIva   FROM CLIENTES  WHERE ClienteID = Var_Cliente;

	IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Var_CtePagIva	:= Var_Si;
	END IF;

	IF (Var_CtePagIva = Var_No) THEN
		SET Var_IVASucurs	:= Decimal_Cero;
	END IF;

	SELECT	prod.ProductoArrendaID,	prod.NombreCorto
		INTO	Var_ProdID,	Var_NomProd
		FROM PRODUCTOARRENDA	prod
		INNER JOIN ARRENDAMIENTOS	arr ON	prod.ProductoArrendaID	= arr.ProductoArrendaID
		WHERE	arr.ArrendaID = Par_ArrendaID;

	IF(Par_NumCon = Con_RepTicket) THEN
		-- SE CALCULA TOTAL DEL ARRENDAMIENTO QUE FALTA POR PAGAR, EL MONTO DE LA SIGUIENTE CUOTA Y LA FECHA DE PROXIMO Pago_Efectivo
		SELECT	ROUND(IFNULL(SUM(ROUND(SaldoCapVigent,2) + ROUND(SaldoCapAtrasad,2)+ROUND(SaldoCapVencido,2)), Decimal_Cero),2),
				ROUND(IFNULL(SUM(ROUND(SaldoCapVigent,2) + ROUND(SaldoCapAtrasad,2) + ROUND(SaldoCapVencido,2)+
									ROUND(SaldoInteresVigente + SaldoInteresAtras + SaldoInteresVen, 2) +
									ROUND(ROUND(SaldoCapVigent * Var_IVASucurs, 2) +
										ROUND(SaldoCapAtrasad * Var_IVASucurs,2) +
										ROUND(SaldoCapVencido * Var_IVASucurs,2) +
										ROUND(SaldoInteresVigente * Var_IVASucurs,2) +
										ROUND(SaldoInteresAtras * Var_IVASucurs,2) +
										ROUND(SaldoInteresVen * Var_IVASucurs,2) +
										ROUND(SaldoSeguro * Var_IVASucurs,2) +
										ROUND(SaldoSeguroVida * Var_IVASucurs,2) +
										ROUND(SaldoMoratorios * Var_IVASucurs,2) +
										ROUND(SaldComFaltPago * Var_IVASucurs,2) +
										ROUND(SaldoOtrasComis * Var_IVASucurs,2), 2) +
									ROUND(SaldoSeguro,2) +
									ROUND(SaldoSeguroVida,2) +
									ROUND(SaldoMoratorios,2) +
									ROUND(SaldoOtrasComis,2) +
									ROUND(SaldComFaltPago,2)),Decimal_Cero), 2)
			INTO	Var_SaldoCapital,	Var_TotalArrenda
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID	=  Par_ArrendaID
			  AND	Estatus		<> Est_Pagado;

		SELECT ROUND(IFNULL(SUM(ROUND(SaldoCapVigent,2) + ROUND(SaldoCapAtrasad,2) + ROUND(SaldoCapVencido,2)+
								ROUND(SaldoInteresVigente + SaldoInteresAtras + SaldoInteresVen, 2) +
								ROUND(ROUND(SaldoCapVigent * Var_IVASucurs, 2) +
									ROUND(SaldoCapAtrasad * Var_IVASucurs,2) +
									ROUND(SaldoCapVencido * Var_IVASucurs,2) +
									ROUND(SaldoInteresVigente * Var_IVASucurs,2) +
									ROUND(SaldoInteresAtras * Var_IVASucurs,2) +
									ROUND(SaldoInteresVen * Var_IVASucurs,2) +
									ROUND(SaldoSeguro * Var_IVASucurs,2) +
									ROUND(SaldoSeguroVida * Var_IVASucurs,2) +
									ROUND(SaldoMoratorios * Var_IVASucurs,2) +
									ROUND(SaldComFaltPago * Var_IVASucurs,2) +
									ROUND(SaldoOtrasComis * Var_IVASucurs,2), 2) +
								ROUND(SaldoSeguro,2) +
								ROUND(SaldoSeguroVida,2) +
								ROUND(SaldoMoratorios,2) +
								ROUND(SaldoOtrasComis,2) +
								ROUND(SaldComFaltPago,2)),Decimal_Cero), 2)	INTO Var_TotAtrasado
			FROM	ARRENDAAMORTI
			WHERE	FechaExigible <= Var_FecActual
			  AND	Estatus <> Est_Pagado
			  AND	ArrendaID = Par_ArrendaID;

			SET	Var_TotAtrasado		:= IFNULL(Var_TotAtrasado, Decimal_Cero);
			SET	Var_TotalArrenda	:= IFNULL(Var_TotalArrenda, Decimal_Cero);
			SET	Var_SaldoCapital	:= IFNULL(Var_SaldoCapital, Decimal_Cero);

			IF (Var_TotAtrasado	> Decimal_Cero) THEN
				SET	Var_TArrendamiento	:= FORMAT(Var_TotalArrenda, 2);
				SET	Var_MontoPxoxPag	:= FORMAT(Var_TotAtrasado,2);
				SET	Var_PoxFecPago		:= 'Inmediato';
			ELSE
				SELECT	MIN(ArrendaAmortiID)
					INTO	Var_AmortizacionID
					FROM	ARRENDAAMORTI
					WHERE	ArrendaID		= Par_ArrendaID
					  AND	FechaExigible	>= Var_FecActual
					  AND	Estatus			!= Est_Pagado;

				SET	Var_AmortizacionID	:= IFNULL(Var_AmortizacionID, Entero_Cero);

				IF	Var_AmortizacionID	!= Entero_Cero THEN
					SELECT	FechaExigible,
							(ROUND(SaldoCapVigent,2) + ROUND(SaldoCapAtrasad,2) + ROUND(SaldoCapVencido,2)+
							ROUND(SaldoInteresVigente + SaldoInteresAtras + SaldoInteresVen, 2) +
							ROUND(ROUND(SaldoCapVigent * Var_IVASucurs, 2) +
									ROUND(SaldoCapAtrasad * Var_IVASucurs,2) +
									ROUND(SaldoCapVencido * Var_IVASucurs,2) +
									ROUND(SaldoInteresVigente * Var_IVASucurs,2) +
									ROUND(SaldoInteresAtras * Var_IVASucurs,2) +
									ROUND(SaldoInteresVen * Var_IVASucurs,2) +
									ROUND(SaldoSeguro * Var_IVASucurs,2) +
									ROUND(SaldoSeguroVida * Var_IVASucurs,2) +
									ROUND(SaldoMoratorios * Var_IVASucurs,2) +
									ROUND(SaldComFaltPago * Var_IVASucurs,2) +
									ROUND(SaldoOtrasComis * Var_IVASucurs,2), 2) +
								ROUND(SaldoSeguro,2) +
								ROUND(SaldoSeguroVida,2) +
								ROUND(SaldoMoratorios,2) +
								ROUND(SaldoOtrasComis,2) +
								ROUND(SaldComFaltPago,2))
						INTO	Var_FechaExigible,
								Var_MontoExigible
						FROM	ARRENDAAMORTI
						WHERE	ArrendaID		= Par_ArrendaID
						  AND	ArrendaAmortiID	= Var_AmortizacionID
						  AND	Estatus			!= Est_Pagado;

					SET	Var_MontoExigible	:= IFNULL(Var_MontoExigible, Decimal_Cero);
					SET	Var_FechaExigible	:= IFNULL(Var_FechaExigible, Fecha_Vacia);


				SET	Var_TArrendamiento	:= FORMAT(Var_TotalArrenda, 2);
				SET	Var_MontoPxoxPag	:= FORMAT(Var_MontoExigible,2);
				SET	Var_PoxFecPago		:= Var_FechaExigible;

				ELSE
					SET	Var_TArrendamiento	:= FORMAT(Var_TotalArrenda, 2);
					SET	Var_MontoPxoxPag	:= FORMAT(Entero_Cero,2);
					SET	Var_PoxFecPago		:= Cadena_Vacia;
				END IF;
			END IF;

		SELECT FORMAT(ROUND(IFNULL(SUM(DetArrenda.MontoCapVig+DetArrenda.MontoCapAtr+DetArrenda.MontoCapVen+DetArrenda.MontoIVACapital
									+DetArrenda.MontoIntVig+DetArrenda.MontoIntAtr+DetArrenda.MontoIntVen
									+DetArrenda.MontoIVAInteres+DetArrenda.MontoSeguro+DetArrenda.MontoIVASeguro
									+DetArrenda.MontoSeguroVida+DetArrenda.MontoIVASeguroVida+DetArrenda.MontoMoratorios
									+DetArrenda.MontoIVAMora+DetArrenda.MontoComFaltPago+DetArrenda.MontoIVAComFalPag
									+DetArrenda.MontoComision+DetArrenda.MontoIVAComi),
									Entero_Cero),2),2) AS MontoTotal,
				FORMAT(IFNULL(SUM(DetArrenda.MontoCapVig+DetArrenda.MontoCapAtr+DetArrenda.MontoCapVen),Entero_Cero),2) AS Capital,
				FORMAT(ROUND(IFNULL(SUM(DetArrenda.MontoIntVig+DetArrenda.MontoIntAtr+DetArrenda.MontoIntVen),Entero_Cero),2),2) AS Interes,
				FORMAT(IFNULL(SUM(DetArrenda.MontoIVAInteres),Entero_Cero),2) AS MontoIVAIntere,
				FORMAT(IFNULL(SUM(DetArrenda.MontoIVACapital),Entero_Cero),2) AS MontoIVACap,
				FORMAT(IFNULL(SUM(DetArrenda.MontoMoratorios),Entero_Cero),2) AS MontoIntMora,
				FORMAT(IFNULL(SUM(DetArrenda.MontoIVAMora),Entero_Cero),2) AS MontoIVAMora,
				FORMAT(IFNULL(SUM(DetArrenda.MontoIVAComFalPag),Entero_Cero),2) AS MontoIVAComFaltPag,
				FORMAT(IFNULL(SUM(DetArrenda.MontoComFaltPago),Entero_Cero),2) AS MontoComFaltPag,
				FORMAT(IFNULL(SUM(DetArrenda.MontoComision),Entero_Cero),2) AS MontoOtrasComis,
				FORMAT(IFNULL(SUM(DetArrenda.MontoIVAComi),Entero_Cero),2) AS MontoIVAOtrasComis,
				FORMAT(IFNULL(SUM(DetArrenda.MontoSeguro),Entero_Cero),2) AS MontoSegInmob,
				FORMAT(IFNULL(SUM(DetArrenda.MontoIVASeguro),Entero_Cero),2) AS MontoIVASegInmob,
				FORMAT(IFNULL(SUM(DetArrenda.MontoSeguroVida),Entero_Cero),2) AS MontoSegVida,
				FORMAT(IFNULL(SUM(DetArrenda.MontoIVASeguroVida),Entero_Cero),2) AS MontoIVASegVida,
				Var_TArrendamiento	AS TotalArrendamiento,
				Var_MontoPxoxPag	AS MontoProxPago,
				Var_PoxFecPago		AS FechaProxPago,
				Var_ProdID			AS ProductoArrendaID,
				Var_NomProd			AS NomProducto,
				CURRENT_TIME()	AS Hora,
				DetArrenda.Transaccion,
				CONVERT(LPAD(CL.ClienteID,10,0),CHAR(12)) AS ClienteID,
				CL.NombreCompleto,
				DetArrenda.ArrendaID
			FROM CLIENTES CL
			LEFT OUTER JOIN  DETALLEPAGARRENDA DetArrenda ON DetArrenda.ArrendaID = Par_ArrendaID AND DetArrenda.FechaPago = Par_FechaPago AND DetArrenda.ClienteID	= CL.ClienteID AND DetArrenda.Transaccion = Aud_NumTransaccion
			WHERE	DetArrenda.ClienteID = CL.ClienteID
			GROUP BY DetArrenda.ClienteID, DetArrenda.Transaccion, CL.ClienteID, CL.NombreCompleto, DetArrenda.ArrendaID;
	END IF;

END$$