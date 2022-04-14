-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFERENCIACLIENTELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFERENCIACLIENTELIS`;
DELIMITER $$


CREATE PROCEDURE `REFERENCIACLIENTELIS`(

	Par_SolicitudCreditoID	BIGINT(20),
	Par_ClienteID			INT(11),
    Par_NumLis				TINYINT UNSIGNED,
	Aud_Usuario				INT(11),
	Aud_Empresa				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)

TerminaStore:BEGIN

    DECLARE Lista_Principal			INT(11);
    DECLARE Lista_PLD				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);	-- Cadena vacia
	DECLARE Entero_Cero				INT(11);	-- Entero cero


    SET Lista_Principal				:= 1;
    SET Lista_PLD					:= 2;
	SET Cadena_Vacia				:= '';		-- Cadena vacia
	SET Entero_Cero					:= 0;		-- Entero cero

    IF(Par_NumLis = Lista_Principal) THEN
		DROP TABLE IF EXISTS TMPREFERENCIACLIENTES;
        CREATE TEMPORARY TABLE TMPREFERENCIACLIENTES (
			ReferenciaID INT(11),
			SolicitudCreditoID BIGINT(20),
			PrimerNombre VARCHAR(50),
			SegundoNombre VARCHAR(50),
			TercerNombre VARCHAR(50),
			ApellidoPaterno VARCHAR(50),
			ApellidoMaterno VARCHAR(50),
			NombreCompleto VARCHAR(250),
			Telefono VARCHAR(20),
			ExtTelefonoPart VARCHAR(7),
			Validado VARCHAR(1),
			Interesado VARCHAR(1),
			TipoRelacionID INT(11),
			EstadoID INT(11),
			MunicipioID INT(11),
			LocalidadID INT(11),
			ColoniaID INT(11),
			Calle VARCHAR(50),
			NumeroCasa VARCHAR(10),
			NumInterior VARCHAR(10),
			Piso CHAR(50),
			CP VARCHAR(5),
            DireccionCompleta	varchar(500),
			Solicitante VARCHAR(250),
			INDEX(ReferenciaID,SolicitudCreditoID)
		);
		INSERT INTO TMPREFERENCIACLIENTES(
			ReferenciaID,			SolicitudCreditoID,		PrimerNombre,			SegundoNombre,		TercerNombre,
			ApellidoPaterno,		ApellidoMaterno,		NombreCompleto,			Telefono,			ExtTelefonoPart,
			Validado,				Interesado,				TipoRelacionID,			EstadoID,			MunicipioID,
			LocalidadID,			ColoniaID,				Calle,					NumeroCasa,			NumInterior,
			Piso,					CP,						DireccionCompleta,		Solicitante
        )
		SELECT
			ReferenciaID,			RC.SolicitudCreditoID,		RC.PrimerNombre,		RC.SegundoNombre,		RC.TercerNombre,
			RC.ApellidoPaterno,		RC.ApellidoMaterno,			RC.NombreCompleto,		RC.Telefono,			RC.ExtTelefonoPart,
			RC.Validado,			RC.Interesado,				RC.TipoRelacionID,		RC.EstadoID,			RC.MunicipioID,
			RC.LocalidadID,			RC.ColoniaID,				RC.Calle,				RC.NumeroCasa,			RC.NumInterior,
			RC.Piso,				RC.CP,						RC.DireccionCompleta,
			CASE WHEN C.NombreCompleto IS NULL THEN P.NombreCompleto ELSE C.NombreCompleto END AS Solicitante
			FROM
				REFERENCIACLIENTE AS RC INNER JOIN
				SOLICITUDCREDITO AS SC ON RC.SolicitudCreditoID=SC.SolicitudCreditoID LEFT JOIN
				CLIENTES AS C ON SC.ClienteID=C.ClienteID LEFT JOIN
				PROSPECTOS AS P ON SC.ProspectoID=P.ProspectoID
				WHERE RC.SolicitudCreditoID=Par_SolicitudCreditoID ORDER BY ReferenciaID;

        SELECT
			TMP.ReferenciaID,				TMP.SolicitudCreditoID,			TMP.PrimerNombre,			TMP.SegundoNombre,		TMP.TercerNombre,
			TMP.ApellidoPaterno,			TMP.ApellidoMaterno,			TMP.NombreCompleto,			TMP.Telefono,			TMP.ExtTelefonoPart,
			TMP.Validado,					TMP.Interesado,					TMP.TipoRelacionID,			TMP.EstadoID,			IF(TMP.MunicipioID = Entero_Cero, Cadena_Vacia, TMP.MunicipioID) AS MunicipioID,
			IF(TMP.LocalidadID = Entero_Cero, Cadena_Vacia, TMP.LocalidadID) AS LocalidadID,
			IF(TMP.ColoniaID = Entero_Cero, Cadena_Vacia, TMP.ColoniaID) AS ColoniaID,
			TMP.Calle,						TMP.NumeroCasa,					TMP.NumInterior,
			TMP.Piso,						TMP.CP,							TMP.DireccionCompleta,		TMP.Solicitante, 		IFNULL(TP.Descripcion, Cadena_Vacia) AS descripcionRelacion,
            IFNULL(ES.Nombre, Cadena_Vacia) AS NombreEstado,
            IFNULL(ES.Nombre, Cadena_Vacia) AS NombreEstado,
            IFNULL(MN.Nombre, Cadena_Vacia) AS NombreMuni,
            IFNULL(LP.NombreLocalidad, Cadena_Vacia) AS NombreLocalidad,
            IFNULL(CONCAT(TipoAsenta, ' ',Asentamiento), Cadena_Vacia) AS NombreColonia
            FROM TMPREFERENCIACLIENTES AS TMP
             LEFT JOIN TIPORELACIONES AS TP ON TMP.TipoRelacionID=TP.TipoRelacionID
             LEFT JOIN ESTADOSREPUB AS ES ON TMP.EstadoID=ES.EstadoID
             LEFT JOIN MUNICIPIOSREPUB AS MN ON TMP.MunicipioID=MN.MunicipioID AND TMP.EstadoID=MN.EstadoID
             LEFT JOIN LOCALIDADREPUB AS LP ON TMP.LocalidadID=LP.LocalidadID AND TMP.EstadoID = LP.EstadoID AND TMP.MunicipioID = LP.MunicipioID
             LEFT JOIN COLONIASREPUB AS CP ON TMP.EstadoID = CP.EstadoID AND TMP.MunicipioID = CP.MunicipioID  AND TMP.ColoniaID = CP.ColoniaID;

	END IF;
	IF(Par_NumLis = Lista_PLD) THEN
		SELECT
			RC.NombreCompleto,		RC.Telefono,			RC.ExtTelefonoPart
			FROM
				REFERENCIACLIENTE AS RC INNER JOIN
				SOLICITUDCREDITO AS SC ON RC.SolicitudCreditoID=SC.SolicitudCreditoID LEFT JOIN
                CONOCIMIENTOCTE as CT ON SC.ClienteID=CT.ClienteID
				WHERE SC.ClienteID=Par_ClienteID
                ORDER BY ReferenciaID LIMIT 2;

	END IF;


END TerminaStore$$
