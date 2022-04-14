-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASFIRMAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASFIRMAALT`;DELIMITER $$

CREATE PROCEDURE `CUENTASFIRMAALT`(
	Par_CuentaAhoID			bigint(12),
	Par_PersonaID			int(12),
	Par_NombreCompleto		varchar(200),
	Par_Tipo				char(1),
	Par_InstrucEspecial		varchar(150),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
			)
TerminaStore: BEGIN
	DECLARE	Cadena_Vacia	char(1);
	DECLARE	Entero_Cero		int;
	DECLARE	NumeroFirma		int;

	Set	Cadena_Vacia	:= '';
	Set	Entero_Cero		:= 0;
	Set	NumeroFirma		:= 0;
	set NumeroFirma := (select ifnull(Max(CuentaFirmaID ),Entero_Cero) + 1
					from CUENTASFIRMA);

	if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
		select '001' as NumErr,
			 'El numero de Cuenta esta vacio.' as ErrMen,
			 'cuentaAhoID' as control;
		LEAVE TerminaStore;
	end if;

	if(not exists(select CuentaAhoID
			from CUENTASAHO
			where CuentaAhoID = Par_CuentaAhoID)) then
			select '002' as NumErr,
			'La Cuenta no existe.' as ErrMen,
			'cuentaAhoID' as control;
	LEAVE TerminaStore;
	end if;

	if(ifnull(Par_PersonaID, Entero_Cero))= Entero_Cero then
		select '003' as NumErr,
			 'El numero de Persona esta vacio.' as ErrMen,
			 'personaID' as control;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_NombreCompleto, Cadena_Vacia)) = Cadena_Vacia then
		select '004' as NumErr,
			  'El Nombre Completo esta Vacio.' as ErrMen,
			  'nombreCompleto' as control;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_Tipo, Cadena_Vacia)) = Cadena_Vacia then
		select '005' as NumErr,
			  'El tipo de Firma esta vacio.' as ErrMen,
			  'tipo' as control;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_InstrucEspecial, Cadena_Vacia)) = Cadena_Vacia then
		select '006' as NumErr,
			  'La Instruccion Especial esta vacia.' as ErrMen,
			  'instrucEspecial' as control;
		LEAVE TerminaStore;
	end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();
	INSERT INTO CUENTASFIRMA
				 VALUES(	NumeroFirma,		Par_CuentaAhoID,		Par_PersonaID,
						Par_NombreCompleto,	Par_Tipo,			Par_InstrucEspecial,
						Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion
					);

select '000' as NumErr,
	  concat("Firma Autorizada Agregada: ", convert(NumeroFirma, CHAR))  as ErrMen,
	  'cuentaAhoID' as control;

END TerminaStore$$