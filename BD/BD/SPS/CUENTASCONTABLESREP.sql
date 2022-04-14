-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASCONTABLESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASCONTABLESREP`;DELIMITER $$

CREATE PROCEDURE `CUENTASCONTABLESREP`(
	Par_TipoCuenta		char(1),
	Par_Moneda			int,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Var_Sentencia	 varchar(750);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero		int;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;

set Var_Sentencia := 'select CuentaCompleta, SUBSTRING(Con.Descripcion,1,55)as Descripcion, Grupo, Naturaleza, TipoCuenta, ';
set Var_Sentencia :=  CONCAT(Var_Sentencia, ' Mon.DescriCorta, Restringida');
set Var_Sentencia :=  CONCAT(Var_Sentencia, ' from CUENTASCONTABLES Con, MONEDAS Mon ');
set Var_Sentencia :=  CONCAT(Var_Sentencia, ' where Con.MonedaID = Mon.MonedaId ');

set Par_Moneda = ifnull(Par_Moneda, Entero_Cero);

 if Par_Moneda != 0 then
	set Var_Sentencia = CONCAT(Var_Sentencia, ' and Mon.MonedaId = ', convert(Par_Moneda, char));
 end if;

set Par_TipoCuenta = ifnull(Par_TipoCuenta, Cadena_Vacia);

 if Par_TipoCuenta != Cadena_Vacia and Par_TipoCuenta != '0' then
	set Var_Sentencia = CONCAT(Var_Sentencia, ' and Con.TipoCuenta = ', convert(Par_TipoCuenta, char));
 end if;

set Var_Sentencia :=  CONCAT(Var_Sentencia, ' order by CuentaCompleta');

SET @Sentencia	= Var_Sentencia;

PREPARE STMAESTROCONTAREP FROM @Sentencia;
EXECUTE STMAESTROCONTAREP;

DEALLOCATE PREPARE STMAESTROCONTAREP;

END TerminaStore$$