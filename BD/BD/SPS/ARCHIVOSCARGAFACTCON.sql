-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOSCARGAFACTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOSCARGAFACTCON`;
DELIMITER $$

CREATE PROCEDURE `ARCHIVOSCARGAFACTCON`(
-- ===================================================================================
-- SP PARA CONSULTAR LOS FOLIOS A PROCESAR DE FACTURAS MAVISAS
-- ===================================================================================
    Par_FolioCargaID        INT(11),			-- FOLIO DE CARGA
    Par_NumCon          	TINYINT UNSIGNED,	-- TIPO DE CONSULTA
	/* Parametros de Auditoria */
    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
    DECLARE Var_MesNoCorresponde	INT(11);
    DECLARE Var_MesCorresponde		INT(11);
    DECLARE Var_ProvNoExiste		INT(11);
    DECLARE Var_ProvExiste			INT(11);
    DECLARE Var_TotalProvedores		INT(11);

	-- DECLARACION DE CONSTANTES
	DECLARE Con_Principal   	INT(11);
	DECLARE Con_DetalleFolio   	INT(11);

	-- ASIGNACION DE CONSTANTES
	SET Con_Principal       	:= 1;
	SET Con_DetalleFolio       	:= 2;

	IF(Par_NumCon = Con_Principal) THEN
		SELECT ARC.FolioCargaID, 		US.NombreCompleto AS Usuario, 			ARC.FechaCarga,			ARC.Mes,		ARC.NumTotalFacturas AS TotalFacturas,
			   ARC.NumFacturasExito,	ARC.NumFacturasError,					ARC.Estatus,
               CASE ARC.Estatus WHEN "P" THEN "PROCESADO" ELSE "NO PROCESADO" END AS DescripcionEstatus
			FROM ARCHIVOSCARGAFACT ARC
			INNER JOIN USUARIOS US ON US.UsuarioID=ARC.UsuarioCarga
			WHERE ARC.FolioCargaID=Par_FolioCargaID;
	END IF;

    IF(Par_NumCon = Con_DetalleFolio) THEN

        SELECT COUNT(TipoError) INTO Var_MesNoCorresponde
			FROM BITACORACARGAFACT
			WHERE FolioCargaID=Par_FolioCargaID
			AND TipoError IN (2, 12);

		SELECT COUNT(TipoError) INTO Var_MesCorresponde
			FROM BITACORACARGAFACT
			WHERE FolioCargaID=Par_FolioCargaID
			AND TipoError NOT IN (2, 12);

		SELECT COUNT(distinct(RfcEmisor)) INTO Var_ProvNoExiste
			FROM BITACORACARGAFACT
			WHERE FolioCargaID=Par_FolioCargaID
			AND TipoError IN (3);

		 SELECT COUNT(distinct(RfcEmisor))  INTO Var_ProvExiste
			FROM BITACORACARGAFACT BI
			WHERE BI.FolioCargaID=Par_FolioCargaID
			AND TipoError NOT IN (3);

		SET Var_TotalProvedores := Var_ProvExiste + Var_ProvNoExiste;


		SELECT ARC.FolioCargaID, 		US.NombreCompleto AS Usuario, 			ARC.FechaCarga,			ARC.Mes,		ARC.NumTotalFacturas AS TotalFacturas,
			   ARC.NumFacturasExito,	ARC.NumFacturasError,					ARC.Estatus,
               CASE ARC.Estatus WHEN "P" THEN "PROCESADO" ELSE "NO PROCESADO" END AS DescripcionEstatus,
               Var_MesNoCorresponde AS MesNoCorresponde, Var_MesCorresponde AS MesCorresponde,
               Var_ProvNoExiste	AS ProvNoExiste, Var_ProvExiste AS ProvExiste,
               Var_TotalProvedores AS TotalProvedores
			FROM ARCHIVOSCARGAFACT ARC
			INNER JOIN USUARIOS US ON US.UsuarioID=ARC.UsuarioCarga
			WHERE ARC.FolioCargaID=Par_FolioCargaID;
	END IF;


END TerminaStore$$