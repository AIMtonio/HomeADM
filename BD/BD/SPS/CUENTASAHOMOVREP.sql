-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOMOVREP`;
DELIMITER $$

CREATE PROCEDURE `CUENTASAHOMOVREP`(
	Par_FechaInicial 	DATE,
	Par_FechaFinal 		DATE,
	Par_Mostrar 		CHAR(1),
	Par_TipoCuenta 		INT(11),
	Par_Sucursal 		INT(12),
	Par_Moneda 			INT(12),
	Par_Promotor 		INT(12),
	Par_Genero 			CHAR(1),
	Par_Estado 			INT(12),
	Par_Municipio 		INT(12),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN
DECLARE NatMov_Cargo 	CHAR(1);
DECLARE NatMov_Abono 	CHAR(1);
DECLARE Fecha_Vacia 	DATE;
DECLARE Entero_Cero 	INT;
DECLARE Var_Sentencia 	VARCHAR(6000);
DECLARE Var_ClienteInst	INT(11);

DECLARE Muestra_Todo	CHAR(1);
DECLARE Muestra_SoloMov CHAR(1);
DECLARE NumTransaccion  BIGINT(20);

SET NatMov_Cargo 	:='C';
SET NatMov_Abono 	:='A';
SET Fecha_Vacia 	:='1900-01-01';
SET Entero_Cero 	:=0;
SET Muestra_Todo	:= 'T';
SET Muestra_SoloMov	:= 'M';



SELECT ClienteInstitucion INTO Var_ClienteInst
FROM PARAMETROSSIS;
--  Todos los datos sin filtros
CALL TRANSACCIONESPRO(NumTransaccion);
INSERT INTO TMPCALCULOCA(CuentaAhoID,NombreCliente,Etiqueta,Cargos,Abonos,FechaUltReti,FechaUltDepo,Saldo,NumTrans)
(select
CM.CuentaAhoID,CLI.NombreCompleto AS NombreCliente, CTA.Etiqueta,
SUM(if(CM.NatMovimiento='C',CM.CantidadMov,Entero_Cero)) AS Cargos,
SUM(if(CM.NatMovimiento='A',CM.CantidadMov,Entero_Cero)) AS Abonos,
CONVERT(IFNULL(MAX(CASE WHEN CM.NatMovimiento = "C" THEN CM.Fecha END),Fecha_Vacia),CHAR) AS FechaUltReti,
CONVERT(IFNULL(MAX(CASE WHEN CM.NatMovimiento = "A" THEN CM.Fecha END),Fecha_Vacia),CHAR) AS FechaUltDepo,
(IFNULL(CTA.Saldo,Entero_Cero))AS Saldo, NumTransaccion
from CUENTASAHOMOV CM
INNER JOIN CUENTASAHO AS CTA ON CTA.CuentaAhoID = CM.CuentaAhoID
INNER JOIN CLIENTES AS CLI ON CLI.ClienteID = CTA.ClienteID
where CM.CuentaAhoID in (select CuentaAhoID from CUENTASAHO where ClienteID <>Var_ClienteInst)
AND CM.Fecha >= Par_FechaInicial AND CM.Fecha <= Par_FechaFinal
group by CM.CuentaAhoID)
UNION ALL
(select
HCM.CuentaAhoID, CLI.NombreCompleto, CTA.Etiqueta,
SUM(if(HCM.NatMovimiento='C',HCM.CantidadMov,Entero_Cero)) AS Cargos,
SUM(if(HCM.NatMovimiento='A',HCM.CantidadMov,Entero_Cero)) AS Abonos,
CONVERT(IFNULL(MAX(CASE WHEN HCM.NatMovimiento = "C" THEN HCM.Fecha END),Fecha_Vacia),CHAR) AS FechaUltReti,
CONVERT(IFNULL(MAX(CASE WHEN HCM.NatMovimiento = "A" THEN HCM.Fecha END),Fecha_Vacia),CHAR) AS FechaUltDepo,
(IFNULL(CTA.Saldo,Entero_Cero))AS Saldo,NumTransaccion
from `HIS-CUENAHOMOV`HCM
INNER JOIN CUENTASAHO AS CTA ON CTA.CuentaAhoID = HCM.CuentaAhoID
INNER JOIN CLIENTES AS CLI ON CLI.ClienteID = CTA.ClienteID
where HCM.CuentaAhoID in (select CuentaAhoID from CUENTASAHO where ClienteID <>Var_ClienteInst)
AND HCM.Fecha >= Par_FechaInicial AND HCM.Fecha <= Par_FechaFinal
group by HCM.CuentaAhoID);

SET Var_Sentencia := CONCAT('
SELECT
		MAX(TCA.NombreCliente) as NombreCliente ,			TCA.CuentaAhoID as Cuenta, 				MAX(TCA.Etiqueta) as Etiqueta, 								sum(TCA.Cargos) as Cargos,
        sum(TCA.Abonos) as Abonos,	MAX(TCA.FechaUltReti) as FechaUltReti,	MAX(TCA.FechaUltDepo) as FechaUltDepo,		 MAX(TCA.Saldo) as Saldo

 FROM TMPCALCULOCA AS TCA
 INNER JOIN CUENTASAHO AS ca ON TCA.CuentaAhoID=ca.CuentaAhoID
 INNER JOIN CLIENTES AS cli ON ca.ClienteID=cli.ClienteID
 WHERE ca.ClienteID <>', Var_ClienteInst);

IF  (IFNULL(Par_TipoCuenta, 0) != 0 ) THEN
SET Var_Sentencia := CONCAT(Var_Sentencia,'
AND	ca.TipoCuentaID = ', Par_TipoCuenta );
END IF;


IF  (IFNULL(Par_Sucursal, 0) != 0 ) THEN
SET Var_Sentencia := CONCAT(Var_Sentencia,'
AND	ca.SucursalID = ', Par_Sucursal );
END IF;


IF  (IFNULL(Par_Moneda, 0) != 0 ) THEN
SET Var_Sentencia := CONCAT(Var_Sentencia,'
AND	ca.MonedaID = ', Par_Moneda );
END IF;


IF  (IFNULL(Par_Promotor, 0) != 0 ) THEN
SET Var_Sentencia := CONCAT(Var_Sentencia,'
AND	cli.PromotorActual = ', Par_Promotor );
END IF;


IF  (IFNULL(Par_Genero,'') !='' ) THEN
SET Var_Sentencia := CONCAT(Var_Sentencia,'
AND	cli.Sexo = "', Par_Genero , '" AND (cli.TipoPersona = "F" OR cli.TipoPersona = "A")');
END IF;

IF  (IFNULL(Par_Estado, 0) != 0 ) THEN
SET Var_Sentencia := CONCAT(Var_sentencia,'
AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial= "S" AND cli.ClienteID=Dir.ClienteID LIMIT 1)=',CONVERT(Par_Estado,CHAR) );
END IF;


IF  (IFNULL(Par_Municipio, 0) != 0 ) THEN
SET Var_Sentencia := CONCAT(Var_sentencia,'
AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial= "S" AND cli.ClienteID=Dir.ClienteID LIMIT 1)=',CONVERT(Par_Municipio,CHAR));
END IF;


SET Var_Sentencia := CONCAT(Var_Sentencia,'
GROUP BY ca.CuentaAhoID
');


IF  (IFNULL(Par_Mostrar, "T") = "M" ) THEN
SET Var_Sentencia := CONCAT(Var_Sentencia,'having Cargos > 0 or Abonos > 0 ');
END IF;

SET Var_Sentencia := CONCAT(Var_Sentencia,';');


	SET @Sentencia	= (Var_Sentencia);
	SET @Fecha	= Par_FechaInicial;
	SET @Fecha1	= Par_FechaFinal;

	PREPARE STCUENTASAHOMOVREP FROM @Sentencia;
	EXECUTE STCUENTASAHOMOVREP;
    DELETE FROM TMPCALCULOCA WHERE NumTrans=NumTransaccion;
DEALLOCATE PREPARE STCUENTASAHOMOVREP;
END TerminaStore$$