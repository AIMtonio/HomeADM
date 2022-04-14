-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAAUTORIZAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAAUTORIZAALT`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAAUTORIZAALT`(
	Par_Producto        INT(11),
	Par_CicloIni        INT(11),
	Par_CicloFin        INT(11),
	Par_MontoIni        DECIMAL(18,2),
	Par_MontoFin        DECIMAL(18,2),
	Par_MontoMax        DECIMAL(18,2),

	Par_Salida		char(1),
	inout Par_NumErr	int,
	inout Par_ErrMen	varchar(400),
	Par_EmpresaID		int(11),
	Aud_Usuario		int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion  	bigint(20)
	)
TerminaStore: BEGIN



DECLARE Var_Producto	       int(11);
DECLARE Var_EsGrupal        char(1);
DECLARE Var_CicloActual     char(1);
DECLARE Var_CicloGrupal     char(1);
DECLARE Var_EsquemaID       int(11);
DECLARE Var_EsquemaCruce    int(11);


DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         datetime;
DECLARE Entero_Cero         int(11);
DECLARE Str_SI              char(1);
DECLARE Str_NO              char(1);



Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set Str_SI              := 'S';
Set Str_NO              := 'N';



Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set     Par_NumErr  := 1;
set     Par_ErrMen  := Cadena_Vacia;


ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-ESQUEMAAUTORIZAALT");
				END;



if(ifnull(Par_Producto, Entero_Cero))= Entero_Cero then
    Set Par_ErrMen  := 'El Producto no es valido.';
    if(Par_Salida = Str_SI) then
        select  '001' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


select ProducCreditoID, EsGrupal
into Var_Producto, Var_EsGrupal
from PRODUCTOSCREDITO
where ProducCreditoID = Par_Producto;

if ifnull(Var_Producto, Entero_Cero) =  Entero_Cero then
    Set Par_ErrMen  := 'El Producto no existe.';
    if(Par_Salida = Str_SI) then
        select  '002' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if ifnull(Par_CicloIni, -1) < Entero_Cero then
    Set Par_ErrMen  := 'El Numero de Ciclo Inicial no puede ser negativo';
    if(Par_Salida = Str_SI) then
        select  '003' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if ifnull(Par_CicloFin, -1) < Entero_Cero then
    Set Par_ErrMen  := 'El Numero de Ciclo Final no puede ser negativo';
    if(Par_Salida = Str_SI) then
        select  '004' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if Par_CicloIni > Par_CicloFin then
    Set Par_ErrMen  := 'El numero de ciclo inicial no puede ser mayor al ciclo final';
    if(Par_Salida = Str_SI) then
        select  '005' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


if ifnull(Par_MontoIni, -1.0) < Entero_Cero then
    Set Par_ErrMen  := 'El Monto Inicial no puede menor a cero';
    if(Par_Salida = Str_SI) then
        select  '006' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


if ifnull(Par_MontoFin, Entero_Cero) <= Entero_Cero then
    Set Par_ErrMen  := 'El Monto Final no puede ser menor o igual a Cero';
    if(Par_Salida = Str_SI) then
        select  '007' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;



if Par_MontoIni > Par_MontoFin then
    Set Par_ErrMen  := 'El Monto Inicial no puede ser mayor al Monto Final';
    if(Par_Salida = Str_SI) then
        select  '008' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if Var_EsGrupal = Str_SI then
    if ifnull(Par_MontoMax, -1.0) < Entero_Cero then
        Set Par_ErrMen  := 'El Monto Maximo no puede ser negativo';
        if(Par_Salida = Str_SI) then
            select  '009' as NumErr,
                     Par_ErrMen as ErrMen,
                     'productoID' as control,
                      Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end if;

else
    Set Par_MontoMax    := Par_MontoFin;
end if;

if exists(select 1 from ESQUEMAAUTORIZA
                    where ProducCreditoID = Par_Producto
                      and CicloInicial = Par_CicloIni
                      and CicloFinal   = Par_CicloFin
                      and MontoInicial = Par_MontoIni
                      and MontoFinal = Par_MontoFin
                      and MontoMaximo = Par_MontoMax) then
    Set Par_ErrMen  := 'Ya Existe un esquema de autorizacion con las condiciones Indicadas.';
    if(Par_Salida = Str_SI) then
        select  '010' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;



select max(EsquemaID)
into Var_EsquemaCruce
from ESQUEMAAUTORIZA
where ProducCreditoID = Par_Producto
and ((Par_CicloIni >= CicloInicial and Par_CicloIni <= CicloFinal )
      or (Par_CicloFin >= CicloInicial and Par_CicloFin <= CicloFinal )
      or (Par_CicloIni <= CicloInicial and Par_CicloFin >= CicloFinal ) )
and ((Par_MontoIni >= MontoInicial and Par_MontoIni <= MontoFinal )
      or (Par_MontoFin >= MontoInicial and Par_MontoFin <= MontoFinal )
      or (Par_MontoIni <= MontoInicial and Par_MontoFin >= MontoFinal ) );

Set Var_EsquemaCruce    := (ifnull(Var_EsquemaCruce, Entero_Cero));

if Var_EsquemaCruce > Entero_Cero then
    Set Par_ErrMen  := concat("Los rangos se traslapan con el esquema de autorizacion  ",cast(Var_EsquemaCruce as char));
    if(Par_Salida = Str_SI) then
        select  '011' as NumErr,
                 Par_ErrMen as ErrMen,
                 'productoID' as control,
                  Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


Set Var_EsquemaID   := (select max(EsquemaID) from ESQUEMAAUTORIZA);

Set Var_EsquemaID   := ifnull(Var_EsquemaID, Entero_Cero) + 1;


INSERT INTO ESQUEMAAUTORIZA (EsquemaID          ,ProducCreditoID    ,CicloInicial   ,CicloFinal         ,MontoInicial
                            ,MontoFinal         ,MontoMaximo        ,EmpresaID      ,Usuario            ,FechaActual
                            ,DireccionIP        ,ProgramaID         ,Sucursal       ,NumTransaccion)

                    VALUES( Var_EsquemaID       ,Par_Producto       ,Par_CicloIni   ,Par_CicloFin       ,Par_MontoIni
                            ,Par_MontoFin       ,Par_MontoMax       ,Par_EmpresaID  ,Aud_Usuario        ,Aud_FechaActual
                            ,Aud_DireccionIP    ,Aud_ProgramaID     ,Aud_Sucursal   ,Aud_NumTransaccion);

set Par_NumErr := Entero_Cero;
set Par_ErrMen := concat("Esquema de Autorizacion grabado con Exito.");

END ManejoErrores;


if(Par_Salida = Str_SI) then
    select '000' as NumErr,
            Par_ErrMen  as ErrMen,
            'producCreditoID' as control,

			Var_EsquemaID as consecutivo;

end if;



END TerminaStore$$