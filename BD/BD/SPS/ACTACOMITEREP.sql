-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTACOMITEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTACOMITEREP`;DELIMITER $$

CREATE PROCEDURE `ACTACOMITEREP`(
	Par_Grupo               bigint,
	Par_Solicitud           bigint,
	Par_Usuario             bigint,
	Par_Seccion             int,

	Par_EmpresaID           int,
	Aud_Usuario             int,
	Aud_FechaActual         DateTime,
	Aud_DireccionIP         varchar(15),
	Aud_ProgramaID          varchar(50),
	Aud_Sucursal            int,
	Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN



DECLARE Var_SucUsuario          int;
DECLARE Var_Firma               varchar(15);
DECLARE Var_Facultado           varchar(50);
DECLARE Var_Usuario             bigint;
DECLARE Var_NombreUsuario       varchar(350);

DECLARE Var_Contador            int;
DECLARE Var_NombreTabla         varchar(40);
DECLARE Var_CreateTable         varchar(9000);
DECLARE Var_InsertTable         varchar(5000);
DECLARE Var_InsertValores       varchar(5000);
DECLARE Var_SelectTable         varchar(5000);
DECLARE Var_DropTable           varchar(5000);



DECLARE Cadena_Vacia            char(1);
DECLARE Entero_Cero             int;
DECLARE IntegranteActivo        char(1);
DECLARE DescStaInactiva         varchar(25);
DECLARE DescStaLiberada         varchar(25);
DECLARE DescStaAutorizada       varchar(25);
DECLARE DescStaDesembolsada     varchar(25);
DECLARE DescStaCancelada        varchar(25);
DECLARE DescNoDefinido          varchar(25);
DECLARE DescIntPresidente       varchar(25);
DECLARE DescIntTesorero         varchar(25);
DECLARE DescIntSecretario       varchar(25);
DECLARE DescIntIntegrante       varchar(25);
DECLARE VarMontoAutorizado      varchar(25);
DECLARE VarMontoLetra           varchar(100);
DECLARE NombreEmpresa           varchar(100);


DECLARE SecDatosUsuario         int;
DECLARE SecDatosGrupo           int;
DECLARE SecListaSolicitudes     int;
DECLARE SecFirmasOtorgadas      int;
DECLARE SecMontoLetra           int;



DECLARE cur_SolGrupo cursor for
    select  case Fir.NumFirma when 1 then 'FIRMA A'
                              when 2 then 'FIRMA B'
                              when 3 then 'FIRMA C'
                              when 4 then 'FIRMA D'
                              when 5 then 'FIRMA E'
                              when 6 then 'FIRMA F'
                                     else 'NO DEFINIDO'
            end as Firma,
    Org.Descripcion as Facultado, Fir.UsuarioFirma, Usu.NombreCompleto
    from INTEGRAGRUPOSCRE Inte
    inner join ESQUEMAAUTFIRMA Fir on Fir.SolicitudCreditoID = Inte.SolicitudCreditoID
    inner join ORGANODESICION Org on Org.OrganoID = Fir.OrganoID
    inner join USUARIOS Usu on Usu.UsuarioID = Fir.UsuarioFirma
    where Inte.GrupoID = Par_Grupo
    group by Fir.NumFirma, Org.Descripcion, Fir.UsuarioFirma, Usu.NombreCompleto
    limit 0,10;




DECLARE cur_SolIndividual cursor for
    select  case Fir.NumFirma when 1 then 'FIRMA A'
                              when 2 then 'FIRMA B'
                              when 3 then 'FIRMA C'
                              when 4 then 'FIRMA D'
                              when 5 then 'FIRMA E'
                              when 6 then 'FIRMA F'
                                     else 'NO DEFINIDO'
            end as Firma,
    Org.Descripcion as Facultado, Fir.UsuarioFirma, Usu.NombreCompleto
    from ESQUEMAAUTFIRMA Fir
    inner join ORGANODESICION Org on Org.OrganoID = Fir.OrganoID
    inner join USUARIOS Usu on Usu.UsuarioID = Fir.UsuarioFirma
    where Fir.SolicitudCreditoID = Par_Solicitud
    group by Fir.NumFirma, Org.Descripcion, Fir.UsuarioFirma, Usu.NombreCompleto
    limit 0,10;




Set Cadena_Vacia                := '';
Set Entero_Cero                 := 0;
Set IntegranteActivo            := 'A';
Set DescStaInactiva             := 'INACTIVA';
Set DescStaLiberada             := 'LIBERADA';
Set DescStaAutorizada           := 'AUTORIZADA';
Set DescStaDesembolsada         := 'DESEMBOLSADA';
Set DescStaCancelada            := 'CANCELADA';
Set DescNoDefinido              := 'NO DEFINIDO';
Set DescIntPresidente           := 'PRESIDENTE';
Set DescIntTesorero             := 'TESORERO';
Set DescIntSecretario           := 'SECRETARIO';
Set DescIntIntegrante           := 'INTEGRANTE';





Set SecDatosUsuario             := 1;
Set SecDatosGrupo               := 2;
Set SecListaSolicitudes         := 3;
Set SecFirmasOtorgadas          := 4;
Set SecMontoLetra               := 5;



if Par_Seccion = SecDatosUsuario then

    set Var_SucUsuario      := (select SucursalUsuario from USUARIOS where UsuarioID = Par_Usuario);

    if  ifnull(Var_SucUsuario, Entero_cero) = Entero_cero then
        leave TerminaStore;
    end if;

    SELECT Nombre into NombreEmpresa
        FROM PARAMETROSSIS sis, INSTITUCIONES ins
        WHERE sis.InstitucionID = ins.InstitucionID;
    select Suc.NombreSucurs,
    concat(cast(DAY(Suc.FechaSucursal) as char)," DE ", case MONTH(Suc.FechaSucursal) when 1 then 'ENERO'
                                                                                      when 2 then 'FEBRERO'
                                                                                      when 3 then 'MARZO'
                                                                                      when 4 then 'ABRIL'
                                                                                      when 5 then 'MAYO'
                                                                                      when 6 then 'JUNIO'
                                                                                      when 7 then 'JULIO'
                                                                                      when 8 then 'AGOSTO'
                                                                                      when 9 then 'SEPT.'
                                                                                      when 10 then'OCTUBRE'
                                                                                      when 11 then'NOVIEMBRE'
                                                                                      when 12 then'DICIEMBRE'
                                                                                                else '---'
    end, " DE ",  cast(YEAR(Suc.FechaSucursal) as char)) as  FechaSucursal,
    cast(CURTIME() as char) as hora, Suc.DirecCompleta, NombreEmpresa
    from SUCURSALES Suc
    where SucursalID = Var_SucUsuario;

end if;


if Par_Seccion = SecDatosGrupo then
        select Gru.GrupoID, Gru.NombreGrupo, Gru.CicloActual, count(Inte.SolicitudCreditoID) as CantSol,
        sum(Sol.MontoSolici) as MontoSolicitado, sum(Sol.MontoAutorizado) as MontoAutorizado
        from INTEGRAGRUPOSCRE Inte
        inner join GRUPOSCREDITO Gru on Gru.GrupoID = Inte.GrupoID
        inner join SOLICITUDCREDITO Sol on Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        where Inte.GrupoID = Par_Grupo
        and Inte.Estatus = IntegranteActivo;

end if;




if Par_Seccion = SecListaSolicitudes then

    if ifnull(Par_Grupo, Entero_Cero) > Entero_Cero then
        select Cli.ClienteID, Cli.NombreCompleto, Sol.MontoSolici, Sol.MontoAutorizado,
        Case Sol.Estatus when 'I' then DescStaInactiva
                         when 'L' then DescStaLiberada
                         when 'A' then DescStaAutorizada
                         when 'D' then DescStaDesembolsada
                         when 'C' then DescStaCancelada
                                  else DescNoDefinido
        end as Estatus,
        case Inte.Cargo when 1 then DescIntPresidente
                        when 2 then DescIntTesorero
                        when 3 then DescIntSecretario
                        when 4 then DescIntIntegrante
                               else DescNoDefinido
        end as TipoIntegrante
        from INTEGRAGRUPOSCRE Inte
        inner join SOLICITUDCREDITO Sol on Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        inner join CLIENTES Cli on Cli.ClienteID = Sol.ClienteID
        where Inte.GrupoID = Par_Grupo
        and Inte.Estatus = IntegranteActivo
        order by Inte.Cargo, Cli.NombreCompleto;
    end if;

    if ifnull(Par_Solicitud, Entero_Cero) > Entero_Cero then

        select Cli.ClienteID,   Cli.NombreCompleto,     Sol.MontoSolici,    Sol.MontoAutorizado,
        Case Sol.Estatus when 'I' then DescStaInactiva
                         when 'L' then DescStaLiberada
                         when 'A' then DescStaAutorizada
                         when 'D' then DescStaDesembolsada
                         when 'C' then DescStaCancelada
                                  else DescNoDefinido
        end as Estatus,
        Cadena_Vacia as TipoIntegrante
        from SOLICITUDCREDITO Sol
        inner join CLIENTES Cli on Cli.ClienteID = Sol.ClienteID
        where Sol.SolicitudCreditoID = Par_Solicitud;
    end if;


end if;





if Par_Seccion = SecFirmasOtorgadas then
    Set Var_Contador        := Entero_Cero;
    Set Var_NombreTabla     := concat(" tmp_Firmas", cast(ifnull(Par_Grupo, Entero_Cero) as char), cast(ifnull(Par_Solicitud, Entero_Cero) as char), " ");

    Set Var_CreateTable     := concat( " create temporary table ", Var_NombreTabla,
                                       " (Firma1 varchar(15) null,   Facultado1 varchar(50) null,   Usuario1 bigint null,     NombreUsuario1 varchar(350) null, ",
                                       "  Firma2 varchar(15) null,   Facultado2 varchar(50) null,   Usuario2 bigint null,     NombreUsuario2 varchar(350) null, ",
                                       "  Firma3 varchar(15) null,   Facultado3 varchar(50) null,   Usuario3 bigint null,     NombreUsuario3 varchar(350) null, ",
                                       "  Firma4 varchar(15) null,   Facultado4 varchar(50) null,   Usuario4 bigint null,     NombreUsuario4 varchar(350) null, ",
                                       "  Firma5 varchar(15) null,   Facultado5 varchar(50) null,   Usuario5 bigint null,     NombreUsuario5 varchar(350) null, ",
                                       "  Firma6 varchar(15) null,   Facultado6 varchar(50) null,   Usuario6 bigint null,     NombreUsuario6 varchar(350) null, ",
                                       "  Firma7 varchar(15) null,   Facultado7 varchar(50) null,   Usuario7 bigint null,     NombreUsuario7 varchar(350) null, ",
                                       "  Firma8 varchar(15) null,   Facultado8 varchar(50) null,   Usuario8 bigint null,     NombreUsuario8 varchar(350) null, ",
                                       "  Firma9 varchar(15) null,   Facultado9 varchar(50) null,   Usuario9 bigint null,     NombreUsuario9 varchar(350) null, ",
                                       "  Firma10 varchar(15) null,  Facultado10 varchar(50) null,  Usuario10 bigint null,    NombreUsuario10 varchar(350) null); ");


    Set Var_InsertTable     := concat(" Insert into ", Var_NombreTabla, " (");
    Set Var_InsertValores   := ' values( ';

    Set Var_SelectTable     := concat(" Select * From ", Var_NombreTabla, "; ");
    Set Var_DropTable       := concat(" drop table if exists ", Var_NombreTabla, "; ");





    SET @Sentencia	= concat( Var_DropTable);
    PREPARE Firmantes FROM @Sentencia;
    EXECUTE  Firmantes;
    DEALLOCATE PREPARE Firmantes;

    SET @Sentencia	= (Var_CreateTable);
    PREPARE Firmantes FROM @Sentencia;
    EXECUTE  Firmantes;
    DEALLOCATE PREPARE Firmantes;


    if ifnull(Par_Grupo, Entero_Cero) > Entero_Cero then

        Open  cur_SolGrupo;
                BEGIN
                    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                    Loop
                        Fetch cur_SolGrupo  Into 	Var_Firma,  Var_Facultado,  Var_Usuario,    Var_NombreUsuario;
                        Set Var_Contador    := Var_Contador + 1;

                        Set Var_InsertTable := concat(Var_InsertTable, case when Var_Contador = 1 then '' else ',' end,   "  Firma",cast(Var_Contador as char),
                                                                                                                          ", Facultado", cast(Var_Contador as char),
                                                                                                                          ", Usuario", cast(Var_Contador as char),
                                                                                                                          ", NombreUsuario",  cast(Var_Contador as char));

                        Set Var_InsertValores   := concat(Var_InsertValores,  case when Var_Contador = 1 then '' else ',' end, "'",Var_Firma, "'",
                                                                                                                               ",'", Var_Facultado, "'",
                                                                                                                               ",", cast(Var_Usuario as char),
                                                                                                                               ",'", Var_NombreUsuario, "'");


                    End Loop;
                END;
        Close cur_SolGrupo;

        Set Var_InsertTable     := concat(Var_InsertTable, ")", "  ", Var_InsertValores, ");  ");

        SET @Sentencia	= (Var_InsertTable);
        PREPARE Firmantes FROM @Sentencia;
        EXECUTE  Firmantes;
        DEALLOCATE PREPARE Firmantes;


        SET @Sentencia	= (Var_SelectTable);
        PREPARE Firmantes FROM @Sentencia;
        EXECUTE  Firmantes;
        DEALLOCATE PREPARE Firmantes;



        SET @Sentencia	= concat( Var_DropTable);
        PREPARE Firmantes FROM @Sentencia;
        EXECUTE  Firmantes;
        DEALLOCATE PREPARE Firmantes;

    end if;

    if ifnull(Par_Solicitud, Entero_Cero) > Entero_Cero then

        Open  cur_SolIndividual;
                BEGIN
                    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                    Loop
                        Fetch cur_SolIndividual  Into 	Var_Firma,  Var_Facultado,  Var_Usuario,    Var_NombreUsuario;
                        Set Var_Contador    := Var_Contador + 1;

                        Set Var_InsertTable := concat(Var_InsertTable, case when Var_Contador = 1 then '' else ',' end,   "  Firma",cast(Var_Contador as char),
                                                                                                                          ", Facultado", cast(Var_Contador as char),
                                                                                                                          ", Usuario", cast(Var_Contador as char),
                                                                                                                          ", NombreUsuario",  cast(Var_Contador as char));

                        Set Var_InsertValores   := concat(Var_InsertValores,  case when Var_Contador = 1 then '' else ',' end, "'",Var_Firma, "'",
                                                                                                                               ",'", Var_Facultado, "'",
                                                                                                                               ",", cast(Var_Usuario as char),
                                                                                                                               ",'", Var_NombreUsuario, "'");


                    End Loop;
                END;
        Close cur_SolIndividual;

        Set Var_InsertTable     := concat(Var_InsertTable, ")", "  ", Var_InsertValores, ");  ");

        SET @Sentencia	= (Var_InsertTable);
        PREPARE Firmantes FROM @Sentencia;
        EXECUTE  Firmantes;
        DEALLOCATE PREPARE Firmantes;


        SET @Sentencia	= (Var_SelectTable);
        PREPARE Firmantes FROM @Sentencia;
        EXECUTE  Firmantes;
        DEALLOCATE PREPARE Firmantes;



        SET @Sentencia	= concat( Var_DropTable);
        PREPARE Firmantes FROM @Sentencia;
        EXECUTE  Firmantes;
        DEALLOCATE PREPARE Firmantes;

    end if;

end if;

if Par_Seccion = SecMontoLetra then
    if ifnull(Par_Grupo, Entero_Cero) > Entero_Cero then
        select FORMAT(sum(Sol.MontoAutorizado),2), FUNCIONNUMLETRAS(sum(Sol.MontoAutorizado)) into VarMontoAutorizado, VarMontoLetra
        from INTEGRAGRUPOSCRE Inte
        inner join GRUPOSCREDITO Gru on Gru.GrupoID = Inte.GrupoID
        inner join SOLICITUDCREDITO Sol on Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        where Inte.GrupoID = Par_Grupo
        and Inte.Estatus = IntegranteActivo;
    end if;
    if ifnull(Par_Solicitud, Entero_Cero) > Entero_Cero then
        select FORMAT(Sol.MontoAutorizado,2), FUNCIONNUMLETRAS(sum(Sol.MontoAutorizado)) into VarMontoAutorizado, VarMontoLetra
        from SOLICITUDCREDITO Sol
        inner join CLIENTES Cli on Cli.ClienteID = Sol.ClienteID
        where Sol.SolicitudCreditoID = Par_Solicitud;
    end if;

    SELECT VarMontoAutorizado, VarMontoLetra;
end if ;


END TerminaStore$$