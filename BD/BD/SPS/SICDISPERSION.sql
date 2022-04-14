-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SICDISPERSION
DELIMITER ;
DROP PROCEDURE IF EXISTS `SICDISPERSION`;DELIMITER $$

CREATE PROCEDURE `SICDISPERSION`(
	Par_FechaOperacion	    DateTime,
	Par_Institucion		    int(11),
	Par_CuentaAho		    bigint(12)
	)
TerminaStore: BEGIN

DECLARE Cadena_Vacia        char(1);
DECLARE Entero_Cero         int;
DECLARE Var_FolioOperacion  int;
DECLARE Aud_NumTransaccion  bigint;
DECLARE Aud_FechaActual     DateTime;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;


if(ifnull(Par_CuentaAho, Entero_Cero))= Entero_Cero then
select '001' as NumErr,
    'El numero de Cuenta esta vacio.' as ErrMen;
    LEAVE TerminaStore;
end if;

if(ifnull(Par_Institucion, Entero_Cero))= Entero_Cero then
select '002' as NumErr,
    'El numero de institucion esta vacio.' as ErrMen;
    LEAVE TerminaStore;
end if;


call FOLIOSAPLICAACT('DISPERSION', Var_FolioOperacion);

Set Aud_FechaActual := CURRENT_TIMESTAMP();

call TRANSACCIONESPRO(Aud_NumTransaccion);

    INSERT INTO DISPERSION(FolioOperacion,  FechaOperacion,         InstitucionID,     CuentaAhoID,
                        FechaActual,        NumTransaccion)

           VALUES   (Var_FolioOperacion,    Par_FechaOperacion,     Par_Institucion,    Par_CuentaAho,
                        Aud_FechaActual,    Aud_NumTransaccion);


select '000' as NumErr,
    concat("Dispersion Autorizada Agregada: ", convert(Var_FolioOperacion, CHAR))  as ErrMen,
    Var_FolioOperacion as FolioDispersion;



END TerminaStore$$