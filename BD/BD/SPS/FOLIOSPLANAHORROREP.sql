-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSPLANAHORROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSPLANAHORROREP`;DELIMITER $$

CREATE PROCEDURE `FOLIOSPLANAHORROREP`(
-- ===========================================================
-- SP PARA GENERA EL REPORTE DE MOVIMIENTOS DE PLAN DE AHORRO
-- ===========================================================
	Par_PlanID			INT(11),		-- Identificador del Plan de Ahorro
	Par_Sucursal		INT(11),		-- Identificador de la Sucursal
	Par_ClienteID		INT(11),		-- Numero de Cliente
	Par_Estatus			CHAR(1),		-- Estatus de Folios
	Par_TipoReporte		INT(1),			-- Tipo de Reporte

	Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT

)
TerminaStore:BEGIN

/*Declaracion de Variables*/
DECLARE Var_Sentencia	VARCHAR(1500);
DECLARE Var_FechaActual DATE;

/*Declaracion de constante*/
DECLARE RepPrincipal 	INT(11);
DECLARE Entero_Cero 	INT(11);
DECLARE Cadena_Vacia	VARCHAR(50);
DECLARE Fecha_Vacia		DATE;

/*Asignacion de Variables*/
SET RepPrincipal		:= 1;
SET Entero_Cero 		:= 0;
SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';

    SET Var_FechaActual := (SELECT FechaSistema FROM PARAMETROSSIS);

	SET Var_Sentencia := CONCAT("SELECT Fp.PlanID, 	Fp.ClienteID, 		Cli.NombreCompleto, 	Fp.CuentaAhoID, 	Tc.Descripcion,
						Suc.NombreSucurs,			Tph.Nombre, 		CONCAT(Tph.Prefijo,'-',Fp.Serie) AS Serie,
                        Fp.Estatus,					Fp.Monto,			Fp.Fecha,
                        CASE WHEN Fp.FechaCancela = '",Fecha_Vacia,"' THEN '-' ELSE Fp.FechaCancela END AS FechaCancela,
                        CASE WHEN Fp.UsuarioCancela = '' THEN '-' ELSE Fp.UsuarioCancela END AS UsuarioCancela,
                        Tph.FechaLiberacion ");
	SET Var_Sentencia := CONCAT(Var_Sentencia, "FROM FOLIOSPLANAHORRO Fp LEFT JOIN TIPOSCUEPLANAHORRO Tp ON  Fp.PlanID = Tp.PlanAhoID ");

	IF(IFNULL(Par_PlanID,Entero_Cero) != Entero_Cero)THEN
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Fp.PlanID = ',Par_PlanID);
    END IF;

    IF(IFNULL(Par_Sucursal,Entero_Cero) != Entero_Cero)THEN
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Fp.Sucursal = ',Par_Sucursal);
    END IF;

    IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero)THEN
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Fp.ClienteID = ',Par_ClienteID);
    END IF;

    IF(IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia)THEN
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Fp.Estatus = "', Par_Estatus,'" ');
    END IF;

    SET Var_Sentencia := CONCAT(Var_Sentencia, " INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Fp.CuentaAhoID AND Tp.TipoCuentaID = Cue.TipoCuentaID ",
    											"LEFT JOIN TIPOSPLANAHORRO Tph ON Fp.PlanID = Tph.PlanID AND Tph.FechaLiberacion >= ",Var_FechaActual,
    											" LEFT JOIN TIPOSCUENTAS Tc ON Tc.TipoCuentaID=Tp.TipoCuentaID ",
    											" LEFT JOIN CLIENTES Cli ON Fp.ClienteID=Cli.ClienteID ",
    											" LEFT JOIN SUCURSALES Suc ON Suc.SucursalID=Fp.Sucursal ",
    											" ORDER BY Suc.NombreSucurs,Fp.PlanID,Fp.ClienteID; ");

    SET @Sentencia	= (Var_Sentencia);

    PREPARE STCREDITOSREP FROM @Sentencia;
	EXECUTE STCREDITOSREP;

	DEALLOCATE PREPARE STCREDITOSREP;


END TerminaStore$$