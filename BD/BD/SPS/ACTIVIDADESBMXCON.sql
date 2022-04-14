-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVIDADESBMXCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVIDADESBMXCON`;DELIMITER $$

CREATE PROCEDURE `ACTIVIDADESBMXCON`(
	Par_ActiviBMXID		varchar(15),
	Par_NumCon			tinyint unsigned,
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

	DECLARE	Cadena_Vacia	char(1);
	DECLARE	Fecha_Vacia	date;
	DECLARE	Entero_Cero	int;
	DECLARE	Con_Principal	int;
	DECLARE	Con_Foranea	int;
	DECLARE	Con_ActComple	int;
	DECLARE	Con_Combo	int;

	Set	Cadena_Vacia		:= '';
	Set	Fecha_Vacia		:= '1900-01-01';
	Set	Entero_Cero		:= 0;
	Set	Con_Principal		:= 1;
	Set	Con_Foranea		:= 2;
	Set	Con_ActComple		:= 3;
	Set	Con_Combo		:= 4;


	if(Par_NumCon = Con_Principal) then
		select	`ActividadBMXID`,	`EmpresaID`, 		`Descripcion`,	`ActividadINEGIID`,	`NumeroBuroCred`,
				`NumeroCNBV`,		`ActividadGuber`,	`ClaveRiesgo`,	`Estatus`
		from ACTIVIDADESBMX
		where  ActividadBMXID = Par_ActiviBMXID;
	end if;

	if(Par_NumCon = Con_Foranea) then
		select	`ActividadBMXID`,		`Descripcion`
		from ACTIVIDADESBMX
		where  ActividadBMXID = Par_ActiviBMXID;
	end if;

	if(Par_NumCon = Con_ActComple) then
		select	BMX.ActividadBMXID,	BMX.Descripcion,	INE.ActividadINEGIID,	INE.Descripcion,	SEC.SectorEcoID,
				SEC.Descripcion,		BMX.ClaveRiesgo,	FR.ActividadFRID,		FR.Descripcion,
              FOM.ActividadFOMURID, FOM.Descripcion
		from ACTIVIDADESBMX	BMX
		LEFT OUTER JOIN ACTIVIDADESFR as FR  ON BMX.ActividadFR = FR.ActividadFRID
		LEFT OUTER JOIN ACTIVIDADESINEGI as INE  ON  BMX.ActividadINEGIID	= INE.ActividadINEGIID
        LEFT OUTER JOIN SECTORESECONOM as SEC  ON INE.SectorEcoID		= SEC.SectorEcoID
        LEFT OUTER JOIN ACTIVIDADESFOMUR as FOM ON BMX.ActividadFOMUR = FOM.ActividadFOMURID
		WHERE BMX.ActividadBMXID = Par_ActiviBMXID;
	end if;


	if(Par_NumCon = Con_Combo) then
		select	FR.Descripcion
		from ACTIVIDADESBMX	BMX
		LEFT OUTER JOIN ACTIVIDADESFR as FR  ON BMX.ActividadFR = FR.ActividadFRID
		WHERE BMX.ActividadBMXID 	= Par_ActiviBMXID;
	end if;


END TerminaStore$$