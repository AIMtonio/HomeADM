-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ANALITICOAHORROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ANALITICOAHORROREP`;DELIMITER $$

CREATE PROCEDURE `ANALITICOAHORROREP`(

    Par_ClienteID        INT(11),
    Par_CuentaAho        BIGINT(12),
  	Par_Sucursal		 INT(11),
	Par_Moneda			 INT(11),
	Par_TipoCuenta		 INT(11),
	Par_PromotorActual   INT(11),
	Par_Genero  		 CHAR(1),
	Par_Estado 			 INT(11),
	Par_Municipio   	 INT(11),


    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT

	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Sentencia 		VARCHAR(4000);
DECLARE Var_ClienteInst		INT(11);


-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT(11);
DECLARE FechaSist			DATE;
DECLARE Sald_Bloqueda		CHAR(1);
DECLARE Sald_Inactiva		CHAR(1);
DECLARE Sald_Registrada		CHAR(1);
DECLARE Var_PerFisica 		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia	       	:= '';
SET Fecha_Vacia		       	:= '1900-01-01';
SET Entero_Cero		       	:= 0;
SET Sald_Bloqueda		    := 'B';                 -- Saldo bloqueado
SET Sald_Inactiva		    := 'I';                 -- Saldo Inactiva
SET Sald_Registrada		 	:= 'R';                 -- Saldo Registrado
SET Var_PerFisica       	:='F';


	SELECT ClienteInstitucion INTO Var_ClienteInst
	FROM PARAMETROSSIS;

    SET Var_Sentencia := ' SELECT  Cue.CuentaAhoID, MAX(Cue.Etiqueta) AS Etiqueta, MAX(Suc.NombreSucurs) AS NombreSucurs, Tic.TipoCuentaID ,MAX(Tic.Descripcion) AS TipoCuenta,MAX(Cli.NombreCompleto) AS NombreCompleto, MAX(Cli.RFCOficial) AS RFCOficial, SUM(Cue.SaldoIniMes) AS Saldo_IniMes, SUM(Cue.CargosMes) AS CargosMes, SUM(Cue.AbonosMes) AS AbonosMes,';
    SET Var_Sentencia := CONCAT(Var_Sentencia,' Cue.SaldoIniMes+Cue.AbonosMes-Cue.CargosMes AS SaldoAlDia,SUM(Cue.SaldoDispon) AS Disponible, SUM(Cue.SaldoBloq) AS SaldoBloq, ');
    SET Var_Sentencia := CONCAT(Var_Sentencia,'	CASE MAX(Cue.Estatus) WHEN  "B" THEN "Bloqueada" WHEN "A" THEN "Activa"' );
    SET Var_Sentencia := CONCAT(Var_Sentencia,' WHEN  "I" THEN "Inactiva" WHEN "C" THEN "Cancelada"');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' WHEN  "R" THEN "Registrada" END AS Estatus,  TIME(NOW()) AS Hora, CURRENT_DATE() AS Fecha');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' FROM  CUENTASAHO AS Cue INNER JOIN TIPOSCUENTAS AS Tic ON Cue.TipoCuentaID = Tic.TipoCuentaID ' );
    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES  AS Cli ON Cue.ClienteID = Cli.ClienteID  INNER JOIN SUCURSALES  AS Suc ON Cue.SucursalID=Suc.SucursalID');
    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN MONEDAS AS Mon ON Cue.MonedaID = Mon.MonedaID INNER JOIN PROMOTORES AS prom  ON prom.PromotorID=Cli.PromotorActual ');
	SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE Cli.ClienteID <> "',Var_ClienteInst,'"');

    SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
    IF(Par_ClienteID != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cli.ClienteID =', CONVERT(Par_ClienteID,CHAR));
    END IF;
    SET Par_TipoCuenta	 := IFNULL(Par_TipoCuenta	 ,Entero_Cero);
    IF(Par_TipoCuenta	!=  Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND Tic.TipoCuentaID=',CONVERT(Par_TipoCuenta,CHAR));
    END IF;

    SET Par_CuentaAho := IFNULL(Par_CuentaAho ,Entero_Cero);
    IF(Par_CuentaAho != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cue.CuentaAhoID =',CONVERT( Par_CuentaAho,CHAR));
    END IF;

    SET Par_Sucursal := IFNULL(Par_Sucursal, Entero_Cero);

IF(Par_Sucursal != Entero_Cero)THEN
    SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cue.SucursalID =',CONVERT(Par_Sucursal,CHAR));
    SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cue.SucursalID = Suc.SucursalID');
       ELSE
   SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cue.SucursalID = Suc.SucursalID');
    END IF;

    SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
    IF(Par_Moneda!=0)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cue.MonedaID=',CONVERT(Par_Moneda,CHAR));
    END IF;

    SET Par_PromotorActual := IFNULL(Par_PromotorActual, Entero_Cero);
        IF(Par_PromotorActual != Entero_Cero)THEN
    SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cli.PromotorActual =',CONVERT(Par_PromotorActual ,CHAR));
    SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cli.PromotorActual = prom.PromotorID');
        ELSE
    SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cli.PromotorActual = prom.PromotorID');
    END IF;




    SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);

    IF(Par_Genero!=Cadena_Vacia)THEN
        SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');

    END IF;



    SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
        IF(Par_Estado!=0)THEN
    SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE  Dir.Oficial="S" AND Cli.ClienteID=Dir.ClienteID LIMIT 1)=',CONVERT(Par_Estado,CHAR));
    END IF;
    SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
    IF(Par_Municipio!=0)THEN
    SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE  Dir.Oficial="S" AND Cli.ClienteID=Dir.ClienteID LIMIT 1)=',CONVERT(Par_Municipio,CHAR));
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia,'   GROUP BY Cue.CuentaAhoID, Tic.TipoCuentaID, Suc.SucursalID');


	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ORDER BY Suc.SucursalID, Tic.TipoCuentaID');

SET @Sentencia	= (Var_Sentencia);

PREPARE ANAHORROREP FROM @Sentencia;
EXECUTE ANAHORROREP;
DEALLOCATE PREPARE ANAHORROREP;

END TerminaStore$$