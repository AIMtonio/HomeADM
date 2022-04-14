-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJAPRINCIPALREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJAPRINCIPALREP`;DELIMITER $$

CREATE PROCEDURE `CAJAPRINCIPALREP`(
	Par_FechaInicio			DATE,
	Par_FechaFin 			DATE,
	Par_CajaID				INT(11),
	Par_MonedaID			INT(11),
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT,
	Aud_FechaActual			DATE,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,

	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE	Var_Sentencia		VARCHAR(65535);#VARCHAR(80000);
DECLARE	Var_SentenciaHis	VARCHAR(65535);#VARCHAR(80000);
DECLARE Var_SentenciaTabla	VARCHAR(10000);

-- Declaracion de Constantes
DECLARE ConstanteCP			VARCHAR(10);
DECLARE DesSalida			VARCHAR(500);
DECLARE DesEntrada			VARCHAR(500);
DECLARE ConstanteSI			CHAR(1);
DECLARE Cadena_Vacia		CHAR;

DECLARE CajaPricipal		CHAR(2);

-- Asignacion de Constantes
SET ConstanteCP		='CP-';
SET DesSalida		='SALIDA';
SET DesEntrada		='ENTRADA';
SET ConstanteSI		='S';
SET Cadena_Vacia	='';
SET CajaPricipal	='CP';


DROP TABLE IF EXISTS TMPCAJAPRINCIPAL;
CREATE TEMPORARY TABLE TMPCAJAPRINCIPAL(
	CajaID		INT(11),		NombreCaja VARCHAR(500),	Fecha			DATE ,			Transaccion BIGINT(20),		Tipo VARCHAR(100),
	Descripcion	VARCHAR(500),	Referencia VARCHAR(500),	Referencia2		VARCHAR(500), 	Entrada		DECIMAL(16,2),	Salida DECIMAL(16,2),
    Naturaleza	INT(11),		HoraEmision	VARCHAR(20),	TipoOperacion	INT(11)
);

SET Var_SentenciaTabla := '
	INSERT INTO TMPCAJAPRINCIPAL(
		CajaID,			NombreCaja,		Fecha,			Transaccion, 	Tipo,
		Descripcion,	Referencia, 	Referencia2, 	Entrada, 		Salida,
		Naturaleza,		HoraEmision,	TipoOperacion
	)';

SET Var_Sentencia := CONCAT(Var_SentenciaTabla,' SELECT Mov.CajaID,convert(concat( "',ConstanteCP ,'",Suc.NombreSucurs),char) as NombreCaja,Mov.Fecha,Mov.Transaccion,');
SET Var_Sentencia := CONCAT(Var_Sentencia,' case when Tip.Naturaleza =1 then "', DesSalida,'" else "',DesEntrada,'"  end as Tipo,');
SET Var_Sentencia := CONCAT(Var_Sentencia,' Tip.Descripcion, Mov.Referencia,');

SET Var_Sentencia := CONCAT(Var_Sentencia,' case when Mov.TipoOperacion in (85,86,20,40,19,39) then Mov.Referencia ');
SET Var_Sentencia := CONCAT(Var_Sentencia,' when Mov.TipoOperacion in (16,36,42,41) then Tran.Referencia else "',Cadena_Vacia,'" end as Referencia2,');

SET Var_Sentencia := CONCAT(Var_Sentencia,' case when Tip.Naturaleza =2 then Mov.MontoEnFirme else 0 end as Entrada, ');
SET Var_Sentencia := CONCAT(Var_Sentencia,' case when Tip.Naturaleza =1 then Mov.MontoEnFirme else 0 end as Salida, Tip.Naturaleza ,  convert(time(now()),char) as HoraEmision,');
SET Var_Sentencia := CONCAT(Var_Sentencia,' Tip.Numero');
SET Var_Sentencia := CONCAT(Var_Sentencia,' FROM CAJASMOVS  Mov INNER JOIN CAJATIPOSOPERA Tip on Tip.Numero = Mov.TipoOperacion');
SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc on Suc.SucursalID = Mov.SucursalID');
SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CAJASVENTANILLA  Caj on Caj.CajaID =Mov.CajaID and Caj.SucursalID = Mov.Sucursal');
SET Var_Sentencia := CONCAT(Var_Sentencia,' left join TRANSFERBANCO Tran on Tran.NumTransaccion= Mov.Transaccion');

SET Var_Sentencia := CONCAT(Var_Sentencia,' where  Tip.Origen =  "',ConstanteSI,'" and Mov.Fecha between "',Par_FechaInicio,'" and "',Par_FechaFin, '"');
SET Var_Sentencia := CONCAT(Var_Sentencia,' and Caj.TipoCaja ="',CajaPricipal,'"');

IF(Par_CajaID >0 )THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia,' and   Mov.CajaID =  ',Par_CajaID);

END IF;

IF(Par_MonedaID >0)THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia,' and   Mov.MonedaID =  ',Par_MonedaID);
END IF;

SET @Sentencia	= Var_Sentencia;

PREPARE STScAJAPRINCIPAL FROM @Sentencia;
EXECUTE STScAJAPRINCIPAL;
DEALLOCATE PREPARE STScAJAPRINCIPAL;

SET Var_SentenciaHis := CONCAT(Var_SentenciaTabla, ' SELECT Mov.CajaID,convert(concat( "',ConstanteCP ,'",Suc.NombreSucurs),char) as NombreCaja,Mov.Fecha,Mov.Transaccion,');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' case when Tip.Naturaleza =1 then "', DesSalida,'" else "',DesEntrada,'"  end as Tipo,');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' Tip.Descripcion, Mov.Referencia,');

SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' case when Mov.TipoOperacion in (85,86,20,40,19,39) then Mov.Referencia ');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' when Mov.TipoOperacion in (16,36,42,41) then Tran.Referencia else "',Cadena_Vacia,'" end as Referencia2,');


SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' case when Tip.Naturaleza =2 then Mov.MontoEnFirme else 0 end as Entrada, ');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' case when Tip.Naturaleza =1 then Mov.MontoEnFirme else 0 end as Salida, Tip.Naturaleza, convert(time(now()),char) as HoraEmision,');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' Tip.Numero');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' FROM `HIS-CAJASMOVS`  Mov INNER JOIN CAJATIPOSOPERA Tip on Tip.Numero = Mov.TipoOperacion');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' INNER JOIN SUCURSALES Suc on Suc.SucursalID = Mov.SucursalID');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' INNER JOIN CAJASVENTANILLA  Caj on Caj.CajaID =Mov.CajaID and Caj.SucursalID = Mov.Sucursal');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' left join `HIS-TRANSFERBANCO` Tran on Tran.NumTransaccion= Mov.Transaccion');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' where  Tip.Origen =  "',ConstanteSI,'" and Mov.Fecha between "',Par_FechaInicio,'" and "',Par_FechaFin, '"');
SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' and Caj.TipoCaja ="',CajaPricipal,'"');


IF(Par_CajaID >0 )THEN
	SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' and   Mov.CajaID =  ',Par_CajaID);
END IF;

IF(Par_MonedaID >0)THEN
	SET Var_SentenciaHis := CONCAT(Var_SentenciaHis,' and   Mov.MonedaID =  ',Par_MonedaID);
END IF;


SET @Sentencia	= Var_SentenciaHis;

PREPARE STScAJAPRINCIPAL FROM @Sentencia;
EXECUTE STScAJAPRINCIPAL;
DEALLOCATE PREPARE STScAJAPRINCIPAL;

SELECT * FROM TMPCAJAPRINCIPAL
GROUP BY CajaID,		NombreCaja,		Fecha,			Transaccion, 	Tipo,
		 Descripcion,	Referencia, 	Referencia2, 	Entrada, 		Salida,
		 Naturaleza,	HoraEmision,	TipoOperacion
ORDER BY Transaccion,  Fecha, CajaID;


END TerminaStore$$