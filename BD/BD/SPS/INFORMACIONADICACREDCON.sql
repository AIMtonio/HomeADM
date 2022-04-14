-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFORMACIONADICACREDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFORMACIONADICACREDCON`;
DELIMITER $$


CREATE PROCEDURE `INFORMACIONADICACREDCON`(
/*SP para la consulta de correos*/
	Par_ClienteID			INT(11),				-- Numero ID del Correo
	Par_NumCon				TINYINT UNSIGNED,		-- Numero de consulta

	/* Parametros de Auditoria */
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
	DECLARE Var_MostrarPantalla		INT(11);				-- Indica que numero de subform mostrara en pantalla
	DECLARE Var_TipoSociedadID		INT(11);				-- Tipo de Sociedad
	DECLARE Var_TipoPersona			CHAR(1);				-- Tipo de Persona
	DECLARE Var_Descripcion			VARCHAR(100);			-- Descripcion de la Sociedad
	DECLARE Var_EsFinanciera		CHAR(1);				-- Indica si el Cliente es una Institucion financiera
	DECLARE Var_Activos				DECIMAL(14,2);			-- Cantidad de activos que tiene el cliente.
	DECLARE Var_ROE					DECIMAL(14,2);
	DECLARE Var_TipCamDof			DECIMAL(14,6);			-- Tipo de Cambio de Moneda
	DECLARE Var_VentaAnuales		DECIMAL(14,2);			-- Cantidad de activos que tiene el cliente.

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);				-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero				INT;					-- Entero Cero
	DECLARE Cons_Si					CHAR(1);				-- Constante SI
	DECLARE Var_MostrarSi			CHAR(1);				-- Mostrar SI
	DECLARE Cons_No					CHAR(1);				-- Constante No
	DECLARE TipoSocIDAlmacen		INT(11);				-- Tipo de Sociedad Financiera que es almacen
	DECLARE TipoPersMoral			CHAR(1);				-- Tipo de Persona Moral
	DECLARE TipoPersFisica			CHAR(1);				-- Tipo de Persona Fisica
	DECLARE TipoPersFisicaActEmp	CHAR(1);				-- Tipo de Persona Fisica Con Actividad Empresarial
	DECLARE ActivosSuperioresA14	DECIMAL(14,2);			-- Activos Mayores A
	DECLARE ActivosSuperioresA600	DECIMAL(14,2);			-- Activos Mayores A los 600 millones
	DECLARE ActivosSuperioresA54	DECIMAL(14,2);			-- Activos Mayores A los 54 millones
	DECLARE Var_UDIS				VARCHAR(45);			-- Simbolo de Moneda UDIS


	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';				-- Cadena vacia
	SET	Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero					:= 0;				-- Entero Cero
	SET Cons_No						:= 'N';				-- Constante No
	SET Cons_Si						:= 'S';				-- Constante Si
	SET TipoPersMoral				:= 'M';				-- Tipo de Persona Moral
	SET TipoPersFisica				:= 'F';				-- Tipo de Persona Fisica
	SET TipoPersFisicaActEmp		:= 'A';				-- Tipo de Persona Fisica con Actividad Empresaral
	SET TipoSocIDAlmacen			:= 21;				-- De acuerdo a la tabla [TIPOSOCIEDAD] - 21 ALMACENES GENERALES DE DEPOSITO
	SET Var_MostrarSi := 'N';
	SET Var_UDIS 					:= 'UDIS';

	SELECT
		CLI.TipoSociedadID,		CLI.TipoPersona,			TIP.Descripcion,			TIP.EsFinanciera,			CON.Activos,
		CON.ImporteVta
		INTO
		Var_TipoSociedadID,		Var_TipoPersona,			Var_Descripcion,			Var_EsFinanciera,			Var_Activos,
		Var_VentaAnuales
		FROM CLIENTES AS CLI
			LEFT JOIN TIPOSOCIEDAD AS TIP ON CLI.TipoSociedadID = TIP.TipoSociedadID
			LEFT JOIN CONOCIMIENTOCTE AS CON ON CLI.ClienteID = CON.ClienteID
			WHERE CLI.ClienteID = Par_ClienteID;

	SET Var_Activos := IFNULL(Var_Activos, Entero_Cero);
	SET Var_VentaAnuales := IFNULL(Var_VentaAnuales, Entero_Cero);

	SET Var_Roe := IFNULL((SELECT CapitalContable FROM CONOCIMIENTOCTE WHERE ClienteID = Par_ClienteID),0);

	SELECT TipCamDof INTO Var_TipCamDof
		FROM MONEDAS
		WHERE Simbolo = Var_UDIS;

	SET ActivosSuperioresA600 := ROUND((600000000 * Var_TipCamDof),2);
	SET ActivosSuperioresA14 := ROUND((14000000 * Var_TipCamDof),2);
	SET ActivosSuperioresA54 := ROUND((54000000 * Var_TipCamDof),2);

	SET Var_MostrarPantalla := 0;
	-- Si el acreditado sea una entidad financiera
	IF(Var_EsFinanciera = Cons_Si AND Var_TipoSociedadID != TipoSocIDAlmacen) THEN
		SET Var_MostrarPantalla := 1;
		IF(Var_Activos>ActivosSuperioresA600) THEN
			SET Var_MostrarSi := 'S';
		END IF;
	END IF;

	IF(Var_TipoSociedadID = TipoSocIDAlmacen AND Var_EsFinanciera = Cons_No) THEN
		SET Var_MostrarPantalla := 2;
		IF(Var_Activos>ActivosSuperioresA600) THEN
			SET Var_MostrarSi := 'S';
		END IF;
	END IF;

	IF(((Var_TipoPersona = TipoPersMoral AND Var_EsFinanciera = Cons_No) OR (Var_TipoPersona IN('F','A')))
		AND Var_VentaAnuales < ActivosSuperioresA14) THEN
		SET Var_MostrarPantalla := 3;
		IF(Var_VentaAnuales>=ActivosSuperioresA14) THEN
			SET Var_MostrarSi := 'S';
		END IF;
	END IF;

	IF(Var_MostrarPantalla = Entero_Cero) THEN
		SET Var_MostrarPantalla := 3;
		IF(Var_VentaAnuales>=ActivosSuperioresA54) THEN
			SET Var_MostrarSi := 'S';
		END IF;
	END IF;

	IF(Var_MostrarPantalla = 1) THEN
		SELECT
			CLI.ClienteID AS Acreditado,
			INF.Idacreditadofira,
			INF.Activocirc AS ActivoCirculante,
			INF.Activosprod AS ActivoProductivos,
			INF.Asrtot AS ActivoSujetosRiesgo,
			INF.Anioingresobruto AS AnioIngresosBruto,
			INF.Califexterna,
			INF.Carteracredito AS CarteraCredito,
			INF.Carteraneta AS CarteraNeta,
			INF.Carteravenc AS CarteraVencida,
			INF.Clientes,
			INF.Compaccion AS CompAccionaria,
			INF.Competencia,
			INF.Consejoadmon AS ConsejoAdmin,
			INF.Contaguber AS CumpleContaGuberna,
			INF.Depbienes AS DepositoDeBienes,
			INF.Emisiontit AS EmisionTitulos,
			INF.Entregulada AS EntidadRegulada,
			INF.Estrucorganiz AS EstructOrgan,
			INF.Fechaedosfin AS FechaEdoFinan,
			INF.Fechaedosfinvn AS FechEdoFinanVentNet,
			INF.Fondeotot AS FondeoTotal,
			INF.Gastosadmon AS GastosAdmin,
			INF.Gastosfin AS GastosFinan,
			INF.Ingresobruto AS IngresosBrutos,
			INF.Ingresostotales AS IngresosTotales,
			INF.Margenfin AS MargenFinan,
			INF.Nivelpoliticas AS NivelPoliticas,
			CLI.NombreCompleto,
			INF.Numempleados AS NumeroEmpleados,
			INF.Numlineas AS NumeroLineasNeg,
			INF.Pasivocirc AS PasivoCirculante,
			INF.Pasivoexigible AS PasivoExigible,
			INF.Pasivolargo AS PasivoLargoPlazo,
            INF.Edosfinaud as PeriodosAudEdoFin,
			INF.Gobiernocorp AS ProcesoAuditoria,
			INF.Proveedores,
			INF.Roe AS ROE,
			INF.Retlab1 AS TasaRetLaboral1,
			INF.Retlab2 AS TasaRetLaboral2,
			INF.Retlab3 AS TasaRetLaboral3,
			INF.Tipoentidad AS TipoEntidad,
			INF.Uafir AS UtilAntGastImpues,
			INF.Utilidadneta AS UtilidaNeta,
			INF.Califexterna AS CalificacionExterna,
			Var_TipoSociedadID AS TipoSociedadID,
			Var_Descripcion AS TipoSociedad,IF(INF.ClienteID IS NULL,1,2) AS TipoTransaccion,
			Var_MostrarSi AS MostrarSi,
			Var_MostrarPantalla as MostrarPantalla,
			INF.Eprc AS EPRC,
			INF.NumFuentes,
			INF.SaldoAcreditados,
			INF.NumConsejerosInd,
			INF.NumConsejerosTot,
			INF.PorcParticipacionAcc,
			INF.Capitalcontableagd AS CapitalContable,
			INF.Aniosexp AS ExpLaboral
			FROM CLIENTES AS CLI LEFT JOIN
				INFORMACIONADICFIRA AS INF ON CLI.ClienteID = INF.ClienteID
				WHERE CLI.ClienteID = Par_ClienteID;
	  ELSEIF(Var_MostrarPantalla = 2) THEN
		SELECT
			CLI.ClienteID AS Acreditado,
			INF.Idacreditadofira,
			INF.Activocirc AS ActivoCirculante,
			INF.Activosprod AS ActivoProductivos,
			INF.Asrtot AS ActivoSujetosRiesgo,
			INF.Anioingresobruto AS AnioIngresosBruto,
			INF.Califexterna,
			INF.Carteracredito AS CarteraCredito,
			INF.Carteraneta AS CarteraNeta,
			INF.Carteravenc AS CarteraVencida,
			INF.Clientes,
			INF.Compaccion AS CompAccionaria,
			INF.Competencia,
			INF.Consejoadmon AS ConsejoAdmin,
			INF.Contaguber AS CumpleContaGuberna,
			INF.Depbienes AS DepositoDeBienes,
			INF.Emisiontitagd AS EmisionTitulos,
			INF.Entregulada AS EntidadRegulada,
			INF.Estrucorganiz AS EstructOrgan,
			INF.Fechaedosfinagd AS FechaEdoFinan,
			INF.Fechaedosfinvn AS FechEdoFinanVentNet,
			INF.Fondeotot AS FondeoTotal,
			INF.Gastosadmonagd AS GastosAdmin,
			INF.Gastosfin AS GastosFinan,
			INF.Ingresostotagd AS IngresosBrutos,
			INF.Ingresostotales AS IngresosTotales,
			INF.Margenfin AS MargenFinan,
			INF.Nivelpoliticas AS NivelPoliticas,
			INF.Numempleados AS NumeroEmpleados,
			INF.Numlineas AS NumeroLineasNeg,
			INF.Pasivocirc AS PasivoCirculante,
			INF.Pasivoexigible AS PasivoExigible,
			INF.Pasivolargo AS PasivoLargoPlazo,
            INF.Edosfinaud as PeriodosAudEdoFin,
			INF.Gobiernocorp AS ProcesoAuditoria,
			INF.Proveedores,
			INF.Roeagd AS ROE,
			INF.Retlab1 AS TasaRetLaboral1,
			INF.Retlab2 AS TasaRetLaboral2,
			INF.Retlab3 AS TasaRetLaboral3,
			INF.Tipoentidad AS TipoEntidad,
			INF.Uafir AS UtilAntGastImpues,
			INF.Utilidadnetaagd AS UtilidaNeta,
			INF.Califexterna AS CalificacionExterna,
			CLI.NombreCompleto,
			Var_TipoSociedadID AS TipoSociedadID,
			Var_Descripcion AS TipoSociedad,IF(INF.ClienteID IS NULL,1,2) AS TipoTransaccion,
			Var_MostrarSi AS MostrarSi,
			Var_MostrarPantalla as MostrarPantalla,
			INF.Eprc AS EPRC,
			INF.NumFuentes,
			INF.SaldoAcreditados,
			INF.NumConsejerosInd,
			INF.NumConsejerosTot,
			INF.PorcParticipacionAcc,
			INF.Capitalcontableagd AS CapitalContable,
			INF.Aniosexp AS ExpLaboral
			FROM
				CLIENTES AS CLI LEFT JOIN INFORMACIONADICFIRA AS INF ON CLI.ClienteID = INF.ClienteID
				WHERE CLI.ClienteID = Par_ClienteID;
	  ELSEIF(Var_MostrarPantalla = 3) THEN
		SELECT
			CLI.ClienteID AS Acreditado,
			INF.Activocirc AS ActivoCirculante,
			INF.Activosprod AS ActivoProductivos,
			INF.Asrtot AS ActivoSujetosRiesgo,
			INF.Anioingresobrutom AS AnioIngresosBruto,
			INF.Califexterna,
			INF.Carteracredito AS CarteraCredito,
			INF.Carteraneta AS CarteraNeta,
			INF.Carteravenc AS CarteraVencida,
			INF.Clientes,
			INF.Compaccion AS CompAccionaria,
			INF.Competencia,
			INF.Consejoadmon AS ConsejoAdmin,
			INF.Contaguber AS CumpleContaGuberna,
			INF.Depbienes AS DepositoDeBienes,
			INF.Emisiontitagd AS EmisionTitulos,
			INF.Entregulada AS EntidadRegulada,
			IFNULL(INF.Estrucorganiz,1) AS EstructOrgan,
			INF.Fechaedosfinm AS FechaEdoFinan,
			INF.Fechaedosfinvn AS FechEdoFinanVentNet,
			INF.Fondeotot AS FondeoTotal,
			INF.Gastosadmonagd AS GastosAdmin,
			INF.Gastosfin AS GastosFinan,
			INF.Ingresobrutom AS IngresosBrutos,
			INF.Ingresostotales AS IngresosTotales,
			INF.Margenfin AS MargenFinan,
			INF.Nivelpoliticas AS NivelPoliticas,
			INF.Numempleadosm AS NumeroEmpleados,
			INF.Numlineas AS NumeroLineasNeg,
			INF.Pasivocirc AS PasivoCirculante,
			INF.Pasivoexigible AS PasivoExigible,
			INF.Pasivolargo AS PasivoLargoPlazo,
			INF.Edosfinaudm AS PeriodosAudEdoFin,
			INF.Gobiernocorp AS ProcesoAuditoria,
			INF.Proveedores,
			INF.Roem AS ROE,
			INF.Retlab1m AS TasaRetLaboral1,
			INF.Retlab2m AS TasaRetLaboral2,
			INF.Retlab3m AS TasaRetLaboral3,
			INF.Tipoentidad AS TipoEntidad,
			INF.Uafir AS UtilAntGastImpues,
			INF.Utilidadnetam AS UtilidaNeta,
			INF.Califexterna AS CalificacionExterna,
			CLI.NombreCompleto,
			Var_TipoSociedadID AS TipoSociedadID,
			Var_Descripcion AS TipoSociedad,IF(INF.ClienteID IS NULL,1,2) AS TipoTransaccion,
			Var_MostrarSi AS MostrarSi,
			Var_MostrarPantalla as MostrarPantalla,
			INF.Eprc AS EPRC,
			INF.NumFuentes,
			INF.SaldoAcreditados,
			INF.NumConsejerosInd,
			INF.NumConsejerosTot,
			INF.PorcParticipacionAcc,
			INF.Capitalcontableagd AS CapitalContable,
			INF.Aniosexp AS ExpLaboral
			FROM CLIENTES AS CLI LEFT JOIN
				INFORMACIONADICFIRA AS INF ON CLI.ClienteID = INF.ClienteID
				WHERE CLI.ClienteID = Par_ClienteID;
	  ELSE
		SELECT
			CLI.ClienteID AS Acreditado,
			INF.Activocirc AS ActivoCirculante,
			INF.Activosprod AS ActivoProductivos,
			INF.Asrtot AS ActivoSujetosRiesgo,
			INF.Anioingresobruto AS AnioIngresosBruto,
			INF.Califexterna,
			INF.Carteracredito AS CarteraCredito,
			INF.Carteraneta AS CarteraNeta,
			INF.Carteravenc AS CarteraVencida,
			INF.Clientes,
			INF.Compaccion AS CompAccionaria,
			INF.Competencia,
			INF.Consejoadmon AS ConsejoAdmin,
			INF.Contaguber AS CumpleContaGuberna,
			INF.Depbienes AS DepositoDeBienes,
			INF.Emisiontit AS EmisionTitulos,
			INF.Entregulada AS EntidadRegulada,
			INF.Estrucorganiz AS EstructOrgan,
			INF.Fechaedosfin AS FechaEdoFinan,
			INF.Fechaedosfinvn AS FechEdoFinanVentNet,
			INF.Fondeotot AS FondeoTotal,
			INF.Gastosadmon AS GastosAdmin,
			INF.Gastosfin AS GastosFinan,
			INF.Ingresobruto AS IngresosBrutos,
			INF.Ingresostotales AS IngresosTotales,
			INF.Margenfin AS MargenFinan,
			INF.Nivelpoliticas AS NivelPoliticas,
			CLI.NombreCompleto,
			INF.Numempleados AS NumeroEmpleados,
			INF.Numlineas AS NumeroLineasNeg,
			INF.Pasivocirc AS PasivoCirculante,
			INF.Pasivoexigible AS PasivoExigible,
			INF.Pasivolargo AS PasivoLargoPlazo,
			INF.Edosfinaud AS PeriodosAudEdoFin,
			INF.Gobiernocorp AS ProcesoAuditoria,
			INF.Proveedores,
			INF.Roe AS ROE,
			INF.Retlab1 AS TasaRetLaboral1,
			INF.Retlab2 AS TasaRetLaboral2,
			INF.Retlab3 AS TasaRetLaboral3,
			INF.Tipoentidad AS TipoEntidad,
			INF.Uafir AS UtilAntGastImpues,
			INF.Utilidadneta AS UtilidaNeta,
			INF.Califexterna AS CalificacionExterna,
			Var_TipoSociedadID AS TipoSociedadID,
			Var_Descripcion AS TipoSociedad,IF(INF.ClienteID IS NULL,1,2) AS TipoTransaccion,
			Var_MostrarSi AS MostrarSi,
			Var_MostrarPantalla as MostrarPantalla,
			INF.Eprc AS EPRC,
			INF.NumFuentes,
			INF.SaldoAcreditados,
			INF.NumConsejerosInd,
			INF.NumConsejerosTot,
			INF.PorcParticipacionAcc,
			INF.Capitalcontableagd AS CapitalContable,
			INF.Aniosexp AS ExpLaboral,
			INF.Edosfinaud as PeriodosAudEdoFin
			FROM CLIENTES AS CLI LEFT JOIN
				INFORMACIONADICFIRA AS INF ON CLI.ClienteID = INF.ClienteID
				WHERE CLI.ClienteID = Par_ClienteID;
	END IF;

END TerminaStore$$