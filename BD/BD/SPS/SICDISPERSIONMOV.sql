-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SICDISPERSIONMOV
DELIMITER ;
DROP PROCEDURE IF EXISTS `SICDISPERSIONMOV`;
DELIMITER $$

CREATE PROCEDURE `SICDISPERSIONMOV`(
    Par_FolioOperacion      int,
    Par_CuentaAhoID         bigint(12),
    Par_Descripcion         varchar(50),
    Par_Referencia          varchar(50),
    Par_Monto               decimal(12,2),
    Par_CuentaClabe         varchar(18),
    Par_NombreBenefi        varchar(250),
    Par_RFC                 varchar(16),
    Par_Sucursal            int,
    Par_TipoDispersion      int
		)
TerminaStore: BEGIN

DECLARE Var_Estatus varchar(1);
DECLARE consecutivo int;
DECLARE Entero_Cero int;
DECLARE Var_Vacio   char(1);


DECLARE Aud_FechaActual     DateTime;
DECLARE Aud_NumTransaccion  bigint;
DECLARE Var_Status          char(1);

set Var_Estatus	:= '';
set Entero_Cero	:= 0;
set Var_Vacio		:= '';


Set Var_Status  := 'P';


if(ifnull(Par_CuentaAhoID,Var_Vacio)) = Var_Vacio then
    select '001' as NumErr,
        'La cuenta esta vacia' as ErrMen;
LEAVE TerminaStore;
end if;

if(ifnull(Par_FolioOperacion,Var_Vacio)) = Var_Vacio then
    select '002' as NumErr,
        'El numero de Dispersion esta vacio' as ErrMen;
LEAVE TerminaStore;
end if;

if(ifnull(Par_Referencia,Var_Vacio)) = Var_Vacio then
    select '003' as NumErr,
        'La referencia esta vacia' as ErrMen;
LEAVE TerminaStore;
end if;

if(ifnull(Par_Monto,Var_Vacio)) = Var_Vacio then
    select '004' as NumErr,
        'El monto a ministrar esta vacio' as ErrMen;
LEAVE TerminaStore;
end if;

if(ifnull(Par_CuentaClabe,Var_Vacio)) = Var_Vacio then
    select '005' as NumErr,
        'La cuenta clabe esta vacia' as ErrMen;
LEAVE TerminaStore;
end if;

if(ifnull(Par_NombreBenefi,Var_Vacio)) = Var_Vacio then
    select '006' as NumErr,
        'El nombre del beneficiario esta vacio' as ErrMen;
LEAVE TerminaStore;
end if;

if(ifnull(Par_Sucursal,Var_Vacio)) = Var_Vacio then
    select '007' as NumErr,
        'La sucursal esta vacio' as ErrMen;
LEAVE TerminaStore;
end if;


call FOLIOSAPLICAACT('DISPERSIONMOV', consecutivo);

call TRANSACCIONESPRO(Aud_NumTransaccion);

Set Aud_FechaActual := CURRENT_TIMESTAMP();

    INSERT INTO DISPERSIONMOV(ClaveDispMov,     DispersionID,    CuentaCargo,		Descripcion,		    Referencia,
                            TipoMovDIspID,      Monto,           CuentaDestino,	Identificacion,	    Estatus,
                            NombreBenefi,       FechaEnvio,      FechaActual,		NumTransaccion)

                VALUES(consecutivo,         Par_FolioOperacion,     Par_CuentaAhoID,	    Par_Descripcion,	    Par_Referencia,
                        Par_TipoDispersion, Par_Monto,              Par_CuentaClabe,	    Par_RFC,				    Var_Status,
                        Par_NombreBenefi,   Aud_FechaActual,        Aud_FechaActual,	    Aud_NumTransaccion);


select '000' as NumErr,
    concat("Se genero el regstro con num", convert(consecutivo, CHAR))  as ErrMen,
    consecutivo as consecutivo;


END TerminaStore$$