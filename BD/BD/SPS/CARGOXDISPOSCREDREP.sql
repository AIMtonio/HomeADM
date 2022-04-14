-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGOXDISPOSCREDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGOXDISPOSCREDREP`;DELIMITER $$

CREATE PROCEDURE `CARGOXDISPOSCREDREP`(
/* REPORTE DE LOS COBROS POR DISPOSICION DE CREDITO. */
	Par_InstitucionID 			INT(11), 			# ID de INSTITUCIONES.
	Par_FechaInicio				DATE, 				# Fecha de inicio
	Par_FechaFinal				DATE, 				# Fecha final
	Par_TipoReporte				TINYINT UNSIGNED,
    /* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),

	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(60),
	Aud_Sucursal				INT(11),

	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_Sentencia 	VARCHAR(8000);

-- Declaracion de constantes
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Entero_Cero		INT;
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE SalidaSI		CHAR(1);
DECLARE SalidaNO		CHAR(1);
DECLARE Con_Principal	INT;
DECLARE TipoDispSPEI	CHAR(1);
DECLARE TipoDispCHEQUE	CHAR(1);
DECLARE TipoDispORDEN 	CHAR(1);
DECLARE TipoDispEFECT	CHAR(1);
DECLARE NombDispSPEI	VARCHAR(20);
DECLARE NombDispCHEQUE	VARCHAR(20);
DECLARE NombDispORDEN 	VARCHAR(20);
DECLARE NombDispEFECT	VARCHAR(20);
DECLARE TipoMonto	 	CHAR(1);
DECLARE TipoPorcentaje	CHAR(1);
DECLARE DescripMonto 	VARCHAR(20);
DECLARE DescripPorcen	VARCHAR(20);

-- Asignacion  de constantes
SET	Cadena_Vacia	:= '';		-- CADENA VACIA
SET	Entero_Cero		:= 0;		-- ENTERO CERO
SET	Decimal_Cero	:= 0.0;		-- DECIMAL CERO
SET	SalidaSI		:= 'S';		-- SALIDA SI
SET	SalidaNO		:= 'N';		-- SALIDA NO
SET	Con_Principal	:= 1;		-- REPORTE PRINCIPAL NO 1
SET TipoDispSPEI	:= 'S';		-- Tipo de dispersion SPEI.
SET TipoDispCHEQUE	:= 'C';		-- Tipo de dispersion CHEQUE.
SET TipoDispORDEN 	:= 'O';		-- Tipo de dispersion ORDEN DE PAGO.
SET TipoDispEFECT	:= 'E';		-- Tipo de dispersion EFECTIVO.
SET NombDispSPEI	:= 'SPEI';	-- Nombre del tipo de dispersión SPEI.
SET NombDispCHEQUE	:= 'CHEQUE';-- Nombre del tipo de dispersión CHEQUE.
SET NombDispORDEN 	:= 'ORDEN DE PAGO';	-- Nombre del tipo de dispersión ORDEN DE PAGO.
SET NombDispEFECT	:= 'EFECTIVO';-- Nombre del tipo de dispersión EFECTIVO.
SET TipoMonto	 	:= 'M';		-- Tipo cargo por Monto.
SET TipoPorcentaje	:= 'P';		-- Tipo cargo por Porcentaje.
SET DescripMonto 	:= 'MONTO';	-- Descripción del Tipo cargo por Monto.
SET DescripPorcen	:= 'PORCENTAJE';-- Descripción del Tipo cargo por Porcentaje.

SET Aud_FechaActual := NOW();

IF(Par_TipoReporte = Con_Principal) THEN
	DROP TEMPORARY TABLE IF EXISTS  TMPCARGOSXDISPREP;
	CREATE TEMPORARY TABLE TMPCARGOSXDISPREP(
		InstitucionID		BIGINT(12),
		NombInstitucion		VARCHAR(150),
		FechaCargo			DATE,
		ClienteID			VARCHAR(300),
		CreditoID			BIGINT(12),
		CuentaAhoID			BIGINT(12),
		MontoCargo			DECIMAL(16,2),
		TipoDispersion		VARCHAR(20),
		TipoCargo			VARCHAR(20),
		Nivel 				VARCHAR(30)
	);

	SET Var_Sentencia := CONCAT('INSERT INTO TMPCARGOSXDISPREP (InstitucionID, NombInstitucion, FechaCargo, ClienteID, CreditoID, CuentaAhoID, MontoCargo, TipoDispersion, TipoCargo, Nivel) ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'SELECT MAX(Car.InstitucionID) AS InstitucionID, CONCAT(MAX(Car.InstitucionID),\' - \',MAX(Car.NombInstitucion)) AS NombInstitucion,	MAX(Car.FechaCargo) AS FechaCargo, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'CONCAT(MAX(Cli.ClienteID),\' - \',MAX(Cli.NombreCompleto)) AS ClienteID, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'Car.CreditoID, MAX(Car.CuentaAhoID) AS CuentaAhoID,	MAX(Car.MontoCargo) AS MontoCargo, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'CASE MAX(Car.TipoDispersion) ',
													'WHEN \'',TipoDispSPEI,'\' THEN \'',NombDispSPEI,'\' ',
													'WHEN \'',TipoDispCHEQUE,'\' THEN \'',NombDispCHEQUE,'\' ',
													'WHEN \'',TipoDispORDEN,'\' THEN \'',NombDispORDEN,'\' ',
													'WHEN \'',TipoDispEFECT,'\' THEN \'',NombDispEFECT,'\' ',
													'ELSE \'',Cadena_Vacia,'\' ',
												'END AS TipoDispersion,  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'CASE MAX(Car.TipoCargo) ',
													'WHEN \'',TipoMonto,'\' THEN \'',DescripMonto,'\' ',
													'WHEN \'',TipoPorcentaje,'\' THEN \'',DescripPorcen,'\' ',
													'ELSE \'',Cadena_Vacia,'\' ',
												'END AS TipoCargo,  ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'IFNULL(MAX(N.Descripcion), \'TODAS\') AS Nivel ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'FROM CARGOXDISPOSCRED Car INNER JOIN CLIENTES Cli ON Car.ClienteID = Cli.ClienteID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'LEFT OUTER JOIN NIVELCREDITO N ON Car.Nivel = N.NivelID ');
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'WHERE Car.FechaCargo BETWEEN \'',Par_FechaInicio,'\' AND \'',Par_FechaFinal,'\' ');

	IF(IFNULL(Par_InstitucionID, Entero_Cero) != Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND Car.InstitucionID = ',Par_InstitucionID,' ');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, 'GROUP BY Car.CreditoID ');
	-- Si existe dos veces el mismo crédito, significa que fue cancelado.
	SET Var_Sentencia := CONCAT(Var_Sentencia, 'HAVING COUNT(Car.CreditoID) < 2; ');
	SET @Sentencia := (Var_Sentencia);

	PREPARE REPORTEDISPOSICIONES FROM @Sentencia;
	EXECUTE REPORTEDISPOSICIONES;
	DEALLOCATE PREPARE REPORTEDISPOSICIONES;

	SELECT
		NombInstitucion,	FechaCargo,		ClienteID,		CreditoID,	CuentaAhoID,
		MontoCargo,		TipoDispersion,		TipoCargo,		Nivel,		InstitucionID
		FROM TMPCARGOSXDISPREP
		ORDER BY FechaCargo, InstitucionID;

	DROP TEMPORARY TABLE IF EXISTS  TMPCARGOSXDISPREP;
END IF;

END TerminaStore$$