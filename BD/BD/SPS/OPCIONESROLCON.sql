-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESROLCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESROLCON`;
DELIMITER $$


CREATE PROCEDURE `OPCIONESROLCON`(
    Par_RolID           int,
	Par_OpcionMenuID	int(11),
    Par_NumCon          tinyint unsigned,
    Par_EmpresaID       int,

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)

BEGIN


DECLARE Var_OpcionMenuID    int;
DECLARE Var_Recurso         varchar(150);
DECLARE Var_DescriRol       varchar(150);
DECLARE Var_NumOpcion       int;

DECLARE Var_Roles           varchar(1000);


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Con_Principal   int;
DECLARE Con_Foranea     int;
DECLARE Con_PorRol      int;
DECLARE Con_Menu      	int;
DECLARE Con_OpcionMenu	int;


DECLARE CURSORRECURSOS CURSOR FOR
    select OpcionMenuID, Recurso
        from OPCIONESMENU
        where Recurso != "enConstruccion.htm";

DECLARE CURSORPERFIL CURSOR FOR
    select Rol.Descripcion
        from OPCIONESROL Opc,
             ROLES Rol
        where Opc.RolID = Rol.RolID
          and Opc.OpcionMenuID  = Var_OpcionMenuID;


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Con_Principal   := 1;
Set Con_Foranea     := 2;
Set Con_PorRol      := 3;
Set Con_Menu        := 4;
set Con_OpcionMenu	:= 5;

if(Par_NumCon = Con_PorRol) then
	select  Opr.OpcionMenuID,	Op.Desplegado, Op.Recurso,	Opr.RolID
		from	 OPCIONESROL	Opr,
			 OPCIONESMENU	Op,
			 GRUPOSMENU	  	Gr,
			 MENUSAPLICACION	Me
		where Opr.RolID 		= Par_RolID
		  and Op.OpcionMenuID	= Opr.OpcionMenuID
		  and Op.GrupoMenuID	= Gr.GrupoMenuID
		  and Gr.MenuID 		= Me.MenuID
		order by Me.Orden, Gr.Orden, Op.Orden;

	select  Opr.OpcionMenuID,	Op.Desplegado, Op.Recurso,	Opr.RolID
		from	 OPCIONESROL	Opr,
			 OPCIONESMENU	Op,
			 GRUPOSMENU	  	Gr,
			 MENUSAPLICACION	Me
		where Opr.RolID 		= Par_RolID
		  and Op.OpcionMenuID	= Opr.OpcionMenuID
		  and Op.GrupoMenuID	= Gr.GrupoMenuID
		  and Gr.MenuID 		= Me.MenuID
		order by Me.Orden, Gr.Orden, Op.Orden;

end if;

if(Par_NumCon = Con_Menu) then
    CREATE TEMPORARY TABLE TMPRECURSOROL(
        `Tmp_Recurso`   varchar(100),
        `Tmp_Roles`     varchar(1000)   );

    set Var_Roles   = Cadena_Vacia;

    OPEN CURSORRECURSOS;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP

        FETCH CURSORRECURSOS into
            Var_OpcionMenuID,   Var_Recurso;

            set Var_Roles   = Cadena_Vacia;
            set Var_NumOpcion := 1;
            OPEN CURSORPERFIL;
            BEGIN
                DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                LOOP

                FETCH CURSORPERFIL into
                    Var_DescriRol;

                    if Var_NumOpcion > 1 then
                        set  Var_Roles = concat(Var_Roles, ",");
                    end if;
                    set  Var_Roles = concat(Var_Roles, Var_DescriRol);
                    set Var_NumOpcion := Var_NumOpcion + 1;
                End LOOP;
            END;
            CLOSE CURSORPERFIL;

            insert TMPRECURSOROL values(
                Var_Recurso, Var_Roles  );

        End LOOP;
    END;
    CLOSE CURSORRECURSOS;

    select  `Tmp_Recurso`, `Tmp_Roles`
        from TMPRECURSOROL;

    drop table TMPRECURSOROL;

end if;
if(Par_NumCon = Con_OpcionMenu)then
	select OpcionMenuID
		from OPCIONESROL
			where  RolID =Par_RolID
				and OpcionMenuID = Par_OpcionMenuID;

end if;

END$$