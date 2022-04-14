-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRECONSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCRECONSALT`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCRECONSALT`(
    Par_SolicitudID         varchar(10),
	Par_Consecutivo	    		int(11),
	Par_FecConsulta				date,
	Par_ClaveOtorgante		varchar(45),
	Par_NomOtorgante		varchar(45),
	Par_TelOtorgante		varchar(10),
	Par_TipoCredito			varchar(45),
	Par_ClaveUniMon			varchar(45),
	Par_ImporteCredito		decimal(14,2),
	Par_TipRespons			varchar(45),

    Par_Salida				char(1),
    inout	Par_NumErr		int,
    inout	Par_ErrMen		varchar(350)


	)
TerminaStore: BEGIN

DECLARE varControl		varchar(50);
DECLARE varConsecutivo	int(11);


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Fecha_Alta		date;
DECLARE	Salida_SI       char(1);
DECLARE	Var_NO			char(1);


Set Cadena_Vacia		:= '';
Set Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero			:= 0;


set Salida_SI			:='S';
set Var_NO				:='N';
set varConsecutivo		:= 0;



set varConsecutivo := (select ifnull(Max(Consecutivo),Entero_Cero) + 1 from CIRCULOCRECONS where fk_SolicitudID = Par_SolicitudID);


insert into CIRCULOCRECONS(
	fk_SolicitudID,		Consecutivo,	 	FecConsulta,		ClaveOtorgante, 	NomOtorgante,
	TelOtorgante, 		TipoCredito,		ClaveUniMon,		ImporteCredito,		TipRespons
)
values  (
	Par_SolicitudID,	varConsecutivo,		Par_FecConsulta, 	Par_ClaveOtorgante,	Par_NomOtorgante,
	Par_TelOtorgante,	Par_TipoCredito,	Par_ClaveUniMon,	Par_ImporteCredito,	Par_TipRespons
);

set Par_NumErr  := 000;
set Par_ErrMen  := concat('La Cadena de consulta se ha insertado correctamente: ',Par_SolicitudID);
set varControl	:= 'fk_SolicitudID';

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
end IF;

END TerminaStore$$