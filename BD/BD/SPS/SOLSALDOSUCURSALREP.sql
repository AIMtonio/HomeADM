-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLSALDOSUCURSALREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLSALDOSUCURSALREP`;DELIMITER $$

CREATE PROCEDURE `SOLSALDOSUCURSALREP`(
	-- SP QUE SE USARA PARA EL REPORTE DE SOLICITUD DE SALDOS POR SUCURSAL EN EL MODULO DE VENTANILLA
	Par_FechaIni				DATE,
    Par_FechaFin				DATE,
    Par_SucursalID				INT(11),

	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

	DECLARE Var_Sentencia 		VARCHAR(9000);

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero 		INT(11);

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero 			:= 0;


	SET Var_Sentencia := '	SELECT	SOL.SolSaldoSucursalID, 	U.Clave AS UsuarioID, 	GROUP_CONCAT(DISTINCT CTAS.NumCtaInstit SEPARATOR ", ") AS Cuentas,
									SOL.SucursalID, 			SUC.NombreSucurs,		SOL.FechaSolicitud,
									SOL.HoraSolicitud,			SOL.CanCreDesem,		IFNULL(SOL.MonCreDesem,0)AS MonCreDesem,
									SOL.CanInverVenci,			IFNULL(SOL.MonInverVenci,0) AS MonInverVenci, 		SOL.CanChequeEmi,
									IFNULL(SOL.MonChequeEmi,0)AS MonChequeEmi, 	SOL.CanChequeIntReA, 	IFNULL(SOL.MonChequeIntReA,0) AS MonChequeIntReA,
									SOL.CanChequeIntRe,			IFNULL(SOL.MonChequeIntRe,0) AS MonChequeIntRe,
									IFNULL(SOL.SaldosCP,0)AS SaldosCP, 	IFNULL(SOL.SaldosCA,0)AS SaldosCA, 		IFNULL(SOL.MontoSolicitado,0) AS MontoSolicitado,
									SOL.Comentarios
							FROM 	SOLSALDOSUCURSAL SOL LEFT JOIN SUCURSALES SUC ON SOL.SucursalID=SUC.SucursalID
									LEFT JOIN USUARIOS U ON SOL.UsuarioID=U.UsuarioID
									LEFT JOIN CUENTASAHOTESO CTAS ON SOL.SucursalID=CTAS.Sucursal
									AND CTAS.Estatus = "A"
							WHERE 	FechaSolicitud BETWEEN "';
	SET Var_Sentencia :=	CONCAT(Var_Sentencia,Par_FechaIni, '" AND "', Par_FechaFin,'" ');


	IF(Par_SucursalID != Entero_Cero) THEN
		SET Var_Sentencia	:= 	CONCAT(Var_Sentencia, " AND SOL.SucursalID=",Par_SucursalID);
	END IF;

	SET Var_Sentencia :=CONCAT(Var_Sentencia, ' GROUP BY SOL.SolSaldoSucursalID ORDER BY SOL.SucursalID, SOL.FechaSolicitud, SOL.HoraSolicitud ;');


	SET @Sentencia	= (Var_Sentencia);
	PREPARE STSOLSALDREP FROM @Sentencia;
	EXECUTE STSOLSALDREP;
	DEALLOCATE PREPARE STSOLSALDREP;


END TerminaStore$$