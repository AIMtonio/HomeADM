-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACLIENTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTACLIENTECON`;DELIMITER $$

CREATE PROCEDURE `EDOCTACLIENTECON`(

    Par_Salida    		char(1),
    inout	Par_NumErr 	int,
    inout	Par_ErrMen  varchar(350)

	)
TerminaStore: BEGIN


DECLARE Var_AnioMes     int;
DECLARE Var_StrAnioMes  varchar(10);
DECLARE Var_FechaInicio date;
DECLARE Var_FechaFin    date;

DECLARE Tex_FechaInicio varchar(50);
DECLARE Tex_FechaFin    varchar(50);


DECLARE Entero_Cero     int;


SET Entero_Cero	:= 0;

set lc_time_names= 'es_MX';

select max(AnioMes) into Var_AnioMes
    from EDOCTARESUMCTA Edo;

set Var_AnioMes := ifnull(Var_AnioMes, 0);

if (Var_AnioMes != 0) then
    set Var_StrAnioMes = convert(Var_AnioMes, char);
else
    set Var_StrAnioMes = '190001';
end if;

set Var_FechaInicio := concat(substring(Var_StrAnioMes,1,4), '-',
                              substring(Var_StrAnioMes,5,2), '-',
                              '01');

set Var_FechaFin    := last_day(Var_FechaInicio);

set Tex_FechaInicio := concat(
                        '1 de ',
                        upper(substring(DATE_FORMAT(Var_FechaInicio, '%M'),1,1)),
                        substring(DATE_FORMAT(Var_FechaInicio, '%M'),2,
                                  CHARACTER_LENGTH(DATE_FORMAT(Var_FechaInicio, '%M'))-1),
                        ' del ', substring(Var_StrAnioMes,1,4));

set Tex_FechaFin := concat(
                        DATE_FORMAT(Var_FechaFin, '%e'), ' de ',
                        upper(substring(DATE_FORMAT(Var_FechaFin, '%M'),1,1)),
                        substring(DATE_FORMAT(Var_FechaFin, '%M'),2,
                                  CHARACTER_LENGTH(DATE_FORMAT(Var_FechaFin, '%M'))-1),
                        ' delhttp://mail.google.com/mail/ ', substring(Var_StrAnioMes,1,4));


select distinct(ClienteID),
       RutaRPTEdoCta as rptName,
        concat(RutaPDFEdoCta , LPAD(convert(ClienteID,char), 10, 0),
               '-',Var_StrAnioMes, '.pdf') as outputFile,

       Tex_FechaInicio as FechaInicio,
       Tex_FechaFin as FechaFin
    from EDOCTARESUMCTA Edo,
         PARAMETROSSIS Par;

END TerminaStore$$