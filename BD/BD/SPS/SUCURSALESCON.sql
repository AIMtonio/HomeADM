-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUCURSALESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUCURSALESCON`;
DELIMITER $$


CREATE PROCEDURE `SUCURSALESCON`(
/* =========== SP DE CONSULTA DE SUCURSALES =========== */
	Par_SucursalID		INT(11),			-- Numero de la Sucursal
	Par_NumCon			TINYINT UNSIGNED,	-- Tipo de Consulta
	Par_EmpresaID		INT(11),			-- Empresa ID
	Par_ClabeInst   	VARCHAR(18),		-- Cuenta CLABE
	Par_InstitucionID 	INT(11),			-- ID de la Isntitucion para cuenta CLABE

	/* Parametros de Auditoria */
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Con_Principal	INT(11);
DECLARE	Con_Foranea		INT(11);
DECLARE Con_NombreSuc	INT(11);
DECLARE Con_RepTicket	INT(11);
DECLARE Con_Corporativo	INT(11);
DECLARE	Con_Atencion	INT(11)	 ;
DECLARE IDSucursal 		INT(11);
DECLARE	TipodeAtencion	CHAR(1);
DECLARE	TipoCorporativo	CHAR(1);
DECLARE	EstatusApert	CHAR(1);
DECLARE	Con_Aportacion	INT(11);

-- Asignacion de Constantes
SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Con_Principal		:= 1;
SET	Con_Foranea			:= 2;
SET Con_NombreSuc 		:= 3;
SET Con_RepTicket 		:= 4;
SET Con_Corporativo		:= 5;
SET Con_Atencion		:= 6;
SET Con_Aportacion		:= 8;			-- Tipo de sucursal de aportaciones
SET	TipodeAtencion		:= 'A';			-- Tipo de Sucursal de Atencion
SET	TipoCorporativo		:= 'C';			-- Tipo de Sucursal Corporativo
SET	EstatusApert		:= 'A';			-- Estatus de la Sucursal Aperturada

IF(Par_NumCon = Con_Principal) THEN
	SELECT	SucursalID,		NombreSucurs,	TipoSucursal,	PlazaID,		CentroCostoID,
			IVA,			TasaISR,		NombreGerente,	SubGerente,		EstadoID,
			MunicipioID,	Calle,			Numero,			Colonia,		CP,
			Telefono,		DifHorarMatriz,	DirecCompleta,	FechaSucursal,	PoderNotarialGte,
            PoderNotarial,	TituloGte,		TituloSubGte,	ExtTelefonoPart,PromotorCaptaID,
            LocalidadID,    ColoniaID,		ClaveSucCNBV,	ClaveSucOpeCred, Latitud,            
            Longitud,       DATE_FORMAT(HoraInicioOper, '%H:%i') AS HoraInicioOper , DATE_FORMAT(HoraFinOper, '%H:%i') AS HoraFinOper
		FROM SUCURSALES
			WHERE SucursalID = Par_SucursalID;
END IF;

IF(Par_NumCon = Con_Foranea) THEN
	SELECT	SucursalID,		NombreSucurs
		FROM SUCURSALES
			WHERE SucursalID = Par_SucursalID
				AND Estatus = EstatusApert;
END IF;

IF(Par_NumCon = Con_NombreSuc) THEN
	SET IDSucursal := (SELECT SucursalID FROM CUENTASAHO WHERE Clabe = Par_ClabeInst AND InstitucionID = Par_InstitucionID);
	SELECT NombreSucurs
		FROM SUCURSALES
			WHERE  SucursalID = IDSucursal;
END IF;

IF(Par_NumCon = Con_Corporativo) THEN
  SELECT SucursalID,		NombreSucurs
	FROM SUCURSALES
		WHERE  SucursalID = Par_SucursalID
			AND Estatus = EstatusApert
            AND TipoSucursal = TipoCorporativo;
END IF;

IF(Par_NumCon = Con_Atencion) THEN
  SELECT SucursalID,		NombreSucurs
	FROM SUCURSALES
		WHERE  SucursalID = Par_SucursalID
			AND Estatus = EstatusApert
            AND TipoSucursal = TipodeAtencion;
END IF;

-- consulta para obtener el municipio
-- se ocupa en el reporte ticket
IF(Par_NumCon = Con_RepTicket) THEN
	SELECT MR.Nombre AS NombreMun, ES.Nombre AS NombreEdo
		FROM SUCURSALES SU,
			MUNICIPIOSREPUB MR,
			ESTADOSREPUB ES
		WHERE SucursalID = Par_SucursalID
			AND SU.MunicipioID = MR.MunicipioID
			AND SU.EstadoID	 = MR.EstadoID
			AND SU.EstadoID	 = ES.EstadoID;
END IF;

IF(Par_NumCon = Con_Aportacion) THEN
	SELECT	SucursalID,		NombreSucurs
		FROM SUCURSALES
			WHERE SucursalID = Par_SucursalID
				AND Estatus = EstatusApert;
END IF;

END TerminaStore$$