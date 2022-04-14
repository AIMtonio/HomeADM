-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ModificaCliente
DELIMITER ;
DROP PROCEDURE IF EXISTS `ModificaCliente`;DELIMITER $$

CREATE PROCEDURE `ModificaCliente`(
ClienteID	int,
PrimerNombre	varchar(50),
SegundoNombre	varchar(50),
ApellidoPaterno	varchar(50),
ApellidoMaterno	varchar(50)
	)
TerminaStore: BEGIN


Set	@NumeroEmpresa	:= 1;
Set	@Cadena_Vacia	:= '';
Set	@Fecha_Vacia	:= '1900-01-01';
Set	@Entero_Cero	:= 0;


if(not exists(select ClienteID
			from clientes where ClienteID = ClienteID)) then
	select '001' as NumErr,
		 'El Numero de Cliente no existe.' as ErrMen,
		 'numero' as control;
	LEAVE TerminaStore;
end if;


if(ifnull(PrimerNombre, @Cadena_Vacia)) = @Cadena_Vacia then
	select '002' as NumErr,
		 'El Primer Nombre esta Vacio.' as ErrMen,
		 'primerNombre' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(ApellidoMaterno, @Cadena_Vacia)) = @Cadena_Vacia then
	select '003' as NumErr,
		  'El Apellido Materno esta Vacio.' as ErrMen,
		  'apellidoMaterno' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(ApellidoPaterno, @Cadena_Vacia)) = @Cadena_Vacia then
	select '004' as NumErr,
		  'El Apellido Paterno esta Vacio.' as ErrMen,
		  'apellidoPaterno' as control;
	LEAVE TerminaStore;
end if;


update clientes set
	NombreCli		= PrimerNombre,
	ApellidopCli	= ApellidoPaterno,
	ApellidomCli	= ApellidoMaterno
where ClienteID	= ClienteID;

select '000' as NumErr ,
	  'Cliente Modificado' as ErrMen,
	  'numero' as control;

END TerminaStore$$