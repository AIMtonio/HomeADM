-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGD244300006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGD244300006REP`;DELIMITER $$

CREATE PROCEDURE `REGD244300006REP`(
# ------------------------------------------------------------------------------------------- #
# - SP QUE GENERA EL REPORTE EN EXCEL Y CSV PARA EL REGULATORIO D 2443 ---------------------- #
# ------------------------------------------------------------------------------------------- #
	Par_Anio				INT, 			-- Ano del reporte
    Par_Trimestre			INT,			-- Trimestre a reportar
    Par_TipoReporte			INT,			-- Tipo de Reporte Excel(1) o CSV(2)

    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
	-- Variables
    DECLARE Var_FechaInicio     DATE;		-- Fecha de incio del trimestre
    DECLARE Var_FechaFin        DATE;		-- Fecha de Fin del trimestre
    DECLARE Var_MesInicio       INT;		-- Mes de Inicio
    DECLARE Var_MesFin          INT;		-- Mes Fin
    DECLARE Var_Periodo			VARCHAR(6); -- Perido a reportar

    -- Constantes
    DECLARE Entero_Cero 	INT;
    DECLARE Rep_Excel		INT;
    DECLARE Rep_CSV			INT;
    DECLARE TresMeses       INT;
    DECLARE DosMeses        INT;
    DECLARE DiezMeses       INT;
    DECLARE DiaPrimero      VARCHAR(5);
    DECLARE TipoNoAplica	VARCHAR(2);
    DECLARE ClaveEnAlta		INT;
    DECLARE ClaveEnOperacion INT;
    DECLARE ClaveEnBaja		INT;
    DECLARE Est_Activo		CHAR(1);
    DECLARE Est_Inactivo	CHAR(1);
    DECLARE Clave_Entidad   VARCHAR(6);
    DECLARE NumReporte		VARCHAR(5);
    DECLARE Cadena_Vacia	VARCHAR(2);
    DECLARE PuntoSucursal   INT;
    DECLARE PuntoCajero     INT;
    DECLARE PuntoTPV		INT;
    DECLARE TipoAtencion	CHAR(1);
    DECLARE Car_Coma		CHAR(1);
    DECLARE Car_Punto		CHAR(1);
    DECLARE Car_Guion		CHAR(1);
    DECLARE Espacio_Vacio	VARCHAR(2);
    DECLARE AAcento         CHAR(1);
    DECLARE EAcento         CHAR(1);
    DECLARE IAcento         CHAR(1);
    DECLARE OAcento         CHAR(1);
    DECLARE UAcento         CHAR(1);
    DECLARE VocalA          CHAR(1);
    DECLARE VocalE          CHAR(1);
    DECLARE VocalI          CHAR(1);
    DECLARE VocalO          CHAR(1);
    DECLARE VocalU          CHAR(1);
    DECLARE Car_Diagonal    CHAR(1);


    -- Inicializacion de constantes
    SET Entero_Cero			:= 0;
    SET Rep_Excel			:= 1;			-- Tipo de Reporte en formato Excel
    SET Rep_CSV				:= 2;			-- Tipo de Reporte en formato Csv
    SET TresMeses           := 3;
    SET DosMeses            := 2;
    SET DiezMeses           := 10;
    SET DiaPrimero          := '-01';
    SET TipoNoAplica		:= 'NA';
    SET ClaveEnAlta			:= 431;			-- Clave : Reportar Alta de Sucursal, ATM
    SET ClaveEnOperacion	:= 433;			-- Clave : Continua en Operacion - Sucursal, ATM
    SET ClaveEnBaja			:= 432;			-- Clave : Reportar Baja de Sucursan , ATM
    SET Est_Activo			:= 'A';			-- Estatus Activo
    SET Est_Inactivo		:= 'I';			-- Estatus Inactivo
    SET NumReporte			:= '2443';		-- Identificador del Reporte
    SET Cadena_Vacia		:= '';
    SET PuntoSucursal		:= 241;			-- Tipo Dato : Sucursal
    SET PuntoCajero			:= 244;			-- Tipo Dato : Cajero
    SET PuntoTPV			:= 247;			-- Tipo Dato : Terminal de Punto de venta
    SET TipoAtencion		:= 'A';			-- Sucursal de Atencion al publico
    SET Espacio_Vacio		:= ' ';
    SET Car_Coma			:= ',';
    SET Car_Punto			:= '.';
    SET Car_Guion			:= '-';
    SET AAcento             :='A';
    SET EAcento             :='E';
    SET IAcento             :='I';
    SET OAcento             :='O';
    SET UAcento             :='U';
    SET VocalA              :='A';
    SET VocalE              :='E';
    SET VocalI              :='I';
    SET VocalO              :='O';
    SET VocalU              :='U';
    SET Car_Diagonal        :='/';

    SELECT ClaveEntidad INTO Clave_Entidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;


    /* -- Se calculan las fechas de los 3 meses del Trimestre -- */
    SET Var_MesFin              := Par_Trimestre * TresMeses;
    SET Var_MesInicio           := Var_MesFin - DosMeses;

    SET Var_FechaInicio         := CONCAT(Par_Anio,'-',CASE Var_MesInicio WHEN Var_MesInicio < DiezMeses
										THEN CONCAT(Entero_Cero,Var_MesInicio) ELSE Var_MesInicio END,DiaPrimero);
    SET Var_FechaFin            := CONCAT(Par_Anio,'-',CASE Var_MesFin    WHEN Var_MesFin    < DiezMeses
										THEN CONCAT(Entero_Cero,Var_MesFin)    ELSE Var_MesFin    END,DiaPrimero);

    SET Var_Periodo             := CONCAT(Par_Anio,Entero_Cero,Par_Trimestre);
    -- Obtenemos el ultimo dia del mes para la fecha Final
    SET Var_FechaFin            := LAST_DAY(Var_FechaFin);


    DROP TABLE IF EXISTS DATREGULATORIOD2443;
    CREATE TEMPORARY TABLE  DATREGULATORIOD2443(
		Periodo					VARCHAR(6),
		ClaveEntidad			VARCHAR(6),
		Subreporte				VARCHAR(5),
		ClavePuntoTran			INT,
		DenomPuntoTran			VARCHAR(100),
		ClaveTipoPunto			INT,
		ClaveSituacion			INT,
		FechaSituacion			VARCHAR(8),
		Calle					VARCHAR(200),
		NumeroExterior			VARCHAR(50),
		NumeroInterior			VARCHAR(50),
		Colonia					VARCHAR(10),
		Localidad				VARCHAR(30),
		Municipio				INT,
		Estado					INT,
		CodigoPostal			VARCHAR(5),
		Latitud					VARCHAR(50),
		Longitud				VARCHAR(50)
    );


	INSERT INTO DATREGULATORIOD2443
	SELECT Var_Periodo,			Clave_Entidad,			NumReporte,
			suc.SucursalID,		suc.NombreSucurs,		PuntoSucursal,
			CASE WHEN FechaAlta < Var_FechaInicio THEN ClaveEnOperacion ELSE ClaveEnAlta END AS ClaveSituacion,
			CASE WHEN FechaAlta < Var_FechaInicio THEN DATE_FORMAT((Var_FechaInicio - INTERVAL 1 DAY),'%Y%m%d')
			ELSE DATE_FORMAT(FechaAlta,'%Y%m%d') END AS FechaSituacion,
			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(suc.Calle,Car_Coma,Espacio_Vacio),
				Car_Punto,Espacio_Vacio),Car_Guion,Espacio_Vacio),AAcento,VocalA),EAcento,VocalE),
                IAcento,VocalI),OAcento,VocalO),UAcento,VocalU),Car_Diagonal,Espacio_Vacio),
			suc.Numero,				TipoNoAplica,
			col.ColoniaCNBV,	col.ClaveINEGI,			suc.MunicipioID,
			suc.EstadoID,		suc.CP,					suc.Latitud,
			suc.Longitud
	 FROM SUCURSALES suc, COLONIASREPUB col
	 WHERE suc.EstadoID = col.EstadoID
	 AND suc.MunicipioID = col.MunicipioID
	 AND suc.ColoniaID = col.ColoniaID
	 AND suc.TipoSucursal = TipoAtencion
	 AND suc.FechaAlta <= Var_FechaFin
	 AND suc.Estatus = Est_Activo;



	 INSERT INTO DATREGULATORIOD2443
	 SELECT Var_Periodo,			Clave_Entidad,			NumReporte,
			cat.SucursalID,		suc.NombreSucurs,		tip.ClaveCNBV,
			 CASE WHEN cat.FechaAlta < Var_FechaInicio AND cat.Estatus = Est_Activo         THEN ClaveEnOperacion
			 WHEN cat.Estatus = Est_Activo             AND cat.FechaAlta >= Var_FechaInicio THEN ClaveEnAlta
			 WHEN cat.Estatus = Est_Inactivo           AND cat.FechaBaja <= Var_FechaFin    THEN ClaveEnBaja ELSE ClaveEnOperacion END AS ClaveSituacion,
			 CASE WHEN cat.FechaAlta < Var_FechaInicio AND cat.Estatus = Est_Activo         THEN  DATE_FORMAT((Var_FechaInicio - INTERVAL 1 DAY),'%Y%m%d')
			 WHEN cat.Estatus = Est_Activo             AND cat.FechaAlta >= Var_FechaInicio THEN  DATE_FORMAT(cat.FechaAlta,'%Y%m%d')
			 WHEN cat.Estatus = Est_Inactivo           AND cat.FechaBaja <= Var_FechaFin    THEN  DATE_FORMAT(cat.FechaBaja,'%Y%m%d')
			 ELSE  DATE_FORMAT((Var_FechaInicio - INTERVAL 1 DAY),'%Y%m%d') END AS FechaSituacion,
             REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cat.Calle,Car_Coma,Espacio_Vacio),
				Car_Punto,Espacio_Vacio),Car_Guion,Espacio_Vacio),AAcento,VocalA),EAcento,VocalE),
                IAcento,VocalI),OAcento,VocalO),UAcento,VocalU),Car_Diagonal,Espacio_Vacio),
             cat.Numero, CASE WHEN TRIM(IFNULL(cat.NumInterior,Cadena_Vacia)) = Cadena_Vacia THEN TipoNoAplica ELSE cat.NumInterior END ,
			 col.ColoniaCNBV,	col.ClaveINEGI,		 	cat.MunicipioID, 	 cat.EstadoID, 		cat.CP,
             cat.Latitud,       cat.Longitud
	  FROM CATCAJEROSATM cat, COLONIASREPUB col, SUCURSALES suc, CATTIPOCAJERO tip
	 WHERE cat.EstadoID = col.EstadoID
	 AND cat.MunicipioID = col.MunicipioID
	 AND cat.ColoniaID = col.ColoniaID
	 AND cat.SucursalID = suc.SucursalID
	 AND cat.TipoCajeroID = tip.TipoCajeroID
	 AND cat.FechaAlta <= Var_FechaFin
	 AND (cat.Estatus = Est_Activo OR (cat.Estatus = Est_Inactivo AND cat.FechaBaja >= Var_FechaInicio));



    IF(Par_TipoReporte = Rep_Excel) THEN
		SELECT
			Periodo,		ClaveEntidad,		Subreporte,		ClavePuntoTran,		DenomPuntoTran,
			ClaveTipoPunto,	ClaveSituacion,		FechaSituacion,	Calle,				NumeroExterior,
			NumeroInterior,	Colonia,			Localidad,		Municipio,			Estado,
			CodigoPostal,	Latitud,			Longitud
        FROM DATREGULATORIOD2443 ORDER BY ClavePuntoTran;
    END IF;

    IF(Par_TipoReporte = Rep_CSV) THEN
		SELECT CONCAT(
			Subreporte, ';',
			IFNULL(ClavePuntoTran,Cadena_Vacia),	';',
            IFNULL(DenomPuntoTran,Cadena_Vacia),	';',
			IFNULL(ClaveTipoPunto,Cadena_Vacia),	';',
            IFNULL(ClaveSituacion,Cadena_Vacia),	';',
            IFNULL(FechaSituacion,Cadena_Vacia),	';',
            IFNULL(Calle,Cadena_Vacia),				';',
            IFNULL(NumeroExterior,Cadena_Vacia),	';',
			IFNULL(NumeroInterior,Cadena_Vacia),	';',
            IFNULL(Colonia,Cadena_Vacia),			';',
            IFNULL(Localidad,Cadena_Vacia),			';',
            IFNULL(Municipio,Cadena_Vacia),			';',
            IFNULL(Estado,Cadena_Vacia),			';',
			IFNULL(CodigoPostal,Cadena_Vacia),		';',
            IFNULL(Latitud,Cadena_Vacia),			';',
            IFNULL(Longitud,Cadena_Vacia)
            ) AS Valor
        FROM DATREGULATORIOD2443 ORDER BY ClavePuntoTran;
    END IF;


END TerminaStore$$