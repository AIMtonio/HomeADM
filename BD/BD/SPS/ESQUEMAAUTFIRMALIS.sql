-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAAUTFIRMALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAAUTFIRMALIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAAUTFIRMALIS`(
	Par_Esquema         INT(11),
	Par_NumFirma        INT(11),
	Par_Organo          INT(11),
	Par_OrganoDescri    VARCHAR(100),
	Par_Producto        INT(11),
	Par_Solicitud       BIGINT(20),
	Par_GrupoID         INT,
	Par_NumLis		    TINYINT UNSIGNED,

	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
		)
TerminaStore: BEGIN

/* Declaracion de Variables  */
DECLARE Var_CicloActual         INT(11);
DECLARE Var_Cliente             INT(11);
DECLARE Var_Esquema             INT(11);
DECLARE Var_MontoSolicitado     DECIMAL(18,2);
DECLARE Var_MontoMaximo         DECIMAL(18,2);
DECLARE Var_EsGrupal            CHAR(1);
DECLARE Var_NumGrupo            INT(11);

/* Declaracion de Constantes */
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Fecha_Vacia             DATETIME;
DECLARE Entero_Cero             INT(11);
DECLARE Str_SI                  CHAR(1);
DECLARE Str_NO                  CHAR(1);
DECLARE Sol_StaInactiva         CHAR(1);
DECLARE Sol_StaLiberada         CHAR(1);
DECLARE Sol_StaAutorizada       CHAR(1);
DECLARE Cre_StaPagado           CHAR(1);
DECLARE Cre_StaVigente          CHAR(1);
DECLARE Cre_StaVencido          CHAR(1);
DECLARE Cre_StaCastigado        CHAR(1);


DECLARE Lis_Principal           INT(11);
DECLARE Lis_FirmOtorSolGrupo    INT(11);

/* Asignacion de Constantes */
SET Cadena_Vacia            := '';
SET Fecha_Vacia             := '1900-01-01';
SET Entero_Cero             := 0;
SET Str_SI                  := 'S';
SET Str_NO                  := 'N';
SET Sol_StaInactiva         := 'I';     -- Estatus de Solicitud Inactiva
SET Sol_StaLiberada         := 'L';     -- Estatus de Solicitud Liberada
SET Sol_StaAutorizada       := 'A';     -- Estatus de Solicitud Autorizada
SET Cre_StaPagado           := 'P';     -- Estatus de Credito Liquidado
SET Cre_StaVigente          := 'V';     -- Estatus de Credito Vigente
SET Cre_StaVencido          := 'B';     -- Estatus de Credito Vencido
SET Cre_StaCastigado        := 'K';     -- Estatus de Credito Castigado


SET Lis_Principal           := 1;       -- Firmas otorgadas por Solicitud
SET Lis_FirmOtorSolGrupo    := 2;       -- Firmas otorgadas por Solicitud Grupal


--  1.- Firmas otogadas por Solicitud
IF (Par_NumLis = Lis_Principal) THEN
    SELECT Fir.SolicitudCreditoID,      Fir.EsquemaID,       Fir.NumFirma,       Fir.OrganoID,       Org.Descripcion
    FROM ESQUEMAAUTFIRMA Fir
    INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
    WHERE Fir.SolicitudCreditoID = Par_Solicitud
    ORDER BY Fir.NumFirma, Fir.OrganoID ;
END IF;

/*  Firmas Otorgadas por Solicitud Grupal */
IF (Par_NumLis = Lis_FirmOtorSolGrupo) THEN
SELECT Gpo.GrupoID,Esq.EsquemaID, Esq.NumFirma, Esq.OrganoID, Descripcion,
		GROUP_CONCAT(Esq.SolicitudCreditoID) AS Solicitudes
	FROM ESQUEMAAUTFIRMA Esq
		INNER JOIN ORGANODESICION Org
			ON Esq.OrganoID = Org.OrganoID
		INNER JOIN SOLICITUDCREDITO Sol
			ON Sol.SolicitudCreditoID=Esq.SolicitudCreditoID
		INNER JOIN GRUPOSCREDITO Gpo
			ON Gpo.GrupoID = Sol.GrupoID
		INNER JOIN INTEGRAGRUPOSCRE Ing
			ON Gpo.GrupoID= Ing.GrupoID
		AND Ing.SolicitudCreditoID=Esq.SolicitudCreditoID
			WHERE Gpo.GrupoID = Par_GrupoID
				GROUP BY Esq.OrganoID,Gpo.GrupoID,Esq.EsquemaID, Esq.NumFirma, Descripcion
				ORDER BY Esq.NumFirma, Esq.OrganoID;
END IF;

END TerminaStore$$