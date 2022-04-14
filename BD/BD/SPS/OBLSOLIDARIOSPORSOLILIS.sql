-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBLSOLIDARIOSPORSOLILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBLSOLIDARIOSPORSOLILIS`;DELIMITER $$

CREATE PROCEDURE `OBLSOLIDARIOSPORSOLILIS`(

	Par_SolicitudCreditoID	INT,				-- Identidicador Solicitud de Credito
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

	-- Parametros de Auditotias
	Par_EmpresaID			INT(11),			-- Parametros de Auditotias
	Aud_Usuario				INT(11),			-- Parametros de Auditotias
	Aud_FechaActual			DATETIME,			-- Parametros de Auditotias
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditotias
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditotias
	Aud_Sucursal			INT(11),			-- Parametros de Auditotias
	Aud_NumTransaccion		BIGINT				-- Parametros de Auditotias

	)
TerminaStore: BEGIN

	-- Declaracion de Variables

	DECLARE Mes_Consulta 	INT(11);			-- Mes Consulta
	DECLARE Ano_Consulta 	INT(11);			-- Anio Consulta
	DECLARE Var_ClienteID	INT(11);			-- Identidicador de Cliente

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero		INT(11);			-- Entero Cero
	DECLARE	Lis_Principal	INT(11);			-- Lista Principal
	DECLARE Lis_AvalRees	INT(11);			-- Lista Avales
	DECLARE	Con_Foranea		INT(11);			-- Foranea
	DECLARE Original		CHAR(1);			-- Original

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Entero Cero
	SET	Lis_Principal		:= 1;				-- Principal
	SET Lis_AvalRees		:= 2;				-- Lista de Avales
	SET Original			:= 'O';				-- Original

	SET Var_ClienteID = (SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID =Par_SolicitudCreditoID);

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT  OBL.OblSolidID, IFNULL(C.ClienteID,Entero_Cero) AS ClienteID, IFNULL(P.ProspectoID,Entero_Cero) AS ProspectoID,
				CASE WHEN  OBL.OblSolidID <> Entero_Cero  AND   OBL.ClienteID = Entero_Cero AND OBL.ProspectoID= Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID = Entero_Cero  AND   OBL.ClienteID <> Entero_Cero AND OBL.ProspectoID= Entero_Cero THEN
				C.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID = Entero_Cero  AND   OBL.ClienteID = Entero_Cero AND OBL.ProspectoID<> Entero_Cero THEN
				P.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID <> Entero_Cero  AND   OBL.ClienteID <> Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID <> Entero_Cero  AND   OBL.ProspectoID <> Entero_Cero THEN
			A.NombreCompleto
			ELSE	CASE WHEN  OBL.ClienteID <> Entero_Cero  AND   OBL.ProspectoID <> Entero_Cero THEN
				C.NombreCompleto END END END END END END AS Nombre,
				OBL.TipoRelacionID as ParentescoID, TR.Descripcion as NombreParentesco,
				OBL.TiempoDeConocido as TiempoDeConocido
		FROM OBLSOLIDARIOSPORSOLI OBL
		LEFT OUTER JOIN OBLIGADOSSOLIDARIOS A ON OBL.OblSolidID= A.OblSolidID
		LEFT OUTER JOIN CLIENTES C ON OBL.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON OBL.ProspectoID= P.ProspectoID
		INNER JOIN TIPORELACIONES TR ON OBL.TipoRelacionID= TR.TipoRelacionID
		WHERE OBL.SolicitudCreditoID=Par_SolicitudCreditoID;
	END IF;


	IF(Par_NumLis = Lis_AvalRees) THEN

		SELECT  OBL.OblSolidID, IFNULL(C.ClienteID,Entero_Cero) AS ClienteID, IFNULL(P.ProspectoID,Entero_Cero) AS ProspectoID,
				CASE WHEN  OBL.OblSolidID <> Entero_Cero  AND   OBL.ClienteID = Entero_Cero AND OBL.ProspectoID= Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID = Entero_Cero  AND   OBL.ClienteID <> Entero_Cero AND OBL.ProspectoID= Entero_Cero THEN
				C.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID = Entero_Cero  AND   OBL.ClienteID = Entero_Cero AND OBL.ProspectoID<> Entero_Cero THEN
				P.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID <> Entero_Cero  AND   OBL.ClienteID <> Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID <> Entero_Cero  AND   OBL.ProspectoID <> Entero_Cero THEN
			A.NombreCompleto
			ELSE	CASE WHEN  OBL.ClienteID <> Entero_Cero  AND   OBL.ProspectoID <> Entero_Cero THEN
				C.NombreCompleto END END END END END END AS Nombre,
				OBL.TipoRelacionID as ParentescoID, TR.Descripcion as NombreParentesco,
				OBL.TiempoDeConocido as TiempoDeConocido
		FROM OBLSOLIDARIOSPORSOLI OBL
		LEFT OUTER JOIN OBLIGADOSSOLIDARIOS A ON OBL.OblSolidID= A.OblSolidID
		LEFT OUTER JOIN CLIENTES C ON OBL.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON OBL.ProspectoID= P.ProspectoID
		INNER JOIN TIPORELACIONES TR ON OBL.TipoRelacionID= TR.TipoRelacionID
		WHERE OBL.SolicitudCreditoID=Par_SolicitudCreditoID
		AND OBL.ClienteID <> Var_ClienteID;
	END IF;

END TerminaStore$$