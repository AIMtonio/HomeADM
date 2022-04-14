-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `RATIOSCON`;DELIMITER $$

CREATE PROCEDURE `RATIOSCON`(
/*SP para realizar la consulta del proceso de RATIOS*/
	Par_SolicitudCreditoID	INT(11),					# Numero de solicitud
	Par_NumCon				TINYINT UNSIGNED,			# Numero de consulta
	/*Auditoria*/
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_MontoSoli			DECIMAL(12,2);
	DECLARE Var_TasaFija			DECIMAL(14,4);
	DECLARE	Var_PeriodicidadCap		INT(11);
	DECLARE Var_NumAmortizacion 	INT(11);
	DECLARE Var_TipoPagoCapital		CHAR(1);
	DECLARE Var_PagaIVA				CHAR(1);
	DECLARE Var_DiasCredito			INT(11);
	DECLARE Var_IVA					DECIMAL(12,2);
	DECLARE Var_MontoCapital		DECIMAL(12,2);
	DECLARE Var_MontoInteres		DECIMAL(12,2);
	DECLARE Var_IVAInteres			DECIMAL(12,2);
	DECLARE Var_MontoCuotaMayor		DECIMAL(14,6);
	DECLARE Var_CobraIVAInteres		CHAR(1);
	DECLARE Var_TasaPeriodica		DECIMAL(14,6);
	DECLARE Var_ProductoCreditoID	INT(11);
	DECLARE Var_NumTransacSim		BIGINT(20);

	-- Declaracion de Constantes
	DECLARE Con_Principal			INT;
	DECLARE Con_DatosGeneralesCte	INT;
	DECLARE Con_NAvales				INT;			# Consulta con el numero de avales
	DECLARE Entero_Cero				INT;
	DECLARE Decimal_Cero			DECIMAL;
	DECLARE PagoCapitalIguales		CHAR(1);
	DECLARE PagoCapitalCrecientes	CHAR(1);
	DECLARE ConstanteSI				CHAR(1);
	DECLARE PagoCapitalLibres		CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);

	-- Asignacion de Constantes
	SET Con_Principal				:=1;
	SET Con_DatosGeneralesCte		:=2;
	SET Con_NAvales					:=3;
	SET Decimal_Cero				:=0.0;
	SET PagoCapitalIguales			:='I';
	SET PagoCapitalCrecientes		:='C';
	SET ConstanteSI					:='S';
	SET PagoCapitalLibres			:='L';
	SET Cadena_Vacia				:='';
	SET Entero_Cero					:= 0;

	IF(Con_Principal = Par_NumCon)THEN
		SELECT Rat.SolicitudCreditoID,	PuntosTotal,		Rat.NivelRiesgo,	Caracter,			Capital,
				CapacidadPago,		Condiciones,		Niv.Descripcion,	TotalResidencia,	TotalOupacion,
				TotalMora, 			TotalAfiliacion,	TotalDeudaActual,	TotalDeudaCredito,	TotalCobertura,
				TotalGastos,		TotalGastosCredito,	TotalEstabilidadIng, TotalNegocio,		MontoTerreno,
				MontoVivienda,		MontoVehiculos,		MontoOtros,			PuntosIDEstNeg,		TieneNegocio,
				PuntosIDVentasMen,	PuntosIDLiquidez,	PuntosIDMercado, 	Rat.Estatus,			Colaterales,	COALESCE(Cte.NombreCompleto, Pro.NombreCompleto) AS NombreCompleto
			FROM RATIOS Rat
				INNER JOIN RATIOSNIVELRIESGO Niv ON Niv.NivelRiesgoID = Rat.NivelRiesgo
                INNER JOIN SOLICITUDCREDITO AS Sol ON Rat.SolicitudCreditoID = Sol.SolicitudCreditoID
                LEFT JOIN CLIENTES AS Cte ON Sol.ClienteID = Cte.ClienteID
                LEFT JOIN PROSPECTOS AS Pro ON Sol.ProspectoID = Pro.ProspectoID
				WHERE Rat.SolicitudCreditoID = Par_SolicitudCreditoID
                LIMIT 1;
	END IF;


	IF(Con_DatosGeneralesCte = Par_NumCon)THEN
		SELECT MontoSolici,			TasaFija,		PeriodicidadCap,		NumAmortizacion,
				TipoPagoCapital,	PagaIVA, ProductoCreditoID, 			NumTransacSim
				INTO
				Var_MontoSoli, Var_TasaFija,	Var_PeriodicidadCap,	Var_NumAmortizacion,
				Var_TipoPagoCapital,Var_PagaIVA, Var_ProductoCreditoID, 	Var_NumTransacSim
		FROM SOLICITUDCREDITO Sol
			LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Sol.ClienteID
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		SET Var_MontoSoli 				:= IFNULL(Var_MontoSoli, Entero_Cero);
		SET Var_TasaFija 				:= IFNULL(Var_TasaFija, Entero_Cero);
		SET Var_PeriodicidadCap 		:= IFNULL(Var_PeriodicidadCap, Entero_Cero);
		SET Var_NumAmortizacion 		:= IFNULL(Var_NumAmortizacion, Entero_Cero);
		SET Var_TipoPagoCapital 		:= IFNULL(Var_TipoPagoCapital, Cadena_Vacia);
		SET Var_PagaIVA 				:= IFNULL(Var_PagaIVA, ConstanteSI);
		SET Var_ProductoCreditoID 		:= IFNULL(Var_ProductoCreditoID, Entero_Cero);
		SET Var_NumTransacSim 			:= IFNULL(Var_NumTransacSim, Entero_Cero);

		SELECT DiasCredito INTO Var_DiasCredito FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;
		SELECT IVA  INTO Var_IVA FROM SUCURSALES WHERE SucursalID = Aud_Sucursal;
		SELECT CobraIVAInteres INTO Var_CobraIVAInteres FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProductoCreditoID;


		IF(Var_CobraIVAInteres =ConstanteSI AND  Var_PagaIVA =ConstanteSI)THEN
				SET Var_IVA		:= Var_IVA;
		ELSE
			SET Var_IVA		:= Decimal_Cero;
		END IF;


		IF(Var_TipoPagoCapital = PagoCapitalIguales)THEN
			SET Var_MontoCapital	:= IF(Var_NumAmortizacion != Entero_Cero, ROUND(Var_MontoSoli / Var_NumAmortizacion,2), Entero_Cero);
			SET Var_MontoInteres	:= ROUND((Var_MontoSoli * Var_TasaFija * Var_PeriodicidadCap)/(Var_DiasCredito *100),2);
			SET Var_IVAInteres		:= ROUND((Var_MontoInteres * Var_IVA ),2);

			SET Var_MontoCuotaMayor	:=  Var_MontoCapital + Var_MontoInteres + Var_IVAInteres;
			SELECT  Var_MontoCuotaMayor AS CuotaMaxima;
		END IF;

		IF(Var_TipoPagoCapital =PagoCapitalCrecientes)THEN
			SET Var_TasaPeriodica 	:= ROUND(((Var_TasaFija / 100) * (1 + Var_IVA ) * Var_PeriodicidadCap) / Var_DiasCredito,6);
			SET Var_MontoCuotaMayor	:=ROUND((Var_MontoSoli * Var_TasaPeriodica * POWER((1 + Var_TasaPeriodica),Var_NumAmortizacion))/ (POWER((1 + Var_TasaPeriodica),Var_NumAmortizacion) -1),0);

			SELECT Var_MontoCuotaMayor AS CuotaMaxima;

		END IF;
		IF(Var_TipoPagoCapital = PagoCapitalLibres)THEN
			SET Var_MontoCuotaMayor := (SELECT MAX(Tmp_SubTotal) FROM TMPPAGAMORSIM WHERE NumTransaccion = Var_NumTransacSim);
			SELECT Var_MontoCuotaMayor AS CuotaMaxima;
		END IF;

	END IF; -- Consulta Cuaotas mayores

	/**
	NConsulta: 3
	Consulta para traer el número de avales que tiene la solicitud de crédito
	**/
	IF(Con_NAvales = Par_NumCon)THEN
		SELECT IFNULL(COUNT(SolicitudCreditoID), Entero_Cero) AS NAvales
			FROM AVALESPORSOLICI
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID
                AND Estatus = 'U';
	END IF;

END	TerminaStore$$