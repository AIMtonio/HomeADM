-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOGRALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMOGRALALT`;DELIMITER $$

CREATE PROCEDURE `SOCIODEMOGRALALT`(
	Par_ProspectoID			int(11),
	Par_ClienteID			int(11),
	Par_FechaRegistro		date ,
	Par_GradoEscolarID		int(11),
	Par_NumDepenEconomi		int(11),
	Par_AntiguedadLab       int,
	Par_FechaIniTrabajo     DATE,

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Aud_Empresa             int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN


DECLARE Var_DescriProd  char(150);
DECLARE Var_DescriPues  char(150);
DECLARE Var_ProspectoID int(11);
DECLARE Var_ClienteID	 int(11);
DECLARE Var_GradoEscolarID INT(11);
DECLARE Var_CalcAntiguedad  CHAR(1);


DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE Fecha_Vacia		DATE;
DECLARE SalidaNO        char(1);
DECLARE SalidaSI        char(1);
DECLARE Var_SI			CHAR(1);
DECLARE Var_NO			CHAR(1);


Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
SET Fecha_Vacia		:= '1900-01-01';
Set SalidaNO        :='N';
Set SalidaSI        :='S';
SET Var_SI			:= 'S';
SET Var_NO			:= 'N';


Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set Par_NumErr              := 1;
set Par_ErrMen              := '';
SET Var_CalcAntiguedad 		:= IFNULL((SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'DetLaboralCteConyug'), Var_NO);



Set Par_FechaRegistro       :=	(select FechaSistema from PARAMETROSSIS);

if(ifnull(Par_ProspectoID, Entero_Cero)) = Entero_Cero then
	Set Par_ProspectoID := Entero_Cero;
end if;


if(ifnull(Par_ClienteID, Entero_Cero)) = Entero_Cero then
	Set Par_ClienteID := Entero_Cero;
end if;

if(ifnull(Par_AntiguedadLab, Entero_Cero)) = Entero_Cero then
	Set Par_AntiguedadLab := Entero_Cero;
end if;

if (Par_ProspectoID = Entero_Cero and Par_ClienteID = Entero_Cero) then
    Set Par_ErrMen  := 'Debe seleccionar un Cliente o Prospecto.';
    if(Par_Salida = SalidaSI) then
			select '001' as NumErr,
				Par_ErrMen as ErrMen,
				'clienteID' as control,
             Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


if Par_ClienteID > Entero_Cero then
    if not exists(select ClienteID from CLIENTES where ClienteID = Par_ClienteID) then
        Set Par_ErrMen  := 'El Numero de Cliente no Existe';
        if(Par_Salida = SalidaSI) then
                select '002' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
else
    if not exists(select ProspectoID from PROSPECTOS where ProspectoID = Par_ProspectoID) then
        Set Par_ErrMen  := 'El Numero de Prospecto no Existe';
        if(Par_Salida = SalidaSI) then
                select '003' as NumErr,
                        Par_ErrMen as ErrMen,
                        'prospectoID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
end if;




if not exists(SELECT GradoEscolarID  FROM CATGRADOESCOLAR where GradoEscolarID = Par_GradoEscolarID) then
    Set Par_ErrMen  := 'El Grado Escolar Indicado no Existe';
    if(Par_Salida = SalidaSI) then
            select '004' as NumErr,
                    Par_ErrMen as ErrMen,
                    'gradoEscolarID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


insert SOCIODEMOGRAL values(
                Par_ProspectoID,    	Par_ClienteID,      	Par_FechaRegistro,      Par_GradoEscolarID,     Par_NumDepenEconomi,
                Par_AntiguedadLab,  	Par_FechaIniTrabajo,
				Aud_Empresa,        	Aud_Usuario,            Aud_FechaActual, 		Aud_DireccionIP,    	Aud_ProgramaID,
				Aud_Sucursal,       	Aud_NumTransaccion  );



		update PROSPECTOS set
			AntiguedadTra	= round((Par_AntiguedadLab/12),2),

			EmpresaID		= Aud_Empresa,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE ProspectoID 	= Par_ProspectoID;


IF(Var_CalcAntiguedad = Var_SI)THEN

		update CLIENTES set
			AntiguedadTra	= Entero_Cero,
			FechaIniTrabajo = Par_FechaIniTrabajo,

			EmpresaID		= Aud_Empresa,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		where ClienteID 	= Par_ClienteID;

ELSE

		update CLIENTES set
			AntiguedadTra	= round((Par_AntiguedadLab/12),2),
			FechaIniTrabajo = Fecha_Vacia,

			EmpresaID		= Aud_Empresa,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		where ClienteID 	= Par_ClienteID;
END IF;



Set Par_NumErr  := Entero_Cero;
Set Par_ErrMen  := 'Los Datos Sociodemograficos se grabaron con Exito';

if(Par_Salida = SalidaSI) then
        select '000' as NumErr,
                Par_ErrMen as ErrMen,
                'gradoEscolarID' as control,
                Entero_Cero as consecutivo;
end if;



END TerminaStore$$