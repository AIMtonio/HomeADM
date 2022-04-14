-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROIDEMENSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROIDEMENSREP`;DELIMITER $$

CREATE PROCEDURE `COBROIDEMENSREP`(
    Par_FechaPeriodo    DATE,
    Par_ClienteID       INT(11),
    Par_SucursalOrigen  INT(11),    -- Sucursal que tiene el cliente

	Par_EmpresaID				INT,
	Aud_Usuario					INT,
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT,
	Aud_NumTransaccion			BIGINT

		)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Sentencia 		VARCHAR(4000);


-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE FechaSist			DATE;
DECLARE Est_Vigente		CHAR(1);
DECLARE Est_Cobrado		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia	:= '';
SET Fecha_Vacia		:= '1900-01-01';
SET Entero_Cero		:= 0;
SET Est_Vigente		:= 'V';                 -- Estatus del Seguro: Vigente
SET Est_Cobrado		:= 'C';                 -- Estatus del Seguro: Cobrado


SET Var_Sentencia :=	'select	Cli.ClienteID as ClienteID,				Cli.CURP as CURP, ';
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		Cli.RFCOficial as RFC, ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		CASE   WHEN Cli.TipoPersona != "M" THEN CONCAT(IFNULL(Cli.PrimerNombre,"")," ", IFNULL(Cli.SegundoNombre,"")," ",IFNULL(Cli.TercerNombre,"")) ELSE Cli.NombreCompleto END as PrimerNombre,');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		Cli.ApellidoPaterno as ApellidoPaterno,	Cli.ApellidoMaterno as ApellidoMaterno, ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		LAST_DAY (CIDE.FechaCorte) as FIN, 	(CIDE.Cantidad+(select MontoExcIDE from PARAMETROSSIS)) as Cantidad , ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		CIDE.Cantidad as CantidadExcento , ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		DC.DireccionCompleta as DirCompleta, DC.CP as CP,  ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		(CASE EsMenorEdad WHEN "S" then "1" when "N" THEN "0" else "" end )as EsMenorEdad,  ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		Cli.SucursalOrigen as SucursalOrigen, 	Cli.Telefono as Telefono,	 ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		Cli.TelefonoCelular as TelCelular, 		Cli.Correo as Correo, ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'		CA.CuentaAhoID as CuentaAhoID  ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'	from COBROIDEMENS as CIDE  ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'	inner join CLIENTES			as Cli	on CIDE.ClienteID=Cli.ClienteID ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'	inner join CUENTASAHO		as CA	on Cli.ClienteID=CA.ClienteID ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'	left outer join DIRECCLIENTE		as DC	on Cli.ClienteID=DC.ClienteID and Oficial = "S" ');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'	where month(CIDE.FechaCorte)= ',MONTH(Par_FechaPeriodo));
SET Var_Sentencia :=  CONCAT(Var_Sentencia,'	and year(CIDE.FechaCorte) =', YEAR(Par_FechaPeriodo));


SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
IF(Par_ClienteID != Entero_Cero)THEN
    SET Var_Sentencia := CONCAT(Var_sentencia,' and Cli.ClienteID =', CONVERT(Par_ClienteID,CHAR));
END IF;

SET Par_SucursalOrigen := IFNULL(Par_SucursalOrigen, Entero_Cero);
IF(Par_SucursalOrigen != Entero_Cero)THEN
    SET Var_Sentencia = CONCAT(Var_sentencia,' and Cli.SucursalOrigen =',CONVERT(Par_SucursalOrigen,CHAR));
END IF;

SET Var_Sentencia := CONCAT(Var_Sentencia,' GROUP BY ClienteID');
SET @Sentencia	= (Var_Sentencia);

PREPARE CTESEGUROREP FROM @Sentencia;
EXECUTE CTESEGUROREP;
DEALLOCATE PREPARE CTESEGUROREP;

END TerminaStore$$