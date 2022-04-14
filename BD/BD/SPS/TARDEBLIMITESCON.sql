-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBLIMITESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBLIMITESCON`;DELIMITER $$

CREATE PROCEDURE `TARDEBLIMITESCON`(
    Par_TarjetaDebID        char(16),
    Par_NumCon              int(11),

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)
TerminaStore: BEGIN

DECLARE Var_EstatusExis     char(1);

DECLARE Con_Principal  		int;


DECLARE EstatusSolic    	char(1);
DECLARE Cadena_Vacia	 	char(1);
DECLARE Entero_Cero			int;



set Con_Principal       :=1;


set Cadena_Vacia        :='';
set Entero_Cero         :=0;



    if(Par_NumCon = Con_Principal) then
        SELECT
            `NoDisposiDia`,		`DisposiDiaNac`,	`NumConsultaMes`,	`DisposiMesNac`,	`ComprasDiaNac`,
			`ComprasMesNac`,	`BloquearATM`,		`BloquearPOS`,		`BloquearCashBack`,	`Vigencia`,
			`AceptaOpeMoto`
        FROM TARDEBLIMITES
        WHERE TarjetaDebID =Par_TarjetaDebID;
    end if;

END TerminaStore$$