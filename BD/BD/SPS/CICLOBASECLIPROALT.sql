-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CICLOBASECLIPROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CICLOBASECLIPROALT`;DELIMITER $$

CREATE PROCEDURE `CICLOBASECLIPROALT`(
    Par_Cliente				int,
    Par_Prospecto   		int,
    Par_Producto          	int,
    Par_CicloBase       	int,

    Par_EmpresaID       	int,

    Par_Salida    			char(1),
    inout	Par_NumErr 		int,
    inout	Par_ErrMen  	varchar(350),

    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
	)
TerminaStore: BEGIN

DECLARE Var_Estatus			char(1);
DECLARE	Estatus_Activo		char(1);
DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE Salida_SI			char(1);
DECLARE	Inactivo			char(1);


Set	Estatus_Activo			:= 'A';
Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
set Salida_SI				:= 'S';
Set Aud_FechaActual 		:= CURRENT_TIMESTAMP();
Set Inactivo				:='I';

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-CLIENTESALT");
    END;
END;

	if 	(ifnull(Par_Cliente, Entero_Cero)) = Entero_Cero && (ifnull(Par_Prospecto, Entero_Cero)) = Entero_Cero
	then
		select '002' as NumErr,
			 'El alta de Ciclo Base Inicial necesita al menos el Cliente o el Prospecto.' as ErrMen,
			 'ClienteProspecto' as control,
			'0' as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Cliente>Entero_Cero)then
		select Estatus into Var_Estatus
			from CLIENTES
				where ClienteID=Par_Cliente;
		if(Var_Estatus=Inactivo)then
			select '003' as NumErr,
			 'El Cliente Indicado se encuentra Inactivo.' as ErrMen,
			 'clienteID' as control,
			  '0' as consecutivo;
		LEAVE TerminaStore;
		end if;
	end if;

	if(ifnull(Par_Producto, Entero_Cero)) = Entero_Cero then
		select '003' as NumErr,
			 'El Producto de Credito esta vacio.' as ErrMen,
			 'productocCreditoID' as control,
			  '0' as consecutivo;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_CicloBase, Entero_Cero)) = Entero_Cero then
		select '004' as NumErr,
			  'El Ciclo Base Inicial esta Vacio.' as ErrMen,
			  'CicloBaseInicial' as control,
			   '0' as consecutivo;
		LEAVE TerminaStore;
	end if;


	IF( EXISTS(
		SELECT ClienteID  FROM CICLOBASECLIPRO
		WHERE ClienteID =  Par_Cliente AND ProspectoID = Par_Prospecto and ProductoCreditoID = Par_Producto))
		then
		select '005' as NumErr,
			  concat('El Ciclo Inicial del Cliente ya esta relacionado al producto de Credito:', Par_Producto) as ErrMen,
			  'CicloBaseInicial' as control,
			   '0' as consecutivo;
		LEAVE TerminaStore;
	end IF;

	set	Par_NumErr := 0;
	set	Par_ErrMen := concat("Ciclo Base Inicial agregado");

if (Par_Salida = Salida_SI) then
	select 	Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'numero' as control,
			'0' as consecutivo;
end if;
	insert into CICLOBASECLIPRO (
		ClienteID,		ProspectoID,	ProductoCreditoID,	CicloBase,		EmpresaID,
		Usuario,		FechaActual,	DireccionIP,		ProgramaID,	Sucursal,
		NumTransaccion)
	values (
		Par_Cliente,	Par_Prospecto,	Par_Producto, 		Par_CicloBase,	Par_EmpresaID,
		Aud_Usuario,	Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,Aud_Sucursal,
		Aud_NumTransaccion	);


END TerminaStore$$