-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCREQALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICIDOCREQALT`;DELIMITER $$

CREATE PROCEDURE `SOLICIDOCREQALT`(
	Par_ProducCreID      	int,
	Par_ClasTDocID        	int,

	Par_Salida          	char(1),
	inout Par_NumErr    	int,
	inout Par_ErrMen    	varchar(400),
	Par_EmpresaID        	int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal		   	int,
	Aud_NumTransaccion  	bigint
	)
TerminaStore: BEGIN


DECLARE Var_SolDocRID		int;


DECLARE Entero_Cero		int;
DECLARE Decimal_Cero	decimal(12,2);
DECLARE Cadena_Vacia	char(1);
DECLARE Fecha_Vacia   	date;
Declare SalidaNO		char(1);
Declare SalidaSI		char(1);



set Entero_Cero		:=0;
set Decimal_Cero	:=0.0;
set Cadena_Vacia	:='';
set Fecha_Vacia		:= '1900-01-01';
Set SalidaNO		:= 'N';
Set SalidaSI		:= 'S';



Set Aud_FechaActual	:=	CURRENT_TIMESTAMP();


 if(ifnull(Par_ProducCreID, Entero_Cero))= Entero_Cero then
    select  '001' as NumErr,
            'El Producto de Credito esta Vacio.' as ErrMen,
				'producCreditoID' as control,
				Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;


set Var_SolDocRID:= (select ifnull(Max(SolDocReqID),Entero_Cero) + 1
                        from SOLICIDOCREQ);



insert into SOLICIDOCREQ	(
		SolDocReqID,	ProducCreditoID,	ClasificaTipDocID,	EmpresaID,		Usuario,
		FechaActual,	DireccionIP,		ProgramaID, 		Sucursal,		NumTransaccion)
		values (
		Var_SolDocRID,	Par_ProducCreID,	Par_ClasTDocID,     Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,   Aud_NumTransaccion);





if(Par_Salida =SalidaSI) then
    select '000' as NumErr,
            concat("Los Documentos Requeridos para el Producto: ",
			convert(Par_ProducCreID, char)," Fueron Agregados.")  as ErrMen,
            'producCreditoID' as control,
            Par_ProducCreID as consecutivo;
end if;

if(Par_Salida =SalidaNO) then
        set 	Par_NumErr := 0;
        set	Par_ErrMen :=  concat("Los Documentos Requeridos para el Producto : ",
							convert(ProducCreditoID, char)," Fueron Agregados.");
        LEAVE TerminaStore;
end if;

END TerminaStore$$