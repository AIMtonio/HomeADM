-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANOINTEGRALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANOINTEGRALIS`;DELIMITER $$

CREATE PROCEDURE `ORGANOINTEGRALIS`(
    Par_OrganoID        int(11),
    Par_ClavePuestoID   varchar(10),
    Par_NumLis          tinyint unsigned,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint  	)
TerminaStore: BEGIN




DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    int;
DECLARE Cadena_Vacia    char(1);
DECLARE Lis_Principal   int;
DECLARE Lis_NoAsigna    int;
DECLARE Puesto_Vigente  char(1);
DECLARE Si_Asignado     char(1);
DECLARE No_Asignado     char(1);



Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set Cadena_Vacia    := '';
Set Lis_Principal   := 1;
Set Lis_NoAsigna    := 2;
Set Puesto_Vigente  := 'V';
Set Si_Asignado     := 'S';
Set No_Asignado     := 'N';

ManejoErrores: BEGIN

    if( Par_NumLis = Lis_Principal) then
        select  Pue.ClavePuestoID, Pue.Descripcion,
                case when ifnull(Org.OrganoID, Entero_Cero) = Entero_Cero THEN No_Asignado
                     else Si_Asignado
                END	AS Asignado
            from PUESTOS Pue
            left outer join ORGANOINTEGRA as Org on  Org.ClavePuestoID = Pue.ClavePuestoID
                                                 and Org.OrganoID = Par_OrganoID
            where Pue.Estatus = Puesto_Vigente;
    end if;

    if( Par_NumLis = Lis_NoAsigna) then
        select  Pue.ClavePuestoID, Pue.Descripcion
            from PUESTOS Pue
            where Pue.ClavePuestoID not in (select  Pus.ClavePuestoID
                                                from ORGANOINTEGRA Org,
                                                     PUESTOS Pus
                                                where Org.OrganoID = Par_OrganoID
                                                  and Org.ClavePuestoID = Pus.ClavePuestoID);

    end if;


END ManejoErrores;



END TerminaStore$$