-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOPORTUNIDADESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOPORTUNIDADESCON`;DELIMITER $$

CREATE PROCEDURE `PAGOPORTUNIDADESCON`(
	Par_Referencia		varchar(45),
    Par_NumCon			tinyint unsigned,

    Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN
DECLARE Var_Referencia			varchar(45);

DECLARE 	ConsultaReferencia	int;
DECLARE 	EnteroCero			int;


set ConsultaReferencia			:=1;
set EnteroCero					:=0;



if(Par_NumCon = ConsultaReferencia)then
	set Var_Referencia 	:=(select Referencia
		from PAGOPORTUNIDADES where Referencia =Par_Referencia limit 1);

        select ifnull(Var_Referencia, 0) as Referencia;
end if;

END TerminaStore$$