-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEADORPRODCRE
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEADORPRODCRE`;DELIMITER $$

CREATE PROCEDURE `FONDEADORPRODCRE`(
    Par_Linea           int
	)
TerminaStore: BEGIN


DECLARE Var_RegComas   varchar(200);
DECLARE Var_Segmento varchar(50);
DECLARE Var_RegComas1   varchar(2000);
DECLARE Var_Segmento1 varchar(50);
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

TRUNCATE TMPFONDEOPRODCRE;

select ProductosCre into Var_RegComas1
        from LINFONCONDCTE
        where LineaFondeoID =  Par_Linea
limit 1;

set Var_RegComas   := ifnull(Var_RegComas, Cadena_Vacia);
set Var_RegComas1   := ifnull(Var_RegComas1, Cadena_Vacia);


if(LOCATE(',', Var_RegComas1) > Entero_Cero) then
    WHILE (LOCATE(',', Var_RegComas1) > Entero_Cero) DO

        set Var_Segmento1 = SUBSTRING_INDEX(Var_RegComas1, ',', 1);
        insert into  TMPFONDEOPRODCRE values(Var_Segmento1);
        set Var_RegComas1 = SUBSTRING(Var_RegComas1, LOCATE(',', Var_RegComas1) + 1);

    END WHILE;
    insert into  TMPFONDEOPRODCRE values(Var_RegComas1);
ELSE if(LOCATE(',', Var_RegComas1) = Entero_Cero) then
     insert into  TMPFONDEOPRODCRE values(Var_RegComas1);
     end if;
end if;



END TerminaStore$$