-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOMOVCONCILIALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOMOVCONCILIALIS`;
DELIMITER $$


CREATE PROCEDURE `TESOMOVCONCILIALIS`(
Par_InstitucionID	 int,
	Par_NumCtaInstit	 varchar(40),
	Par_InstitNominaID	 int(11),
	Par_NumLis			 tinyint unsigned,

	Aud_EmpresaID		 int,
	Aud_Usuario			 int,
	Aud_FechaActual		 DateTime,
	Aud_DireccionIP		 varchar(15),
	Aud_ProgramaID		 varchar(50),
	Aud_Sucursal		 int,
	Aud_NumTransaccion	 bigint
	)

TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Est_NoConci			char(1);
DECLARE	Lis_NoConci	 		int;
DECLARE Lis_ComboIN	        int;
DECLARE Lis_MovTeso         INT(11);        -- Lsita para movimientos de tesoreria
DECLARE TipoMovPagInst      varchar(10);    -- Variable para tipo de movimiento

DECLARE NatAbono			char(1);
DECLARE TipoMovPagCreNom	varchar(10);
DECLARE EstatusCon			char(1);



Set Cadena_Vacia	 := '';
Set Fecha_Vacia		 := '1900-01-01';
Set Entero_Cero		 := 0;
Set Est_NoConci		 := 'N';
Set Lis_NoConci		 := 1;
Set Lis_ComboIN := 2;
SET Lis_MovTeso     := 5;

Set NatAbono		 :='A';
Set EstatusCon		 :='C';


set TipoMovPagCreNom := (Select TipoMovTesCon from PARAMETROSNOMINA);


if(Par_NumLis = Lis_NoConci) then
	select 	FolioCargaID, 	NumeroMov,			InstitucionID,	NumCtaInstit,		FechaOperacion,
			NatMovimiento, 	format(MontoMov,2), 	TipoMov, 		DescripcionMov, 	ReferenciaMov,
			Status
		from TESOMOVSCONCILIA
		where InstitucionID = Par_InstitucionID
		and NumCtaInstit = Par_NumCtaInstit
		and Status = Est_NoConci;
end if;

if(Par_NumLis = Lis_ComboIN) then

	select FolioCargaID, format(MontoMov,2) as Descripcion
		from TESOMOVSCONCILIA
		where InstitucionID = Par_InstitucionID
		and NumCtaInstit = Par_NumCtaInstit
		and NatMovimiento = NatAbono
		and TipoMov = TipoMovPagCreNom
		and EstatusConciliaIN = Est_NoConci
        and ReferenciaMov = Par_InstitNominaID ;
end if;

IF(Par_NumLis = Lis_MovTeso) THEN
    SET TipoMovPagInst :=  (SELECT TipoMovID FROM INSTITNOMINA WHERE InstitNominaID = Par_InstitNominaID);
    SET TipoMovPagCreNom := IFNULL(TipoMovPagInst, TipoMovPagCreNom);

    SELECT NumeroMov AS FolioCargaID, DescripcionMov AS Descripcion
        FROM TESOMOVSCONCILIA
        WHERE InstitucionID = Par_InstitucionID
        AND NumCtaInstit = Par_NumCtaInstit
        AND NatMovimiento = NatAbono
        AND TipoMov = TipoMovPagCreNom
       	AND EstAplicaInst = Est_NoConci;
END IF;

END TerminaStore$$