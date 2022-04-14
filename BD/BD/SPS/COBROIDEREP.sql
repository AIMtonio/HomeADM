-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROIDEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROIDEREP`;DELIMITER $$

CREATE PROCEDURE `COBROIDEREP`(
    Par_TipoReporte    	CHAR(1),   		-- Tipo de reporte M-mensual, A- anual
    Par_ClienteID       INT(11), 		-- Id del cliente
	Par_Periodo			INT(11),		-- Mes a reportar
    Par_Ejercicio		INT(11),		-- Ejercicio a reportar(anio fiscal)
    Par_SucursalOrigen  INT(11),    	-- Sucursal que tiene el cliente

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Sentencia 		VARCHAR(6000);
	DECLARE Var_MontoExede		DECIMAL(14,2);
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Entero_Cero		INT;
	DECLARE Entero_Uno		INT;
	DECLARE ConstanteSI		CHAR(1);
	DECLARE ConstanteNO		CHAR(1);
    DECLARE ReporteMensual	CHAR(1);
    DECLARE ReporteAnual	CHAR(1);
    DECLARE CaracterAmp		CHAR(1);
    DECLARE CorreoVacio		VARCHAR(20);
    DECLARE TelefonoVacio	VARCHAR(20);
    DECLARE EstatusActivo	CHAR(1);
	-- Asignacion de Constantes
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET Entero_Cero		:= 0;
	SET ConstanteSI		:= 'S';
	SET ConstanteNO		:= 'N';
    SET ReporteMensual	:= 'M';
    SET ReporteAnual	:= 'A';
	SET Entero_Uno		:= 1;
    SET CaracterAmp		:= '&';
	SET TelefonoVacio	:= '000000000000000';
    SET CorreoVacio		:= 'SIN CORREO';
	SET EstatusActivo :='A';
	SET Var_MontoExede	:=(SELECT MontoExcIDE FROM PARAMETROSSIS);
    SET Var_Sentencia := '';

	SET Var_Sentencia := CONCAT(Var_Sentencia,
		'SELECT  Cli.ClienteID,	Cli.CURP, 	Cli.RFCOficial AS RFC, CONCAT(IFNULL(Cli.PrimerNombre,"', Cadena_Vacia, '")," ",
			IFNULL(Cli.SegundoNombre,"', Cadena_Vacia, '")," ",IFNULL(Cli.TercerNombre,"', Cadena_Vacia, '")) AS PrimerNombre,
            Cli.ApellidoPaterno,	Cli.ApellidoMaterno, LAST_DAY(CIDE.FechaCorte) AS FechaCorte,
			ROUND((CIDE.Cantidad+"', Var_MontoExede, '"),2) AS Cantidad,
			ROUND(CIDE.Cantidad,2) AS CantidadExcento , IFNULL(DC.DireccionCompleta,"', Cadena_Vacia, '") AS DireccionCompleta, DC.CP,
			CASE Cli.EsMenorEdad WHEN "', ConstanteSI, '"  THEN "', Entero_Uno, '"
							   WHEN "', ConstanteNO, '"  THEN "', Entero_Cero, '"
							   ELSE "', Cadena_Vacia, '" END AS EsMenorEdad,
			Cli.SucursalOrigen,
            CASE IFNULL(Cli.Telefono,"', Cadena_Vacia, '") WHEN "', Cadena_Vacia, '" THEN "', TelefonoVacio, '"
                    ELSE Cli.Telefono END AS Telefono,
			CASE IFNULL(Cli.TelefonoCelular,"', Cadena_Vacia, '") WHEN "', Cadena_Vacia, '" THEN "', TelefonoVacio, '"
                    ELSE Cli.TelefonoCelular END AS TelefonoCelular,
            CASE IFNULL(Cli.Correo,"', Cadena_Vacia, '") WHEN "', Cadena_Vacia, '" THEN "', CorreoVacio, '"
				ELSE Cli.Correo END AS Correo,
            CA.CuentaAhoID,	Cli.TipoPersona,	REPLACE(Cli.NombreCompleto,"', CaracterAmp, '","', Cadena_Vacia, '") AS NombreCompleto,
            MONTH(CIDE.FechaCorte) AS Consecutivo
		FROM COBROIDEMENS CIDE
			INNER JOIN CLIENTES Cli	ON CIDE.ClienteID=Cli.ClienteID
			INNER JOIN CUENTASAHO CA ON Cli.ClienteID=CA.ClienteID
			LEFT OUTER JOIN DIRECCLIENTE DC	ON Cli.ClienteID=DC.ClienteID AND Oficial = "', ConstanteSI, '"
            WHERE YEAR(CIDE.FechaCorte)="', Par_Ejercicio, '"');

    IF(Par_TipoReporte=ReporteMensual)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,' AND MONTH(CIDE.FechaCorte)=', Par_Periodo);
    END IF;

	IF(IFNULL(Par_ClienteID, Entero_Cero) != Entero_Cero)THEN
	    SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.ClienteID =', Par_ClienteID);
	END IF;

	IF(IFNULL(Par_SucursalOrigen,Entero_Cero)!= Entero_Cero)THEN
	    SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.SucursalOrigen =',Par_SucursalOrigen);
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,' GROUP BY ClienteID,Consecutivo');

    IF(Par_TipoReporte= ReporteAnual)THEN
	    SET Var_Sentencia := CONCAT(Var_sentencia,' ORDER BY Consecutivo,ClienteID');
	END IF;


	SET @Sentencia	= (Var_Sentencia);

	PREPARE CTESEGUROREP FROM @Sentencia;
	EXECUTE CTESEGUROREP;
	DEALLOCATE PREPARE CTESEGUROREP;

END TerminaStore$$