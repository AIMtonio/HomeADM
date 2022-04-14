-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENFOLIOSCOMITEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENFOLIOSCOMITEPRO`;DELIMITER $$

CREATE PROCEDURE `GENFOLIOSCOMITEPRO`(
    Par_Fecha           date,
    Par_Salida          char(1),
	inout	Par_NumErr  int,
	inout	Par_ErrMen  varchar(100),

    Par_EmpresaID       int,

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
)
TerminaStore: BEGIN


DECLARE Var_FechaBatch  date;
DECLARE Var_FecBitaco   datetime;
DECLARE Var_MinutosBit  int;
DECLARE Var_Folio       bigint;
DECLARE Var_SucursalID  bigint;
DECLARE Var_FoliosComite    char(1);


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Monto_Mayores   decimal(12,2);
DECLARE Gen_FoliosSI    char(1);
DECLARE Salida_NO       char(1);
DECLARE Pro_FolComite   int;
DECLARE Acta_Sucursal   char(1);
DECLARE Acta_CreMayores char(1);
DECLARE Acta_Relaciona  char(1);
DECLARE Acta_Reestruc   char(1);


DECLARE CURSORSUCURSALES CURSOR FOR
    select distinct(Suc.SucursalID)
        from SUCURSALES Suc;


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Monto_Mayores   := 60000;
Set Gen_FoliosSI    := 'S';
Set Salida_NO       := 'N';
Set Pro_FolComite   := 902;
Set Acta_Sucursal   := 'S';
Set Acta_CreMayores := 'C';
Set Acta_Relaciona  := 'L';
Set Acta_Reestruc   := 'R';


set Aud_ProgramaID	:= 'GENFOLIOSCOMITEPRO';
set Var_FecBitaco	:= now();

select Fecha into Var_FechaBatch
	from BITACORABATCH
	where Fecha 			= Par_Fecha
	  and ProcesoBatchID	= Pro_FolComite;

set Var_FechaBatch := ifnull(Var_FechaBatch, Fecha_Vacia);

select FoliosActasComite into Var_FoliosComite
    from PARAMETROSSIS;

set Var_FoliosComite    := ifnull(Var_FoliosComite, Cadena_Vacia);

if Var_FechaBatch != Fecha_Vacia then
	LEAVE TerminaStore;
end if;

if Var_FoliosComite != Gen_FoliosSI then
	LEAVE TerminaStore;
end if;


OPEN CURSORSUCURSALES;
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    LOOP

    FETCH CURSORSUCURSALES into
        Var_SucursalID;


        call `FOLIOACTACOMITECON`(
            Acta_Sucursal,  Par_Fecha,      Var_SucursalID,     Salida_NO,          Var_Folio,
            Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,   Aud_NumTransaccion  );

    End LOOP;
END;

CLOSE CURSORSUCURSALES;



call `FOLIOACTACOMITECON`(
    Acta_CreMayores,    Par_Fecha,      Entero_Cero,        Salida_NO,          Var_Folio,
    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
    Aud_Sucursal,       Aud_NumTransaccion  );


call `FOLIOACTACOMITECON`(
    Acta_Relaciona,     Par_Fecha,      Entero_Cero,        Salida_NO,          Var_Folio,
    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
    Aud_Sucursal,       Aud_NumTransaccion  );


call `FOLIOACTACOMITECON`(
    Acta_Reestruc,      Par_Fecha,      Entero_Cero,        Salida_NO,          Var_Folio,
    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
    Aud_Sucursal,       Aud_NumTransaccion  );



set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());
call BITACORABATCHALT(
    Pro_FolComite,      Par_Fecha,          Var_MinutosBit, Par_EmpresaID,  Aud_Usuario,
    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );

END TerminaStore$$