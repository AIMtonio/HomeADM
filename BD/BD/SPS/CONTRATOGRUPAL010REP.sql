DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOGRUPAL010REP`;
DELIMITER $$

CREATE PROCEDURE `CONTRATOGRUPAL010REP`(
	Par_GrupoID				INT,
	Par_TipoConsulta		INT,

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

		DECLARE Var_GrupoID				INT(11);         -- VARIABLE GRUPO
	DECLARE Var_MontoTotal			VARCHAR(100);    -- VARIABLE MONTO
	DECLARE Var_PorcBonifNum		DECIMAL(14,4);   -- VARIABLE PORCENTAJE BONIFICACION
	DECLARE Var_PorcBonif			VARCHAR(100);    -- VARIABLE PORCENTAJE
	DECLARE Var_MontoBonif			VARCHAR(100);    -- VARIABLE MONTO BONIFICACION
	DECLARE Var_Plazo				VARCHAR(20);     -- VARIABLE PLAZO
	DECLARE Var_TasaOrdinaria		VARCHAR(100);    -- VARIABLE TASA
	DECLARE Var_TasaMoratoria		VARCHAR(100);    -- VARIABLE TASA MORATORIA
	DECLARE Var_CAT					VARCHAR(100);    -- VARIABLE CAT
	DECLARE Var_ComisionAdmon		VARCHAR(100);    -- VARIABLE COMISION
	DECLARE Var_MontoComAdm			VARCHAR(100);    -- VARIABLE MONTO ADMINISTRATIVO
	DECLARE Var_CoberturaSeguro		VARCHAR(100);    -- VARIABLE SEGURO
	DECLARE Var_PrimaSeguro			VARCHAR(100);    -- VARIABLE PRIMA SEGURO
	DECLARE Var_DatosUEAU			VARCHAR(250);    -- VARIABLE DATOS
	DECLARE Var_PorcGarLiquida		VARCHAR(100);    -- VARIABLE GARANTIA
	DECLARE Var_MontoGarLiquida		VARCHAR(100);    -- VARIABLE GARANTIA MONTO
	DECLARE Var_Reca				VARCHAR(250);    -- VARIABLE RECA
	DECLARE Var_DireccionSuc		VARCHAR(150);    -- VARIABLE DIRECCION
	DECLARE Var_FechaIniCredito		VARCHAR(150);    -- VARIABLE FECHA INICIO
	DECLARE Var_FechaNacRepLegal	VARCHAR(150);    -- VARIABLE NACIONAL
	DECLARE Var_DirecRepLegal		VARCHAR(150);    -- VARIABLE REP
	DECLARE Var_IdentRepLegal		VARCHAR(150);    -- VARIABLE IDENTIFACION
	DECLARE Var_DirecPresidenta		VARCHAR(300);    -- VARIABLE DIC PRESIDENTA 


	DECLARE Var_Generales			INT;             -- VARIABLE GENERALES
	DECLARE Var_Cuotas				INT;             -- VARIABLE CUOTAS
	DECLARE Var_FormatoTasaConsol	CHAR(2);         -- VARIABLE TASA
	DECLARE Var_FormatoPesoConsol	CHAR(2);         -- VARIABLE PESO
	DECLARE Var_MoraNVeces			CHAR(1);         -- VARIABLE MORA  
	DECLARE Var_MoraTasa			CHAR(1);         -- VARIABLE MORA TASAS
	DECLARE Var_Presidente			INT(11);         -- VARIABLE PRESIDENTE
	DECLARE Decimal_Cero			DECIMAL(14,2);   
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Var_SI					CHAR(1);
	DECLARE Var_Esta_Activo			CHAR(1);

	SET Var_Generales			:= 1;
	SET Var_Cuotas				:= 2;
	SET Var_FormatoTasaConsol	:= '%A';
	SET Var_FormatoPesoConsol	:= '$C';
	SET Var_MoraNVeces			:= 'N';
	SET Var_MoraTasa			:= 'T';
	SET Var_Presidente			:= 1;
	SET Decimal_Cero			:= 0.00;
	SET Cadena_Vacia			:= '';
	SET Var_SI					:= 'S';
	SET Var_Esta_Activo			:= 'A';

	SET Var_GrupoID := Par_GrupoID;

	IF(Par_TipoConsulta = Var_Generales) THEN
		SELECT	CONVPORCANT(SUM(IFNULL(MontoCredito, Decimal_Cero)), Var_FormatoPesoConsol, 'Peso', 'Nacional')
				INTO Var_MontoTotal
		FROM CREDITOS AS C
			INNER JOIN INTEGRAGRUPOSCRE AS I
					ON I.SolicitudCreditoID = C.SolicitudCreditoID
						AND I.GrupoID = Var_GrupoID
						AND I.Estatus = Var_Esta_Activo
			GROUP BY I.GrupoID;

		SET Var_PorcBonifNum := 1.00;

		SELECT CONVPORCANT(IFNULL(Var_PorcBonifNum, 0.00), Var_FormatoTasaConsol, '1', ' ANUAL MÁS I.V.A.') INTO Var_PorcBonif;

		SELECT	CONVPORCANT(IFNULL(SUM(IFNULL(MontoCredito, Decimal_Cero)) * Var_PorcBonifNum / 100, 0.00), Var_FormatoPesoConsol, 'Peso', 'Nacional')
				INTO Var_MontoBonif
		FROM CREDITOS C
			INNER JOIN INTEGRAGRUPOSCRE AS I
				ON I.SolicitudCreditoID = C.SolicitudCreditoID
					AND I.Estatus = Var_Esta_Activo
					AND I.GrupoID = Var_GrupoID
		GROUP BY I.GrupoID;

		SELECT IFNULL(Descripcion, Cadena_Vacia) INTO Var_Plazo
		FROM CREDITOSPLAZOS AS CP
			INNER JOIN CREDITOS AS C
						ON C.PlazoID = CP.PlazoID

			INNER JOIN INTEGRAGRUPOSCRE AS I
						ON I.SolicitudCreditoID = C.SolicitudCreditoID
							AND I.Cargo = Var_Presidente
							AND I.Estatus = Var_Esta_Activo
							AND I.GrupoID = Var_GrupoID;

		SELECT 	CONVPORCANT(IFNULL(TasaFija, Decimal_Cero), Var_FormatoTasaConsol, '2', ' ANUAL MÁS I.V.A.'),
				CONVPORCANT(IF(TipCobComMorato = Var_MoraTasa,
							IFNULL(FactorMora, Decimal_Cero),
							IFNULL(FactorMora, Decimal_Cero) * IFNULL(TasaFija, Decimal_Cero)),
							Var_FormatoTasaConsol, '2', ' ANUAL MÁS I.V.A.'),
				CONVPORCANT(IFNULL(ValorCAT, Decimal_Cero), Var_FormatoTasaConsol, '2', ' ANUAL MÁS I.V.A.'),
				REPLACE(
				CONCAT(DAY(FechaInicio), ' (', FNLETRACAPITAL(FUNCIONSOLONUMLETRAS(DAY(FechaInicio))), ') días del mes de ',FNLETRACAPITAL(FUNCIONMESNOMBRE(FechaInicio)), ' del año ', YEAR(FechaInicio), ' (', 
					SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(FechaInicio)), 1, 1),
					LOWER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(FechaInicio)), 2, length(FUNCIONSOLONUMLETRAS(YEAR(FechaInicio)))-2))
					,')'), ' )', ')')
				INTO Var_TasaOrdinaria, Var_TasaMoratoria, Var_CAT, Var_FechaIniCredito
		FROM CREDITOS C
			INNER JOIN INTEGRAGRUPOSCRE AS I
						ON I.SolicitudCreditoID = C.SolicitudCreditoID
							AND I.Cargo = Var_Presidente
							AND I.Estatus = Var_Esta_Activo
							AND I.GrupoID = Var_GrupoID;

		SELECT	CONVPORCANT(MAX(IFNULL(PorcGarLiq, Decimal_Cero)), Var_FormatoTasaConsol, '2', ''),
				CONVPORCANT(IFNULL(SUM(AporteCliente), Decimal_Cero), Var_FormatoPesoConsol, '2', ')')
				INTO Var_PorcGarLiquida, Var_MontoGarLiquida
		FROM CREDITOS C
			INNER JOIN INTEGRAGRUPOSCRE AS I
						ON I.SolicitudCreditoID = C.SolicitudCreditoID
						AND I.Estatus = Var_Esta_Activo
						AND I.GrupoID = Var_GrupoID
		GROUP BY I.GrupoID;

		SELECT CONVPORCANT(0.00, Var_FormatoTasaConsol, '2', ' ANUAL MÁS I.V.A.') INTO Var_ComisionAdmon;
		SELECT CONVPORCANT(0.00, Var_FormatoPesoConsol, 'Peso', 'Nacional') INTO Var_MontoComAdm;

		SELECT CONVPORCANT(30000.00, Var_FormatoPesoConsol, 'Peso', 'Nacional') INTO Var_CoberturaSeguro;
		SELECT CONVPORCANT(90.00, Var_FormatoPesoConsol, 'Peso', 'Nacional') INTO Var_PrimaSeguro;  -- CS tkt 11213

		SELECT CONCAT('Domicilio: ', IFNULL(DireccionUEAU, Cadena_Vacia), ' Tel: ',
				IFNULL(TelefonoUEAU, Cadena_Vacia), ', ', IFNULL(OtrasCiuUEAU, Cadena_Vacia),
				' www.consolnegocios.com', ' e-mail: ', IFNULL(CorreoUEAU, Cadena_Vacia))
				INTO Var_DatosUEAU
		FROM EDOCTAPARAMS;

		SET Var_DatosUEAU := IFNULL(Var_DatosUEAU, Cadena_Vacia);

		SELECT 'Tlajomulco de Zúñiga, Jalisco' INTO Var_DireccionSuc;

		SELECT FNFECHATEXTO(CP.FechaNac), CP.Domicilio, CP.NumIdentific
			   INTO Var_FechaNacRepLegal, Var_DirecRepLegal, Var_IdentRepLegal
		  FROM CUENTASPERSONA AS CP,
			   CUENTASAHO AS CA,
			   CLIENTES AS C
		 WHERE C.ClienteID = 1
		       AND C.ClienteID = CA.ClienteID
		       AND CA.CuentaAhoID = CP.CuentaAhoID
		       AND CP.EsApoderado = 'S'
		LIMIT 1; 

		SELECT IFNULL(P.RegistroRECA, Cadena_Vacia) INTO Var_Reca
	      FROM PRODUCTOSCREDITO AS P
		       INNER JOIN CREDITOS AS C
			              ON C.ProductoCreditoID = P.ProducCreditoID
		       INNER JOIN INTEGRAGRUPOSCRE AS I
			              ON I.SolicitudCreditoID = C.SolicitudCreditoID
						     AND I.Cargo = Var_Presidente
						     AND I.Estatus = Var_Esta_Activo
							 AND I.GrupoID = Var_GrupoID;

		SELECT IFNULL(D.DireccionCompleta, Cadena_Vacia) INTO Var_DirecPresidenta
	      FROM DIRECCLIENTE AS D
		       INNER JOIN INTEGRAGRUPOSCRE AS I
			              ON I.ClienteID = D.ClienteID
						     AND I.Cargo = Var_Presidente
						     AND I.Estatus = Var_Esta_Activo
							 AND I.GrupoID = Var_GrupoID
							 AND D.Oficial = Var_SI;


		SELECT	Var_GrupoID AS GrupoID, Var_MontoTotal AS MontoTotal, Var_PorcBonif AS PorcBonif, Var_MontoBonif AS MontoBonif, Var_Plazo AS Plazo,
				Var_TasaOrdinaria AS TasaOrdinaria, Var_TasaMoratoria AS TasaMoratoria, Var_CAT AS CAT, Var_ComisionAdmon AS ComisionAdmon,
				Var_MontoComAdm AS MontoComAdm, Var_CoberturaSeguro AS CoberturaSeguro, Var_PrimaSeguro AS PrimaSeguro, Var_DatosUEAU AS DatosUEAU,
				Var_PorcGarLiquida AS PorcGarLiquida, Var_MontoGarLiquida AS MontoGarLiquida, Var_Reca AS Reca,
				Var_DireccionSuc AS DireccionSuc, Var_FechaNacRepLegal AS FechaNacRepLegal, Var_DirecRepLegal AS DirecRepLegal,
				Var_IdentRepLegal AS IdentRepLegal, Var_FechaIniCredito AS FechaIniCredito, Var_DirecPresidenta AS DireccionPresidenta;

	END IF;

	IF(Par_TipoConsulta = Var_Cuotas) THEN
		SELECT P.AmortizacionID,	FNFECHATEXTO(MAX(FechaVencim)) AS FechaPago,
			   CONVPORCANT(SUM(P.Capital + P.Interes + P.IVAInteres), '$C', 'PESOS', 'NACIONAL') AS MontoCuota
		  FROM PAGARECREDITO AS P
		       INNER JOIN CREDITOS AS C
			              ON C.CreditoID = P.CreditoID
				INNER JOIN INTEGRAGRUPOSCRE AS I
						   ON I.SolicitudCreditoID = C.SolicitudCreditoID
						      AND I.Estatus = Var_Esta_Activo
			                  AND I.GrupoID = Var_GrupoID
		GROUP BY P.AmortizacionID;
	END IF;

END TerminaStore$$
