-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESPORSOLILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESPORSOLILIS`;DELIMITER $$

CREATE PROCEDURE `AVALESPORSOLILIS`(

	Par_SolicitudCreditoID	INT,
	Par_NumLis				TINYINT UNSIGNED,

	Par_EmpresaID				INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal				INT,
	Aud_NumTransaccion		BIGINT

	)
TerminaStore: BEGIN

-- Declaracion de Variables

DECLARE Mes_Consulta 		INT;
DECLARE Ano_Consulta 		INT;
DECLARE Var_ClienteID		INT(11);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Lis_Principal		INT;
DECLARE Lis_AvalRees	INT(11);
DECLARE	Con_Foranea		INT;
DECLARE Original		CHAR(1);

-- Asignacion de Constantes
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Lis_Principal			:= 1;
SET Lis_AvalRees		:= 2;
SET Original			:= 'O';

SET Var_ClienteID = (SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID =Par_SolicitudCreditoID);

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT  AP.AvalID, IFNULL(C.ClienteID,Entero_Cero) AS ClienteID, IFNULL(P.ProspectoID,Entero_Cero) AS ProspectoID,
				CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
				C.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero THEN
				P.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
			A.NombreCompleto
			ELSE	CASE WHEN  AP.ClienteID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
				C.NombreCompleto END END END END END END AS Nombre,
				AP.TipoRelacionID as ParentescoID, TR.Descripcion as NombreParentesco,
				AP.TiempoDeConocido as TiempoDeConocido
		FROM AVALESPORSOLICI AP
		LEFT OUTER JOIN AVALES A ON AP.AvalID= A.AvalID
		LEFT OUTER JOIN CLIENTES C ON AP.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON AP.ProspectoID= P.ProspectoID
		INNER JOIN TIPORELACIONES TR ON AP.TipoRelacionID= TR.TipoRelacionID
		WHERE AP.SolicitudCreditoID=Par_SolicitudCreditoID;
	END IF;


	IF(Par_NumLis = Lis_AvalRees) THEN

		SELECT  AP.AvalID, IFNULL(C.ClienteID,Entero_Cero) AS ClienteID, IFNULL(P.ProspectoID,Entero_Cero) AS ProspectoID,
				CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
				C.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero THEN
				P.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
			A.NombreCompleto
			ELSE	CASE WHEN  AP.ClienteID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
				C.NombreCompleto END END END END END END AS Nombre, EstatusSolicitud,
				AP.TipoRelacionID as ParentescoID, TR.Descripcion as NombreParentesco,
				AP.TiempoDeConocido as TiempoDeConocido
		FROM AVALESPORSOLICI AP
		LEFT OUTER JOIN AVALES A ON AP.AvalID= A.AvalID
		LEFT OUTER JOIN CLIENTES C ON AP.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON AP.ProspectoID= P.ProspectoID
		INNER JOIN TIPORELACIONES TR ON AP.TipoRelacionID= TR.TipoRelacionID
		WHERE AP.SolicitudCreditoID=Par_SolicitudCreditoID
		AND AP.ClienteID <> Var_ClienteID;
	END IF;

END TerminaStore$$