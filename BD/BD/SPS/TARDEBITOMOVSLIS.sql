-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBITOMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBITOMOVSLIS`;


	Par_MovimientoID    int(11),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)



DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         date;
DECLARE Entero_Cero			int;
DECLARE Lis_Combo           int;

Set Cadena_Vacia		:= '';
Set Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero			:= 0;
Set Lis_Combo   		:= 1;
if(Par_NumLis = Lis_Combo) then
	SELECT MovimientoID,concat(convert(NumeroTransaccion, char),' - ',DescripcionMov, ' - ',convert(format(MontoTransaccion,2),char)) as NumeroTransaccion ,
			DescripcionMov,MontoTransaccion
		FROM TARJETADEBITOMOVS
			WHERE MovimientoID like concat("%", Par_MovimientoID, "%")
			limit 0, 15;
end if;

END TerminaStore$$