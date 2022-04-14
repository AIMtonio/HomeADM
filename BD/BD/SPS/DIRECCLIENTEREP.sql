-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCLIENTEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECCLIENTEREP`;DELIMITER $$

CREATE PROCEDURE `DIRECCLIENTEREP`(
	Par_ClienteID			int(11),
	Par_SeccionRep		int(11),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN



DECLARE Cadena_Vacia        char(1);
DECLARE Entero_Cero         int(11);




DECLARE SeccionEncabezado   int(11);
DECLARE SeccionDetalleDir   int(11);



Set Cadena_Vacia            := '';
Set Entero_Cero             := 0;




Set SeccionEncabezado       := 1;
Set SeccionDetalleDir       := 2;




if Par_SeccionRep  = SeccionEncabezado then
    Select	Cli.ClienteID,		Cli.NombreCompleto,     Cli.FechaNacimiento,        Cli.RFCOficial,     Cli.CURP,
            case when Cli.Sexo = 'M' then 'MASCULINO'
                 when Cli.Sexo = 'F' then 'FEMENINO'
                                      else Cadena_Vacia
            end as Genero,
            case Cli.TipoPersona    when 'A' then 'FISICA CON ACTIVIDAD EMPRESARIAL'
                                    when 'F' then 'FISICA'
                                    when 'M' then 'MORAL'
                                             else Cadena_Vacia
            end as TipoPersona,
            Cli.PromotorActual,
            Pro.NombrePromotor,
            Cli.SucursalOrigen,
            Suc.NombreSucurs,
            Cli.FechaAlta,
            case when Cli.Nacion = 'N' then 'MEXICANA'
                 when Cli.Nacion = 'E' then 'EXTRANJERA'
                                        else Cadena_Vacia
            end as Nacionalidad,
            case Cli.EstadoCivil    when 'S'    then 'SOLTERO'
                                    when 'CS'   then 'CASADO CON BIENES SEPARADOS'
                                    when 'CM'   then 'CASADO CON BIENES MANCOMUNADOS'
                                    when 'CC'   then 'CASADO CON BIENES MANCOMUNADOS CON CAPITULACION'
                                    when 'V'    then 'VIUDO(A)'
                                    when 'D'    then 'DIVORCIADO(A)'
                                    when 'SE'   then 'SEPARADO(A)'
                                    when 'U'    then 'EN UNION LIBRE'
                                                else Cadena_Vacia
            end as EstadoCivil,
            ifnull(Cli.Telefono, Cadena_Vacia) as Telefono,
            ifnull(Cli.Correo, Cadena_Vacia) as Correo,
            Cli.ActividadBancoMX,
            Ifnull(Bmx.Descripcion, Cadena_Vacia) as Bmx_Descripcion,
            Cli.ActividadINEGI,
            Ifnull(Ine.Descripcion, Cadena_Vacia) as Ine_Descripcion,
            Cli.ActividadFR,
            ifnull(Fr.Descripcion, Cadena_Vacia) as Fr_Descripcion,
            Cli.ActividadFOMURID,
            ifnull(Fom.Descripcion, Cadena_Vacia) as Fom_Descripcion
    from CLIENTES Cli
    left join PROMOTORES Pro on Pro.PromotorID = Cli.PromotorActual
    left join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen
    left join ACTIVIDADESBMX Bmx on Bmx.ActividadBMXID = Cli.ActividadBancoMX
    left join ACTIVIDADESINEGI Ine on Ine.ActividadINEGIID = Cli.ActividadINEGI
    left join ACTIVIDADESFR Fr  on Fr.ActividadFRID = Cli.ActividadFR
    left join ACTIVIDADESFOMUR Fom  on Fom.ActividadFOMURID = Cli.ActividadFOMURID
    where ClienteID = Par_ClienteID;

end if;


if Par_SeccionRep  = SeccionDetalleDir then

    Select   Dir.DireccionID        ,Dir.TipoDireccionID        ,Tip.Descripcion        ,Dir.EstadoID           ,Est.Nombre
            ,Dir.MunicipioID        ,Mun.Nombre                 ,Dir.LocalidadID        ,Loc.NombreLocalidad    ,Dir.ColoniaID
            ,Col.TipoAsenta         ,Col.Asentamiento           ,Dir.Calle              ,Dir.NumeroCasa         ,Dir.NumInterior
            ,Dir.Piso               ,Dir.PrimeraEntreCalle      ,Dir.SegundaEntrecalle  ,Dir.CP                 ,Dir.Oficial
            ,Dir.Manzana            ,Dir.Lote                   ,Dir.Latitud            ,Dir.Longitud
            ,case when Dir.Oficial = 'S' then 'OFICIAL' else 'NO OFICIAL' end as EsOficial
            ,concat("CALLE ", ltrim(rtrim(Dir.Calle))
                    ,case when rtrim(ltrim(ifnull(Dir.NumeroCasa, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(" NUMERO ", ltrim(rtrim(Dir.NumeroCasa))) end
                    ,case when rtrim(ltrim(ifnull(Dir.NumInterior, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(" INTERIOR ", ltrim(rtrim(Dir.NumInterior))) end
                    ,case when rtrim(ltrim(ifnull(Dir.Manzana, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(" MANZANA ", ltrim(rtrim(Dir.Manzana))) end
                    ,case when rtrim(ltrim(ifnull(Dir.Lote, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(" LOTE ", ltrim(rtrim(Dir.Lote))) end
                    ,case when rtrim(ltrim(ifnull(Dir.Piso, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(" PISO ", ltrim(rtrim(Dir.Piso))) end
                    ,case when rtrim(ltrim(ifnull(Dir.PrimeraEntreCalle, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0') OR  rtrim(ltrim(ifnull(Dir.SegundaEntrecalle, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0') then Cadena_Vacia else concat(",  ENTRE ", rtrim(ltrim(ifnull(Dir.PrimeraEntreCalle, Cadena_Vacia))), " Y ", rtrim(ltrim(ifnull(Dir.SegundaEntrecalle, Cadena_Vacia)))) end
                    ,case when rtrim(ltrim(ifnull(Col.TipoAsenta, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(", ", ltrim(rtrim(Col.TipoAsenta))) end
                    ,case when rtrim(ltrim(ifnull(Col.Asentamiento, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(" ", ltrim(rtrim(Col.Asentamiento))) end
                    ,case when rtrim(ltrim(ifnull(Dir.CP, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(" C.P. ", ltrim(rtrim(Dir.CP))) end
                    ,case when rtrim(ltrim(ifnull(Loc.NombreLocalidad, Cadena_Vacia))) in (Cadena_Vacia) Or (rtrim(ltrim(ifnull(Loc.NombreLocalidad, Cadena_Vacia))) <> Cadena_Vacia and rtrim(ltrim(ifnull(Loc.NombreLocalidad, Cadena_Vacia))) = rtrim(ltrim(ifnull(Mun.Nombre, Cadena_Vacia))))  then Cadena_Vacia else concat(" LOCALIDAD ", ltrim(rtrim(Loc.NombreLocalidad))) end
                    ,case when rtrim(ltrim(ifnull(Mun.Nombre, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(", MUNICIPIO ", ltrim(rtrim(Mun.Nombre))) end
                    ,case when rtrim(ltrim(ifnull(Est.Nombre, Cadena_Vacia))) in (Cadena_Vacia, 'NA', 'SN', '0')   then Cadena_Vacia else concat(", ", ltrim(rtrim(Est.Nombre))) end
                   ) as DireccionCompleta
    from DIRECCLIENTE Dir
    left join TIPOSDIRECCION Tip on Tip.TipoDireccionID = Dir.TipoDireccionID
    left join LOCALIDADREPUB Loc on Loc.LocalidadID = Dir.LocalidadID and Dir.MunicipioID = Loc.MunicipioID and Dir.EstadoID = Loc.EstadoID
    left join COLONIASREPUB Col on Col.ColoniaID = Dir.ColoniaID and Dir.MunicipioID = Col.MunicipioID and Dir.EstadoID = Col.EstadoID
    left join MUNICIPIOSREPUB Mun on Mun.EstadoID = Dir.EstadoID and Mun.MunicipioID = Dir.MunicipioID
    left join ESTADOSREPUB Est on Est.EstadoID = Dir.EstadoID
    where ClienteID = Par_ClienteID
    Order by Dir.Oficial DESC, Dir.TipoDireccionID;

end if;
END TerminaStore$$