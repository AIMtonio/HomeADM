-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONSOCIOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONSOCIOACT`;DELIMITER $$

CREATE PROCEDURE `APORTACIONSOCIOACT`(
    Par_ClienteID       int(11),
    Par_Saldo           decimal(14,2),
    Par_NumAct          tinyint unsigned,


    Par_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)
Terminastore: BEGIN


DECLARE Var_AporatcionID    int;
DECLARE Var_ClienteID    	int;
DECLARE Var_SucursalID      int;





DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Act_Devolucion  int;
DECLARE Act_Aportacion  int;





Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Act_Devolucion  := 2;
Set Act_Aportacion  := 1;


if(Par_NumAct = Act_Aportacion) then
     update APORTACIONSOCIO
            set   Saldo  = Saldo + Par_Saldo
            where  ClienteID     = Par_ClienteID ;
    end if;


if(Par_NumAct = Act_Devolucion) then
     update APORTACIONSOCIO
            set   Saldo  = Saldo - Par_Saldo
            where  ClienteID     = Par_ClienteID ;
    end if;

END TerminaStore$$