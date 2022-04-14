-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMBITACOESTEMPLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMBITACOESTEMPLIS`;DELIMITER $$

CREATE PROCEDURE `NOMBITACOESTEMPLIS`(
	Par_InstitNominaID      int,
    Par_NumLis          tinyint unsigned,
	 Par_FechaInicio 	date,
	Par_FechaFin		date,
    Par_ClienteID     int(11),
    Par_Estatus       char(1),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)
TerminaStore: BEGIN


DECLARE Lis_Principal   int;
DECLARE Lis_BitaPorInst	int;
DECLARE Est_Todos        char(1);
DECLARE Entero_Cero     int;


DECLARE	Var_Sentencia	varchar(8000);


SET Lis_Principal   := 1;
SET Lis_BitaPorInst := 2;
SET Est_Todos       := '0';
SET Entero_Cero     := 0;
SET Var_Sentencia   := '';

if(Par_NumLis = Lis_BitaPorInst)then
        SET Var_Sentencia := CONCAT(
            'select	Nom.NombreInstit,		Bi.Fecha,			Bi.ClienteID,				Cli.NombreCompleto,
                    Bi.EstatusAnterior,		Bi.EstatusNuevo,	Bi.FechaInicioIncapacidad,
                    Bi.FechaFinIncapacidad,	Bi.FechaBaja,		Bi.MotivoBaja, convert(time(now()),char) as HoraEmision
            from NOMBITACOESTEMP Bi
            inner join INSTITNOMINA Nom on(Bi.InstitNominaID = Nom.InstitNominaID
                                       and Nom.InstitNominaID = ',Par_InstitNominaID,')

            inner join CLIENTES Cli on (Bi.ClienteID = Cli.ClienteID)
            where Bi.InstitNominaID= ',Par_InstitNominaID,'
              and Nom.InstitNominaID=', Par_InstitNominaID,'
              and Bi.Fecha >="', Par_FechaInicio,'"
              and Bi.Fecha <="', Par_FechaFin,'"'

        );
        if(ifnull(Par_ClienteID,Entero_Cero) != Entero_Cero) then
            set Var_Sentencia :=  CONCAT(Var_Sentencia,' and Cli.ClienteID=',Par_ClienteID );
        end if;
        if(Par_Estatus != Est_Todos) then
             set Var_Sentencia := CONCAT(Var_Sentencia,' and Bi.EstatusNuevo="',Par_Estatus,'"');
        end if;

SET @Sentencia	= (Var_Sentencia);
PREPARE STNOMBITACOESTEMP FROM @Sentencia;
 EXECUTE STNOMBITACOESTEMP ;
DEALLOCATE PREPARE STNOMBITACOESTEMP;
end if;

END TerminaStore$$