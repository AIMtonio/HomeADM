-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_BITACORACON`;DELIMITER $$

CREATE PROCEDURE `TC_BITACORACON`(
-- SP PARA CONSULTAR LA BITACORA DE LA TARJETA DE CREDITO
Par_TarjetaCredID	CHAR(16),			-- ID de tarjeta de credito
Par_NumCon			TINYINT UNSIGNED,	-- Numero de consulta

Par_EmpresaID		INT, 				-- Auditoria
Aud_Usuario			INT, 				-- Auditoria
Aud_FechaActual		DATETIME, 			-- Auditoria
Aud_DireccionIP		VARCHAR(15),		-- Auditoria
Aud_ProgramaID		VARCHAR(50),		-- Auditoria
Aud_Sucursal		INT, 				-- Auditoria
Aud_NumTransaccion	BIGINT				-- Auditoria
)
TerminaStore: BEGIN

	DECLARE Con_TipoEvenTDID 	INT;
	DECLARE Con_BitacoraDesbloq INT;

	SET Con_BitacoraDesbloq   :=5;
	SET Con_TipoEvenTDID	  :=8;	-- Tipo de evento "Tarjeta Bloqueada" de la tabla TARDEBEVENTOSTD

	IF(Par_NumCon = Con_BitacoraDesbloq) THEN
			SELECT Tar.TarjetaCredID,			Est.Descripcion,	Cli.ClienteID,NombreCompleto,   Cli.CorpRelacionado,	Cat.Descripcion,
				   DATE(Bit.Fecha)AS Fecha, 	Bit.DescripAdicio,	Est.EstatusId
			  FROM BITACORATARCRED AS Bit
				INNER JOIN TARJETACREDITO  AS Tar ON Bit.TarjetaCredID =Tar.TarjetaCredID
				INNER JOIN CLIENTES 	   AS Cli ON Tar.ClienteID=Cli.ClienteID
				INNER JOIN ESTATUSTD 	   AS Est ON Est.EstatusID=Bit.TipoEvenTDID
				INNER JOIN CATALCANBLOQTAR AS Cat ON Cat.MotCanBloID =Bit.MotivoBloqID
			WHERE Tar.TarjetaCredID= Par_TarjetaCredID
			  AND Bit.TipoEvenTDID=Con_TipoEvenTDID
			ORDER BY Bit.Fecha DESC
	 LIMIT 1;
	END IF;


END TerminaStore$$