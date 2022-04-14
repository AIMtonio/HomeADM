-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAAMORTICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAAMORTICON`;DELIMITER $$

CREATE PROCEDURE `ARRENDAAMORTICON`(
	-- SP para la consulta de Amortizacion de Arrendamientos*/
	Par_ArrendaID		BIGINT(12),			-- Id del arrendamiento
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de consulta
	-- Parametros de Auditoria
	Par_EmpresaID		INT(11),			-- Id de la empresa
	Aud_Usuario			INT(11),			-- Usuario
	Aud_FechaActual		DATETIME,	 		-- Fecha actual
	Aud_DireccionIP		VARCHAR(15), 		-- Direccion IP
	Aud_ProgramaID		VARCHAR(50), 		-- Id del programa
	Aud_Sucursal		INT(11),	 		-- Numero de sucursal
	Aud_NumTransaccion	BIGINT(20)   		-- Numero de transaccion
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Entero_Cero		INT(11);			-- Entero cero
	DECLARE Con_Principal	INT(11);			-- Consulta principal
	DECLARE Con_PagAmorti   INT(11);			-- Consulta Pago
	DECLARE Decimal_Cero	DECIMAL(14,2);		-- Decimal cero
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE Var_CtePagIva 	CHAR(1);			-- VARIABLE PARA  GUARDAR SU EL CLIENTE PAGA O NO IVA
	DECLARE Var_SI 			CHAR(1);			-- Variable si
	DECLARE Var_NO 			CHAR(1);			-- Variable no
	DECLARE Var_Cliente		INT(11);			-- 'Numero de Cliente al que se le da de alta el arrendamiento',

	--  Declaracion de Constantes. Cardinal Sistemas Inteligentes
	DECLARE Est_Vigente			CHAR(1);		-- Estatus Vigente
	DECLARE Est_Vencido			CHAR(1);		-- Estatus Vencido
	DECLARE EstatusPagado		CHAR(1);		-- Estatus Pagado

	DECLARE Var_FecActual       DATE;			-- Fecha Actual del sistema
	DECLARE Var_FechaVencim     DATE;			-- Fecha de vencimiento del arrendamiento
	DECLARE Var_diasFaltaPago  	INT(11);		-- Dias para el proximo pago
	DECLARE Var_FecProxPago     DATE;			-- Fecha del proximo pago


	DECLARE Var_IVASucurs		DECIMAL(8, 2);	-- IVA por sucursal
	DECLARE Var_SucCliente		INT(11);		-- Numero de sucursal del cliente del arrendamiento

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;				-- Entero cero
	SET Con_Principal		:= 1;				-- Consulta por llave primaria
	SET Con_PagAmorti		:= 2;				-- Consulta de amortizacion de la pantalla de amortizacion
	SET Decimal_Cero		:= 0.00;			-- Constante 0.0
	SET Cadena_Vacia		:= ''; 				-- Constante Vacia
	SET Fecha_Vacia         := '1900-01-01';	-- Fecha Vacia
	SET Var_SI 				:= 'S';				-- Permite Salida SI
	SET Var_NO  			:= 'N';				-- Permite Salida NO


	-- Asignacion de Constantes. Cardinal Sistemas Inteligentes
	SET Est_Vigente			:= 'V';		-- Estatus Vigente
	SET Est_Vencido			:= 'B';		-- Estatus Vencido
	SET EstatusPagado   	:= 'P';		-- Estatus Pagado


	SELECT	FechaSistema
		INTO	Var_FecActual
		FROM	PARAMETROSSIS;

	SELECT	cli.SucursalOrigen,	arrenda.ClienteID
		INTO	Var_SucCliente,	Var_Cliente
		FROM	ARRENDAMIENTOS arrenda
		INNER	JOIN CLIENTES cli	ON	arrenda.ClienteID	= cli.ClienteID
		WHERE	arrenda.ArrendaID	= Par_ArrendaID;

	SELECT	IVA
		INTO	Var_IVASucurs
		FROM	SUCURSALES
		WHERE	SucursalID	= Var_SucCliente;

	SET Var_IVASucurs	:= IFNULL(Var_IVASucurs, Decimal_Cero);

	SELECT PagaIVA INTO Var_CtePagIva   FROM CLIENTES  WHERE ClienteID = Var_Cliente;

	IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Var_CtePagIva	:= Var_Si;
	END IF;

	IF (Var_CtePagIva = Var_No) THEN
		SET Var_IVASucurs	:= Decimal_Cero;
	END IF;

	-- Consulta de amortizacion de arrendamiento, Utilizada en las Pantalla de Pago de Arrendamiento.
	-- No.Consulta: 2
	IF(Par_NumCon = Con_PagAmorti) THEN

		SELECT	FORMAT(IFNULL(SUM(amo.SaldoCapVigent),Decimal_Cero),2) AS SaldoCapVigent,
				FORMAT(IFNULL(SUM(amo.SaldoCapAtrasad),Decimal_Cero),2)AS SaldoCapAtrasad,
				FORMAT(IFNULL(SUM(amo.SaldoCapVencido),Decimal_Cero),2) AS SaldoCapVencido,
				FORMAT(IFNULL(SUM(amo.SaldoInteresVigente),Decimal_Cero),2) AS SaldoInteresVigente,
				FORMAT(IFNULL(SUM(amo.SaldoInteresAtras),Decimal_Cero),2) AS SaldoInteresAtras,
				FORMAT(IFNULL(SUM(amo.SaldoInteresVen),Decimal_Cero),2) AS SaldoInteresVen,
                FORMAT(IFNULL(SUM(ROUND(InteresRenta * Var_IVASucurs, 2)) - SUM(MontoIVAInteres) ,Decimal_Cero), 2) AS MontoIVAInteres,
                FORMAT(IFNULL(SUM(IVARenta - ROUND(InteresRenta * Var_IVASucurs, 2)) - SUM(MontoIVACapital),Decimal_Cero) , 2) AS MontoIVACapital,
                FORMAT(IFNULL(SUM(amo.SaldoMoratorios),Decimal_Cero),2) AS SaldoMoratorios,
				FORMAT((IFNULL(SUM(amo.SaldoMoratorios),Decimal_Cero)*Var_IVASucurs),2) AS MontoIVAMora,
				FORMAT(IFNULL(SUM(amo.SaldComFaltPago),Decimal_Cero),2) AS SaldComFaltPago,
				FORMAT((IFNULL(SUM(amo.SaldComFaltPago),Decimal_Cero)*Var_IVASucurs),2) AS MontoIVAComFalPag,
				FORMAT(IFNULL(SUM(amo.SaldoOtrasComis),Decimal_Cero),2) AS SaldoOtrasComis,
				FORMAT((IFNULL(SUM(amo.SaldoOtrasComis),Decimal_Cero)*Var_IVASucurs),2) AS MontoIVAComisi,
				FORMAT(IFNULL(SUM(amo.SaldoSeguro),Decimal_Cero),2) AS SaldoSeguro,
				FORMAT((IFNULL(SUM(amo.SaldoSeguro),Decimal_Cero)*Var_IVASucurs),2) AS MontoIVASeguro,
				FORMAT(IFNULL(SUM(amo.SaldoSeguroVida),Decimal_Cero),2) AS SaldoSeguroVida,
				FORMAT((IFNULL(SUM(amo.SaldoSeguroVida),Decimal_Cero)*Var_IVASucurs),2) AS MontoIVASeguroVida,
				FORMAT(IFNULL(SUM(amo.SaldoCapVigent+amo.SaldoCapAtrasad+amo.SaldoCapVencido),Decimal_Cero),2)	AS TotalCapital,
				FORMAT(IFNULL(SUM(amo.SaldoInteresVigente+amo.SaldoInteresAtras+amo.SaldoInteresVen),Decimal_Cero),2) AS TotalInteres,
				FORMAT(IFNULL(SUM(amo.SaldComFaltPago+amo.SaldoOtrasComis+amo.SaldoSeguro+amo.SaldoSeguroVida),Decimal_Cero),2)	AS TotalComision,
				FORMAT(IFNULL(SUM((IFNULL(amo.SaldComFaltPago,Decimal_Cero)*Var_IVASucurs) + (IFNULL(amo.SaldoOtrasComis,Decimal_Cero)*Var_IVASucurs) +
									(IFNULL(amo.SaldoSeguro,Decimal_Cero)*Var_IVASucurs) +
									(IFNULL(amo.SaldoSeguroVida,Decimal_Cero)*Var_IVASucurs)),Decimal_Cero),2)	AS TotalIVACom,
				FORMAT(IFNULL(SUM(	ROUND(amo.SaldoCapVigent,2) + ROUND(amo.SaldoCapAtrasad,2) + ROUND(amo.SaldoCapVencido,2) + ROUND(amo.SaldoInteresVigente,2) +
									ROUND(amo.SaldoInteresAtras,2) + ROUND(amo.SaldoInteresVen,2) + ROUND(amo.SaldComFaltPago,2)+ ROUND(amo.SaldoOtrasComis,2) +
									ROUND(amo.SaldoSeguro,2) + ROUND(amo.SaldoMoratorios,2) + ROUND(amo.SaldoSeguroVida,2)+
									ROUND((amo.SaldComFaltPago*Var_IVASucurs),2) +
									ROUND((amo.SaldoOtrasComis*Var_IVASucurs),2) +
									ROUND((amo.SaldoSeguro*Var_IVASucurs),2) +
									ROUND((amo.SaldoSeguroVida*Var_IVASucurs),2) +
									(ROUND(InteresRenta * Var_IVASucurs, 2) - MontoIVAInteres) +              -- IVA de Interes
									(IVARenta - ROUND(InteresRenta * Var_IVASucurs, 2) - MontoIVACapital) +   -- IVA de Capital
									ROUND((amo.SaldoMoratorios*Var_IVASucurs),2)
									),Decimal_Cero),2)	AS TotalExigible
			FROM	ARRENDAAMORTI amo
			WHERE	amo.ArrendaID = Par_ArrendaID
			  AND	amo.FechaExigible	<= Var_FecActual
			  AND Estatus       != EstatusPagado;


	END IF;
END TerminaStore$$