-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQTOSCOBRANZA028REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQTOSCOBRANZA028REP`;
DELIMITER $$ 

CREATE PROCEDURE `REQTOSCOBRANZA028REP`(
	Par_ClienteID			INT(11),
	Par_RequerimientoID		INT(11),
	Par_GerenteID			INT(11),
	Par_NombreUSuario		VARCHAR(50),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_MoraInf		INT;			-- Numero inferioir de dias mora
	DECLARE Var_MoraSup		INT;			-- Numero superior de dias mora
	DECLARE Var_FechaSis	DATE;			-- Almacenar Fecha del sistema

	-- Declaracion de constantes
	DECLARE Var_EstPagago	CHAR(1);		-- Estatus Amortizacion Pagada 'P'
	DECLARE Var_Vencido		CHAR(1);		-- Estatus Credito Vencido 'B'
	DECLARE Var_Vigente		CHAR(1);		-- Estatus Credito Vigente 'V'
	DECLARE Var_ConCero		INT;			-- Constante numero 0
	DECLARE Var_DirOfi		CHAR(1);		-- Direccion Oficial de Cliente 'S'

	DECLARE Var_Cabecera	INT(11);		-- Numero para obtener la cabecera del reporte
	DECLARE Var_CobTasa		CHAR(1);		-- Cobra Factor Mora Tasa 'T'

	-- Inicializar Constantes
	SET	Var_EstPagago		:= 'P';			-- Estatus Amortizacion Pagada 'P'
	SET	Var_Vencido			:= 'B';			-- Estatus Credito Vencido 'B'
	SET	Var_Vigente			:= 'V';			-- Estatus Credito Vigente 'V'
	SET	Var_ConCero			:= 0;			-- Constante numero 0
	SET	Var_DirOfi			:= 'S';			-- Direccion Oficial de Cliente 'S'

	SET	Var_Cabecera		:= 4;			-- Numero para obtener la cabecera del reporte
	SET	Var_CobTasa			:= 'T';			-- Cobra Factor Mora Tasa 'T'

	IF(Par_RequerimientoID = Var_Cabecera) THEN

		SELECT Suc.DirecCompleta, Edos.Nombre AS Estado, Mun.Nombre AS Municipio
			FROM SUCURSALES Suc
			INNER JOIN USUARIOS Usu ON Suc.SucursalID = Usu.SucursalUsuario
			INNER JOIN ESTADOSREPUB Edos ON Suc.EstadoID = Edos.EstadoID
			INNER JOIN MUNICIPIOSREPUB Mun ON Edos.EstadoID = Mun.EstadoID
			  AND Suc.MunicipioID = Mun.MunicipioID
			WHERE Usu.NombreCompleto = Par_NombreUSuario;

	ELSE

		DROP TEMPORARY TABLE IF EXISTS TMPTAMREQTOSCOBRANZA;
		CREATE TEMPORARY TABLE TMPTAMREQTOSCOBRANZA(
			ClienteID			INT(11),
			CreditoID			BIGINT(12),
			NombreCliente		VARCHAR(200),
			DireccionCliente	VARCHAR(200),
			DiasMora			INT(11),
			FechaExigible		DATE,
			MontoExigible		VARCHAR(100),
			MontoLetras			VARCHAR(100),
			AmortVencidas		INT(11),
			InteresMora			DECIMAL(12,4),
			TasaFija			DECIMAL(12,4),
			KEY (`ClienteID`,`CreditoID`)
		);

		DROP TEMPORARY TABLE IF EXISTS TMPAUXREQTOSCOBRANZA;
		CREATE TEMPORARY TABLE TMPAUXREQTOSCOBRANZA(
			ClienteID			INT(11),
			CreditoID			BIGINT(12),
			DiasMora			INT(11),
			FechaExigible		DATE,
			AmortVencidas		INT(11),
			KEY (`ClienteID`,`CreditoID`)
		);

		SELECT		FechaSistema
			INTO	Var_FechaSis
			FROM PARAMETROSSIS;

		SET	Par_ClienteID	:= IFNULL(Par_ClienteID,Var_ConCero);

		INSERT INTO TMPAUXREQTOSCOBRANZA (ClienteID, CreditoID,DiasMora,FechaExigible, AmortVencidas)
			SELECT	Cre.ClienteID, Cre.CreditoID,DATEDIFF(Var_FechaSis,MIN(Amor.FechaExigible)) AS DiasMora, MIN(Amor.FechaExigible), COUNT(AmortizacionID)
				FROM CREDITOS Cre
				INNER JOIN AMORTICREDITO Amor ON Cre.CreditoID = Amor.CreditoID
				  AND Amor.FechaExigible <= Var_FechaSis 
				  AND Amor.Estatus <> Var_EstPagago
				WHERE Cre.Estatus IN (Var_Vencido,Var_Vigente)
				GROUP BY Amor.CreditoID, Cre.CreditoID;

		SELECT		DiasMoraInf,	DiasMoraSup 
			INTO 	Var_MoraInf,	Var_MoraSup
			FROM REQTOSCOBRANZA
			WHERE RequerimientoID = Par_RequerimientoID;

		IF(Par_ClienteID!=0)THEN

			INSERT INTO TMPTAMREQTOSCOBRANZA (
						ClienteID,			CreditoID,			NombreCliente,					DireccionCliente,
						DiasMora,			FechaExigible,		MontoExigible,					MontoLetras,
						AmortVencidas,		InteresMora,		TasaFija)
				SELECT	Tmp.ClienteID,		Tmp.CreditoID,		Cli.NombreCompleto,				Dir.DireccionCompleta,
						Tmp.DiasMora,		Tmp.FechaExigible,	FUNCIONEXIGIBLE(Tmp.CreditoID),	FUNCIONNUMLETRAS(FUNCIONEXIGIBLE(Tmp.CreditoID)),
						Tmp.AmortVencidas,	IF(Cre.TipCobComMorato=Var_CobTasa,Cre.FactorMora,Cre.FactorMora*Cre.TasaFija),
						Cre.TasaFija
					FROM TMPAUXREQTOSCOBRANZA Tmp
					LEFT JOIN CLIENTES Cli ON Tmp.ClienteID = Cli.ClienteID
					LEFT JOIN DIRECCLIENTE Dir ON Cli.ClienteID = Dir.ClienteID
					  AND Dir.Oficial = Var_DirOfi
					LEFT JOIN CREDITOS Cre ON Tmp.CreditoID = Cre.CreditoID
					WHERE Tmp.ClienteID = Par_ClienteID
					  AND Tmp.DiasMora BETWEEN Var_MoraInf AND Var_MoraSup;

		ELSE IF(Par_ClienteID = 0)THEN
				INSERT INTO TMPTAMREQTOSCOBRANZA (
						ClienteID,			CreditoID,			NombreCliente,					DireccionCliente,
						DiasMora,			FechaExigible,		MontoExigible,					MontoLetras,
						AmortVencidas,		InteresMora,		TasaFija)
				SELECT	Tmp.ClienteID,		Tmp.CreditoID,		Cli.NombreCompleto,				Dir.DireccionCompleta,
						Tmp.DiasMora,		Tmp.FechaExigible,	FUNCIONEXIGIBLE(Tmp.CreditoID),	FUNCIONNUMLETRAS(FUNCIONEXIGIBLE(Tmp.CreditoID)),
						Tmp.AmortVencidas,	IF(Cre.TipCobComMorato=Var_CobTasa,Cre.FactorMora,Cre.FactorMora*Cre.TasaFija),
						Cre.TasaFija
					FROM TMPAUXREQTOSCOBRANZA Tmp
					LEFT JOIN CLIENTES Cli ON Tmp.ClienteID = Cli.ClienteID
					LEFT JOIN DIRECCLIENTE Dir ON Cli.ClienteID = Dir.ClienteID
					  AND Dir.Oficial = Var_DirOfi
					LEFT JOIN CREDITOS Cre ON Tmp.CreditoID = Cre.CreditoID
					WHERE Tmp.DiasMora BETWEEN Var_MoraInf AND Var_MoraSup;
			END IF;
		END IF;

		SELECT	ClienteID,		CreditoID,		NombreCliente,	DireccionCliente,	DiasMora,
			DATE_FORMAT(FechaExigible,'%d/%m/%Y') AS FechaExigible,
			MontoExigible,	MontoLetras,	AmortVencidas,	FORMAT(InteresMora,2) AS InteresMora,
			FORMAT(TasaFija,2) AS TasaFija
		FROM TMPTAMREQTOSCOBRANZA
		ORDER BY ClienteID, CreditoID;

		DROP TABLE TMPAUXREQTOSCOBRANZA;

	END IF;

END TerminaStore$$