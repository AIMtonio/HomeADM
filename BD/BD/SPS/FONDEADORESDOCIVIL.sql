-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEADORESDOCIVIL
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEADORESDOCIVIL`;DELIMITER $$

CREATE PROCEDURE `FONDEADORESDOCIVIL`(
    Par_Linea           int
	)
TerminaStore: BEGIN


DECLARE Var_RegComas   varchar(200);
DECLARE Var_Segmento varchar(50);
DECLARE Var_RegComas1   varchar(200);
DECLARE Var_Segmento1 int(11);
DECLARE Var_FechaSaldos date;
DECLARE Var_MonCapConta decimal(14,2);


DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE Fecha_Vacia     date;
DECLARE Nat_Deudora     char(1);
DECLARE Nat_Acreedora   char(1);


set Cadena_Vacia    := '';
set Entero_Cero     := 0;
set Fecha_Vacia     := '1900-01-01';
set Nat_Deudora     := 'D';
set Nat_Acreedora   := 'A';

TRUNCATE TMPFONDEDOCIV;

select EstadoCivil,ProductosCre into Var_RegComas, Var_RegComas1
        from LINFONCONDCTE
        where LineaFondeoID =  Par_Linea
limit 1;

set Var_RegComas   := ifnull(Var_RegComas, Cadena_Vacia);
set Var_RegComas1   := ifnull(Var_RegComas1, Cadena_Vacia);

if(LOCATE(',', Var_RegComas) > Entero_Cero) then
    WHILE (LOCATE(',', Var_RegComas) > Entero_Cero) DO

        set Var_Segmento = SUBSTRING_INDEX(Var_RegComas, ',', 1);
        insert into  TMPFONDEDOCIV values(Var_Segmento);
        set Var_RegComas = SUBSTRING(Var_RegComas, LOCATE(',', Var_RegComas) + 1);

    END WHILE;
    insert into  TMPFONDEDOCIV values(Var_RegComas);
ELSE if(LOCATE(',', Var_RegComas) = Entero_Cero) then
     insert into  TMPFONDEDOCIV values(Var_RegComas);
     end if;
end if;




END TerminaStore$$