-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLITUDESASIGNADASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLITUDESASIGNADASCON`;
DELIMITER $$

CREATE PROCEDURE `SOLITUDESASIGNADASCON`(
-- --------------------------------------------------------------------
-- SP DE CONSULTA DE LOS CREDITOS
-- --------------------------------------------------------------------
    Par_SolicitudCreditoID    BIGINT(20),	-- ID de la solicitud de credito
	Par_TipoAsignacionID       INT(11),     -- Id tipo Asignacion
	Par_ProductoID             INT(11),     -- Id producto de credito
	Par_UsuarioID              INT(11),     -- Id usuario de tipo analista
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),            -- Parametro de auditoria
	Aud_Usuario			INT(11),            -- Parametro de auditoria
	Aud_FechaActual		DATETIME,           -- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),        -- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),        -- Parametro de auditoria
	Aud_Sucursal		INT(11),            -- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)          -- Parametro de auditoria
)
TerminaStore: BEGIN



	-- Declaracion de constantes

	DECLARE Con_Principal   	INT(11);        -- Consulta principal sobre las solicitudes asignadas a cada analista de credito
	DECLARE Con_AnalisasAsig    INT(11);        -- Consulta para analistas asignados a la solicitud de credito
    DECLARE AnalistaVirtual     VARCHAR(20);    -- Analista virtual
	DECLARE EstatusAnalisis     CHAR(1);        -- Estatus analisis Activo A

	SET Con_Principal       := 1;
	SET Con_AnalisasAsig    :=2;
	SET AnalistaVirtual     :='ANALISTA VIRTUAL';
	SET EstatusAnalisis     :='A';





	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			Sol.SolicitudAsignaID,         Sol.UsuarioID,       Sol.SolicitudCreditoID,        Sol.TipoAsignacionID,        Sol.ProductoID,
			ifnull(Usu.NombreCompleto,AnalistaVirtual) AS NombreCompleto,         Cli.NombreCompleto AS NombreCliente									
        FROM SOLICITUDESASIGNADAS Sol
		LEFT  JOIN USUARIOS Usu          ON       Sol.UsuarioID          =     Usu.UsuarioID 
       	INNER JOIN SOLICITUDCREDITO Soli ON       Sol.SolicitudCreditoID =     Soli.SolicitudCreditoID
		INNER JOIN CLIENTES Cli          ON       Soli.ClienteID         =     Cli.ClienteID
        WHERE  Sol.SolicitudCreditoID    =     Par_SolicitudCreditoID;
	END IF;

   
	IF(Par_NumCon = Con_AnalisasAsig) THEN
		SELECT  Sol.UsuarioID,       Usu.NombreCompleto
		FROM    ANALISTASASIGNACION Sol
		INNER JOIN USUARIOS Usu       ON Usu.UsuarioID      =      Sol.UsuarioID
		WHERE   Sol.TipoAsignacionID  =     Par_TipoAsignacionID AND
		        Sol.ProductoID        =     Par_ProductoID AND 
		        Usu.EstatusAnalisis   =     EstatusAnalisis AND
		        Sol.UsuarioID         =     Par_UsuarioID;
	END IF;


END TerminaStore$$