-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOSREFEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOSREFEREP`;
DELIMITER $$


CREATE PROCEDURE `DEPOSITOSREFEREP`(
	Par_FechaInicio 	DATE,
	Par_FechaFin		DATE,
	Par_Institucion		INT(11),
	Par_CuentaAhoID		BIGINT(12),
 	Par_ClienteID		INT(11),

	Par_SucursalID 		INT(11),
	Par_Estado			INT(11),
    /* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN
-- DECLARACION DE VARIABLES --
DECLARE Var_Sentencia 	TEXT(80000);
DECLARE Var_Estado		VARCHAR(2);
-- DECLARACION DE CONSTANTES --
DECLARE Entero_Cero		INT(11);
DECLARE Cadena_Vacia 	CHAR(1);
DECLARE Pago_Credito	INT(11);
DECLARE Dep_Cuenta		INT(11);
DECLARE Dep_Cliente		INT(11);
DECLARE Est_Aplicado	CHAR(1);
DECLARE Est_NoIdenti	VARCHAR(2);
DECLARE Est_Cancelado	CHAR(1);
DECLARE Aplicado		VARCHAR(8);
DECLARE NoIdentificcado	VARCHAR(17);
DECLARE Decimal_Cero	DECIMAL(16,2);
DECLARE Entero_Uno		INT(11);
DECLARE Entero_Dos		INT(11);
-- ASIGNACION DE CONSTANTES --
SET Entero_Cero		:=0;
SET Cadena_Vacia 	:='';
SET Pago_Credito 	:=1;
SET Dep_Cuenta		:=2;
SET Dep_Cliente		:=3;
SET Est_Aplicado	:='A';
SET Est_NoIdenti	:='NI';
SET Est_Cancelado	:='C';
SET Aplicado		:='Aplicado';
SET NoIdentificcado :='No Identificado';
SET Decimal_Cero	:= 0.0;
SET Entero_Uno		:=1;
SET Entero_Dos		:=2;


IF(Par_Estado = Entero_Uno)THEN
SET Var_Estado := 'A';
END IF;
IF(Par_Estado = Entero_Dos)THEN
SET Var_Estado := 'NI';
END IF;

DELETE FROM  TMPDEPOSITOSREFERE;

DROP TABLE IF EXISTS TMPDEPOSITOREF;
CREATE TEMPORARY TABLE TMPDEPOSITOREF (
  FolioCargaID BIGINT(17) NOT NULL,
  CuentaAhoID VARCHAR(20) NOT NULL,
  NumeroMov BIGINT(20) DEFAULT NULL,
  InstitucionID INT(11) NOT NULL,
  FechaCarga DATE DEFAULT NULL,
  FechaAplica DATE DEFAULT NULL,
  NatMovimiento CHAR(1) DEFAULT NULL,
  MontoMov DECIMAL(12,2) DEFAULT NULL,
  TipoMov CHAR(4) DEFAULT NULL,
  DescripcionMov VARCHAR(150) DEFAULT NULL,
  ReferenciaMov VARCHAR(40) DEFAULT NULL,          -- CS JCENTENO tkt 13085
  DescripcionNoIden VARCHAR(150) DEFAULT NULL,
  ReferenciaNoIden VARCHAR(35) DEFAULT NULL,
  Estatus CHAR(2) DEFAULT NULL,
  MontoPendApli DECIMAL(12,2) DEFAULT NULL,
  TipoDeposito CHAR(1) DEFAULT NULL,
  TipoCanal INT(11) DEFAULT NULL,
  NumIdenArchivo VARCHAR(20),
  MonedaId INT(11) DEFAULT NULL,
  NumTransaccion BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (FolioCargaID,CuentaAhoID,InstitucionID));

INSERT INTO TMPDEPOSITOREF (FolioCargaID,	CuentaAhoID,		NumeroMov,			InstitucionID,	FechaCarga, 
							FechaAplica, 	NatMovimiento,		MontoMov,			TipoMov,		DescripcionMov,
							ReferenciaMov,	DescripcionNoIden,	ReferenciaNoIden,	Estatus,		MontoPendApli,
							TipoDeposito,	TipoCanal,			NumIdenArchivo,		MonedaId,		NumTransaccion)
SELECT FolioCargaID,	CuentaAhoID,		NumeroMov,			InstitucionID,	FechaCarga, 
		FechaAplica, 	NatMovimiento,		MontoMov,			TipoMov,		DescripcionMov,
		ReferenciaMov,	DescripcionNoIden,	ReferenciaNoIden,	Status,			MontoPendApli,
		TipoDeposito,	TipoCanal,			NumIdenArchivo,		MonedaId,		NumTransaccion
		FROM DEPOSITOREFERE WHERE TipoCanal = Pago_Credito
			 AND Status != Est_Cancelado AND FechaAplica BETWEEN Par_FechaInicio AND Par_FechaFin;

SET Var_Sentencia :=CONCAT(' INSERT INTO TMPDEPOSITOSREFERE (Cliente,NombreCompleto,Referencia,	TipoCarga, DescripcionMov,HoraEmision,	InstitucionID, Banco, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CuentaBancaria, Estado, FechaCarga,FechaAplica,Monto,MontoAplicado,TipoCanal,TipoMov, TipoDeposito) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT cr.ClienteID AS Cliente, cl.NombreCompleto, de.ReferenciaMov AS Referencia, CASE WHEN IFNULL(da.NumTransaccion,0)=0 THEN "MANUAL" ELSE "AUTOMATICO" END ,de.DescripcionMov, TIME(NOW()) AS HoraEmision, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' de.InstitucionID,ba.NombreCorto AS Banco,de.CuentaAhoID AS CuentaBancaria, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE de.Estatus WHEN "',Est_Aplicado,'" THEN "',Aplicado,'" WHEN "',Est_NoIdenti,'" THEN "',NoIdentificcado,'" END AS Estado, de.FechaCarga, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' de.FechaAplica,de.MontoMov AS Monto, CASE de.Estatus WHEN "',Est_Aplicado,'" THEN de.MontoMov WHEN "',Est_NoIdenti,'" THEN ',Decimal_Cero,' END AS MontoAplicado, de.TipoCanal, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE de.TipoCanal WHEN "',Pago_Credito,'" THEN "Pago Credito" END AS TipoMov, de.TipoDeposito ');
SET Var_sentencia :=CONCAT(Var_sentencia,' FROM TMPDEPOSITOREF de ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN CREDITOS cr ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ON IF(IFNULL(de.ReferenciaMov,0)="",0,de.ReferenciaMov) = cr.CreditoID');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN INSTITUCIONES ba ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ON ba.InstitucionID = de.InstitucionID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN CLIENTES cl ON cr.ClienteID = cl.ClienteID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN DEPREFAUTOMATICO da ON de.NumTransaccion = da.NumTransaccion');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHERE de.TipoCanal = ',Pago_Credito,''); -- Pago Credito
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.Estatus != "',Est_Cancelado,'" ');

IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND cr.ClienteID = ',Par_ClienteID);
END IF;
IF(IFNULL(Par_Institucion, Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.InstitucionID = ',Par_Institucion);
END IF;
IF(IFNULL(Par_CuentaAhoID,Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.CuentaAhoID = ',Par_CuentaAhoID);
END IF;
IF(IFNULL(Par_SucursalID,Entero_Cero) !=Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.Sucursal = ',Par_SucursalID);
END IF;
IF(IFNULL(Par_Estado,Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.Estatus = "',Var_Estado,'" ');
END IF;
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.FechaAplica BETWEEN ? AND ? ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ORDER BY de.FechaAplica) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT cu.ClienteID AS Cliente, cl.NombreCompleto,de.ReferenciaMov AS Referencia, CASE WHEN IFNULL(da.NumTransaccion,0)=0 THEN "MANUAL" ELSE "AUTOMATICO" END ,de.DescripcionMov, TIME(NOW()) AS HoraEmision, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' de.InstitucionID,ba.NombreCorto AS Banco,de.CuentaAhoID AS CuentaBancaria, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE de.Status WHEN "',Est_Aplicado,'" THEN "',Aplicado,'" WHEN "',Est_NoIdenti,'" THEN "',NoIdentificcado,'" END AS Estado, de.FechaCarga, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' de.FechaAplica,de.MontoMov AS Monto, CASE de.Status WHEN "',Est_Aplicado,'" THEN de.MontoMov WHEN "',Est_NoIdenti,'" THEN ',Decimal_Cero,' END AS MontoAplicado, de.TipoCanal, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE de.TipoCanal WHEN ',Dep_Cuenta,' THEN "Dep a Cuenta" END AS TipoMov, de.TipoDeposito ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' FROM DEPOSITOREFERE de ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN CUENTASAHO cu ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ON cu.CuentaAhoID = de.ReferenciaMov ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN INSTITUCIONES ba ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ON ba.InstitucionID = de.InstitucionID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN CLIENTES cl ON cu.ClienteID = cl.ClienteID');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN DEPREFAUTOMATICO da ON de.NumTransaccion = da.NumTransaccion');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHERE de.TipoCanal = ',Dep_Cuenta,' '); -- Dep Cuenta
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.Status != "',Est_Cancelado,'"');

IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND cu.ClienteID = ',Par_ClienteID);
END IF;
IF(IFNULL(Par_Institucion, Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.InstitucionID = ',Par_Institucion);
END IF;
IF(IFNULL(Par_CuentaAhoID,Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.CuentaAhoID = ',Par_CuentaAhoID);
END IF;
IF(IFNULL(Par_SucursalID,Entero_Cero) !=Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.Sucursal = ',Par_SucursalID);
END IF;
IF(IFNULL(Par_Estado,Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.Status = "',Var_Estado,'" ');
END IF;
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.FechaAplica BETWEEN ? AND ? ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ORDER BY de.FechaAplica) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT cl.ClienteID AS Cliente, cl.NombreCompleto,de.ReferenciaMov AS Referencia, CASE WHEN IFNULL(da.NumTransaccion,0)=0 THEN "MANUAL" ELSE "AUTOMATICO" END ,de.DescripcionMov, TIME(NOW()) AS HoraEmision, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' de.InstitucionID,ba.NombreCorto AS Banco,de.CuentaAhoID AS CuentaBancaria, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE de.Status WHEN "',Est_Aplicado,'" THEN "',Aplicado,'" WHEN "',Est_NoIdenti,'" THEN "',NoIdentificcado,'" END AS Estado, de.FechaCarga, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' de.FechaAplica,de.MontoMov AS Monto, CASE de.Status WHEN "',Est_Aplicado,'" THEN de.MontoMov WHEN "',Est_NoIdenti,'" THEN ',Decimal_Cero,' END AS MontoAplicado, de.TipoCanal, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE de.TipoCanal WHEN ',Dep_Cliente,' THEN "Dep. Pago Cliente" END AS TipoMov, de.TipoDeposito ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' FROM DEPOSITOREFERE de ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN CLIENTES cl ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ON cl.ClienteID = de.ReferenciaMov ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN INSTITUCIONES ba ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ON ba.InstitucionID = de.InstitucionID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN DEPREFAUTOMATICO da ON de.NumTransaccion = da.NumTransaccion');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHERE de.TipoCanal = ',Dep_Cliente,' '); -- Cliente );
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.Status != "',Est_Cancelado,'"');

IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND cl.ClienteID = ',Par_ClienteID);
END IF;
IF(IFNULL(Par_Institucion, Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.InstitucionID = ',Par_Institucion);
END IF;
IF(IFNULL(Par_CuentaAhoID,Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.CuentaAhoID = ',Par_CuentaAhoID);
END IF;
IF(IFNULL(Par_SucursalID,Entero_Cero) !=Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.Sucursal = ',Par_SucursalID);
END IF;
IF(IFNULL(Par_Estado,Entero_Cero) != Entero_Cero)THEN
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.Status = "',Var_Estado,'" ');
END IF;
SET Var_Sentencia :=CONCAT(Var_Sentencia,' AND de.FechaAplica BETWEEN ? AND ? ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ORDER BY de.FechaAplica) ');


SET @Sentencia 		:=(Var_Sentencia);
SET @FechaInicio 	:=Par_FechaInicio;
SET @FechaFin		:=Par_FechaFin;

PREPARE DEPOSITOSREFEREP FROM @Sentencia;
EXECUTE DEPOSITOSREFEREP USING @FechaInicio, @FechaFin,@FechaInicio, @FechaFin,@FechaInicio, @FechaFin;
 SELECT * FROM TMPDEPOSITOSREFERE
 ORDER BY FechaAplica;
DEALLOCATE PREPARE DEPOSITOSREFEREP;


END TerminaStore$$
